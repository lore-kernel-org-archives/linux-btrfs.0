Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:35492 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3JWQVs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 12:21:48 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id BA5697C06AB
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 10:21:47 -0600 (MDT)
Date: Wed, 23 Oct 2013 12:21:45 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Martin <m_btrfs@ml1.co.uk>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: 8 days looped? (btrfsck --repair --init-extent-tree)
Message-ID: <20131023162145.GE10632@localhost.localdomain>
References: <l46ece$pi4$1@ger.gmane.org>
 <20131022181736.GB27304@localhost.localdomain>
 <l48q6q$e50$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <l48q6q$e50$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 23, 2013 at 04:32:51PM +0100, Martin wrote:
> On 22/10/13 19:17, Josef Bacik wrote:
> > On Tue, Oct 22, 2013 at 06:58:48PM +0100, Martin wrote:
> >> Dear list,
> >>
> >> I've been trying to recover a 2TB single disk btrfs from a good few days
> >> ago as already commented on the list. btrfsck complained of an error in
> >> the extents and so I tried:
> >>
> >> btrfsck --repair --init-extent-tree /dev/sdX
> >>
> >>
> >> That was 8 days ago.
> >>
> >> The btrfs process is still running at 100% cpu but with no disk activity
> >> and no visible change in memory usage.
> >>
> >> Looped?
> >>
> >> Is there any way to check whether it is usefully doing anything or
> >> whether this is a lost cause?
> >>
> >>
> >> The only output it has given, within a few seconds of starting, is:
> >>
> >>
> >> parent transid verify failed on 911904604160 wanted 17448 found 17449
> >> parent transid verify failed on 911904604160 wanted 17448 found 17449
> >> parent transid verify failed on 911904604160 wanted 17448 found 17449
> >> parent transid verify failed on 911904604160 wanted 17448 found 17449
> >> Ignoring transid failure
> >>
> >>
> >> Any comment/interest before abandoning?
> >>
> >> This all started from trying to delete/repair a directory tree of a few
> >> MBytes of files...
> >>
> > 
> > Sooo it probably is looped, you should be able to attach gdb to it and run bt to
> > see where it is stuck and send that back to the list so we can figure out what
> > to do.  Thanks,
> 
> OK... But I doubt this helps much:
> 
> (gdb) bt
> #0  0x000000000042b93f in ?? ()
> #1  0x000000000041cf10 in ?? ()
> #2  0x000000000041e29d in ?? ()
> #3  0x000000000041e8ae in ?? ()
> #4  0x0000000000425bf2 in ?? ()
> #5  0x0000000000425cae in ?? ()
> #6  0x0000000000421e87 in ?? ()
> #7  0x0000000000422022 in ?? ()
> #8  0x000000000042210c in ?? ()
> #9  0x0000000000416b07 in ?? ()
> #10 0x00000000004043ad in ?? ()
> #11 0x00007f5ba972860d in __libc_start_main () from /lib64/libc.so.6
> #12 0x00000000004043dd in ?? ()
> #13 0x00007fff7ead12a8 in ?? ()
> #14 0x00000000ffffffff in ?? ()
> #15 0x0000000000000004 in ?? ()
> #16 0x000000000064f4d0 in ?? ()
> #17 0x00007fff7ead2469 in ?? ()
> #18 0x00007fff7ead2472 in ?? ()
> #19 0x00007fff7ead2485 in ?? ()
> #20 0x0000000000000000 in ?? ()
> 
> At least it stays consistent when repeated!
> 
> 
> Recompiling with -ggdb for the symbols and rerunning:
> 
> # gdb /sbin/btrfsck 17151
> GNU gdb (Gentoo 7.5.1 p2) 7.5.1
> Copyright (C) 2012 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later
> <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-pc-linux-gnu".
> For bug reporting instructions, please see:
> <http://bugs.gentoo.org/>...
> Reading symbols from /sbin/btrfsck...Reading symbols from
> /usr/lib64/debug/sbin/btrfsck.debug...(no debugging symbols found)...done.
> (no debugging symbols found)...done.
> Attaching to program: /sbin/btrfsck, process 17151
> 
> warning: Could not load shared library symbols for linux-vdso.so.1.
> Do you need "set solib-search-path" or "set sysroot"?
> Reading symbols from /lib64/libuuid.so.1...(no debugging symbols
> found)...done.
> Loaded symbols for /lib64/libuuid.so.1
> Reading symbols from /lib64/libblkid.so.1...(no debugging symbols
> found)...done.
> Loaded symbols for /lib64/libblkid.so.1
> Reading symbols from /lib64/libz.so.1...(no debugging symbols found)...done.
> Loaded symbols for /lib64/libz.so.1
> Reading symbols from /usr/lib64/liblzo2.so.2...(no debugging symbols
> found)...done.
> Loaded symbols for /usr/lib64/liblzo2.so.2
> Reading symbols from /lib64/libpthread.so.0...(no debugging symbols
> found)...done.
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib64/libthread_db.so.1".
> Loaded symbols for /lib64/libpthread.so.0
> Reading symbols from /lib64/libc.so.6...(no debugging symbols found)...done.
> Loaded symbols for /lib64/libc.so.6
> Reading symbols from /lib64/ld-linux-x86-64.so.2...(no debugging symbols
> found)...done.
> Loaded symbols for /lib64/ld-linux-x86-64.so.2
> 0x000000000041e74f in btrfs_search_slot ()
> (gdb) bt
> #0  0x000000000041e74f in btrfs_search_slot ()
> #1  0x00000000004259fa in find_first_block_group ()
> #2  0x0000000000425ab4 in btrfs_read_block_groups ()
> #3  0x0000000000421c15 in btrfs_setup_all_roots ()
> #4  0x0000000000421dce in __open_ctree_fd ()
> #5  0x0000000000421ea8 in open_ctree_fs_info ()
> #6  0x00000000004169b4 in cmd_check ()
> #7  0x000000000040443b in main ()
> 
> And over twelve hours later:
> 
> (gdb)
> #0  0x000000000041e74f in btrfs_search_slot ()
> #1  0x00000000004259fa in find_first_block_group ()
> #2  0x0000000000425ab4 in btrfs_read_block_groups ()
> #3  0x0000000000421c15 in btrfs_setup_all_roots ()
> #4  0x0000000000421dce in __open_ctree_fd ()
> #5  0x0000000000421ea8 in open_ctree_fs_info ()
> #6  0x00000000004169b4 in cmd_check ()
> #7  0x000000000040443b in main ()
> 
> 
> Any further debug useful?
> 

Nope I know where it's breaking, I need to fix how we init the extent tree.
Thanks,

Josef
