class fifo_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(fifo_scoreboard)

    //----------------------------------
    // Analysis Imports
    //----------------------------------
    uvm_tlm_analysis_fifo #(fifo_seq_item) wr_fifo;
    uvm_tlm_analysis_fifo #(fifo_seq_item) rd_fifo;

    //----------------------------------
    // Reference Model
    //----------------------------------
    bit [WIDTH-1:0] model_q[$];

    //----------------------------------
    // Constructor
    //----------------------------------
    function new(
        string name,
        uvm_component parent
    );
        super.new(name,parent);
    endfunction

    //----------------------------------
    // Build Phase
    //----------------------------------
    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        wr_fifo = new("wr_fifo",this);
        rd_fifo = new("rd_fifo",this);

    endfunction

    //----------------------------------
    // Run Phase
    //----------------------------------
    task run_phase(uvm_phase phase);

    fifo_seq_item wr_tr;
    fifo_seq_item rd_tr;

    bit [WIDTH-1:0] expected;

    fork

        //----------------------------------
        // Handle Writes
        //----------------------------------
        forever begin

            wr_fifo.get(wr_tr);

            model_q.push_back(
                wr_tr.wr_data
            );

            `uvm_info(
                "SCOREBOARD",
                $sformatf(
                    "WRITE STORED = 0x%0h",
                    wr_tr.wr_data
                ),
                UVM_MEDIUM
            );

        end

        //----------------------------------
        // Handle Reads
        //----------------------------------
        forever begin

            rd_fifo.get(rd_tr);

            if(model_q.size()==0)
            begin

                `uvm_error(
                    "SCOREBOARD",
                    "Read occurred on empty model"
                );

            end
            else
            begin

                expected =
                    model_q.pop_front();

                if(expected != rd_tr.rd_data)
                begin

                    `uvm_error(
                        "SCOREBOARD",
                        $sformatf(
                            "Mismatch! Expected=0x%0h Actual=0x%0h",
                            expected,
                            rd_tr.rd_data
                        )
                    );
                end
                else
                begin

                    `uvm_info(
                        "SCOREBOARD",
                        $sformatf(
                            "MATCH Expected=0x%0h Actual=0x%0h",
                            expected,
                            rd_tr.rd_data
                        ),
                        UVM_MEDIUM
                    );

                end

            end

        end

    join_none

    endtask

endclass
