From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 6/7] btrfs: Don't BUG_ON alloc_path errors in find_next_chunk
Date: Thu, 14 Jul 2011 15:15:01 -0700
Message-ID: <1310681702-13922-7-git-send-email-mfasheh@suse.com>
References: <1310681702-13922-1-git-send-email-mfasheh@suse.com>
 <1310681702-13922-2-git-send-email-mfasheh@suse.com>
 <1310681702-13922-3-git-send-email-mfasheh@suse.com>
 <1310681702-13922-4-git-send-email-mfasheh@suse.com>
 <1310681702-13922-5-git-send-email-mfasheh@suse.com>
 <1310681702-13922-6-git-send-email-mfasheh@suse.com>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310681702-13922-6-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

I also removed the BUG_ON from error return of find_next_chunk in
init_first_rw_device(). It turns out that the only caller of
init_first_rw_device() also BUGS on any nonzero return so no actual behavior
change has occurred here.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/volumes.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

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

