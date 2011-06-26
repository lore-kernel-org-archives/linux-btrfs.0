From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v8 5/8] btrfs: Balance filter for device ID
Date: Sun, 26 Jun 2011 21:36:52 +0100
Message-ID: <1309120615-18104-6-git-send-email-hugo@carfax.org.uk>
References: <1309120615-18104-1-git-send-email-hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309120615-18104-1-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Balance filter to take only chunks which have (or had) a stripe on the
given device. Useful if a device has been forcibly removed from the
filesystem, and the data from that device needs rebuilding.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ioctl.h   |    8 ++++++--
 fs/btrfs/volumes.c |   14 ++++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 124296e..21b0e6a 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -202,7 +202,8 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_BALANCE_FILTER_COUNT_ONLY (1 << 0)
 
 #define BTRFS_BALANCE_FILTER_CHUNK_TYPE (1 << 1)
-#define BTRFS_BALANCE_FILTER_MASK ((1 << 2) - 1) /* Logical or of all filter
+#define BTRFS_BALANCE_FILTER_DEVID (1 << 2)
+#define BTRFS_BALANCE_FILTER_MASK ((1 << 3) - 1) /* Logical or of all filter
 				       * flags -- effectively versions
 				       * the filtered balance ioctl */
 
@@ -219,7 +220,10 @@ struct btrfs_ioctl_balance_start {
 	__u64 chunk_type;      /* Flag bits required */
 	__u64 chunk_type_mask; /* Mask of bits to examine */
 
-	__u64 spare[507]; /* Make up the size of the structure to 4088
+	/* For FILTER_DEVID */
+	__u64 devid;
+
+	__u64 spare[506]; /* Make up the size of the structure to 4088
 			   * bytes for future expansion */
 };
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ea466ab..36d9018 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2021,6 +2021,7 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 {
 	struct extent_buffer *eb;
 	struct btrfs_chunk *chunk;
+	int i;
 
 	/* No filter defined, everything matches */
 	if (!filter)
@@ -2040,6 +2041,19 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 			return 0;
 		}
 	}
+	if (filter->flags & BTRFS_BALANCE_FILTER_DEVID) {
+		int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
+		int res = 0;
+		for (i = 0; i < num_stripes; i++) {
+			struct btrfs_stripe *stripe = btrfs_stripe_nr(chunk, i);
+			if (btrfs_stripe_devid(eb, stripe) == filter->devid) {
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

