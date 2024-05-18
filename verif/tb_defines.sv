// INFO
`define LOGD(MSG) `uvm_info(get_type_name(), $sformatf MSG, UVM_DEBUG)
`define LOGH(MSG) `uvm_info(get_type_name(), $sformatf MSG, UVM_HIGH)
`define LOGM(MSG) `uvm_info(get_type_name(), $sformatf MSG, UVM_MEDIUM)
`define LOGL(MSG) `uvm_info(get_type_name(), $sformatf MSG, UVM_LOW)
`define LOGN(MSG) `uvm_info(get_type_name(), $sformatf MSG, UVM_NONE)

// WARNING
`define LOGW(MSG) `uvm_warning(get_type_name(), $sformatf MSG)

// ERROR
`define LOGE(MSG) `uvm_error(get_type_name(), $sformatf MSG)

// FATAL
`define LOGF(MSG) `uvm_fatal(get_type_name(), $sformatf MSG)
