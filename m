Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:31816 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab3EOIwM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 04:52:12 -0400
Message-ID: <51934CBD.4080006@giantdisaster.de>
Date: Wed, 15 May 2013 10:52:13 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Btrfs: introduce a tree for UUID to subvol ID
 mapping
References: <cover.1368523154.git.sbehrens@giantdisaster.de> <20130514105523.GD15127@liubo.jp.oracle.com> <5192705A.6030708@giantdisaster.de>
In-Reply-To: <5192705A.6030708@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 14 May 2013 19:11:54 +0200, Stefan Behrens wrote:
> On Tue, 14 May 2013 18:55:23 +0800, Liu Bo wrote:
>> On Tue, May 14, 2013 at 11:36:52AM +0200, Stefan Behrens wrote:
>>> Mapping UUIDs to subvolume IDs is an operation with a high effort
>>> today. Today, the algorithm even has quadratic effort (based on the
>>> number of existing subvolumes), which means, that it takes minutes
>>> to send/receive a single subvolume if 10,000 subvolumes exist. But
>>> even linear effort would be too much since it is a waste. And these
>>> data structures to allow mapping UUIDs to subvolume IDs are created
>>> every time a btrfs send/receive instance is started.
>>>
>>> So the issue to address is that Btrfs send / receive does not work
>>> as it is today when a high number of subvolumes exist.
>>>
>>> It is much more efficient to maintain a searchable persistent data
>>> structure in the filesystem, one that is updated whenever a
>>> subvolume/snapshot is created and deleted, and when the received
>>> subvolume UUID is set by the btrfs-receive tool.
>>>
>>> Therefore kernel code is added that is able to maintain data
>>> structures in the filesystem that allow to quickly search for a
>>> given UUID and to retrieve the subvol ID.
>>>
>>> Now follows the lengthy justification, why a new tree was added
>>> instead of using the existing root tree:
>>>
>>> The first approach was to not create another tree that holds UUID
>>> items. Instead, the items should just go into the top root tree.
>>> Unfortunately this confused the algorithm to assign the objectid
>>> of subvolumes and snapshots. The reason is that
>>> btrfs_find_free_objectid() calls btrfs_find_highest_objectid() for
>>> the first created subvol or snapshot after mounting a filesystem,
>>> and this function simply searches for the largest used objectid in
>>> the root tree keys to pick the next objectid to assign. Of course,
>>> the UUID keys have always been the ones with the highest offset
>>> value, and the next assigned subvol ID was wastefully huge.
>>>
>>> To use any other existing tree did not look proper. To apply a
>>> workaround such as setting the objectid to zero in the UUID item
>>> key and to implement collision handling would either add
>>> limitations (in case of a btrfs_extend_item() approach to handle
>>> the collisions) or a lot of complexity and source code (in case a
>>> key would be looked up that is free of collisions). Adding new code
>>> that introduces limitations is not good, and adding code that is
>>> complex and lengthy for no good reason is also not good. That's the
>>> justification why a completely new tree was introduced.
>>
>> I'd appreciate if some performance number appear here since it's a speedup.
> 
> That's a good idea. The numbers are below in the table and there's also a link to a chart.
> 
> I stopped the measurement with the old version after 10000 subvolumes because it already took almost 13 minutes to send a single, empty subvolume. All the time is spent building a database, and this is done each time the btrfs send or receive tool is started to send or receive a single subvolume.
> 
> The table shows the time it takes to send a single, empty subvolume depending on the number of subvolume that exist in the filesystem.
> 
> # of subvols  | without    | with
> in filesystem | UUID tree  | UUID tree
> --------------+------------+----------
>             2 |  0m00.004s | 0m00.003s
>          1000 |  0m07.010s | 0m00.004s
>          2000 |  0m28.210s | 0m00.004s
>          3000 |  1m04.872s | 0m00.004s
>          4000 |  1m56.059s | 0m00.004s
>          5000 |  3m00.489s | 0m00.004s
>          6000 |  4m27.376s | 0m00.004s
>          7000 |  6m08.938s | 0m00.004s
>          8000 |  7m54.020s | 0m00.004s
>          9000 | 10m05.108s | 0m00.004s
>         10000 | 12m47.406s | 0m00.004s
> 
> Or as a chart:
> http://btrfs.giantdisaster.de/Btrfs-send-recv-perf.pdf

