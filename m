Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48079 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0LPIpf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Dec 2010 03:45:35 -0500
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id oBG8jW8V020131
	for <linux-btrfs@vger.kernel.org> (envelope-from t-itoh@jp.fujitsu.com);
	Thu, 16 Dec 2010 17:45:33 +0900
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 9A60445DE56
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Dec 2010 17:45:32 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 15F6B45DE63
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Dec 2010 17:45:32 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0231A1DB803C
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Dec 2010 17:45:32 +0900 (JST)
Received: from m108.s.css.fujitsu.com (m108.s.css.fujitsu.com [10.249.87.108])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 8BBBDE18005
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Dec 2010 17:45:31 +0900 (JST)
Message-ID: <4D09D153.1060208@jp.fujitsu.com>
Date: Thu, 16 Dec 2010 17:44:03 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [BUG?] There is a possibility that 'i_ino' overflows
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

In btrfs, inode number is increased each time a new file or directory
is made.
Therefore, if the making deletion of the file is repeated, value of
'i_ino' increases rapidly.

For example, inode number changes as follows. 

  $ touch foo
  $ ls -i foo
  266 foo
  $ rm foo
  $ touch bar
  $ ls -i bar
  267 bar
  $

And then, length of 'i_ino' and 'objectid' is as follows on the x86
system. 

  unsigned long i_ino == 32bits
  u64 objectid        == 64bits

Therefore, in the operation to substitute 'objectid' to 'i_ino',
'i_ino' overflows when 'objectid' 4294967296 is substituted to 'i_ino'. 
Then, the file with inode number 0 is made.

As a result, ls command has looped infinitely, and btrfsck detected the
error.
Please see below.

  $ uname -a
  Linux luna 2.6.37-rc5 #1 SMP Thu Dec 9 13:02:41 JST 2010 i686 i686 i386 GNU/Linux
  $ df -T /test1
  Filesystem    Type   1K-blocks      Used Available Use% Mounted on
  /dev/sdd14   btrfs     4162560        56   3717632   1% /test1
  $ strace -FfTttx ls /test1
  14:03:10.115440 execve("/bin/ls", ["ls", "/test1"], [/* 28 vars */]) = 0 <0.000181>
  ...
  ...
  14:03:10.123431 stat("/test1", {st_mode=S_IFDIR|0777, st_size=8, ...}) = 0 <0.000017>
  14:03:10.123521 open("/test1", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3 <0.000018>
  14:03:10.123578 fcntl(3, F_GETFD)       = 0x1 (flags FD_CLOEXEC) <0.000013>
  14:03:10.123637 getdents(3, /* 3 entries */, 32768) = 72 <0.000025>
  14:03:10.123712 getdents(3, /* 1 entries */, 32768) = 24 <0.000016>
  14:03:10.123768 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
  14:03:10.123824 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
  14:03:10.123880 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
  14:03:10.123936 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
  14:03:10.123992 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
  14:03:10.124047 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
  14:03:10.124103 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
  14:03:10.124261 getdents(3, /* 1 entries */, 32768) = 24 <0.000016>
  14:03:10.124320 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
  14:03:10.124381 getdents(3, /* 1 entries */, 32768) = 24 <0.000015>
  14:03:10.124437 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
  14:03:10.124493 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
  14:03:10.124549 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
  14:03:10.124605 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
  14:03:10.124661 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
  14:03:10.124717 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
  14:03:10.124773 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
  14:03:10.124840 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
  14:03:10.124896 getdents(3, /* 1 entries */, 32768) = 24 <0.000014>
  ...
  ...
  $ cd /test1
  $ ls -i A123
  ls: cannot access A123: No such file or directory
  $ touch aaaa
  $ ls -i aaaa
  1 aaaa
  $

  # umount /test1
  # btrfsck /dev/sdd14
  root 5 inode 0 errors 2001
          unresolved ref dir 256 index 4294967041 namelen 4 name A123 filetype 1 error 4
  root 5 inode 1 errors 2001
          unresolved ref dir 256 index 4294967042 namelen 4 name aaaa filetype 1 error 4
  root 5 inode 4294967296 errors 2000
          unresolved ref dir 256 index 4294967041 namelen 4 name A123 filetype 0 error 3
  root 5 inode 4294967297 errors 2000
          unresolved ref dir 256 index 4294967042 namelen 4 name aaaa filetype 0 error 3
  found 28672 bytes used err is 1
  total csum bytes: 0
  total tree bytes: 28672
  total fs tree bytes: 8192
  btree space waste bytes: 23191
  file data blocks allocated: 0
   referenced 0
  Btrfs v0.19-36-g70c6c10
  #


Regards,
Itoh

