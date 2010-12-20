Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46161 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0LTCDD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Dec 2010 21:03:03 -0500
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id oBK230kD024649
	for <linux-btrfs@vger.kernel.org> (envelope-from t-itoh@jp.fujitsu.com);
	Mon, 20 Dec 2010 11:03:01 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 8AC1A45DE6A
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Dec 2010 11:02:59 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 6EF1F45DE67
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Dec 2010 11:02:59 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 587CC1DB803C
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Dec 2010 11:02:59 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.249.87.104])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 01C5B1DB803B
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Dec 2010 11:02:59 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id BF78A9F6C71
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Dec 2010 11:02:58 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.124.101.86])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 4F0EF9F6C64
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Dec 2010 11:02:58 +0900 (JST)
Message-ID: <4D0EB953.2010106@jp.fujitsu.com>
Date: Mon, 20 Dec 2010 11:02:59 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG?] There is a possibility that 'i_ino' overflows
References: <4D09D153.1060208@jp.fujitsu.com>
In-Reply-To: <4D09D153.1060208@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


(2010/12/16 17:44), Tsutomu Itoh wrote:
> Hi,
> 
> In btrfs, inode number is increased each time a new file or directory
> is made.
> Therefore, if the making deletion of the file is repeated, value of
> 'i_ino' increases rapidly.
> 
> For example, inode number changes as follows. 
> 
>   $ touch foo
>   $ ls -i foo
>   266 foo
>   $ rm foo
>   $ touch bar
>   $ ls -i bar
>   267 bar
>   $
> 
> And then, length of 'i_ino' and 'objectid' is as follows on the x86
> system. 
> 
>   unsigned long i_ino == 32bits
>   u64 objectid        == 64bits
> 
> Therefore, in the operation to substitute 'objectid' to 'i_ino',
> 'i_ino' overflows when 'objectid' 4294967296 is substituted to 'i_ino'. 
> Then, the file with inode number 0 is made.

I think that it is better to recycle inode number that became unused. 
And, at least, I think that it should make the filesystem not become an
abnormal condition. 

This patch is a patch that makes an error when inode number is bigger
than BTRFS_LAST_FREE_OBJECTID.


Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 inode.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -urNp linux-2.6.37-rc6/fs/btrfs/inode.c linux-2.6.37-rc6.new/fs/btrfs/inode.c
--- linux-2.6.37-rc6/fs/btrfs/inode.c   2010-12-16 10:24:48.000000000 +0900
+++ linux-2.6.37-rc6.new/fs/btrfs/inode.c       2010-12-20 09:04:18.000000000 +0900
@@ -4529,6 +4529,10 @@ static struct inode *btrfs_new_inode(str
 
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = objectid;
+	if (unlikely(inode->i_ino > (unsigned long)BTRFS_LAST_FREE_OBJECTID)) {
+		ret = -ENOSPC;
+		goto fail;
+	}
 	inode_set_bytes(inode, 0);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],


> As a result, ls command has looped infinitely, and btrfsck detected the
> error.
> Please see below.
> 
>   $ uname -a
>   Linux luna 2.6.37-rc5 #1 SMP Thu Dec 9 13:02:41 JST 2010 i686 i686 i386 GNU/Linux
>   $ df -T /test1
>   Filesystem    Type   1K-blocks      Used Available Use% Mounted on
>   /dev/sdd14   btrfs     4162560        56   3717632   1% /test1
>   $ strace -FfTttx ls /test1
>   14:03:10.115440 execve("/bin/ls", ["ls", "/test1"], [/* 28 vars */]) = 0 <0.000181>
>   ...
>   ...
>   14:03:10.123431 stat("/test1", {st_mode=S_IFDIR|0777, st_size=8, ...}) = 0 <0.000017>
>   14:03:10.123521 open("/test1", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3 <0.000018>
>   14:03:10.123578 fcntl(3, F_GETFD)       = 0x1 (flags FD_CLOEXEC) <0.000013>
>   14:03:10.123637 getdents(3, /* 3 entries */, 32768) = 72 <0.000025>
>   14:03:10.123712 getdents(3, /* 1 entries */, 32768) = 24 <0.000016>
>   14:03:10.123768 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
>   14:03:10.123824 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
>   14:03:10.123880 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
>   14:03:10.123936 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
>   14:03:10.123992 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
>   14:03:10.124047 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
>   14:03:10.124103 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
>   14:03:10.124261 getdents(3, /* 1 entries */, 32768) = 24 <0.000016>
>   14:03:10.124320 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
>   14:03:10.124381 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
>   14:03:10.124437 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
>   14:03:10.124493 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
>   14:03:10.124549 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
>   14:03:10.124605 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
>   14:03:10.124661 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
>   14:03:10.124717 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
>   14:03:10.124773 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
>   14:03:10.124840 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
>   14:03:10.124896 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
>   ...
>   ...
>   $ cd /test1
>   $ ls -i A123
>   ls: cannot access A123: No such file or directory
>   $ touch aaaa
>   $ ls -i aaaa
>   1 aaaa
>   $
> 
>   # umount /test1
>   # btrfsck /dev/sdd14
>   root 5 inode 0 errors 2001
>           unresolved ref dir 256 index 4294967041 namelen 4 name A123 filetype 1 error 4
>   root 5 inode 1 errors 2001
>           unresolved ref dir 256 index 4294967042 namelen 4 name aaaa filetype 1 error 4
>   root 5 inode 4294967296 errors 2000
>           unresolved ref dir 256 index 4294967041 namelen 4 name A123 filetype 0 error 3
>   root 5 inode 4294967297 errors 2000
>           unresolved ref dir 256 index 4294967042 namelen 4 name aaaa filetype 0 error 3
>   found 28672 bytes used err is 1
>   total csum bytes: 0
>   total tree bytes: 28672
>   total fs tree bytes: 8192
>   btree space waste bytes: 23191
>   file data blocks allocated: 0
>    referenced 0
>   Btrfs v0.19-36-g70c6c10
>   #
> 
> 
> Regards,
> Itoh
> 

