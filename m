Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51032 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab3KUKG6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 05:06:58 -0500
Received: by mail-wi0-f178.google.com with SMTP id ca18so773478wib.17
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Nov 2013 02:06:57 -0800 (PST)
MIME-Version: 1.0
From: Andrea Gelmini <andrea.gelmini@gmail.com>
Date: Thu, 21 Nov 2013 11:06:36 +0100
Message-ID: <CAK-xaQbp8Yfgpu-Tx5CV2yhACxku6_8Zv0cXFCudyFKqoq0D=w@mail.gmail.com>
Subject: Clean crash...
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,
  and thanks a lot for your work.
  I have an USB drive with BTRFS, on which I write with different
kernel release.
  Anyway, today I made a copy of one big file, and than powered off
the computer with a clean shutdown (Ubuntu 13.10 - 32bit).
  Now it's impossible to me to mount it (even with kernel 3.12).
  Here the kernel log:
[33109.118337] scsi 19:0:0:0: Direct-Access     WD       My Passport
0748 1019 PQ: 0 ANSI: 6
[33109.118497] sd 19:0:0:0: Attached scsi generic sg2 type 0
[33109.122721] sd 19:0:0:0: [sdb] Spinning up disk...
[33110.126799] .....ready
[33114.148252] sd 19:0:0:0: [sdb] 3906963456 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[33114.148517] sd 19:0:0:0: [sdb] Write Protect is off
[33114.148521] sd 19:0:0:0: [sdb] Mode Sense: 47 00 10 08
[33114.148783] sd 19:0:0:0: [sdb] No Caching mode page found
[33114.148786] sd 19:0:0:0: [sdb] Assuming drive cache: write through
[33114.149846] sd 19:0:0:0: [sdb] No Caching mode page found
[33114.149852] sd 19:0:0:0: [sdb] Assuming drive cache: write through
[33114.156920]  sdb: sdb1 sdb2
[33114.157997] sd 19:0:0:0: [sdb] No Caching mode page found
[33114.158001] sd 19:0:0:0: [sdb] Assuming drive cache: write through
[33114.158004] sd 19:0:0:0: [sdb] Attached SCSI disk
[33125.448462] btrfs: device label GelmaWdUsb2T devid 1 transid 5356 /dev/dm-1
[33130.874900] btrfs: device label GelmaWdUsb2T devid 1 transid 5356
/dev/mapper/toshi
[33130.876116] btrfs: disk space caching is enabled
[33130.981694] parent transid verify failed on 789536112640 wanted
5356 found 5352
[33130.985050] parent transid verify failed on 789536112640 wanted
5356 found 5352
[33131.002965] btrfs: open_ctree failed
[33249.141036] kvm [3219]: vcpu0 disabled perfctr wrmsr: 0xc1 data 0xffff
[33395.534631] btrfs: device label GelmaWdUsb2T devid 1 transid 5356 /dev/dm-1
[33414.549954] btrfs: device label GelmaWdUsb2T devid 1 transid 5356
/dev/mapper/toshi
[33414.550582] btrfs: disk space caching is enabled
[33414.598941] parent transid verify failed on 789536112640 wanted
5356 found 5352
[33414.602385] parent transid verify failed on 789536112640 wanted
5356 found 5352
[33414.618747] btrfs: open_ctree failed

And here what happens trying the fix:
root@glen:/home/gelma/dev/prg/btrfs# ./btrfsck --repair /dev/mapper/toshi
enabling repair mode
parent transid verify failed on 789536112640 wanted 5356 found 5352
parent transid verify failed on 789536112640 wanted 5356 found 5352
parent transid verify failed on 789536112640 wanted 5356 found 5352
parent transid verify failed on 789536112640 wanted 5356 found 5352
Ignoring transid failure
Checking filesystem on /dev/mapper/toshi
UUID: 35eb15cd-d7e3-4be8-92f1-7b210353e241
checking extents
parent transid verify failed on 789310947328 wanted 5356 found 5354
parent transid verify failed on 789310947328 wanted 5356 found 5354
parent transid verify failed on 789311094784 wanted 5356 found 5354
parent transid verify failed on 789311094784 wanted 5356 found 5354
leaf parent key incorrect 789310947328
bad block 789310947328
leaf parent key incorrect 789311094784
bad block 789311094784
leaf parent key incorrect 789311143936
bad block 789311143936
Unable to find block group for 0
btrfsck: extent-tree.c:288: find_search_start: Assertion `!(1)' failed.
Annullato

I've got a backup of the harddrive, but I am far away from the last file.

Thanks a lot for your help,
Andrea
