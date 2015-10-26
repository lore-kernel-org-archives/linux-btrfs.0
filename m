Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:50048 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbbJZGT6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 02:19:58 -0400
Received: from [192.168.1.4] (unknown [119.224.19.150])
	by pim.lukas-pirl.de (Postfix) with ESMTPSA id D8AA31C6AB41
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 06:19:56 +0000 (UTC)
From: Lukas Pirl <btrfs@lukas-pirl.de>
Subject: corrupted RAID1: unsuccessful recovery / help needed
To: linux-btrfs@vger.kernel.org
Message-ID: <562DC606.3070602@lukas-pirl.de>
Date: Mon, 26 Oct 2015 19:19:50 +1300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

TL;DR: RAID1 does not recover, I guess the interesting part in the stack 
trace is:

   Call Trace:
   [<ffffffffc0377e60>] __del_reloc_root+0x30/0x100 [btrfs]
   [<ffffffffc0377f55>] free_reloc_roots+0x25/0x40 [btrfs]
   [<ffffffffc037e47e>] merge_reloc_roots+0x18e/0x240 [btrfs]
   [<ffffffffc037f1f4>] btrfs_recover_relocation+0x374/0x420 [btrfs]
   [<ffffffffc0328f6d>] open_ctree+0x1b7d/0x23e0 [btrfs]
   [<ffffffffc02ff72e>] btrfs_mount+0x94e/0xa70 [btrfs]
   [<ffffffff813bc0c5>] ? find_next_bit+0x15/0x20
   [<ffffffff811f1078>] mount_fs+0x38/0x160
   …

Hello list.

I'd appreciate some help for repairing a corrupted RAID1.

Setup:
* Linux 4.2.0-12, Btrfs v3.17, `btrfs fi show`:
   uuid: 5be372f5-5492-4f4b-b641-c14f4ad8ae23
   Total devices 6 FS bytes used 2.87TiB
   devid 1 size 931.51GiB used 636.00GiB path /dev/mapper/WD-WCC4J7AFLTSZ
   devid 2 size 931.51GiB used 634.03GiB path /dev/mapper/WD-WCAU45343103
   devid 3 size   1.82TiB used   1.53TiB path /dev/mapper/WD-WCAVY6423276
   devid 4 size   1.82TiB used   1.53TiB path /dev/mapper/WD-WCAZAF872578
   devid 6 size   1.82TiB used   1.05TiB path /dev/mapper/WD-WMC4M0H3Z5UK
   *** Some devices missing
* disks are dm-crypted

What happened:
* devid 5 started to die (slowly)
* added a new disk (devid 6) and tried `btrfs device delete`
* failed with kernel crashes (guess:) due to heavy IO errors
* removed devid 5 from /dev (deactivated in dm-crypt)
* tried `btrfs balance`
   * interrupted multiple times due to kernel crashes
     (probably due to semi-corrupted file system?)
* file system did not mount anymore after a required hard-reset
* no successful recovery so far:
   if not read-only, kernel IO blocks eventually (hard-reset required)
* tried:
   * `-o degraded`
     -> IO freeze, kernel log: http://pastebin.com/Rzrp7XeL
   * `-o degraded,recovery`
     -> IO freeze, kernel log: http://pastebin.com/VemHfnuS
   * `-o degraded,recovery,ro`
     -> file system accessible, system stable
* going rw again does not fix the problem

I did not btrfs-zero-log so far because my oops did not look very
similar to the one in the Wiki and I did not want to risk to make
recovery harder.

Thanks,

Lukas

