From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v5 8/8] Interface for device range balance filter
Date: Sun, 10 Apr 2011 22:16:34 +0100
Message-ID: <a9ad9bfd6e9f53fc8661823cd920c880b0573bd7.1302469689.git.hugo@carfax.org.uk>
References: <cover.1302469689.git.hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1302469689.git.hugo@carfax.org.uk>
In-Reply-To: <cover.1302469689.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Implement the userspace side of the balance filter for a range of
bytes on any device. Note that this will match the same range on any
device, so the use of the devid filter is recommended where this
filter is used.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs_cmds.c   |   22 ++++++++++++++++++++++
 ioctl.h        |    9 +++++++--
 man/btrfs.8.in |    8 ++++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index e5f2c39..e82c103 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -785,6 +785,12 @@ const struct filter_class_desc filter_class[] = {
 	  "\trange of the filesystem's virtual address space.\n"
 	  "\t<start> is inclusive, <end> is exclusive.\n",
 	  BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE },
+	{ "drange",
+	  "drange=<start>,<end>\n"
+	  "\tBalances chunks which have any bytes within the given\n"
+	  "\tbyte range on any of the filesystem's underlying devices.\n"
+	  "\t<start> is inclusive, <end> is exclusive.\n",
+	  BTRFS_BALANCE_FILTER_DEVICE_ADDRESS_RANGE },
 	{ NULL, NULL, 0 }
 };
 
@@ -907,6 +913,22 @@ int parse_filter(struct btrfs_ioctl_balance_start *args, char *filters_string)
 				return 15;
 			}
 			break;
+
+		case BTRFS_BALANCE_FILTER_DEVICE_ADDRESS_RANGE:
+			errno = 0;
+			args->drange_start = strtoull(part, NULL, 10);
+			if (errno != 0) {
+				fprintf(stderr, "ERROR: '%s' is not a valid start address\n", part);
+				return 15;
+			}
+			part = strtok_r(NULL, "=,", &subsave);
+			errno = 0;
+			args->drange_end = strtoull(part, NULL, 10);
+			if (errno != 0) {
+				fprintf(stderr, "ERROR: '%s' is not a valid end address\n", part);
+				return 15;
+			}
+			break;
 		}
 
 		this_filter_string = strtok_r(NULL, ":", &saveptr);
diff --git a/ioctl.h b/ioctl.h
index 71fa90e..a99c225 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -143,7 +143,8 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_BALANCE_FILTER_CHUNK_TYPE 0x2
 #define BTRFS_BALANCE_FILTER_DEVID 0x4
 #define BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE 0x8
-#define BTRFS_BALANCE_FILTER_MASK 0xf
+#define BTRFS_BALANCE_FILTER_DEVICE_ADDRESS_RANGE 0x10
+#define BTRFS_BALANCE_FILTER_MASK 0x1f
 
 /* All the possible options for a filter */
 struct btrfs_ioctl_balance_start {
@@ -164,7 +165,11 @@ struct btrfs_ioctl_balance_start {
 	__u64 vrange_start;
 	__u64 vrange_end;
 
-	__u64 spare[503]; /* Make up the size of the structure to 4088
+	/* For FILTER_DEVICE_ADDRESS_RANGE */
+	__u64 drange_start;
+	__u64 drange_end;
+
+	__u64 spare[501]; /* Make up the size of the structure to 4088
 					   * bytes for future expansion */
 };
 
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 1031af6..6adf8bb 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -219,6 +219,14 @@ address of the last chunk moved, this filter can be used to restart a
 cancelled or interrupted balance operation, by supplying a range of
 \fB0,\fI<chunkaddr+1>\fR.
 
+.TP
+\fBdrange\fR=\fI<start>\fB,\fI<end>\fR
+
+Select chunks which contain data in the address range \fI<start>\fR
+(inclusive) to \fI<end>\fR (exclusive) on \fIany\fR block device in
+the filesystem. Can be mixed with the \fBdevid\fR filter to select
+chunks in a given address range on a specific device.
+
 .SH EXIT STATUS
 \fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
 case of failure.
-- 
1.7.2.5

