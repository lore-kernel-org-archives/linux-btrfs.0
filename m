From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v4 6/8] btrfs: Balance filter for virtual address ranges
Date: Thu,  7 Apr 2011 18:06:13 +0100
Message-ID: <1302195975-3088-7-git-send-email-hugo@carfax.org.uk>
References: <1302195975-3088-1-git-send-email-hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302195975-3088-1-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Allow the balancing of chunks where some part of the chunk lies within
the virtual (i.e. btrfs-internal) address range passed.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ioctl.h   |    9 +++++++--
 fs/btrfs/volumes.c |    6 ++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 29627ca..5177229 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -167,7 +167,8 @@ struct btrfs_ioctl_balance_progress {
 
 #define BTRFS_BALANCE_FILTER_CHUNK_TYPE 0x2
 #define BTRFS_BALANCE_FILTER_DEVID 0x4
-#define BTRFS_BALANCE_FILTER_MASK 0x7 /* Logical or of all filter
+#define BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE 0x8
+#define BTRFS_BALANCE_FILTER_MASK 0xf /* Logical or of all filter
 				       * flags -- effectively versions
 				       * the filtered balance ioctl */
 
@@ -187,7 +188,11 @@ struct btrfs_ioctl_balance_start {
 	/* For FILTER_DEVID */
 	__u64 devid;
 
-	__u64 spare[505]; /* Make up the size of the structure to 4088
+	/* For FILTER_VIRTUAL_ADDRESS_RANGE */
+	__u64 vrange_start;
+	__u64 vrange_end;
+
+	__u64 spare[503]; /* Make up the size of the structure to 4088
 			   * bytes for future expansion */
 };
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4f215e7..4c1b5a6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2070,6 +2070,12 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 		if (!res)
 			return 0;
 	}
+	if (filter->flags & BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE) {
+		u64 start = key->offset;
+		u64 end = start + btrfs_chunk_length(eb, chunk);
+		if (filter->vrange_start >= end || start >= filter->vrange_end)
+			return 0;
+	}
 
 	return 1;
 }
-- 
1.7.2.5

