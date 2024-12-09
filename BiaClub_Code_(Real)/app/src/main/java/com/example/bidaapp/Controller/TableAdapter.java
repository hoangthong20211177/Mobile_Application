package com.example.bidaapp.Controller;

import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import android.content.SharedPreferences;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;

import com.example.bidaapp.Model.DatabaseHelper;
import com.example.bidaapp.Model.Table;
import com.example.bidaapp.View.Activity.OrderActivity;
import com.example.bidaapp.R;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class TableAdapter extends RecyclerView.Adapter<TableAdapter.TableViewHolder> {
    private Context context;
    private List<Table> tableList;
    private DatabaseHelper dbHelper;
    private String thoiGianBatDau;

    public TableAdapter(Context context, List<Table> tableList) {
        this.context = context;
        this.tableList = tableList;
        this.dbHelper = new DatabaseHelper(context);
    }

    @NonNull
    @Override
    public TableViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_table, parent, false);
        return new TableViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull TableViewHolder holder, int position) {
        Table table = tableList.get(position);
        holder.bind(table);
    }

    @Override
    public int getItemCount() {
        return tableList.size();
    }

    class TableViewHolder extends RecyclerView.ViewHolder {
        TextView tableNameTextView;
        View statusDot;
        Button actionButton;
        Button deleteButton;

        public TableViewHolder(@NonNull View itemView) {
            super(itemView);
            tableNameTextView = itemView.findViewById(R.id.tableName);
            statusDot = itemView.findViewById(R.id.statusDot);
            actionButton = itemView.findViewById(R.id.action_button);
            deleteButton = itemView.findViewById(R.id.delete_button);
        }

        public void bind(Table table) {
            tableNameTextView.setText(table.getTableName());

            if ("Có khách".equals(table.getStatus())) {
                statusDot.setBackgroundResource(R.drawable.status_dot_yellow);
                actionButton.setText("Chi tiết");
                actionButton.setOnClickListener(v -> showTableDetails(table));
                deleteButton.setVisibility(View.GONE);
            } else {
                statusDot.setBackgroundResource(R.drawable.status_dot);
                actionButton.setText("Bắt đầu");
                actionButton.setOnClickListener(v -> startNewSession(table));
                deleteButton.setVisibility(View.VISIBLE);

                deleteButton.setOnClickListener(v -> confirmDeleteTable(table));
            }
        }

        private void showTableDetails(Table table) {
            String tableName = table.getTableName();
            String tableStatus = table.getStatus();
            String startTime = dbHelper.getStartTime(table.getId());
            if (startTime != null && !startTime.isEmpty()) {
                thoiGianBatDau = startTime;
            }

            String message = "Tên bàn: " + tableName + "\n" +
                    "Trạng thái: " + tableStatus + "\n" +
                    "Thời gian bắt đầu: " + (startTime != null && !startTime.isEmpty() ? startTime : "Chưa bắt đầu");

            new AlertDialog.Builder(context)
                    .setTitle("Chi tiết bàn")
                    .setMessage(message)
                    .setPositiveButton("Xem thêm", (dialog, which) -> {
                        dialog.dismiss();
                        Intent intent = new Intent(context, OrderActivity.class);
                        intent.putExtra("id_ban", table.getId());
                        intent.putExtra("table_name", table.getTableName());
                        intent.putExtra("table_status", table.getStatus());
                        intent.putExtra("thoi_gian_bat_dau", thoiGianBatDau);
                        context.startActivity(intent);
                    })
                    .show();
        }

        private void startNewSession(Table table) {
            String thoiGianBatDau = getCurrentTime();
            SharedPreferences preferences = context.getSharedPreferences("AppPrefs", Context.MODE_PRIVATE);
            int idAccount = preferences.getInt("account_id", -1);

            if (idAccount == -1) {
                Log.e("StartNewSession", "ID Account không hợp lệ: " + idAccount);
                Toast.makeText(context, "ID tài khoản không hợp lệ", Toast.LENGTH_SHORT).show();
                return;
            }

            long id_thoigian = dbHelper.insertThoiGianChoi(table.getId(), idAccount, thoiGianBatDau);
            if (id_thoigian != -1) {
                Log.d("StartNewSession", "ID Thoi Gian: " + id_thoigian);
            } else {
                Log.e("StartNewSession", "Không thể lưu thời gian chơi");
            }

            dbHelper.updateTableStatus(table.getId(), "Có khách");
            table.setStatus("Có khách");

            Toast.makeText(context, "Bắt đầu phiên chơi thành công!", Toast.LENGTH_SHORT).show();

            Intent intent = new Intent(context, OrderActivity.class);
            intent.putExtra("id_ban", table.getId());
            intent.putExtra("thoi_gian_bat_dau", thoiGianBatDau);
            context.startActivity(intent);
        }

        private void confirmDeleteTable(Table table) {
            new AlertDialog.Builder(context)
                    .setTitle("Xóa bàn")
                    .setMessage("Bạn có chắc chắn muốn xóa bàn này không?")
                    .setPositiveButton("Xóa", (dialog, which) -> deleteTable(table))
                    .setNegativeButton("Hủy", (dialog, which) -> dialog.dismiss())
                    .show();
        }

        private void deleteTable(Table table) {
            if ("Có khách".equals(table.getStatus())) {
                Toast.makeText(context, "Không thể xóa bàn đang có khách!", Toast.LENGTH_SHORT).show();
                return;
            }

            boolean success = dbHelper.deleteTable(table.getId());
            if (success) {
                tableList.remove(table);
                notifyDataSetChanged(); // Cập nhật lại danh sách
                Toast.makeText(context, "Xóa bàn thành công!", Toast.LENGTH_SHORT).show();
            } else {
                Toast.makeText(context, "Xóa bàn thất bại!", Toast.LENGTH_SHORT).show();
            }
        }

        private String getCurrentTime() {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
            return sdf.format(new Date());
        }
    }
}
