From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v6 5/8] Initial implementation of userspace interface for filtered balancing.
Date: Sun,  1 May 2011 16:47:13 +0100
Message-ID: <e88182ff28fa1267dde4d4d36d09396c369442dc.1304262467.git.hugo@carfax.org.uk>
References: <cover.1304262467.git.hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1304262467.git.hugo@carfax.org.uk>
In-Reply-To: <cover.1304262467.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

It is useful to be able to balance a subset of the full filesystem.
This patch implements the infrastructure for filtering block groups on
different criteria when balancing the filesystem.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs.c        |    5 +-
 btrfs_cmds.c   |  166 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 ioctl.h        |   24 ++++++++
 man/btrfs.8.in |   42 ++++++++++++---
 4 files changed, 224 insertions(+), 13 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 7b42658..a9aeb51 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -92,8 +92,9 @@ static struct Command commands[] = {
 		"Show space usage information for a mount point\n."
 	},
 	{ do_balance, -1,
-	  "filesystem balance", "[-w|--wait] <path>\n"
-		"Balance the chunks across the device."
+	  "filesystem balance", "[-w|--wait] [-c|--count] [-v|--verbose] [-f|--filter=<filter>:...] <path>\n"
+		"Balance chunks across the devices. --filter=help for help on filters.\n"
+		"--count to count chunks only (no balance performed).\n"
 	},
 	{ do_balance, -1,
 	  "balance start", "[-w|--wait] <path>\n"
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 070b8a9..279d93a 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -756,26 +756,171 @@ int do_add_volume(int nargs, char **args)
 
 const struct option balance_options[] = {
 	{ "wait", 0, NULL, 'w' },
+	{ "filter", 1, NULL, 'f' },
+	{ "count", 0, NULL, 'c' },
+	{ "verbose", 0, NULL, 'v' },
 	{ NULL, 0, NULL, 0 }
 };
 
+struct filter_class_desc {
+	char *keyword;
+	char *description;
+	int flag;
+};
+
+const struct filter_class_desc filter_class[] = {
+	{ "type",
+	  "type=[~]<flagname>[,...]\n"
+	  "\tWhere <flagname> is one of:\n"
+	  "\t\tmeta, sys, data, raid0, raid1, raid10, dup\n"
+	  "\tPrefix a <flagname> with ~ to negate the match.\n",
+	  BTRFS_BALANCE_FILTER_CHUNK_TYPE },
+	{ NULL, NULL, 0 }
+};
+
+struct type_filter_desc {
+	char *keyword;
+	__u64 mask;
+	__u64 set;
+	__u64 unset;
+};
+
+#define BTRFS_BLOCK_GROUP_SINGLE \
+	BTRFS_BLOCK_GROUP_RAID0 | \
+	BTRFS_BLOCK_GROUP_RAID1 | \
+	BTRFS_BLOCK_GROUP_RAID10 | \
+	BTRFS_BLOCK_GROUP_DUP
+
+const struct type_filter_desc type_filters[] = {
+	{ "data", BTRFS_BLOCK_GROUP_DATA, BTRFS_BLOCK_GROUP_DATA, 0 },
+	{ "sys", BTRFS_BLOCK_GROUP_SYSTEM, BTRFS_BLOCK_GROUP_SYSTEM, 0 },
+	{ "meta", BTRFS_BLOCK_GROUP_METADATA, BTRFS_BLOCK_GROUP_METADATA, 0 },
+	{ "raid0", BTRFS_BLOCK_GROUP_RAID0, BTRFS_BLOCK_GROUP_RAID0, 0 },
+	{ "raid1", BTRFS_BLOCK_GROUP_RAID1, BTRFS_BLOCK_GROUP_RAID1, 0 },
+	{ "raid10", BTRFS_BLOCK_GROUP_RAID10, BTRFS_BLOCK_GROUP_RAID10, 0 },
+	{ "dup", BTRFS_BLOCK_GROUP_DUP, BTRFS_BLOCK_GROUP_DUP, 0 },
+	{ "single", BTRFS_BLOCK_GROUP_SINGLE, 0, BTRFS_BLOCK_GROUP_SINGLE },
+	{ NULL, 0, 0, 0 }
+};
+
+int parse_filter(struct btrfs_ioctl_balance_start *args, char *filters_string)
+{
+	char *this_filter_string;
+	char *saveptr;
+
+	/* Parse the filters string, if there is one */
+	this_filter_string = strtok_r(filters_string, ":", &saveptr);
+	while(this_filter_string) {
+		char *subsave;
+		char *part;
+		char *type = strtok_r(this_filter_string, "=,", &subsave);
+		int class_id = -1;
+
+		/* Work out what filter type we're looking at */
+		if(strcmp(type, "help") == 0) {
+			while(filter_class[++class_id].keyword) {
+				printf("%s", filter_class[class_id].description);
+			}
+			return 1;
+		}
+
+		while(filter_class[++class_id].keyword) {
+			if(strcmp(type, filter_class[class_id].keyword) == 0)
+				break;
+		}
+		if(filter_class[class_id].keyword == NULL) {
+			fprintf(stderr, "ERROR: Unknown filter type '%s'\n", type);
+			free(args);
+			return 14;
+		}
+
+		/* Mark this filter class as being in use */
+		args->flags |= filter_class[class_id].flag;
+		
+		/* Parse the arguments for this filter */
+		part = strtok_r(NULL, "=,", &subsave);
+
+		switch(filter_class[class_id].flag) {
+		case BTRFS_BALANCE_FILTER_CHUNK_TYPE:
+			while(part) {
+				int negated = 0;
+				int i = 0;
+				if(part[0] == '~') {
+					negated = 1;
+					part += 1;
+				}
+				while(type_filters[i].keyword) {
+					if(strcmp(part, type_filters[i].keyword) == 0)
+						break;
+					i += 1;
+				}
+				if(type_filters[i].keyword == NULL) {
+					fprintf(stderr, "ERROR: Unknown chunk type '%s'\n", part);
+					free(args);
+					return 15;
+				}
+
+				args->chunk_type_mask |= type_filters[i].mask;
+				args->chunk_type &= ~type_filters[i].mask;
+				if (negated)
+					args->chunk_type |= type_filters[i].unset;
+				else
+					args->chunk_type |= type_filters[i].set;
+
+				part = strtok_r(NULL, "=,", &subsave);
+			}
+			break;
+		}
+
+		this_filter_string = strtok_r(NULL, ":", &saveptr);
+	}
+
+	return 0;
+}
+
 int do_balance(int argc, char **argv)
 {
 	int	fdmnt, ret=0;
 	int background = 1;
-	struct btrfs_ioctl_vol_args args;
+	struct btrfs_ioctl_balance_start *args;
 	char *path;
 	int ttyfd;
+	int verbose = 0;
+	int count_only = 0;
+
+	args = malloc(4096);
+	if (!args) {
+		fprintf(stderr, "ERROR: Not enough memory\n");
+		return 13;
+	}
+
+	args->flags = 0;
+	args->chunk_type = 0;
+	args->chunk_type_mask = 0;
 
 	optind = 1;
 	while(1) {
-		int c = getopt_long(argc, argv, "w", balance_options, NULL);
+		int c = getopt_long(argc, argv, "wf:", balance_options, NULL);
 		if (c < 0)
 			break;
 		switch(c) {
 		case 'w':
 			background = 0;
 			break;
+		case 'f':
+			ret = parse_filter(args, optarg);
+			if (ret != 0) {
+				free(args);
+				return ret;
+			}
+			break;
+		case 'c':
+			count_only = 1;
+			background = 0;
+			/* Counting is only sensible if we also print some output. */
+		case 'v':
+			verbose = 1;
+			break;
 		default:
 			fprintf(stderr, "Invalid arguments for balance\n");
 			free(argv);
@@ -783,6 +928,9 @@ int do_balance(int argc, char **argv)
 		}
 	}
 
+	if (background)
+		verbose = 0;
+
 	if(optind >= argc) {
 		fprintf(stderr, "No filesystem path given for balance\n");
 		return 1;
@@ -796,6 +944,9 @@ int do_balance(int argc, char **argv)
 		return 12;
 	}
 
+	if (count_only)
+		args->flags |= BTRFS_BALANCE_FILTER_COUNT_ONLY;
+
 	if (background) {
 		int pid = fork();
 		if (pid == 0) {
@@ -815,14 +966,21 @@ int do_balance(int argc, char **argv)
 		}
 	}
 
-	memset(&args, 0, sizeof(args));
-	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE, &args);
+	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE_FILTERED, args);
 	close(fdmnt);
 	if(ret<0){
 		fprintf(stderr, "ERROR: balancing '%s'\n", path);
 
 		return 19;
 	}
