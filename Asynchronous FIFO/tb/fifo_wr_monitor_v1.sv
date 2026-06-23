class fifo_wr_monitor extends uvm_monitor;

    `uvm_component_utils(fifo_wr_monitor)

    //----------------------------------
    // Virtual Interface
    //----------------------------------
    virtual fifo_if.WR_MON vif;

    //----------------------------------
    // Analysis Port
    //----------------------------------
    uvm_analysis_port #(fifo_seq_item) ap;

    //----------------------------------
    // Constructor
    //----------------------------------
    function new(
        string name = "fifo_wr_monitor",
        uvm_component parent
    );
        super.new(name,parent);

        ap = new("ap",this);

    endfunction

    //----------------------------------
    // Build Phase
    //----------------------------------
    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db#(
            virtual fifo_if.WR_MON
        )::get(
            this,
            "",
            "vif",
            vif
        ))
        begin
            `uvm_fatal(
                "NO_VIF",
                "Write Monitor: Virtual Interface not found"
            );
        end

    endfunction

    //----------------------------------
    // Run Phase
    //----------------------------------
    task run_phase(uvm_phase phase);

        fifo_seq_item tr;

        forever begin

            @(posedge vif.wr_clk);

            if(vif.wr_enable && !vif.full)
            begin

                tr = fifo_seq_item::type_id::create("tr");

                tr.wr_en   = 1'b1;
                tr.rd_en   = 1'b0;
                tr.wr_data = vif.wr_data;

                ap.write(tr);

                `uvm_info(
                    get_type_name(),
                    $sformatf(
                        "MONITORED WRITE : 0x%0h",
                        tr.wr_data
                    ),
                    UVM_MEDIUM
                );

            end

        end

    endtask

endclass
