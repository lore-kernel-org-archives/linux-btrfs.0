From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v5 8/8] btrfs: Balance filter for physical device address
Date: Sun, 10 Apr 2011 22:06:11 +0100
Message-ID: <1302469571-12605-9-git-send-email-hugo@carfax.org.uk>
References: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com, dave@jikos.cz, lizf@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Add a filter for balancing which allows the selection of chunks with
data in the given byte range on any block device in the filesystem. On
its own, this filter is of little use, but when used with the devid
filter, it can be used to rebalance all chunks which lie on a part of
a specific device.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ioctl.h   |    9 +++++++--
 fs/btrfs/volumes.c |   19 +++++++++++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 50d4801..a037714 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -168,7 +168,8 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_BALANCE_FILTER_CHUNK_TYPE (1 << 1)
 #define BTRFS_BALANCE_FILTER_DEVID (1 << 2)
 #define BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE (1 << 3)
-#define BTRFS_BALANCE_FILTER_MASK ((1 << 4) - 1) /* Logical or of all filter
+#define BTRFS_BALANCE_FILTER_DEVICE_ADDRESS_RANGE (1 << 4)
+#define BTRFS_BALANCE_FILTER_MASK ((1 << 5) - 1) /* Logical or of all filter
 				       * flags -- effectively versions
 				       * the filtered balance ioctl */
 
@@ -192,7 +193,11 @@ struct btrfs_ioctl_balance_start {
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
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9216ad85..19dc117 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2124,6 +2124,25 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 		if (filter->vrange_start >= end || start >= filter->vrange_end)
 			return 0;
 	}
+	if (filter->flags & BTRFS_BALANCE_FILTER_DEVICE_ADDRESS_RANGE) {
+		int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
+		int stripe_length = btrfs_chunk_length(eb, chunk)
+			* num_stripes / replinfo.num_copies;
+		int res = 0;
+
+		for (i = 0; i < num_stripes; i++) {
+			struct btrfs_stripe *stripe = btrfs_stripe_nr(chunk, i);
+			u64 start = btrfs_stripe_offset(eb, stripe);
+			u64 end = start + stripe_length;
+			if (filter->drange_start < end
+			    && start < filter->drange_end) {
+				res = 1;
+				break;
+			}
+		}
+		if (!res)
+			return 0;
+	}
 
 	return 1;
 }
-- 
1.7.2.5

