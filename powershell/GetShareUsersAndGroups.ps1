## This will get the list of groups and users who have
## access to a network share (this is the information 
## that shows up under the security tab).
## 
## Note: the Identity Reference will give you the name of the object
## <path>: The network path that you want to get the users/groups fo.r

$network_path = "\\networkshare\dept\test"
get-acl $network_path | % { $_.Access} | ft IdentityReference