+
+	if (verbose) {
+		printf("%u chunks considered, %u chunks balanced\n",
+			   args->examined, args->balanced);
+	}
+
+	free(args);
+
 	return 0;
 }
 
diff --git a/ioctl.h b/ioctl.h
index 40c0b57..230c314 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -137,6 +137,28 @@ struct btrfs_ioctl_balance_progress {
 	__u32 completed;
 };
 
+/* Types of balance filter */
+#define BTRFS_BALANCE_FILTER_COUNT_ONLY 0x1
+
+#define BTRFS_BALANCE_FILTER_CHUNK_TYPE 0x2
+#define BTRFS_BALANCE_FILTER_MASK 0x3
+
+/* All the possible options for a filter */
+struct btrfs_ioctl_balance_start {
+	__u64 flags; /* Bit field indicating which fields of this struct are filled */
+
+	/* Output values: chunk counts */
+	__u32 examined;
+	__u32 balanced;
+
+	/* For FILTER_CHUNK_TYPE */
+	__u64 chunk_type;      /* Flag bits required */
+	__u64 chunk_type_mask; /* Mask of bits to examine */
+
+	__u64 spare[507]; /* Make up the size of the structure to 4088
+					   * bytes for future expansion */
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -177,4 +199,6 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 27, \
 					struct btrfs_ioctl_balance_progress)
 #define BTRFS_IOC_BALANCE_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
