Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56728 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725731AbeHUFAI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 01:00:08 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 76638AD72
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 01:42:06 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2.1] btrfs: Handle owner mismatch gracefully when walking up tree
Date: Tue, 21 Aug 2018 09:42:03 +0800
Message-Id: <20180821014203.5443-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
When mounting certain crafted image, btrfs will trigger kernel BUG_ON()
when try to recover balance:
------
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:8956!
invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
CPU: 1 PID: 662 Comm: mount Not tainted 4.18.0-rc1-custom+ #10
RIP: 0010:walk_up_proc+0x336/0x480 [btrfs]
RSP: 0018:ffffb53540c9b890 EFLAGS: 00010202
Call Trace:
 walk_up_tree+0x172/0x1f0 [btrfs]
 btrfs_drop_snapshot+0x3a4/0x830 [btrfs]
 merge_reloc_roots+0xe1/0x1d0 [btrfs]
 btrfs_recover_relocation+0x3ea/0x420 [btrfs]
 open_ctree+0x1af3/0x1dd0 [btrfs]
 btrfs_mount_root+0x66b/0x740 [btrfs]
 mount_fs+0x3b/0x16a
 vfs_kern_mount.part.9+0x54/0x140
 btrfs_mount+0x16d/0x890 [btrfs]
 mount_fs+0x3b/0x16a
 vfs_kern_mount.part.9+0x54/0x140
 do_mount+0x1fd/0xda0
 ksys_mount+0xba/0xd0
 __x64_sys_mount+0x21/0x30
 do_syscall_64+0x60/0x210
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
---[ end trace d4344e4deee03435 ]---
------

[CAUSE]
Another extent tree corruption.

In this particular case, tree reloc root's owner is
DATA_RELOC_TREE (should be TREE_RELOC_TREE), thus its backref is
corrupted and we failed the owner check in walk_up_tree().

[FIX]
It's pretty hard to take care of every extent tree corruption, but at
least we can remove such BUG_ON() and exit more gracefully.

And since in this particular image, DATA_RELOC_TREE and TREE_RELOC_TREE
shares the same root (which is obviously invalid), we needs to make
__del_reloc_root() more robust to detect such invalid share to avoid
possible NULL dereference as root->node can be NULL in this case.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=200411
Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Merge the same error message output code into one block and add label
  for the goto usage.
v2.1:
  Fix compile error.
---
 fs/btrfs/extent-tree.c | 18 ++++++++++++------
 fs/btrfs/relocation.c  |  2 +-
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3578fa5b30ef..697dffc9d598 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8939,15 +8939,14 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 	if (eb == root->node) {
 		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
 			parent = eb->start;
-		else
-			BUG_ON(root->root_key.objectid !=
-			       btrfs_header_owner(eb));
+		else if (root->root_key.objectid != btrfs_header_owner(eb))
+			goto owner_mismatch;
 	} else {
 		if (wc->flags[level + 1] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
 			parent = path->nodes[level + 1]->start;
-		else
-			BUG_ON(root->root_key.objectid !=
-			       btrfs_header_owner(path->nodes[level + 1]));
+		else if (root->root_key.objectid !=
+			   btrfs_header_owner(path->nodes[level + 1]))
+			goto owner_mismatch;
 	}
 
 	btrfs_free_tree_block(trans, root, eb, parent, wc->refs[level] == 1);
@@ -8955,6 +8954,11 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 	wc->refs[level] = 0;
 	wc->flags[level] = 0;
 	return 0;
+
+owner_mismatch:
+	btrfs_err_rl(fs_info, "unexpected tree owner, have %llu expect %llu",
+		     btrfs_header_owner(eb), root->root_key.objectid);
+	return -EUCLEAN;
 }
 
 static noinline int walk_down_tree(struct btrfs_trans_handle *trans,
@@ -9008,6 +9012,8 @@ static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
 			ret = walk_up_proc(trans, root, path, wc);
 			if (ret > 0)
 				return 0;
+			if (ret < 0)
+				return ret;
 
 			if (path->locks[level]) {
 				btrfs_tree_unlock_rw(path->nodes[level],
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index be94c65bb4d2..5ee49b796815 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1321,7 +1321,7 @@ static void __del_reloc_root(struct btrfs_root *root)
 	struct mapping_node *node = NULL;
 	struct reloc_control *rc = fs_info->reloc_ctl;
 
-	if (rc) {
+	if (rc && root->node) {
 		spin_lock(&rc->reloc_root_tree.lock);
 		rb_node = tree_search(&rc->reloc_root_tree.rb_root,
 				      root->node->start);
-- 
2.18.0
