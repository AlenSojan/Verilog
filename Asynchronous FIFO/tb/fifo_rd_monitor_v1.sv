class fifo_rd_monitor extends uvm_monitor;

    `uvm_component_utils(fifo_rd_monitor)

    //----------------------------------
    // Virtual Interface
    //----------------------------------
    virtual fifo_if.RD_MON vif;

    //----------------------------------
    // Analysis Port
    //----------------------------------
    uvm_analysis_port #(fifo_seq_item) ap;

    //----------------------------------
    // Constructor
    //----------------------------------
    function new(
        string name = "fifo_rd_monitor",
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
            virtual fifo_if.RD_MON
        )::get(
            this,
            "",
            "vif",
            vif
        ))
        begin
            `uvm_fatal(
                "NO_VIF",
                "Read Monitor: Virtual Interface not found"
            );
        end

    endfunction

    //----------------------------------
    // Run Phase
    //----------------------------------
    task run_phase(uvm_phase phase);

        fifo_seq_item tr;

        forever begin

            @(posedge vif.rd_clk);

            if(vif.rd_enable && !vif.empty)
            begin

                // wait for rd_data update
                #0;

                tr = fifo_seq_item::type_id::create("tr");

                tr.wr_en   = 1'b0;
                tr.rd_en   = 1'b1;
                tr.rd_data = vif.rd_data;

                ap.write(tr);

                `uvm_info(
                    get_type_name(),
                    $sformatf(
                        "MONITORED READ : 0x%0h",
                        tr.rd_data
                    ),
                    UVM_MEDIUM
                );

            end

        end

    endtask

endclass
