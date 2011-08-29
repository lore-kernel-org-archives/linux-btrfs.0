From: slyich@gmail.com
Subject: [PATCH] btrfs: btrfs_print_leaf: don't OOps on NULL extent_buffer parameter
Date: Mon, 29 Aug 2011 23:29:02 +0300
Message-ID: <1314649742-10677-1-git-send-email-slyich@gmail.com>
Cc: Josef Bacik <josef@redhat.com>,
	Sergei Trofimovich <slyfox@gentoo.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

btrfs_print_leaf() is usually called in emergency situations.
Don't die on SIGSEGV in such situations. Skip gracefully instead:

> [   18.680000] parent transid verify failed on 227736236032 wanted 132659 found 123593
> [   22.410000] btrfs: btrfs_print_leaf got NULL extent buffer. Skip printing.
> [   22.410000] ------------[ cut here ]------------
> [   22.410000] WARNING: at linux-2.6/fs/btrfs/extent-tree.c:4482 __btrfs_free_extent+0x650/0x7e0()
> [   22.410000] Call Trace:
> [   22.410000] 6f569a98:  [<600314a2>] warn_slowpath_common+0x62/0x90
...
> [   22.410000] btrfs unable to find ref byte nr 39186432 parent 0 root 5  owner 0 offset 0
Instead of OOPsing in btrfs_print_leaf in get a little deeper and print useful info.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/print-tree.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index fb2605d..7089603 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -159,7 +159,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
 	u32 type;
-	u32 nr = btrfs_header_nritems(l);
+	u32 nr;
 	struct btrfs_item *item;
 	struct btrfs_root_item *ri;
 	struct btrfs_dir_item *di;
@@ -172,6 +172,13 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 
+	if (!l) {
+		printk(KERN_ERR "btrfs: btrfs_print_leaf got NULL extent buffer. Skip printing.\n");
+		return;
+	}
+
+	nr = btrfs_header_nritems(l);
+
 	printk(KERN_INFO "leaf %llu total ptrs %d free space %d\n",
 		(unsigned long long)btrfs_header_bytenr(l), nr,
 		btrfs_leaf_free_space(root, l));
-- 
1.7.3.4

