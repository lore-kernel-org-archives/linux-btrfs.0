Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from parrot.pmhahn.de ([88.198.50.102]:47716 "EHLO parrot.pmhahn.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751253AbdGQGhB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 02:37:01 -0400
Subject: Re: segfault on btrfs --repair
To: Tassos Mavroudeas <amavroudeas@yahoo.co.uk>, linux-btrfs@vger.kernel.org
References: <4effea44-4fd2-c562-f7fb-17bc4623ced5@yahoo.co.uk>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
From: Philipp Hahn <pmhahn@pmhahn.de>
Message-ID: <4be5b27a-25ad-4c24-719b-4477ed5822dc@pmhahn.de>
Date: Mon, 17 Jul 2017 08:30:41 +0200
MIME-Version: 1.0
In-Reply-To: <4effea44-4fd2-c562-f7fb-17bc4623ced5@yahoo.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Am 16.07.2017 um 13:19 schrieb Tassos Mavroudeas:
> let me share with you a segfault on btrfs --repair
> 
> I have backups etc. latest kernel and progs.
> 
> [root@node ~]# uname -a
> Linux node 4.12.2 #1 SMP Sun Jul 16 08:15:48 EEST 2017 x86_64 x86_64
> x86_64 GNU/Linux
> [root@node ~]# btrfs version
> btrfs-progs v4.11.1
> 
> GNU gdb (GDB) Red Hat Enterprise Linux 7.6.1-94.el7
...
> Program received signal SIGSEGV, Segmentation fault.
> 0x00007f2f2a8e3f12 in __memmove_ssse3 () from /lib64/libc.so.6
...
> (gdb) backtrace
> #0  0x00007f2f2a8e3f12 in __memmove_ssse3 () from /lib64/libc.so.6
> #1  0x0000000000424705 in memmove (__len=141733920735, __src=0x91e58a1,
> __dest=0x91e5880) at /usr/include/bits/string3.h:57
> #2  memmove_extent_buffer (dst=dst@entry=0x91e4be0,
> dst_offset=dst_offset@entry=3104, src_offset=src_offset@entry=3137,
> len=len@entry=141733920735) at extent_io.c:882
> #3  0x000000000040edb1 in btrfs_del_ptr (root=root@entry=0x8a3470,
> path=path@entry=0x7fffffffde00, level=level@entry=0, slot=91) at
> ctree.c:2607
> #4  0x0000000000452809 in repair_btree (corrupt_blocks=0x7fffffffdfa0,
> root=0x8a3470) at cmds-check.c:3847
> #5  check_fs_root (root=root@entry=0x8a3470,
> root_cache=root_cache@entry=0x7fffffffe4b0, wc=wc@entry=0x7fffffffe200)
> at cmds-check.c:4009
> #6  0x000000000045eda5 in check_fs_roots (root_cache=0x7fffffffe4b0,
> root=0x8a3470) at cmds-check.c:4115
> #7  cmd_check (argc=<optimized out>, argv=<optimized out>) at
> cmds-check.c:13076
> #8  0x000000000040abd4 in main (argc=3, argv=0x7fffffffe600) at btrfs.c:302

"Welcome to the club" - I have a similar broken btrfs.
I posted some patches 2017-06-02 following "[PATCH 0/2] More nritems
range checking"
<http://www.spinics.net/lists/linux-btrfs/msg66143.html>, which at leas
replace the SIGSEGV with a BUG_ON, but the have not been picked up yet.
The do NOT fix the --repair, but only terminate fsck with a better error
message.

Philipp
