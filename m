From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH RFC] Initial implementation of userspace interface for filtered balancing.
Date: Tue, 18 Jan 2011 21:31:17 +0000
Message-ID: <41000ab0802c6ca175a9d1e209a2b0af96bba4be.1295394184.git.hugo@carfax.org.uk>
References: <E1PfLAh-00035I-Oz@ruthven.carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <E1PfLAh-00035I-Oz@ruthven.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

   This is the userspace side of the filtered balance patch, again
purely for comment at this stage. The command-line invocation will
look something like this:

$ sudo btrfs fi bal --filter type=meta,~raid1 /mnt

   This will balance all metadata block groups that are not replicated
with RAID1. Once I've implemented additional filter types, they can be
specified with extra --filter options, with the semantics of "and"
between each --filter option.

   (Yes, Goffredo, I know I need to update the man pages for this
patch... :) )

   This patch, and the preceding kernel one, both apply on top of my
previous balance progress/cancel patches.

   Hugo.


It is useful to be able to balance a subset of the full filesystem.
This patch implements the infrastructure for filtering block groups on
different criteria when balancing the filesystem.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs.c      |    4 +-
 btrfs_cmds.c |  132 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 ioctl.h      |   15 +++++++
 3 files changed, 145 insertions(+), 6 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 7b42658..19b0e56 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -92,8 +92,8 @@ static struct Command commands[] = {
 		"Show space usage information for a mount point\n."
 	},
 	{ do_balance, -1,
-	  "filesystem balance", "[-w|--wait] <path>\n"
-		"Balance the chunks across the device."
+	  "filesystem balance", "[-w|--wait] [-f|--filter=<filter>:...] <path>\n"
+		"Balance chunks across the devices. --filter=help for help on filters.\n"
 	},
 	{ do_balance, -1,
 	  "balance start", "[-w|--wait] <path>\n"
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index fadcb4f..f7bd835 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -756,26 +756,74 @@ int do_add_volume(int nargs, char **args)
 
 const struct option balance_options[] = {
 	{ "wait", 0, NULL, 'w' },
+	{ "filter", 1, NULL, 'f' },
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
 int do_balance(int argc, char **argv)
 {
 	int	fdmnt, ret=0;
 	int background = 1;
-	struct btrfs_ioctl_vol_args args;
+	struct btrfs_ioctl_balance_start *args;
 	char *path;
+	char *filters_string = NULL;
+	char *this_filter_string;
+	char *saveptr;
 	int ttyfd;
 
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
+			filters_string = optarg;
+			break;
 		default:
 			fprintf(stderr, "Invalid arguments for balance\n");
 			free(argv);
@@ -796,6 +844,82 @@ int do_balance(int argc, char **argv)
 		return 12;
 	}
 
+	args = malloc(4096);
+	if (!args) {
+		fprintf(stderr, "ERROR: Not enough memory\n");
+		return 13;
+	}
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
+			return 0;
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
+			args->chunk_type = 0;
+			args->chunk_type_mask = 0;
+
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
 	if (background) {
 		int pid = fork();
 		if (pid == 0) {
@@ -815,8 +939,8 @@ int do_balance(int argc, char **argv)
 		}
 	}
 
-	memset(&args, 0, sizeof(args));
-	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE, &args);
+	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE_FILTERED, args);
+	free(args);
 	close(fdmnt);
 	if(ret<0){
 		fprintf(stderr, "ERROR: balancing '%s'\n", path);
diff --git a/ioctl.h b/ioctl.h
index 1fc665b..bdcaf13 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -137,6 +137,19 @@ struct btrfs_ioctl_balance_progress {
 	__u64 completed;
 };
 
+/* Types of balance filter */
+#define BTRFS_BALANCE_FILTER_CHUNK_TYPE 0x1
+#define BTRFS_BALANCE_FILTER_MASK 0x1
+
+/* All the possible options for a filter */
+struct btrfs_ioctl_balance_start {
+	__u64 flags; /* Bit field indicating which fields of this struct are filled */
+
+	/* For FILTER_CHUNK_TYPE */
+	__u64 chunk_type;      /* Flag bits required */
+	__u64 chunk_type_mask; /* Mask of bits to examine */
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -177,4 +190,6 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 25, \
 					struct btrfs_ioctl_balance_progress)
 #define BTRFS_IOC_BALANCE_CANCEL _IO(BTRFS_IOCTL_MAGIC, 26)
+#define BTRFS_IOC_BALANCE_FILTERED _IOW(BTRFS_IOCTL_MAGIC, 27, \
+				struct btrfs_ioctl_balance_start)
 #endif
-- 
1.7.2.3

