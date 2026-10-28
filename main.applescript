-- Errors are already logged by the shell script; swallowing them here stops a dialog popping up from a background run.
try
	do shell script quoted form of POSIX path of (path to resource "prune-lr-backups.sh")
end try
