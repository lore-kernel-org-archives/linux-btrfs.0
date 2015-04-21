Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35136 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751973AbbDUDQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 23:16:48 -0400
Message-ID: <5535C11C.2050308@cn.fujitsu.com>
Date: Tue, 21 Apr 2015 11:16:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Lukas Lueg <lukas.lueg@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Carefully crafted BTRFS-image causes kernel to crash
References: <CAJF-kYngS4U6=oiXhs0ZF3Na3ezTGcMX1Wyd5HVVm887V61mWw@mail.gmail.com>
In-Reply-To: <CAJF-kYngS4U6=oiXhs0ZF3Na3ezTGcMX1Wyd5HVVm887V61mWw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Carefully crafted BTRFS-image causes kernel to crash
From: Lukas Lueg <lukas.lueg@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年04月21日 07:04

> See also https://bugzilla.kernel.org/show_bug.cgi?id=96971
>
>
> I've identified some problems in the btrfs code and attached a
> btrfs-image which causes the userland tools to crash and the kernel to
> immediately freeze once the filesystem get's mounted and one of the
> files is accessed. Putting the image onto a usb-drive gives you a
> freeze-on-a-stick :-)
>
> "btrfs check" crashes due to a SIGFPE in count_csum_range(). The
> culprit is struct btrfs_root->fs_info->super_copy->csum_size being 0,
> which goes unchecked before entering a division.
> I was not able to identify where the kernel crashes (system goes down
> the tubes), yet the problem is probably the same.
Thanks for the bug report.

Although we may add extra check for such problem to improve robustness,
but IMHO it's not a real world problem.

For normal case, csum will not be zero for sure.
And even for corrupted superblock, sb csum will prevent btrfs from using it.

This problem will only happen, as your mentioned, by a specially crafted 
image or a known bug which btrfs will still use corruped sb even sb csum 
dismatches.

Thanks,
Qu
>
> "btrfs version" is v3.19.1; bug is also present in latest git (kdave
> and unstable) as of 2015/04/21
>
>
> Full gdb output:
>
> gdb btrfs
> GNU gdb (GDB) Fedora 7.8.2-38.fc21
> Copyright (C) 2014 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-redhat-linux-gnu".
> Type "show configuration" for configuration details.
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>.
> Find the GDB manual and other documentation resources online at:
> <http://www.gnu.org/software/gdb/documentation/>.
> For help, type "help".
> Type "apropos word" to search for commands related to "word"...
> Reading symbols from btrfs...Reading symbols from
> /usr/lib/debug/usr/sbin/btrfs.debug...done.
> done.
> (gdb) run check btrfs_fukked.bin
> Starting program: /usr/sbin/btrfs check btrfs_fukked.bin
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib64/libthread_db.so.1".
> Checking filesystem on btrfs_fukked.bin
> UUID: cdd8684f-9eb1-40a4-91ec-1ed7c3cb444c
> checking extents
> checking free space cache
> checking fs roots
>
> Program received signal SIGFPE, Arithmetic exception.
> count_csum_range (root=<optimized out>, root=<optimized out>,
>      found=<synthetic pointer>, len=7385088, start=7471104) at cmds-check.c:1455
> 1455 csum_end = key.offset + (size / csum_size) * root->sectorsize;
> (gdb) bt
> #0  count_csum_range (root=<optimized out>, root=<optimized out>,
>      found=<synthetic pointer>, len=7385088, start=7471104) at cmds-check.c:1455
> #1  process_file_extent (active_node=0x7fffffffd710, key=0x7fffffffd680,
>      slot=11, eb=<optimized out>, root=0x894b10) at cmds-check.c:1551
> #2  process_one_leaf (wc=0x7fffffffd6c0, eb=<optimized out>, root=0x894b10)
>      at cmds-check.c:1617
> #3  walk_down_tree (level=<synthetic pointer>, wc=0x7fffffffd6c0,
>      path=0x7fffffffd7f0, root=0x894b10) at cmds-check.c:1742
> #4  check_fs_root (wc=0x7fffffffd6c0, root_cache=0x7fffffffdb20, root=0x894b10)
>      at cmds-check.c:3380
> #5  check_fs_roots (root_cache=root_cache@entry=0x7fffffffdb20, root=0x894b10)
>      at cmds-check.c:3516
> #6  0x0000000000428aea in cmd_check (argc=<optimized out>,
>      argv=<optimized out>) at cmds-check.c:9465
> #7  0x000000000040e5a2 in main (argc=2, argv=0x7fffffffdeb0) at btrfs.c:245
> (gdb) p csum_size
> $2 = 0
>
