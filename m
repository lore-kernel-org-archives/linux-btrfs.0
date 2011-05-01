From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v6 7/8] Balance filter for virtual address range
Date: Sun,  1 May 2011 16:47:15 +0100
Message-ID: <3db2b2f9276c86dae66cb5fa43b5bf605d324c12.1304262467.git.hugo@carfax.org.uk>
References: <cover.1304262467.git.hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1304262467.git.hugo@carfax.org.uk>
In-Reply-To: <cover.1304262467.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Implement the userspace side of the virtual address range filter.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs_cmds.c   |   22 ++++++++++++++++++++++
 ioctl.h        |    9 +++++++--
 man/btrfs.8.in |    9 +++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 0f1434f..1f6149d 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -779,6 +779,12 @@ const struct filter_class_desc filter_class[] = {
 	  "devid=<n>\n"
 	  "\tBalance only chunks which have a stripe on device <n>.\n",
 	  BTRFS_BALANCE_FILTER_DEVID },
+	{ "vrange",
+	  "vrange=<start>,<end>\n"
+	  "\tBalances only chunks which have any bytes within the given\n"
+	  "\trange of the filesystem's virtual address space.\n"
+	  "\t<start> is inclusive, <end> is exclusive.\n",
+	  BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE },
 	{ NULL, NULL, 0 }
 };
 
@@ -883,6 +889,22 @@ int parse_filter(struct btrfs_ioctl_balance_start *args, char *filters_string)
 				return 15;
 			}
 			break;
+
+		case BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE:
+			errno = 0;
+			args->vrange_start = strtoull(part, NULL, 10);
+			if (errno != 0) {
+				fprintf(stderr, "ERROR: '%s' is not a valid start address\n", part);
+				return 15;
+			}
+			part = strtok_r(NULL, "=,", &subsave);
+			errno = 0;
+			args->vrange_end = strtoull(part, NULL, 10);
+			if (errno != 0) {
+				fprintf(stderr, "ERROR: '%s' is not a valid end address\n", part);
+				return 15;
+			}
+			break;
 		}
 
 		this_filter_string = strtok_r(NULL, ":", &saveptr);
diff --git a/ioctl.h b/ioctl.h
index e30687c..85c5dcc 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -142,7 +142,8 @@ struct btrfs_ioctl_balance_progress {
 
 #define BTRFS_BALANCE_FILTER_CHUNK_TYPE 0x2
 #define BTRFS_BALANCE_FILTER_DEVID 0x4
-#define BTRFS_BALANCE_FILTER_MASK 0x7
+#define BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE 0x8
+#define BTRFS_BALANCE_FILTER_MASK 0xf
 
 /* All the possible options for a filter */
 struct btrfs_ioctl_balance_start {
@@ -159,7 +160,11 @@ struct btrfs_ioctl_balance_start {
 	/* For FILTER_DEVID */
 	__u64 devid;
 
-	__u64 spare[506]; /* Make up the size of the structure to 4088
+	/* For FILTER_VIRTUAL_ADDRESS_RANGE */
+	__u64 vrange_start;
+	__u64 vrange_end;
+
+	__u64 spare[504]; /* Make up the size of the structure to 4088
 					   * bytes for future expansion */
 };
 
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 020260f..c49a82c 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -210,6 +210,15 @@ Select chunks which have data on device ID \fI<n>\fR. This can be
 used, for example, to reduplicate data in a mirrored configuration
 where one drive has been lost due to hardware failure.
 
+.TP
+\fBvrange\fR=\fI<start>\fB,\fI<end>\fR
+
+Select chunks which have btrfs-internal virtual addresses within the
+range \fI<start>\fR (inclusive) to \fI<end>\fR (exclusive). Given the
+address of the last chunk moved, this filter can be used to restart a
+cancelled or interrupted balance operation, by supplying a range of
+\fB0,\fI<chunkaddr+1>\fR.
+
 .SH EXIT STATUS
 \fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
 case of failure.
-- 
1.7.2.5