+#define BTRFS_IOC_BALANCE_FILTERED _IOWR(BTRFS_IOCTL_MAGIC, 29, \
+				struct btrfs_ioctl_balance_start)
 #endif
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 77558fa..5ac0694 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -21,11 +21,11 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
 .PP
-\fBbtrfs\fP \fBfilesystem balance\fP [\fB-w\fP|\fB--wait\fP] \fI<path>\fP
+\fBbtrfs\fP \fBfilesystem balance\fP [\fB-wcv\fP] [\fB--wait\fP] [\fB--count\fP] [\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
 .PP
-\fBbtrfs\fP \fBbalance start\fP [\fB-w\fP|\fB--wait\fP] \fI<path>\fP
+\fBbtrfs\fP \fBbalance start\fP [\fB-wcv\fP] [\fB--wait\fP] [\fB--count\fP] [\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBbalance progress\fP [\fB-m\fP|\fB--monitor\fP] \fI<path>\fP
 .PP
@@ -149,13 +149,18 @@ Show the btrfs filesystem with some additional info. If no UUID or label is
 passed, \fBbtrfs\fR show info of all the btrfs filesystem.
 .TP
 
-\fBdevice balance\fR [\fB-w\fP|\fB--wait\fP] \fI<path>\fR
+\fBdevice balance\fP [\fB-wcv\fP] [\fB--wait\fP] [\fB--count\fP] [\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] \fI<path>\fP
 .TP
-\fBbalance start\fR [\fB-w\fP|\fB--wait\fP] \fI<path>\fR
+\fBbalance start\fR [\fB-wcv\fP] [\fB--wait\fP] [\fB--count\fP] [\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] \fI<path>\fP
 
 Balance the chunks of the filesystem identified by \fI<path>\fR across
-the devices. The process runs in the background. Use \fB--wait\fP to
-wait in the foreground for completion of the balance.
+the devices. The command returns immediately, and the balance
+operation runs in the background. Use \fB--wait\fP to run
+synchronously instead. Use \fB--count\fP to scan the filesystem and
+report the number of chunks that would be processed. Use
+\fB--verbose\fP in synchronous mode to report the number of chunks
+examined and balanced. See \fBBALANCE FILTERS\fR, below, for details
+of the different filter types and syntax.
 .TP
 
 \fBdevice add\fR\fI <dev> [<dev>..] <path>\fR
@@ -171,10 +176,33 @@ Report progress on the currently-running balance operation on the
 filesystem mounted at \fI<path>\fP. Use --monitor to report progress
 continually, including an estimate of completion time.
 
-\fbalance cancel\fP \fI<path>\fP
+\fBbalance cancel\fP \fI<path>\fP
 Cancel the balance currently running on the filesystem mounted at
 \fI<path>\fP.
 
+.SH BALANCE FILTERS
+With balance filters, it is possible to perform a balance operation on
+only a subset of the available chunks. Filters are specified with the
+\fB--filter\fR option of \fBbtrfs device balance\fR or \fBbtrfs
+balance start\fR. Multiple filters may be given, either with multiple
+\fB--filter\fR options, or in a colon-separated list. When multiple
+filters are given, only the chunks meeting all of the selection
+critera are balanced. Help on the avaialble filters can be obtained
+with \fB--filter=help\fR.
+
+.TP
+\fBtype\fR=[\fB~\fR]\fI<flagname>\fR[\fB,\fR...]
+
+Select only the chunks with the given type flag(s). Requiring a flag
+to be off can be specified with a \fB~\fR preceding the flag
+name. Flag names are:
+
+\fBmeta\fR, \fBdata\fR, \fBsys\fR for metadata, file data and system
+chunk types.
+
+\fBraid0\fR, \fBraid1\fR, \fBraid10\fR, \fBdup\fR for chunks of the
+given replication levels.
+
 .SH EXIT STATUS
 \fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
 case of failure.
-- 
1.7.2.5

