Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([85.222.100.130]:55345 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab2LFISg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Dec 2012 03:18:36 -0500
Received: from [85.222.100.130] (zlom.siedziba.pl [85.222.100.130])
	by zlom.siedziba.pl (Postfix) with ESMTPSA id 47D682F189F
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Dec 2012 09:18:31 +0100 (CET)
Message-ID: <50C05466.9000002@siedziba.pl>
Date: Thu, 06 Dec 2012 09:16:38 +0100
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: various problems converting to RAID1
References: <50BDB967.9070400@siedziba.pl>
In-Reply-To: <50BDB967.9070400@siedziba.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I try btrfsck in repair mode, it fails to fix the corruption (log 
below). Is there any other version of btrfsck besides the one at 
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git that 
I could try?

(gdb) run
Starting program: /home/pp/btrfs-progs/btrfsck --repair /dev/mapper/pp-dysk4
enabling repair mode
ERROR: unable to scan the device '/dev/sda7' - Device or resource busy
ERROR: unable to scan the device '/dev/sdc7' - Device or resource busy
ERROR: unable to scan the device '/dev/sda7' - Device or resource busy
ERROR: unable to scan the device '/dev/sdc7' - Device or resource busy
checking extents
ref mismatch on [711069696 4096] extent item 1, found 0
btrfsck: extent-tree.c:2549: btrfs_reserve_extent: Assertion `!(ret)' 
failed.

Program received signal SIGABRT, Aborted.
0x00007ffff784c425 in __GI_raise (sig=<optimized out>) at 
../nptl/sysdeps/unix/sysv/linux/raise.c:64
64    ../nptl/sysdeps/unix/sysv/linux/raise.c: Nie ma takiego pliku ani 
katalogu.
(gdb) bt
#0  0x00007ffff784c425 in __GI_raise (sig=<optimized out>) at 
../nptl/sysdeps/unix/sysv/linux/raise.c:64
#1  0x00007ffff784fb8b in __GI_abort () at abort.c:91
#2  0x00007ffff78450ee in __assert_fail_base (fmt=<optimized out>, 
assertion=0x43d21e "!(ret)",
     file=0x43d210 "extent-tree.c", line=<optimized out>, 
function=<optimized out>) at assert.c:94
#3  0x00007ffff7845192 in __GI___assert_fail (assertion=0x43d21e 
"!(ret)", file=0x43d210 "extent-tree.c", line=2549,
     function=0x43d870 <__PRETTY_FUNCTION__.7967> 
"btrfs_reserve_extent") at assert.c:103
#4  0x000000000041ef7d in btrfs_reserve_extent (trans=0x64fed0, 
root=0x64f6e0, num_bytes=4096, empty_size=0,
     hint_byte=433791696896, search_end=18446744073709551615, 
ins=0x7fffffffdd00, data=52) at extent-tree.c:2549
#5  0x000000000041f218 in alloc_tree_block (trans=0x64fed0, 
root=0x64f6e0, num_bytes=4096, root_objectid=2,
     generation=289502, flags=0, key=0x7fffffffdd80, level=3, 
empty_size=0, hint_byte=433791696896,
     search_end=18446744073709551615, ins=0x7fffffffdd00) at 
extent-tree.c:2612
#6  0x000000000041f426 in btrfs_alloc_free_block (trans=0x64fed0, 
root=0x64f6e0, blocksize=4096, root_objectid=2,
     key=0x7fffffffdd80, level=3, hint=433791696896, empty_size=0) at 
extent-tree.c:2658
#7  0x000000000040d504 in __btrfs_cow_block (trans=0x64fed0, 
root=0x64f6e0, buf=0x6749c0, parent=0x0, parent_slot=0,
     cow_ret=0x7fffffffde68, search_start=433791696896, empty_size=0) at 
ctree.c:321
#8  0x000000000040d950 in btrfs_cow_block (trans=0x64fed0, 
root=0x64f6e0, buf=0x6749c0, parent=0x0, parent_slot=0,
     cow_ret=0x7fffffffde68) at ctree.c:410
#9  0x000000000040f464 in btrfs_search_slot (trans=0x64fed0, 
root=0x64f6e0, key=0x7fffffffdec0, p=0x30409b20, ins_len=0,
     cow=1) at ctree.c:1214
#10 0x000000000040a246 in delete_extent_records (trans=0x64fed0, 
root=0x64f6e0, path=0x30409b20, bytenr=711069696,
     new_len=4096) at btrfsck.c:2858
#11 0x000000000040aa2d in fixup_extent_refs (trans=0x64fed0, 
info=0x6513e0, rec=0xf7de760) at btrfsck.c:3078
#12 0x000000000040b1a3 in check_extent_refs (trans=0x64fed0, 
root=0xa0fa70, extent_cache=0x7fffffffe080, repair=1)
     at btrfsck.c:3317
#13 0x000000000040b89f in check_extents (trans=0x64fed0, root=0xa0fa70, 
repair=1) at btrfsck.c:3461
#14 0x000000000040bcd7 in main (ac=1, av=0x7fffffffe4d8) at btrfsck.c:3573
(gdb)
