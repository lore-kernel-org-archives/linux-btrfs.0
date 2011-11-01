From: David Sterba <dave@jikos.cz>
Subject: Warnings: destroy inode (was: new integration-danger branch pushed out (kernel))
Date: Tue, 1 Nov 2011 11:28:41 +0100
Message-ID: <20111101102841.GC12759@twin.jikos.cz>
References: <20111101024957.GH4468@shiny>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111101024957.GH4468@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

this time I'm not quite sure which xfstest triggered it, but there was

209 35s ...     [11:20:19] [11:20:53] [failed, exit status 1] - output mismatch (see 209.out.bad)
--- 209.out     2011-02-11 11:42:31.000000000 +0100
+++ 209.out.bad 2011-11-01 11:20:53.000000000 +0100
@@ -1,2 +1,2 @@
 QA output created by 209
-test ran for 30 seconds without error
+reader found old byte at pos 7380992
\ No newline at end of file


[ 3134.165501] ------------[ cut here ]------------
[ 3134.171488] WARNING: at fs/btrfs/inode.c:6789 btrfs_destroy_inode+0x315/0x350 [btrfs]()
[ 3134.180812] Hardware name: Santa Rosa platform
[ 3134.180814] Modules linked in: loop btrfs aoe
[ 3134.180820] Pid: 26264, comm: rm Tainted: G        W   3.1.0-default+ #64
[ 3134.180822] Call Trace:
[ 3134.180829]  [<ffffffff81057fdf>] warn_slowpath_common+0x7f/0xc0
[ 3134.180832]  [<ffffffff8105803a>] warn_slowpath_null+0x1a/0x20
[ 3134.180845]  [<ffffffffa0048165>] btrfs_destroy_inode+0x315/0x350 [btrfs]
[ 3134.180850]  [<ffffffff8115db3c>] destroy_inode+0x3c/0x70
[ 3134.180853]  [<ffffffff8115dc8e>] evict+0x11e/0x1c0
[ 3134.180855]  [<ffffffff8115de3d>] iput+0x10d/0x210
[ 3134.180859]  [<ffffffff8115240f>] do_unlinkat+0x16f/0x1d0
[ 3134.180863]  [<ffffffff81a15319>] ? retint_swapgs+0x13/0x1b
[ 3134.180867]  [<ffffffff81097bd5>] ? trace_hardirqs_on_caller+0x155/0x1d0
[ 3134.180872]  [<ffffffff8135c9be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 3134.180875]  [<ffffffff811532b2>] sys_unlinkat+0x22/0x40
[ 3134.180879]  [<ffffffff81a1d782>] system_call_fastpath+0x16/0x1b
[ 3134.180882] ---[ end trace 81d2bc6c70d7ca5c ]---
[ 3134.180883] ------------[ cut here ]------------
[ 3134.180895] WARNING: at fs/btrfs/inode.c:6790 btrfs_destroy_inode+0x2ff/0x350 [btrfs]()
[ 3134.180897] Hardware name: Santa Rosa platform
[ 3134.180899] Modules linked in: loop btrfs aoe
[ 3134.180903] Pid: 26264, comm: rm Tainted: G        W   3.1.0-default+ #64
[ 3134.180905] Call Trace:
[ 3134.180908]  [<ffffffff81057fdf>] warn_slowpath_common+0x7f/0xc0
[ 3134.180911]  [<ffffffff8105803a>] warn_slowpath_null+0x1a/0x20
[ 3134.180923]  [<ffffffffa004814f>] btrfs_destroy_inode+0x2ff/0x350 [btrfs]
[ 3134.180927]  [<ffffffff8115db3c>] destroy_inode+0x3c/0x70
[ 3134.180929]  [<ffffffff8115dc8e>] evict+0x11e/0x1c0
[ 3134.180933]  [<ffffffff8115de3d>] iput+0x10d/0x210
[ 3134.180936]  [<ffffffff8115240f>] do_unlinkat+0x16f/0x1d0
[ 3134.180939]  [<ffffffff81a15319>] ? retint_swapgs+0x13/0x1b
[ 3134.180942]  [<ffffffff81097bd5>] ? trace_hardirqs_on_caller+0x155/0x1d0
[ 3134.180945]  [<ffffffff8135c9be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 3134.180948]  [<ffffffff811532b2>] sys_unlinkat+0x22/0x40
[ 3134.180952]  [<ffffffff81a1d782>] system_call_fastpath+0x16/0x1b
[ 3134.180954] ---[ end trace 81d2bc6c70d7ca5d ]---
[ 3134.180956] ------------[ cut here ]------------
[ 3134.180967] WARNING: at fs/btrfs/inode.c:6792 btrfs_destroy_inode+0x2d3/0x350 [btrfs]()
[ 3134.181008] Hardware name: Santa Rosa platform
[ 3134.181010] Modules linked in: loop btrfs aoe
[ 3134.181014] Pid: 26264, comm: rm Tainted: G        W   3.1.0-default+ #64
[ 3134.181016] Call Trace:
[ 3134.181019]  [<ffffffff81057fdf>] warn_slowpath_common+0x7f/0xc0
[ 3134.181023]  [<ffffffff8105803a>] warn_slowpath_null+0x1a/0x20
[ 3134.181035]  [<ffffffffa0048123>] btrfs_destroy_inode+0x2d3/0x350 [btrfs]
[ 3134.181038]  [<ffffffff8115db3c>] destroy_inode+0x3c/0x70
[ 3134.181041]  [<ffffffff8115dc8e>] evict+0x11e/0x1c0
[ 3134.181043]  [<ffffffff8115de3d>] iput+0x10d/0x210
[ 3134.181046]  [<ffffffff8115240f>] do_unlinkat+0x16f/0x1d0
[ 3134.181049]  [<ffffffff81a15319>] ? retint_swapgs+0x13/0x1b
[ 3134.181052]  [<ffffffff81097bd5>] ? trace_hardirqs_on_caller+0x155/0x1d0
[ 3134.181055]  [<ffffffff8135c9be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 3134.181059]  [<ffffffff811532b2>] sys_unlinkat+0x22/0x40
[ 3134.181062]  [<ffffffff81a1d782>] system_call_fastpath+0x16/0x1b
[ 3134.181064] ---[ end trace 81d2bc6c70d7ca5e ]---
[ 3135.152109] ------------[ cut here ]------------

6782 void btrfs_destroy_inode(struct inode *inode)
6783 {
6784         struct btrfs_ordered_extent *ordered;
6785         struct btrfs_root *root = BTRFS_I(inode)->root;
6786
6787         WARN_ON(!list_empty(&inode->i_dentry));
6788         WARN_ON(inode->i_data.nrpages);
6789         WARN_ON(BTRFS_I(inode)->outstanding_extents);
6790         WARN_ON(BTRFS_I(inode)->reserved_extents);
6791         WARN_ON(BTRFS_I(inode)->delalloc_bytes);
6792         WARN_ON(BTRFS_I(inode)->csum_bytes);


david
