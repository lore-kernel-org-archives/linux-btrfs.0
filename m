Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38773 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaIRH26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 03:28:58 -0400
Received: by mail-pa0-f53.google.com with SMTP id rd3so897837pab.40
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 00:28:57 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: "btrfs rescue super-recover" memory corruption
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <5419BE1E.2020607@redhat.com>
Date: Thu, 18 Sep 2014 15:28:43 +0800
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>
Message-Id: <CE0C467D-8BD9-4B3B-8FED-AD70F31DC743@gmail.com>
References: <5419BE1E.2020607@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Eric,

> This:
> 
> # truncate --size=8g
> # dd if=/dev/zero of=file conv=notrunc  bs=4 seek=16384 count=1
> # valgrind ./btrfs rescue super-recover file -v
> 
> yields:
> 
> ==4604== Memcheck, a memory error detector
> ==4604== Copyright (C) 2002-2012, and GNU GPL'd, by Julian Seward et al.
> ==4604== Using Valgrind-3.8.1 and LibVEX; rerun with -h for copyright info
> ==4604== Command: ./btrfs rescue super-recover file -v
> ==4604== 
> All Devices:
> 	Device: id = 1, name = file
> 
> Before Recovering:
> 	[All good supers]:
> 		device name = file
> 		superblock bytenr = 67108864
> 
> 	[All bad supers]:
> 		device name = file
> 		superblock bytenr = 65536
> 
> 
> Make sure this is a btrfs disk otherwise the tool will destroy other fs, Are you sure? [y/N]: y
> Recovered bad superblocks successful
> ==4604== Invalid read of size 8
> ==4604==    at 0x426B55: btrfs_recover_superblocks (list.h:204)
> ==4604==    by 0x421C79: cmd_super_recover (cmds-rescue.c:148)
> ==4604==    by 0x40420A: handle_command_group (btrfs.c:145)
> ==4604==    by 0x421B54: cmd_rescue (cmds-rescue.c:162)
> ==4604==    by 0x404199: main (btrfs.c:247)
> ==4604==  Address 0x4c250b0 is 48 bytes inside a block of size 96 free'd
> ==4604==    at 0x4A063F0: free (vg_replace_malloc.c:446)
> ==4604==    by 0x43C77E: btrfs_close_devices (volumes.c:196)
> ==4604==    by 0x42F5D1: close_ctree (disk-io.c:1404)
> ==4604==    by 0x426A85: btrfs_recover_superblocks (super-recover.c:340)
> ==4604==    by 0x421C79: cmd_super_recover (cmds-rescue.c:148)
> ==4604==    by 0x40420A: handle_command_group (btrfs.c:145)
> ==4604==    by 0x421B54: cmd_rescue (cmds-rescue.c:162)
> ==4604==    by 0x404199: main (btrfs.c:247)
> ==4604== 
> ==4604== Invalid free() / delete / delete[] / realloc()
> ==4604==    at 0x4A063F0: free (vg_replace_malloc.c:446)
> ==4604==    by 0x426B9E: btrfs_recover_superblocks (super-recover.c:85)
> ==4604==    by 0x421C79: cmd_super_recover (cmds-rescue.c:148)
> ==4604==    by 0x40420A: handle_command_group (btrfs.c:145)
> ==4604==    by 0x421B54: cmd_rescue (cmds-rescue.c:162)
> ==4604==    by 0x404199: main (btrfs.c:247)
> ==4604==  Address 0x4c25080 is 0 bytes inside a block of size 96 free'd
> ==4604==    at 0x4A063F0: free (vg_replace_malloc.c:446)
> ==4604==    by 0x43C77E: btrfs_close_devices (volumes.c:196)
> ==4604==    by 0x42F5D1: close_ctree (disk-io.c:1404)
> ==4604==    by 0x426A85: btrfs_recover_superblocks (super-recover.c:340)
> ==4604==    by 0x421C79: cmd_super_recover (cmds-rescue.c:148)
> ==4604==    by 0x40420A: handle_command_group (btrfs.c:145)
> ==4604==    by 0x421B54: cmd_rescue (cmds-rescue.c:162)
> ==4604==    by 0x404199: main (btrfs.c:247)
> ==4604== 
> ==4604== 
> ==4604== HEAP SUMMARY:
> ==4604==     in use at exit: 0 bytes in 0 blocks
> ==4604==   total heap usage: 72 allocs, 73 frees, 140,384 bytes allocated
> ==4604== 
> ==4604== All heap blocks were freed -- no leaks are possible
> ==4604== 
> ==4604== For counts of detected and suppressed errors, rerun with: -v
> ==4604== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 6 from 6)
> 
> i.e. I think we are double freeing memory:
> 
>        close_ctree(root); // <-- here
> no_recover:
>        recover_err_str(ret);
>        free_recover_superblock(&recover); // <-- and here
> 
> I can't really work out what all this is all doing, but maybe the fix is obvious
> to Wang Shilong (who wrote the original code)?

Though i no longer spend much time on btrfs, i will take a look at this. ^_^

Thanks Eric
> 
> Thanks,
> -Eric

Best Regards,
Wang Shilong

