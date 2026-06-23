class fifo_rd_driver extends uvm_driver #(fifo_seq_item);

    `uvm_component_utils(fifo_rd_driver)

    //----------------------------------
    // Virtual Interface
    //----------------------------------
    virtual fifo_if.RD_DRV vif;

    //----------------------------------
    // Constructor
    //----------------------------------
    function new(
        string name = "fifo_rd_driver",
        uvm_component parent
    );
        super.new(name,parent);
    endfunction

    //----------------------------------
    // Build Phase
    //----------------------------------
    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db#(
            virtual fifo_if.RD_DRV
        )::get(
            this,
            "",
            "vif",
            vif
        ))
        begin
            `uvm_fatal(
                "NO_VIF",
                "Read Driver: Virtual Interface not found"
            );
        end

    endfunction

    //----------------------------------
    // Run Phase
    //----------------------------------
    task run_phase(uvm_phase phase);

        fifo_seq_item req;

        forever begin

            //----------------------------------
            // Get transaction
            //----------------------------------
            seq_item_port.get_next_item(req);

            //----------------------------------
            // Read operation
            //----------------------------------
            if(req.rd_en)
            begin

                @(vif.rd_cb);

                if(!vif.rd_cb.empty)
                begin

                    vif.rd_cb.rd_enable <= 1'b1;

                    `uvm_info(
                        get_type_name(),
                        "READ REQUEST",
                        UVM_MEDIUM
                    );

                    @(vif.rd_cb);

                    vif.rd_cb.rd_enable <= 1'b0;

                end
                else
                begin

                    `uvm_warning(
                        get_type_name(),
                        "FIFO EMPTY : READ SKIPPED"
                    );

                end

            end

            //----------------------------------
            // Done
            //----------------------------------
            seq_item_port.item_done();

        end

    endtask

endclass
