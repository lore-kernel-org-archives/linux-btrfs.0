From: Yan Zheng <zheng.yan@oracle.com>
Subject: Re: btrfs filesystem freeze
Date: Sun, 21 Dec 2008 19:13:19 +0800
Message-ID: <494E24CF.9080907@oracle.com>
References: <550569572@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs@vger.kernel.org
To: devzero@web.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <550569572@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

devzero@web.de wrote:
> Hello, 
> 
> i was testing btrfs a little bit for stability and i think i have found an issue.
> 
> during some heavy activity (multiple processes writing/reading to compressed /btrfs at the same time), i did some snapshots in a loop (every 10 seconds).
> 
> very soon, all filesystem activity stopped, i.e. i cannot read/write anyting from/to /btrfs anymore.
> this happens with latest git-unstable with kernel 2.6.27
> nothing in dmesg. 
> 
> besides that, the system seems ok.
> 
> as the system is a vmware virtual machine, i did a snapshot of the system state, so we can always go back to this state.
> 
> if somebody want`s to analyse this, please tell me what to do.
> 

Thank you for reporting this. Please try the attached patch.

Yan Zheng

---
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
