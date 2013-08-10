Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:54841 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968472Ab3HJJIA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Aug 2013 05:08:00 -0400
Received: from bluebottle.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 794E92192F
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Aug 2013 19:07:51 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: btrfs device stats /dev/mapper/ext4 SEGV
Date: Sat, 10 Aug 2013 19:07:50 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201308101907.50539.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git

I can repeatedly get the following SEGV from running "btrfs device stats" on a 
device node for an Ext3/4 filesystem.  This happens with the version of the 
code downloaded from the above GIT repository as well as with an older 
version.  Obviously the command in question is not going to do anything useful 
when run against a non-BTRFS filesystem, but it should do something other than 
crash.

Program received signal SIGSEGV, Segmentation fault.
0x000000000045842d in get_fs_info (path=0x7fffffffce60 "/boot", 
    fi_args=0x7fffffffe6c0, di_ret=0x7fffffffe6b8) at utils.c:1560
1560                    fi_args->max_id = fs_devices_mnt->latest_devid;
(gdb) bt
#0  0x000000000045842d in get_fs_info (path=0x7fffffffce60 "/boot", 
    fi_args=0x7fffffffe6c0, di_ret=0x7fffffffe6b8) at utils.c:1560
#1  0x0000000000408576 in cmd_dev_stats (argc=2, argv=0x7fffffffec78)
    at cmds-device.c:331
#2  0x0000000000404177 in handle_command_group (grp=0x684660, argc=2, 
    argv=0x7fffffffec78) at btrfs.c:154
#3  0x0000000000408830 in cmd_device (argc=3, argv=0x7fffffffec70)
    at cmds-device.c:410
#4  0x000000000040450e in main (argc=3, argv=0x7fffffffec70) at btrfs.c:296

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
