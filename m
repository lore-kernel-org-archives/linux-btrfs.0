Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740AbaIQRAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 13:00:36 -0400
Message-ID: <5419BE1E.2020607@redhat.com>
Date: Wed, 17 Sep 2014 12:00:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Shilong Wang <wangshilong1991@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: "btrfs rescue super-recover" memory corruption
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This:

# truncate --size=8g
# dd if=/dev/zero of=file conv=notrunc  bs=4 seek=16384 count=1
# valgrind ./btrfs rescue super-recover file -v

yields:

==4604== Memcheck, a memory error detector
==4604== Copyright (C) 2002-2012, and GNU GPL'd, by Julian Seward et al.
==4604== Using Valgrind-3.8.1 and LibVEX; rerun with -h for copyright info
==4604== Command: ./btrfs rescue super-recover file -v
==4604== 
All Devices:
	Device: id = 1, name = file

Before Recovering:
	[All good supers]:
		device name = file
		superblock bytenr = 67108864

	[All bad supers]:
		device name = file
		superblock bytenr = 65536


Make sure this is a btrfs disk otherwise the tool will destroy other fs, Are you sure? [y/N]: y
Recovered bad superblocks successful
==4604== Invalid read of size 8
==4604==    at 0x426B55: btrfs_recover_superblocks (list.h:204)
==4604==    by 0x421C79: cmd_super_recover (cmds-rescue.c:148)
==4604==    by 0x40420A: handle_command_group (btrfs.c:145)
==4604==    by 0x421B54: cmd_rescue (cmds-rescue.c:162)
==4604==    by 0x404199: main (btrfs.c:247)
==4604==  Address 0x4c250b0 is 48 bytes inside a block of size 96 free'd
==4604==    at 0x4A063F0: free (vg_replace_malloc.c:446)
==4604==    by 0x43C77E: btrfs_close_devices (volumes.c:196)
==4604==    by 0x42F5D1: close_ctree (disk-io.c:1404)
==4604==    by 0x426A85: btrfs_recover_superblocks (super-recover.c:340)
==4604==    by 0x421C79: cmd_super_recover (cmds-rescue.c:148)
==4604==    by 0x40420A: handle_command_group (btrfs.c:145)
==4604==    by 0x421B54: cmd_rescue (cmds-rescue.c:162)
==4604==    by 0x404199: main (btrfs.c:247)
==4604== 
==4604== Invalid free() / delete / delete[] / realloc()
==4604==    at 0x4A063F0: free (vg_replace_malloc.c:446)
==4604==    by 0x426B9E: btrfs_recover_superblocks (super-recover.c:85)
==4604==    by 0x421C79: cmd_super_recover (cmds-rescue.c:148)
==4604==    by 0x40420A: handle_command_group (btrfs.c:145)
==4604==    by 0x421B54: cmd_rescue (cmds-rescue.c:162)
==4604==    by 0x404199: main (btrfs.c:247)
==4604==  Address 0x4c25080 is 0 bytes inside a block of size 96 free'd
==4604==    at 0x4A063F0: free (vg_replace_malloc.c:446)
==4604==    by 0x43C77E: btrfs_close_devices (volumes.c:196)
==4604==    by 0x42F5D1: close_ctree (disk-io.c:1404)
==4604==    by 0x426A85: btrfs_recover_superblocks (super-recover.c:340)
==4604==    by 0x421C79: cmd_super_recover (cmds-rescue.c:148)
==4604==    by 0x40420A: handle_command_group (btrfs.c:145)
==4604==    by 0x421B54: cmd_rescue (cmds-rescue.c:162)
==4604==    by 0x404199: main (btrfs.c:247)
==4604== 
==4604== 
==4604== HEAP SUMMARY:
==4604==     in use at exit: 0 bytes in 0 blocks
==4604==   total heap usage: 72 allocs, 73 frees, 140,384 bytes allocated
==4604== 
==4604== All heap blocks were freed -- no leaks are possible
==4604== 
==4604== For counts of detected and suppressed errors, rerun with: -v
==4604== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 6 from 6)

i.e. I think we are double freeing memory:

        close_ctree(root); // <-- here
no_recover:
        recover_err_str(ret);
        free_recover_superblock(&recover); // <-- and here

I can't really work out what all this is all doing, but maybe the fix is obvious
to Wang Shilong (who wrote the original code)?

Thanks,
-Eric
