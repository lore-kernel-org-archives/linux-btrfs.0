Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36536 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751861AbeDKH6M (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 11 Apr 2018 03:58:12 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: calestyo@scientia.net
Subject: [PATCH v2.1 2/2] btrfs-progs: Use more loose open ctree flags for dump-tree and restore
Date: Wed, 11 Apr 2018 15:58:01 +0800
Message-Id: <20180411075801.14686-1-wqu@suse.com>
In-Reply-To: <20180411072936.12915-1-wqu@suse.com>
References: <20180411072936.12915-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Corrupted extent tree (either the root node or leaf) can normally block
us from open the fs.
As normally open_ctree() has the following call chain:
__open_ctree_fd()
|- btrfs_setup_all_roots()
   |- btrfs_read_block_groups()
      And we will search block group items in extent tree.

And considering how block group items are scattered around the whole
extent tree, any error would block the fs from being mounted.

Fortunately, we already have OPEN_CTREE_NO_BLOCK_GROUPS flags to disable
block group items search, which will not only allow us to open some
fs, but also hugely speed up open time.

Currently dump-tree and btrfs-restore is ensured that they care nothing
about block group items. So specify OPEN_CTREE_NO_BLOCK_GROUPS flag as
default.

Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  New comment to explain why OPEN_CTREE_NO_BLOCK_GROUPS is OK here.
v2.1:
  Update commit message, as the typo fix goes to previous patch, not
  this one.
---
 cmds-inspect-dump-tree.c | 10 +++++++++-
 cmds-restore.c           |  9 ++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index e6510851e8f4..b2091d808c55 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -220,12 +220,20 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	int uuid_tree_only = 0;
 	int roots_only = 0;
 	int root_backups = 0;
-	unsigned open_ctree_flags = OPEN_CTREE_PARTIAL;
+	unsigned open_ctree_flags;
 	u64 block_only = 0;
 	struct btrfs_root *tree_root_scan;
 	u64 tree_id = 0;
 	bool follow = false;
 
+	/*
+	 * For debug-tree, we care nothing about extent tree (it's just backref
+	 * and usage accounting, only makes sense for RW operations).
+	 * Use NO_BLOCK_GROUPS here could also speedup open_ctree() and allow us
+	 * to inspect fs with corrupted extent tree blocks, and show as many good
+	 * tree blocks as possible.
+	 */
+	open_ctree_flags = OPEN_CTREE_PARTIAL | OPEN_CTREE_NO_BLOCK_GROUPS;
 	while (1) {
 		int c;
 		enum { GETOPT_VAL_FOLLOW = 256 };
diff --git a/cmds-restore.c b/cmds-restore.c
index ade35f0f880f..f228acab8276 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1281,8 +1281,15 @@ static struct btrfs_root *open_fs(const char *dev, u64 root_location,
 
 	for (i = super_mirror; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
+
+		/*
+		 * Restore won't allocate extent and doesn't care anything
+		 * in extent tree. Skip block group item search will allow
+		 * restore to be executed on heavily damaged fs.
+		 */
 		fs_info = open_ctree_fs_info(dev, bytenr, root_location, 0,
-					     OPEN_CTREE_PARTIAL);
+					     OPEN_CTREE_PARTIAL |
+					     OPEN_CTREE_NO_BLOCK_GROUPS);
 		if (fs_info)
 			break;
 		fprintf(stderr, "Could not open root, trying backup super\n");
-- 
2.17.0

