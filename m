From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 1/2] Btrfs: don't call free_extent_buffer twice in iterate_irefs
Date: Fri, 13 Apr 2012 12:28:00 +0200
Message-ID: <1334312880-21721-1-git-send-email-list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Avoid calling free_extent_buffer more than once when the iterator function
returns non-zero. The only code that uses this is scrub repair for corrupted
nodatasum blocks.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f4e9074..8be551c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1247,7 +1247,7 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
 				struct btrfs_path *path,
 				iterate_irefs_t *iterate, void *ctx)
 {
-	int ret;
+	int ret = 0;
 	int slot;
 	u32 cur;
 	u32 len;
@@ -1259,7 +1259,7 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
 	struct btrfs_inode_ref *iref;
 	struct btrfs_key found_key;
 
-	while (1) {
+	while (!ret) {
 		ret = inode_ref_info(inum, parent ? parent+1 : 0, fs_root, path,
 					&found_key);
 		if (ret < 0)
@@ -1288,10 +1288,8 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
 				 (unsigned long long)found_key.objectid,
 				 (unsigned long long)fs_root->objectid);
 			ret = iterate(parent, iref, eb, ctx);
-			if (ret) {
-				free_extent_buffer(eb);
+			if (ret)
 				break;
-			}
 			len = sizeof(*iref) + name_len;
 			iref = (struct btrfs_inode_ref *)((char *)iref + len);
 		}
-- 
1.7.3.4

