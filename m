Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38070 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbcF1P7G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 11:59:06 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 3AC7C21713
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 11:59:00 -0400 (EDT)
Received: from [192.168.1.129] (unknown [2.235.201.237])
	by mail.messagingengine.com (Postfix) with ESMTPA id 9FFEFCCDBC
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 11:58:59 -0400 (EDT)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Francesco Turco <fturco@fastmail.fm>
Subject: Btrfs check command fails with "assertion failed" error
Message-ID: <5b7fbcfe-520a-cc00-f772-97a83fc9aa3d@fastmail.fm>
Date: Tue, 28 Jun 2016 17:58:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When trying to repair a btrfs root filesystem I get the following error
message:

# losetup -f /home/fturco/Buffer/root-20160616.img
# btrfs check --repair /dev/loop0
enabling repair mode
warning, device 4 is missing
Checking filesystem on /dev/loop0
UUID: 34fb5b58-f50f-47c3-a5b8-91d81a30eade
checking extents
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.
btrfs[0x44882e]
btrfs(btrfs_reserve_extent+0xaa9)[0x44d639]
btrfs(btrfs_alloc_free_block+0x5f)[0x44d6ff]
btrfs(__btrfs_cow_block+0xc4)[0x43e9d4]
btrfs(btrfs_cow_block+0x35)[0x43efd5]
btrfs[0x4442e6]
btrfs(btrfs_commit_transaction+0x95)[0x446115]
btrfs[0x42b58e]
btrfs(cmd_check+0x76c)[0x42c60c]
btrfs(main+0x7b)[0x40ac3b]
/usr/lib/libc.so.6(__libc_start_main+0xf1)[0x7f272f658741]
btrfs(_start+0x29)[0x40ad39]

This is an unmountable filesystem:

# mount /dev/loop0 /mnt/
mount: wrong fs type, bad option, bad superblock on /dev/loop0,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

# dmesg | tail
[ 9185.503571] scsi 8:0:0:1: Direct-Access     Samsung  File-CD Gadget
0000 PQ: 0 ANSI: 2
[ 9185.513943] sd 8:0:0:0: [sdb] Attached SCSI removable disk
[ 9185.514565] sd 8:0:0:1: [sdc] Attached SCSI removable disk
[13773.533435] usb 1-4: USB disconnect, device number 8
[31454.672925] loop: module loaded
[31455.600069] BTRFS: device fsid 34fb5b58-f50f-47c3-a5b8-91d81a30eade
devid 1 transid 81460 /dev/loop0
[32584.640398] BTRFS info (device loop0): disk space caching is enabled
[32584.640403] BTRFS: has skinny extents
[32584.654196] BTRFS: failed to read the system array on loop0
[32584.666774] BTRFS: open_ctree failed

Fortunately I have no valuable content in that image file and I restored
the system from a recent backup, but I still wonder if there's a bug
somewhere in btrfs-check.

Do you need other debug informations perhaps?

-- 
Website: http://www.fturco.net/
GPG key: 6712 2364 B2FE 30E1 4791 EB82 7BB1 1F53 29DE CD34
