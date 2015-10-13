Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbbJMJI1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 05:08:27 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7405CABF7
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 09:08:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/2] btrfs: extend balance filter limit to take minimum and maximum
Date: Tue, 13 Oct 2015 11:07:16 +0200
Message-Id: <7df131a2100ad31899c8c85253cbeed5a4ee2c40.1444664601.git.dsterba@suse.com>
In-Reply-To: <cover.1444664601.git.dsterba@suse.com>
References: <cover.1444664601.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 'limit' filter is underdesigned, it should have been a range for
[min,max], with some relaxed semantics when one of the bounds is
missing. Besides that, using a full u64 for a single value is a waste of
bytes.

Let's fix both by extending the use of the u64 bytes for the [min,max]
range. This can be done in a backward compatible way, the range will be
interpreted only if the appropriate flag is set
(BTRFS_BALANCE_ARGS_LIMITS).

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h           | 14 ++++++++++++--
 fs/btrfs/volumes.c         | 14 ++++++++++++++
 fs/btrfs/volumes.h         |  1 +
 include/uapi/linux/btrfs.h | 13 ++++++++++++-
 4 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 938efe33be80..7d2e1b6d0ac1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -846,8 +846,18 @@ struct btrfs_disk_balance_args {
 	/* BTRFS_BALANCE_ARGS_* */
 	__le64 flags;
 
-	/* BTRFS_BALANCE_ARGS_LIMIT value */
-	__le64 limit;
+	/*
+	 * BTRFS_BALANCE_ARGS_LIMIT with value 'limit'
+	 * BTRFS_BALANCE_ARGS_LIMITS - the extend version can use minimum and
+	 * maximum
+	 */
+	union {
+		__le64 limit;
+		struct {
+			__le32 limit_min;
+			__le32 limit_max;
+		};
+	};
 
 	__le64 unused[7];
 } __attribute__ ((__packed__));
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6fc735869c18..0693e974f1c0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3250,6 +3250,15 @@ static int should_balance_chunk(struct btrfs_root *root,
 			return 0;
 		else
 			bargs->limit--;
+	} else if ((bargs->flags & BTRFS_BALANCE_ARGS_LIMITS)) {
+		if (bargs->limit_min < bargs->limit_max) {
+			bargs->limit_max--;
+		} else if (bargs->limit_min == bargs->limit_max) {
+			bargs->limit_min = UINT_MAX;
+			bargs->limit_max = 0;
+		} else {
+			return 0;
+		}
 	}
 
 	return 1;
@@ -3274,6 +3283,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	int ret;
 	int enospc_errors = 0;
 	bool counting = true;
+	/* The single value limit and min/max limits use the same bytes in the */
 	u64 limit_data = bctl->data.limit;
 	u64 limit_meta = bctl->meta.limit;
 	u64 limit_sys = bctl->sys.limit;
@@ -3317,6 +3327,10 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	spin_unlock(&fs_info->balance_lock);
 again:
 	if (!counting) {
+		/*
+		 * The single value limit and min/max limits use the same bytes
+		 * in the
+		 */
 		bctl->data.limit = limit_data;
 		bctl->meta.limit = limit_meta;
 		bctl->sys.limit = limit_sys;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2ca784a14e84..1c9d8edd7d57 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -375,6 +375,7 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
 #define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
 #define BTRFS_BALANCE_ARGS_LIMIT	(1ULL << 5)
+#define BTRFS_BALANCE_ARGS_LIMITS	(1ULL << 6)
 
 /*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index b6dec05c7196..264ecea5ecfc 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -217,7 +217,18 @@ struct btrfs_balance_args {
 
 	__u64 flags;
 
-	__u64 limit;		/* limit number of processed chunks */
+	/*
+	 * BTRFS_BALANCE_ARGS_LIMIT with value 'limit'
+	 * BTRFS_BALANCE_ARGS_LIMITS - the extend version can use minimum and
+	 * maximum
+	 */
+	union {
+		__u64 limit;		/* limit number of processed chunks */
+		struct {
+			__u32 limit_min;
+			__u32 limit_max;
+		};
+	};
 	__u64 unused[7];
 } __attribute__ ((__packed__));
 
-- 
2.6.1

