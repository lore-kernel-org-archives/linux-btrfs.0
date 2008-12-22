From: Yan Zheng <zheng.yan@oracle.com>
Subject: Re: btrfs filesystem freeze
Date: Mon, 22 Dec 2008 08:55:33 +0800
Message-ID: <494EE585.5090209@oracle.com>
References: <551034715@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs@vger.kernel.org
To: devzero@web.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <551034715@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

devzero@web.de wrote:
> thank you.
> 
> i tried your patch and did another test run.
> 
> first, it looked better as i could do much more snapshots than before, but then it froze again.
> 
> i don`t really have a clue if your patch enhanced anything, as my test setup isn`t exactly  reproducable for now and i did not check for exact "testing lab conditions".
> 
> after /btrfs froze again, i tried to unmount by forcibly unloading btrfs module. 
> 
> after reloading the module and trying to mount again, it failed with the following  kernel message:
> 
I hope the new patch can solve the problem.

Yan Zheng 

---
diff -urp 1/fs/btrfs/inode.c 2/fs/btrfs/inode.c
--- 1/fs/btrfs/inode.c	2008-12-18 08:09:16.062111805 +0800
+++ 2/fs/btrfs/inode.c	2008-12-22 08:47:06.000000000 +0800
@@ -2891,7 +2891,7 @@ void btrfs_delete_inode(struct inode *in
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
 	btrfs_i_size_write(inode, 0);
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_join_transaction(root, 1);
 
 	btrfs_set_trans_block_group(trans, inode);
 	ret = btrfs_truncate_inode_items(trans, root, inode, inode->i_size, 0);
diff -urp 1/fs/btrfs/transaction.c 2/fs/btrfs/transaction.c
--- 1/fs/btrfs/transaction.c	2008-12-13 12:35:29.487886730 +0800
+++ 2/fs/btrfs/transaction.c	2008-12-21 19:09:09.000000000 +0800
@@ -804,7 +804,7 @@ static noinline int finish_pending_snaps
 
 	parent_inode = pending->dentry->d_parent->d_inode;
 	parent_root = BTRFS_I(parent_inode)->root;
-	trans = btrfs_start_transaction(parent_root, 1);
+	trans = btrfs_join_transaction(parent_root, 1);
 
 	/*
 	 * insert the directory item
