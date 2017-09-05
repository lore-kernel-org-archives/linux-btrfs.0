Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:56877 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750707AbdIEF6t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Sep 2017 01:58:49 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: btrfs is slow while looping in search_bitmap
 <-btrfs_find_space_for_alloc
Message-ID: <89bd6888-71a5-895d-43db-622ff129d56b@profihost.ag>
Date: Tue, 5 Sep 2017 07:58:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

while expecting slow btrfs volumes i switched to kernel v4.13 and to
space_cache=v2.

But i'm still expecting slow performance and single kworker processes
using 100% CPU.

Tracing the kworker process shows me:
# sed 's/.*: //' /trace | sort | uniq -c | sort -n
  21595 tree_search_offset.isra.23 <-btrfs_find_space_for_alloc
  21610 btrfs_find_space_for_alloc <-find_free_extent
  21619 _raw_spin_lock <-btrfs_find_space_for_alloc
  27431 _cond_resched <-find_free_extent
  27437 down_read <-find_free_extent
  27451 block_group_cache_done.isra.29 <-find_free_extent
  27451 btrfs_put_block_group <-find_free_extent
  27464 up_read <-find_free_extent
  27486 __get_raid_index <-find_free_extent
  27503 _raw_spin_lock <-find_free_extent
  48335 search_bitmap <-btrfs_find_space_for_alloc

Is there anything to optimize? Can i speed up this?

There's still plenty of unallocated space:
# btrfs fi usage /vmbackup/
Overall:
    Device size:                  58.20TiB
    Device allocated:             22.66TiB
    Device unallocated:           35.54TiB
    Device missing:                  0.00B
    Used:                         21.07TiB
    Free (estimated):             37.12TiB      (min: 37.12TiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID0: Size:22.57TiB, Used:20.99TiB
   /dev/sdc1       5.64TiB
   /dev/sdd1       5.64TiB
   /dev/sde1       5.64TiB
   /dev/sdf1       5.64TiB

Metadata,RAID0: Size:90.00GiB, Used:81.60GiB
   /dev/sdc1      22.50GiB
   /dev/sdd1      22.50GiB
   /dev/sde1      22.50GiB
   /dev/sdf1      22.50GiB

System,RAID0: Size:64.00MiB, Used:1.53MiB
   /dev/sdc1      16.00MiB
   /dev/sdd1      16.00MiB
   /dev/sde1      16.00MiB
   /dev/sdf1      16.00MiB

Unallocated:
   /dev/sdc1       8.88TiB
   /dev/sdd1       8.88TiB
   /dev/sde1       8.88TiB
   /dev/sdf1       8.88TiB

Is btrfs trying to hard to find free space?

Greets,
Stefan
