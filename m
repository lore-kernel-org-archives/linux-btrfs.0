From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v4 8/8] btrfs: Balance filter for physical device address
Date: Thu,  7 Apr 2011 18:06:15 +0100
Message-ID: <1302195975-3088-9-git-send-email-hugo@carfax.org.uk>
References: <1302195975-3088-1-git-send-email-hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302195975-3088-1-git-send-email-hugo@carfax.org.uk>
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
index 5177229..b13f14d 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -168,7 +168,8 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_BALANCE_FILTER_CHUNK_TYPE 0x2
 #define BTRFS_BALANCE_FILTER_DEVID 0x4
 #define BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE 0x8
-#define BTRFS_BALANCE_FILTER_MASK 0xf /* Logical or of all filter
+#define BTRFS_BALANCE_FILTER_DEVICE_ADDRESS_RANGE 0x10
+#define BTRFS_BALANCE_FILTER_MASK 0x1f /* Logical or of all filter
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
index 83f13b6..f97f19f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2123,6 +2123,25 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
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

