// INFO
`define LOGD(MSG) `uvm_info(get_name(), $sformatf MSG, UVM_DEBUG)
`define LOGH(MSG) `uvm_info(get_name(), $sformatf MSG, UVM_HIGH)
`define LOGM(MSG) `uvm_info(get_name(), $sformatf MSG, UVM_MEDIUM)
`define LOGL(MSG) `uvm_info(get_name(), $sformatf MSG, UVM_LOW)
`define LOGN(MSG) `uvm_info(get_name(), $sformatf MSG, UVM_NONE)

// WARNING
`define LOGW(MSG) `uvm_warning(get_name(), $sformatf MSG)

// ERROR
`define LOGE(MSG) `uvm_error(get_name(), $sformatf MSG)

// FATAL
`define LOGF(MSG) `uvm_fatal(get_name(), $sformatf MSG)


//==================================================================================
typedef struct {
    bit  my_type;
    int  length;
} consecutive_data;

typedef struct {
    bit         my_type;
    bit[4-1:0]  length;
    bit[15-1:0] stream_length;
} vlc_data;

typedef enum {IDLE, ONE, ZERO} input_state;
typedef enum {OUT_IDLE, LENGTH, STREAM_LENGTH} output_state;
