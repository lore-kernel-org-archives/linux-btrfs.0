From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v5 6/8] Balance filter by device ID
Date: Sun, 10 Apr 2011 22:16:32 +0100
Message-ID: <358851595c0a5aaa94038a34d7efe275d536457e.1302469689.git.hugo@carfax.org.uk>
References: <cover.1302469689.git.hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1302469689.git.hugo@carfax.org.uk>
In-Reply-To: <cover.1302469689.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Add the userspace implementation for filtering balances by device ID.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs_cmds.c   |   13 +++++++++++++
 ioctl.h        |    8 ++++++--
 man/btrfs.8.in |    7 +++++++
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index f0588d2..ffca32b 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -775,6 +775,10 @@ const struct filter_class_desc filter_class[] = {
 	  "\t\tmeta, sys, data, raid0, raid1, raid10, dup\n"
 	  "\tPrefix a <flagname> with ~ to negate the match.\n",
 	  BTRFS_BALANCE_FILTER_CHUNK_TYPE },
+	{ "devid",
+	  "devid=<n>\n"
+	  "\tBalance only chunks which have a stripe on device <n>.\n",
+	  BTRFS_BALANCE_FILTER_DEVID },
 	{ NULL, NULL, 0 }
 };
 
@@ -872,6 +876,15 @@ int parse_filter(struct btrfs_ioctl_balance_start *args, char *filters_string)
 				part = strtok_r(NULL, "=,", &subsave);
 			}
 			break;
+
+		case BTRFS_BALANCE_FILTER_DEVID:
+			errno = 0;
+			args->devid = strtoull(part, NULL, 10);
+			if (errno != 0) {
+				fprintf(stderr, "ERROR: '%s' is not a valid device ID\n", part);
+				return 15;
+			}
+			break;
 		}
 
 		this_filter_string = strtok_r(NULL, ":", &saveptr);
diff --git a/ioctl.h b/ioctl.h
index 6488e82..cb605c0 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -141,7 +141,8 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_BALANCE_FILTER_COUNT_ONLY 0x1
 
 #define BTRFS_BALANCE_FILTER_CHUNK_TYPE 0x2
-#define BTRFS_BALANCE_FILTER_MASK 0x3
+#define BTRFS_BALANCE_FILTER_DEVID 0x4
+#define BTRFS_BALANCE_FILTER_MASK 0x7
 
 /* All the possible options for a filter */
 struct btrfs_ioctl_balance_start {
@@ -155,7 +156,10 @@ struct btrfs_ioctl_balance_start {
 	__u64 chunk_type;      /* Flag bits required */
 	__u64 chunk_type_mask; /* Mask of bits to examine */
 
-	__u64 spare[506]; /* Make up the size of the structure to 4088
+	/* For FILTER_DEVID */
+	__u64 devid;
+
+	__u64 spare[505]; /* Make up the size of the structure to 4088
 					   * bytes for future expansion */
 };
 
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 3023eb5..94114a9 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -203,6 +203,13 @@ chunk types.
 \fBraid0\fR, \fBraid1\fR, \fBraid10\fR, \fBdup\fR for chunks of the
 given replication levels.
 
+.TP
+\fBdevid\fR=\fI<n>\fR
+
+Select chunks which have data on device ID \fI<n>\fR. This can be
+used, for example, to reduplicate data in a mirrored configuration
+where one drive has been lost due to hardware failure.
+
 .SH EXIT STATUS
 \fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
 case of failure.
-- 
1.7.2.5

