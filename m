From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 6/7] btrfs: Don't BUG_ON alloc_path errors in find_next_chunk
Date: Thu, 21 Jul 2011 12:48:32 -0700
Message-ID: <1311277713-7747-7-git-send-email-mfasheh@suse.com>
References: <1311277713-7747-1-git-send-email-mfasheh@suse.com>
 <1311277713-7747-2-git-send-email-mfasheh@suse.com>
 <1311277713-7747-3-git-send-email-mfasheh@suse.com>
 <1311277713-7747-4-git-send-email-mfasheh@suse.com>
 <1311277713-7747-5-git-send-email-mfasheh@suse.com>
 <1311277713-7747-6-git-send-email-mfasheh@suse.com>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311277713-7747-6-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

I also removed the BUG_ON from error return of find_next_chunk in
init_first_rw_device(). It turns out that the only caller of
init_first_rw_device() also BUGS on any nonzero return so no actual behavior
change has occurred here.

do_chunk_alloc() also needed an update since it calls btrfs_alloc_chunk()
which can now return -ENOMEM. Instead of setting space_info->full on any
error from btrfs_alloc_chunk() I catch and return every error value _except_
-ENOSPC. Thanks goes to Tsutomu Itoh for pointing that issue out.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/extent-tree.c |    3 +++
 fs/btrfs/volumes.c     |    6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index aa91773..ff339b2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3277,6 +3277,9 @@ again:
 	}
 
 	ret = btrfs_alloc_chunk(trans, extent_root, flags);
+	if (ret < 0 && ret != -ENOSPC)
+		return ret;
+
 	spin_lock(&space_info->lock);
 	if (ret)
 		space_info->full = 1;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 530a2fc..90d956c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1037,7 +1037,8 @@ static noinline int find_next_chunk(struct btrfs_root *root,
 	struct btrfs_key found_key;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	key.objectid = objectid;
 	key.offset = (u64)-1;
@@ -2663,7 +2664,8 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 
 	ret = find_next_chunk(fs_info->chunk_root,
 			      BTRFS_FIRST_CHUNK_TREE_OBJECTID, &chunk_offset);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	alloc_profile = BTRFS_BLOCK_GROUP_METADATA |
 			(fs_info->metadata_alloc_profile &
-- 
1.7.5.3

