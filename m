Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727438AbeHJKXw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 06:23:52 -0400
Subject: Re: [RFC PATCH 00/17] btrfs zoned block device support
From: Nikolay Borisov <nborisov@suse.com>
To: Naohiro Aota <naota@elisp.net>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>
References: <20180809180450.5091-1-naota@elisp.net>
 <bfbb2001-adbd-64ac-1f46-6b19c01eea9c@suse.com>
Message-ID: <cc3b336f-912e-f98d-8c79-ad85af6330b4@suse.com>
Date: Fri, 10 Aug 2018 10:55:06 +0300
MIME-Version: 1.0
In-Reply-To: <bfbb2001-adbd-64ac-1f46-6b19c01eea9c@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.08.2018 10:53, Nikolay Borisov wrote:
> 
> 
> On  9.08.2018 21:04, Naohiro Aota wrote:
>> This series adds zoned block device support to btrfs.
>>
>> A zoned block device consists of a number of zones. Zones are either
>> conventional and accepting random writes or sequential and requiring that
>> writes be issued in LBA order from each zone write pointer position. This
>> patch series ensures that the sequential write constraint of sequential
>> zones is respected while fundamentally not changing BtrFS block and I/O
>> management for block stored in conventional zones.
>>
>> To achieve this, the default dev extent size of btrfs is changed on zoned
>> block devices so that dev extents are always aligned to a zone. Allocation
>> of blocks within a block group is changed so that the allocation is always
>> sequential from the beginning of the block groups. To do so, an allocation
>> pointer is added to block groups and used as the allocation hint.  The
>> allocation changes also ensures that block freed below the allocation
>> pointer are ignored, resulting in sequential block allocation regardless of
>> the block group usage.
>>
>> While the introduction of the allocation pointer ensure that blocks will be
>> allocated sequentially, I/Os to write out newly allocated blocks may be
>> issued out of order, causing errors when writing to sequential zones. This
>> problem s solved by introducing a submit_buffer() function and changes to
>> the internal I/O scheduler to ensure in-order issuing of write I/Os for
>> each chunk and corresponding to the block allocation order in the chunk.
>>
>> The zones of a chunk are reset to allow reusing of the zone only when the
>> block group is being freed, that is, when all the extents of the block group
>> are unused.
>>
>> For btrfs volumes composed of multiple zoned disks, restrictions are added
>> to ensure that all disks have the same zone size. This matches the existing
>> constraint that all dev extents in a chunk must have the same size.
>>
>> It requires zoned block devices to test the patchset. Even if you don't
>> have zone devices, you can use tcmu-runner [1] to emulate zoned block
>> devices. It can export emulated zoned block devices via iSCSI. Please see
>> the README.md of tcmu-runner [2] for howtos to generate a zoned block
>> device on tcmu-runner.
>>
>> [1] https://github.com/open-iscsi/tcmu-runner
>> [2] https://github.com/open-iscsi/tcmu-runner/blob/master/README.md
>>
>> Patch 1 introduces the HMZONED incompatible feature flag to indicate that
>> the btrfs volume was formatted for use on zoned block devices.
>>
>> Patches 2 and 3 implement functions to gather information on the zones of
>> the device (zones type and write pointer position).
>>
>> Patch 4 restrict the possible locations of super blocks to conventional
>> zones to preserve the existing update in-place mechanism for the super
>> blocks.
>>
>> Patches 5 to 7 disable features which are not compatible with the sequential
>> write constraints of zoned block devices. This includes fallocate and
>> direct I/O support. Device replace is also disabled for now.
>>
>> Patches 8 and 9 tweak the extent buffer allocation for HMZONED mode to
>> implement sequential block allocation in block groups and chunks.
>>
>> Patches 10 to 12 implement the new submit buffer I/O path to ensure sequential
>> write I/O delivery to the device zones.
>>
>> Patches 13 to 16 modify several parts of btrfs to handle free blocks
>> without breaking the sequential block allocation and sequential write order
>> as well as zone reset for unused chunks.
>>
>> Finally, patch 17 adds the HMZONED feature to the list of supported
>> features.
>>
>> Naohiro Aota (17):
>>   btrfs: introduce HMZONED feature flag
>>   btrfs: Get zone information of zoned block devices
>>   btrfs: Check and enable HMZONED mode
>>   btrfs: limit super block locations in HMZONED mode
>>   btrfs: disable fallocate in HMZONED mode
>>   btrfs: disable direct IO in HMZONED mode
>>   btrfs: disable device replace in HMZONED mode
>>   btrfs: align extent allocation to zone boundary
>>   btrfs: do sequential allocation on HMZONED drives
>>   btrfs: split btrfs_map_bio()
>>   btrfs: introduce submit buffer
>>   btrfs: expire submit buffer on timeout
>>   btrfs: avoid sync IO prioritization on checksum in HMZONED mode
>>   btrfs: redirty released extent buffers in sequential BGs
>>   btrfs: reset zones of unused block groups
>>   btrfs: wait existing extents before truncating
>>   btrfs: enable to mount HMZONED incompat flag
>>
>>  fs/btrfs/async-thread.c     |   1 +
>>  fs/btrfs/async-thread.h     |   1 +
>>  fs/btrfs/ctree.h            |  36 ++-
>>  fs/btrfs/dev-replace.c      |  10 +
>>  fs/btrfs/disk-io.c          |  48 +++-
>>  fs/btrfs/extent-tree.c      | 281 +++++++++++++++++-
>>  fs/btrfs/extent_io.c        |   1 +
>>  fs/btrfs/extent_io.h        |   1 +
>>  fs/btrfs/file.c             |   4 +
>>  fs/btrfs/free-space-cache.c |  36 +++
>>  fs/btrfs/free-space-cache.h |  10 +
>>  fs/btrfs/inode.c            |  14 +
>>  fs/btrfs/super.c            |  32 ++-
>>  fs/btrfs/sysfs.c            |   2 +
>>  fs/btrfs/transaction.c      |  32 +++
>>  fs/btrfs/transaction.h      |   3 +
>>  fs/btrfs/volumes.c          | 551 ++++++++++++++++++++++++++++++++++--
>>  fs/btrfs/volumes.h          |  37 +++
>>  include/uapi/linux/btrfs.h  |   1 +
>>  19 files changed, 1061 insertions(+), 40 deletions(-)
>>
> 
> There are multiple places where you do naked shifts by
> ilog2(sectorsize). There is a perfectly well named define: SECTOR_SHIFT
> which a lot more informative for someone who doesn't necessarily have
> experience with linux storage/fs layers. Please fix such occurrences of
> magic values shifting.
> 

And Hannes just reminded me that this lannded in commit :
233bde21aa43 ("block: Move SECTOR_SIZE and SECTOR_SHIFT definitions into
<linux/blkdev.h>")

This March so it might fairly recent depending on the tree you've based
your work on.
