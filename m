Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56225 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaHRJZb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Aug 2014 05:25:31 -0400
Received: from fb07-iapwap2.localnet ([134.176.19.122]) by mail.gmx.com
 (mrgmx001) with ESMTPSA (Nemesis) id 0MMkDH-1XIVJW3Kn9-008Xx8 for
 <linux-btrfs@vger.kernel.org>; Mon, 18 Aug 2014 11:25:29 +0200
From: Marc Dietrich <marvin24@gmx.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs restore memory corruption (bug: 82701)
Date: Mon, 18 Aug 2014 11:25:28 +0200
Message-ID: <2058629.ulFxBAG3Lx@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I did a checkout of the latest btrfs progs to repair my damaged filesystem. 
Running btrfs restore gives me several failed to inflate: -6 and crashes with 
some memory corruption. I ran it again with valgrind and got:

valgrind --log-file=x2 -v --leak-check=yes btrfs restore /dev/sda9 /mnt/backup

==8528== Memcheck, a memory error detector
==8528== Copyright (C) 2002-2012, and GNU GPL'd, by Julian Seward et al.
==8528== Using Valgrind-3.8.1 and LibVEX; rerun with -h for copyright info
==8528== Command: btrfs restore /dev/sda9 /mnt/backup
==8528== Parent PID: 8453
==8528== 
==8528== Syscall param pwrite64(buf) points to uninitialised byte(s)
==8528==    at 0x59BE3C3: __pwrite_nocancel (in /lib64/libpthread-2.18.so)
==8528==    by 0x41F22F: search_dir (cmds-restore.c:392)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
==8528==    by 0x4043FE: main (btrfs.c:286)
==8528==  Address 0x66956a0 is 7,056 bytes inside a block of size 8,192 
alloc'd
==8528==    at 0x4C277AB: malloc (in /usr/lib64/valgrind/vgpreload_memcheck-
amd64-linux.so)
==8528==    by 0x41EEAD: search_dir (cmds-restore.c:316)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
==8528==    by 0x4043FE: main (btrfs.c:286)
==8528== 
==8528== Invalid read of size 1
==8528==    at 0x4C2BF15: memcpy@@GLIBC_2.14 (in 
/usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==8528==    by 0x43818F: read_extent_buffer (string3.h:51)
==8528==    by 0x41EC66: search_dir (cmds-restore.c:233)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
==8528==    by 0x4043FE: main (btrfs.c:286)
==8528==  Address 0x684c186 is 1,110 bytes inside a block of size 4,224 free'd
==8528==    at 0x4C28ADC: free (in /usr/lib64/valgrind/vgpreload_memcheck-
amd64-linux.so)
==8528==    by 0x437895: free_extent_buffer (extent_io.c:618)
==8528==    by 0x41E053: next_leaf (cmds-restore.c:202)
==8528==    by 0x41E50F: search_dir (cmds-restore.c:731)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
==8528==    by 0x4043FE: main (btrfs.c:286)
==8528== 
==8528== Invalid read of size 8
==8528==    at 0x4C2BF40: memcpy@@GLIBC_2.14 (in 
/usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==8528==    by 0x43818F: read_extent_buffer (string3.h:51)
==8528==    by 0x41EC66: search_dir (cmds-restore.c:233)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
==8528==    by 0x4043FE: main (btrfs.c:286)
==8528==  Address 0x684c178 is 1,096 bytes inside a block of size 4,224 free'd
==8528==    at 0x4C28ADC: free (in /usr/lib64/valgrind/vgpreload_memcheck-
amd64-linux.so)
==8528==    by 0x437895: free_extent_buffer (extent_io.c:618)
==8528==    by 0x41E053: next_leaf (cmds-restore.c:202)
==8528==    by 0x41E50F: search_dir (cmds-restore.c:731)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
==8528==    by 0x4043FE: main (btrfs.c:286)
==8528== 
==8528== Invalid read of size 8
==8528==    at 0x4C2BF52: memcpy@@GLIBC_2.14 (in 
/usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==8528==    by 0x43818F: read_extent_buffer (string3.h:51)
==8528==    by 0x41EC66: search_dir (cmds-restore.c:233)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
==8528==    by 0x4043FE: main (btrfs.c:286)
==8528==  Address 0x684c168 is 1,080 bytes inside a block of size 4,224 free'd
==8528==    at 0x4C28ADC: free (in /usr/lib64/valgrind/vgpreload_memcheck-
amd64-linux.so)
==8528==    by 0x437895: free_extent_buffer (extent_io.c:618)
==8528==    by 0x41E053: next_leaf (cmds-restore.c:202)
==8528==    by 0x41E50F: search_dir (cmds-restore.c:731)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
==8528==    by 0x4043FE: main (btrfs.c:286)
==8528== 
==8528== Invalid read of size 1
==8528==    at 0x4C2BFE4: memcpy@@GLIBC_2.14 (in 
/usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==8528==    by 0x43818F: read_extent_buffer (string3.h:51)
==8528==    by 0x41EC66: search_dir (cmds-restore.c:233)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
==8528==    by 0x4043FE: main (btrfs.c:286)
==8528==  Address 0x6a385f8 is 2,680 bytes inside a block of size 4,224 free'd
==8528==    at 0x4C28ADC: free (in /usr/lib64/valgrind/vgpreload_memcheck-
amd64-linux.so)
==8528==    by 0x437895: free_extent_buffer (extent_io.c:618)
==8528==    by 0x41E053: next_leaf (cmds-restore.c:202)
==8528==    by 0x41E50F: search_dir (cmds-restore.c:731)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
==8528==    by 0x4043FE: main (btrfs.c:286)
==8528== 
==8528== Invalid read of size 2
==8528==    at 0x4C2BFA0: memcpy@@GLIBC_2.14 (in 
/usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==8528==    by 0x43818F: read_extent_buffer (string3.h:51)
==8528==    by 0x41EC66: search_dir (cmds-restore.c:233)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
==8528==    by 0x4043FE: main (btrfs.c:286)
==8528==  Address 0x6b0bfb8 is 632 bytes inside a block of size 4,224 free'd
==8528==    at 0x4C28ADC: free (in /usr/lib64/valgrind/vgpreload_memcheck-
amd64-linux.so)
==8528==    by 0x437895: free_extent_buffer (extent_io.c:618)
==8528==    by 0x4261CA: btrfs_release_path (ctree.c:61)
==8528==    by 0x426212: btrfs_free_path (ctree.c:51)
==8528==    by 0x41F93B: search_dir (cmds-restore.c:911)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528== 
==8528== Invalid read of size 2
==8528==    at 0x4C2BFB3: memcpy@@GLIBC_2.14 (in 
/usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==8528==    by 0x43818F: read_extent_buffer (string3.h:51)
==8528==    by 0x41EC66: search_dir (cmds-restore.c:233)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
==8528==    by 0x4043FE: main (btrfs.c:286)
==8528==  Address 0x6b0bfb4 is 628 bytes inside a block of size 4,224 free'd
==8528==    at 0x4C28ADC: free (in /usr/lib64/valgrind/vgpreload_memcheck-
amd64-linux.so)
==8528==    by 0x437895: free_extent_buffer (extent_io.c:618)
==8528==    by 0x4261CA: btrfs_release_path (ctree.c:61)
==8528==    by 0x426212: btrfs_free_path (ctree.c:51)
==8528==    by 0x41F93B: search_dir (cmds-restore.c:911)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
==8528== 
==8528== 
==8528== HEAP SUMMARY:
==8528==     in use at exit: 0 bytes in 0 blocks
==8528==   total heap usage: 260,452 allocs, 260,452 frees, 278,189,550 bytes 
allocated
==8528== 
==8528== All heap blocks were freed -- no leaks are possible
==8528== 
==8528== For counts of detected and suppressed errors, rerun with: -v
==8528== Use --track-origins=yes to see where uninitialised values come from
==8528== ERROR SUMMARY: 16597 errors from 7 contexts (suppressed: 2 from 2)

see: https://bugzilla.kernel.org/show_bug.cgi?id=82701

Marc

p.s.

I wonder if this list should be autosubscribed to btrfs related bugs

