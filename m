From: Balaji Rao <balajirrao@gmail.com>
Subject: Problem during implementing NFS support
Date: Mon, 21 Jul 2008 00:41:10 +0530
Message-ID: <200807210041.10609.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

There's a problem in btrfs_readdir that tries to lock a root node with one 
being held. This happens when NFS calls vfs_readdir function with a nfs 
specific filldir function pointer. This filldir function, called with the 
lock held calls btrfs_lookup, which tries to take the same lock. So, it keeps 
waiting on lock_page indefinitely - a deadlock. This is not seen if the inode 
is RAM in which case, lookup is not called.

Why can't we allow multiple readers to read a page ?

Please clarify.

Balaji Rao
