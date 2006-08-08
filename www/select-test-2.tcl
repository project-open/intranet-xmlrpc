ad_page_contract {
    Autenticate the user and issue an auth-token
    that needs to be specified for every xmlrpc-request
    
    @author Frank Bergmann (frank.bergmann@project-open.com)
} {
    user_id
    timestamp
    token
    object_type
    {url "/RPC2/" }
    {method "sqlapi.select"}
}


# ------------------------------------------------------------
# Security & Defaults
# ------------------------------------------------------------

set return_url "[ad_conn url]?[ad_conn query]"
set page_title "Select-Test-2"
set context_bar [im_context_bar $page_title]
set current_user_id [im_xmlrpc_get_user_id]

# ------------------------------------------------------------
# 
# ------------------------------------------------------------

set error ""
set result ""
set info ""

set query_results [list]


# Get the list of all objects of that type
if {[catch {

    set authinfo [list \
	   [list -string token] \
	   [list -int $user_id] \
	   [list -string $timestamp] \
	   [list -string $token] \
    ]

    set query_results [xmlrpc::remote_call \
	http://172.26.0.3:30038/RPC2 \
	"sqlapi.select" \
	-array $authinfo \
	-string $object_type \
	-array [list [list -string foo] [list -string "bar"]]
    ]

} err_msg]} {
    append error $err_msg
}


set status [lindex $query_results 0]
set object_id_options [list]

if {"ok" != $status} {

    set error "$status "
    append error [lindex $query_results 1]


} else {

    set object_ids [lindex $query_results 1]
    foreach id $object_ids {
	set object_id [lindex $id 0]
	set object_name [lindex $id 1]
	append object_id_options "<option value=\"$object_id\">$object_name</option>\n"
    }
}


