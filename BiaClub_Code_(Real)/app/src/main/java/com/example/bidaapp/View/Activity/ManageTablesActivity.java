package com.example.bidaapp.View.Activity;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.bidaapp.View.Layout.AddTableDialogFragment;
import com.example.bidaapp.Controller.TableAdapter;
import com.example.bidaapp.Model.DatabaseHelper;
import com.example.bidaapp.Model.Table;
import com.example.bidaapp.R;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.List;

public class ManageTablesActivity extends BaseActivity implements AddTableDialogFragment.OnTableAddedListener {
    private RecyclerView recyclerView;
    private TableAdapter tableAdapter;
    private DatabaseHelper databaseHelper;
    private int accountId;
    private List<Table> currentTableList;
    private ImageView backBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getLayoutInflater().inflate(R.layout.activity_manage_tables, findViewById(R.id.content_frame));

        Intent intent = getIntent();
        accountId = intent.getIntExtra("account_id", -1);
        backBtn = findViewById(R.id.backBtn);
        databaseHelper = new DatabaseHelper(this);
        recyclerView = findViewById(R.id.listViewInvoices);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        if (accountId != -1) {
            loadTableList();
        } else {
            Toast.makeText(this, "Account ID không hợp lệ!", Toast.LENGTH_SHORT).show();
        }

        FloatingActionButton addTableButton = findViewById(R.id.btnAddCustomer);
        addTableButton.setOnClickListener(v -> {
            AddTableDialogFragment dialog = new AddTableDialogFragment(accountId);
            dialog.show(getSupportFragmentManager(), "AddTableDialog");
        });

        EditText editTextSearch = findViewById(R.id.editTextSearch);
        Button btnSearch = findViewById(R.id.btnSearch);
        btnSearch.setOnClickListener(v -> {
            String searchQuery = editTextSearch.getText().toString().trim();
            if (!searchQuery.isEmpty()) {
                searchTableList(searchQuery);
            } else {
                loadTableList();
            }
        });

        backBtn.setOnClickListener(v -> finish());
    }

    private void loadTableList() {
        List<Table> newTableList = databaseHelper.getTablesByAccountId(accountId);
        currentTableList = newTableList; // Cập nhật danh sách hiện tại
        tableAdapter = new TableAdapter(this, currentTableList);
        recyclerView.setAdapter(tableAdapter); // Cập nhật adapter
    }

    private void searchTableList(String tableName) {
        List<Table> searchResults = databaseHelper.searchTablesByName(accountId, tableName);
        tableAdapter = new TableAdapter(this, searchResults);
        recyclerView.setAdapter(tableAdapter);
    }

    @Override
    public void onTableAdded() {
        loadTableList();
    }

    @Override
    protected void onResume() {
        super.onResume();
        loadTableList();
    }
}
