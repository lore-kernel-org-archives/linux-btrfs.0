Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:48447 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbeDXFDU (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Apr 2018 01:03:20 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: print-tree: Add locking status output for debug build
Date: Tue, 24 Apr 2018 13:03:13 +0800
Message-Id: <20180424050313.32740-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's pretty handy if we can get debug output for locking status of an
extent buffer, specially for race related debugging.

So add the following output for btrfs_print_tree() and
btrfs_print_leaf():
- refs
- write_locks (as w:%d)
- read_locks (as r:%d)
- blocking_writers (as bw:%d)
- blocking_readers (as br:%d)
- spinning_writers (as sw:%d)
- spinning_readers (as sr:%d)
- lock_owner
- current->pid

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Use correct specifier for int (both atomic_t and pid_t, no special
  specifier found in Documentation/core-api/printk-formats.rst)
---
 fs/btrfs/print-tree.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 9904cf741e1c..7f0ada51e5fe 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -179,6 +179,26 @@ static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
 	}
 }
 
+/*
+ * Helper to output refs and locking status.
+ *
+ * Useful to debug race related problem
+ */
+static void print_eb_refs_lock(struct extent_buffer *eb)
+{
+#ifdef CONFIG_BTRFS_DEBUG
+	btrfs_info(eb->fs_info,
+"refs %u lock(w:%u r:%u bw:%u br:%u sw:%u sr:%u) lock_owner %u current %u",
+		   atomic_read(&eb->refs), atomic_read(&eb->write_locks),
+		   atomic_read(&eb->read_locks),
+		   atomic_read(&eb->blocking_writers),
+		   atomic_read(&eb->blocking_readers),
+		   atomic_read(&eb->spinning_writers),
+		   atomic_read(&eb->spinning_readers),
+		   eb->lock_owner, current->pid);
+#endif
+}
+
 void btrfs_print_leaf(struct extent_buffer *l)
 {
 	struct btrfs_fs_info *fs_info;
@@ -206,6 +226,7 @@ void btrfs_print_leaf(struct extent_buffer *l)
 		   "leaf %llu gen %llu total ptrs %d free space %d owner %llu",
 		   btrfs_header_bytenr(l), btrfs_header_generation(l), nr,
 		   btrfs_leaf_free_space(fs_info, l), btrfs_header_owner(l));
+	print_eb_refs_lock(l);
 	for (i = 0 ; i < nr ; i++) {
 		item = btrfs_item_nr(i);
 		btrfs_item_key_to_cpu(l, &key, i);
@@ -360,6 +381,7 @@ void btrfs_print_tree(struct extent_buffer *c, bool follow)
 		   btrfs_header_bytenr(c), level, btrfs_header_generation(c),
 		   nr, (u32)BTRFS_NODEPTRS_PER_BLOCK(fs_info) - nr,
 		   btrfs_header_owner(c));
+	print_eb_refs_lock(c);
 	for (i = 0; i < nr; i++) {
 		btrfs_node_key_to_cpu(c, &key, i);
 		pr_info("\tkey %d (%llu %u %llu) block %llu gen %llu\n",
-- 
2.17.0

