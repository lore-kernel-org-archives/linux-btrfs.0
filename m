Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh3.e.nsc.no ([193.213.121.74]:33325 "EHLO nmsh3.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbbL0OKK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 09:10:10 -0500
Received: from [10.0.0.10] (ti0210a400-0205.bb.online.no [88.91.8.206])
	(authenticated bits=0)
	by nmsh3.nsc.no (8.14.7/8.14.7) with ESMTP id tBRDxJ0o016469
	for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 14:59:22 +0100 (MET)
To: linux-btrfs@vger.kernel.org
From: Waxhead <waxhead@online.no>
Subject: Btrfs scrub failure for raid 6 kernel 4.3
Message-ID: <567FEEB6.3080701@online.no>
Date: Sun, 27 Dec 2015 14:59:18 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a "toy-array" of 6x USB drives hooked up to a hub where I made a 
btrfs raid 6 data+metadata filesystem.

I copied some files to the filesystem, ripped out one USB drive and 
ruined it dd if=/dev/random to various locations on the drive. Put the 
USB drive back and the filesystem mounts ok.

If i start scrub I after seconds get the following

  kernel:[   50.844026] CPU: 1 PID: 91 Comm: kworker/u4:2 Not tainted 4.3.0-1-686-pae #1 Debian 4.3.3-2
  kernel:[   50.844026] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
  kernel:[   50.844026] Workqueue: btrfs-endio-raid56 btrfs_endio_raid56_helper [btrfs]
  kernel:[   50.844026] task: f642c040 ti: f664c000 task.ti: f664c000
  kernel:[   50.844026] Stack:
  kernel:[   50.844026]  00000005 f0d20800 f664ded0 f86d0262 00000000 f664deac c109a0fc 00000001
  kernel:[   50.844026]  f79eac40 edb4a000 edb7a000 edb8a000 edbba000 eccc1000 ecca1000 00000000
  kernel:[   50.844026]  00000000 f664de68 00000003 f664de74 ecb23000 f664de5c f5cda6a4 f0d20800
  kernel:[   50.844026] Call Trace:
  kernel:[   50.844026]  [<f86d0262>] ? finish_parity_scrub+0x272/0x560 [btrfs]
  kernel:[   50.844026]  [<c109a0fc>] ? set_next_entity+0x8c/0xba0
  kernel:[   50.844026]  [<c127d130>] ? bio_endio+0x40/0x70
  kernel:[   50.844026]  [<f86891fe>] ? btrfs_scrubparity_helper+0xce/0x270 [btrfs]
  kernel:[   50.844026]  [<c107ca7d>] ? process_one_work+0x14d/0x360
  kernel:[   50.844026]  [<c107ccc9>] ? worker_thread+0x39/0x440
  kernel:[   50.844026]  [<c107cc90>] ? process_one_work+0x360/0x360
  kernel:[   50.844026]  [<c10821a6>] ? kthread+0xa6/0xc0
  kernel:[   50.844026]  [<c1536181>] ? ret_from_kernel_thread+0x21/0x30
  kernel:[   50.844026]  [<c1082100>] ? kthread_create_on_node+0x130/0x130
  kernel:[   50.844026] Code: 6e c1 e8 ac dd f2 ff 83 c4 04 5b 5d c3 8d b6 00 00 00 00 31 c9 81 3d 84 f0 6e c1 84 f0 6e c1 0f 95 c1 eb b9 8d b4 200 00 00 00 0f 0b 8d b4 26 00 00 00 00 8d bc 27 00
  kernel:[   50.844026] EIP: [<c1174858>] kunmap_high+0xa8/0xc0 SS:ESP 0068:f664de40

This is only a test setup and I will keep this filesystem for a while if 
it can be of any use...