The table goes on like this for larger number of subvolumes (and the time value is always the time to transfer just _one_ of the subvolumes):

# of subvols  | without    | with
in filesystem | UUID tree  | UUID tree
--------------+------------+----------
            2 |  0m00.004s | 0m00.003s
         1000 |  0m07.010s | 0m00.004s
         2000 |  0m28.210s | 0m00.004s
         3000 |  1m04.872s | 0m00.004s
         4000 |  1m56.059s | 0m00.004s
         5000 |  3m00.489s | 0m00.004s
         6000 |  4m27.376s | 0m00.004s
         7000 |  6m08.938s | 0m00.004s
         8000 |  7m54.020s | 0m00.004s
         9000 | 10m05.108s | 0m00.004s
        10000 | 12m47.406s | 0m00.004s
        11000 | 15m05.800s | 0m00.004s
        12000 | 18m00.170s | 0m00.004s
        13000 | 21m39.438s | 0m00.004s
        14000 | 24m54.681s | 0m00.004s
        15000 | 28m09.096s | 0m00.004s
        16000 | 33m08.856s | 0m00.004s
        17000 | 37m10.562s | 0m00.004s
        18000 | 41m44.727s | 0m00.004s
        19000 | 46m14.335s | 0m00.004s
        20000 | 51m55.100s | 0m00.004s
        21000 | 56m54.346s | 0m00.004s
        22000 | 62m53.466s | 0m00.004s
        23000 | 66m57.328s | 0m00.004s
        24000 | 73m59.687s | 0m00.004s
        25000 | 81m24.476s | 0m00.004s
        26000 | 87m11.478s | 0m00.004s
        27000 | 92m59.225s | 0m00.004s

For 100,000 existing subvolumes, the calculated value is 22 hours 25 minutes 19 seconds to start btrfs send/receive to transfer a single subvolume.
For 1,000,000 existing subvolumes, it would take 102 days.
30 years for 10 million existing subvolumes. And 30 years is unacceptable.


> The Hardware:
> Intel(R) Xeon(R) CPU X3450 @ 2.67GHz
> 8 GB RAM
> 6 high performance SSDs
> 
> The script:
> #!/bin/bash
> set -e
> MOUNT=/mnt2
> umount $MOUNT || true
> mkfs.btrfs -f -m raid0 -d raid0 -n 32768 /dev/sdc /dev/sdj /dev/sds /dev/sdt /dev/sdu /dev/sdv
> mount /dev/sdc $MOUNT
> btrfs subv create $MOUNT/0
> btrfs subv snapshot -r $MOUNT/0 $MOUNT/0ro > /dev/null
> echo '2 subvols'
> time btrfs send $MOUNT/0ro > /dev/null
> umount $MOUNT
> mkfs.btrfs -f -m raid0 -d raid0 -n 32768 /dev/sdc /dev/sdj /dev/sds /dev/sdt /dev/sdu /dev/sdv
> mount /dev/sdc $MOUNT
> for i in `seq 1000`; do
>         btrfs subv create $MOUNT/$i
>         for j in `seq 500`; do
>                 btrfs subv create $MOUNT/$i/$j > /dev/null
>                 btrfs subv snapshot -r $MOUNT/$i/$j $MOUNT/$i/${j}ro > /dev/null
>         done
>         echo $i 'k subvols'
>         time btrfs send $MOUNT/$i/1ro > /dev/null
> done


