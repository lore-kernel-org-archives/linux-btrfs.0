From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v8 8/8] btrfs: Balance filter for physical device address
Date: Sun, 26 Jun 2011 21:36:55 +0100
Message-ID: <1309120615-18104-9-git-send-email-hugo@carfax.org.uk>
References: <1309120615-18104-1-git-send-email-hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309120615-18104-1-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Add a filter for balancing which allows the selection of chunks with
data in the given byte range on any block device in the filesystem. On
its own, this filter is of little use, but when used with the devid
filter, it can be used to rebalance all chunks which lie on a part of
a specific device.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ioctl.h   |    9 +++++++--
 fs/btrfs/volumes.c |   22 ++++++++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index ba09b19..08fcfed 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -204,7 +204,8 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_BALANCE_FILTER_CHUNK_TYPE (1 << 1)
 #define BTRFS_BALANCE_FILTER_DEVID (1 << 2)
 #define BTRFS_BALANCE_FILTER_VIRTUAL_ADDRESS_RANGE (1 << 3)
-#define BTRFS_BALANCE_FILTER_MASK ((1 << 4) - 1) /* Logical or of all filter
+#define BTRFS_BALANCE_FILTER_DEVICE_ADDRESS_RANGE (1 << 4)
+#define BTRFS_BALANCE_FILTER_MASK ((1 << 5) - 1) /* Logical or of all filter
 				       * flags -- effectively versions
 				       * the filtered balance ioctl */
 
@@ -228,7 +229,11 @@ struct btrfs_ioctl_balance_start {
 	__u64 vrange_start;
 	__u64 vrange_end;
 
-	__u64 spare[504]; /* Make up the size of the structure to 4088
+	/* For FILTER_DEVICE_ADDRESS_RANGE */
+	__u64 drange_start;
+	__u64 drange_end;
+
+	__u64 spare[502]; /* Make up the size of the structure to 4088
 			   * bytes for future expansion */
 };
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fb11550..fa536e9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2067,6 +2067,7 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 	struct extent_buffer *eb;
 	struct btrfs_chunk *chunk;
 	int i;
+	struct btrfs_replication_info replinfo;
 
 	/* No filter defined, everything matches */
 	if (!filter)
@@ -2080,6 +2081,8 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 	chunk = btrfs_item_ptr(eb, path->slots[0],
 						   struct btrfs_chunk);
 
+	btrfs_get_replication_info(&replinfo, btrfs_chunk_type(eb, chunk));
+
 	if (filter->flags & BTRFS_BALANCE_FILTER_CHUNK_TYPE) {
 		if ((btrfs_chunk_type(eb, chunk) & filter->chunk_type_mask)
 			!= filter->chunk_type) {
@@ -2105,6 +2108,25 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
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

