Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:59090 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbaDWVEL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 17:04:11 -0400
Received: by mail-ve0-f181.google.com with SMTP id oy12so1876613veb.12
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 14:04:10 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Apr 2014 17:04:10 -0400
Message-ID: <CACZaor2-NMo2PeZ=pO0ygz=VjE4JDoORp4Np8unVGd3buwKBxw@mail.gmail.com>
Subject: raid6, disks of different sizes, ENOSPC errors despite having plenty
 of space
From: Sergey Ivanyuk <modemch@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a filesystem that I've converted to raid6 from raid1, on 4 drives (I
have another copy of the data):

        Total devices 4 FS bytes used 924.64GiB
        devid    1 size 1.82TiB used 474.00GiB path /dev/sdd
        devid    2 size 465.76GiB used 465.76GiB path /dev/sda
        devid    3 size 465.76GiB used 465.76GiB path /dev/sdb
        devid    4 size 465.76GiB used 465.73GiB path /dev/sdc

Data, RAID6: total=924.00GiB, used=923.42GiB
System, RAID1: total=32.00MiB, used=208.00KiB
Metadata, RAID1: total=1.70GiB, used=1.28GiB
Metadata, DUP: total=384.00MiB, used=252.13MiB
unknown, single: total=512.00MiB, used=0.00


Recent btrfs-progs built from source, kernel 3.15.0-rc2 on armv7l. Despite
having plenty of space left on the larger drive, attempting to copy more
data onto the filesystem results in a kworker process pegged at 100% CPU
for a very long time (10s of minutes), at which point the writes proceed
for some time, and the process repeats until the eventual "No space left on
device" error. Balancing fails with the same error, even if attempting to
convert back to raid1.

I realize that this likely has something to do with the disparity between
device sizes, and per the wiki a fixed-width stripe may help, though I'm
not sure if it's possible to change the stripe width in my situation, since
I can't rebalance. Is there anything I can do to get this filesystem back
to writable state?

Also, here's a stack trace for the stuck kworker process, which appears to
be a bug since it does this for a very long time:

Exception stack(0xab4699c8 to 0xab469a10)
99c0:                   aec7c870 00000000 00000000 aec7c841 08000000
aec7c870
99e0: ab469ad0 bd51e880 00003000 00000000 0006c000 00000000 00000005
ab469a10
9a00: 80299c8c 80310098 200e0013 ffffffff
[<80011e80>] (__irq_svc) from [<80310098>] (rb_next+0x14/0x5c)
[<80310098>] (rb_next) from [<80299c8c>]
(btrfs_find_space_for_alloc+0x138/0x344)
[<80299c8c>] (btrfs_find_space_for_alloc) from [<80240020>]
(find_free_extent+0x378/0xabc)
[<80240020>] (find_free_extent) from [<80240840>]
(btrfs_reserve_extent+0xdc/0x164)
[<80240840>] (btrfs_reserve_extent) from [<8025aef4>]
(cow_file_range+0x17c/0x5bc)
[<8025aef4>] (cow_file_range) from [<8025c1e0>]
(run_delalloc_range+0x34c/0x380)
[<8025c1e0>] (run_delalloc_range) from [<80274d6c>]
(__extent_writepage+0x708/0x940)
[<80274d6c>] (__extent_writepage) from [<802754b4>]
(extent_writepages+0x238/0x368)
[<802754b4>] (extent_writepages) from [<8009b190>] (do_writepages+0x24/0x38)
[<8009b190>] (do_writepages) from [<800ef59c>]
(__writeback_single_inode+0x28/0x110)
[<800ef59c>] (__writeback_single_inode) from [<800f04c8>]
(writeback_sb_inodes+0x184/0x38c)
[<800f04c8>] (writeback_sb_inodes) from [<800f0740>]
(__writeback_inodes_wb+0x70/0xac)
[<800f0740>] (__writeback_inodes_wb) from [<800f0978>]
(wb_writeback+0x1fc/0x20c)
[<800f0978>] (wb_writeback) from [<800f0b78>]
(bdi_writeback_workfn+0x144/0x338)
[<800f0b78>] (bdi_writeback_workfn) from [<80037cfc>]
(process_one_work+0x110/0x368)
[<80037cfc>] (process_one_work) from [<800383c8>]
(worker_thread+0x138/0x3e8)
[<800383c8>] (worker_thread) from [<8003de90>] (kthread+0xcc/0xe8)
[<8003de90>] (kthread) from [<8000e238>] (ret_from_fork+0x14/0x3c)
