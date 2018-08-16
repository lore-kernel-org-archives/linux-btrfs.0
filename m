Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:42923 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbeHPMCl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 08:02:41 -0400
Date: Thu, 16 Aug 2018 18:05:31 +0900
From: Naohiro Aota <naota@elisp.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>
Subject: Re: [RFC PATCH 00/17] btrfs zoned block device support
Message-ID: <20180816090531.knjb423b3fm5fdk4@zazie>
References: <20180809180450.5091-1-naota@elisp.net>
 <d5473558-47a1-708e-551b-fabb4ea0842e@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d5473558-47a1-708e-551b-fabb4ea0842e@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2018 at 03:28:21PM +0800, Qu Wenruo wrote:
> 
> 
> On 8/10/18 2:04 AM, Naohiro Aota wrote:
> > This series adds zoned block device support to btrfs.
> > 
> > A zoned block device consists of a number of zones. Zones are either
> > conventional and accepting random writes or sequential and requiring that
> > writes be issued in LBA order from each zone write pointer position.
> 
> Not familiar with zoned block device, especially for the sequential case.
> 
> Is that sequential case tape like?

It's somewhat similar but not the same as tape drives. In the tape
drives, you still *can* write in random access patters, though it's
much slow. In sequential required zones, it is always enforced to
write sequentially in a zone. Violating sequential write rule results
I/O error.

One user of sequential write required zone is Host-Managed "Shingled
Magnetic Recording" (SMR) HDDs [1]. They increase the volume capacity
by overlapping the tracks. As a result, writing to tracks overwrites
adjacent tracks. Such physical nature forces the sequential write
pattern.

[1] https://en.wikipedia.org/wiki/Shingled_magnetic_recording

> > This
> > patch series ensures that the sequential write constraint of sequential
> > zones is respected while fundamentally not changing BtrFS block and I/O
> > management for block stored in conventional zones.
> > 
> > To achieve this, the default dev extent size of btrfs is changed on zoned
> > block devices so that dev extents are always aligned to a zone. Allocation
> > of blocks within a block group is changed so that the allocation is always
> > sequential from the beginning of the block groups. To do so, an allocation
> > pointer is added to block groups and used as the allocation hint.  The
> > allocation changes also ensures that block freed below the allocation
> > pointer are ignored, resulting in sequential block allocation regardless of
> > the block group usage.
> 
> This looks like it would cause a lot of holes for metadata block groups.
> It would be better to avoid metadata block allocation in such sequential
> zone.
> (And that would need the infrastructure to make extent allocator
> priority-aware)

Yes, it would introduce holes in metadata block groups. I agree it is
desirable to allocate metadata blocks from conventional
(non-sequential) zones.

However, it's sometime impossible to allocate metadata blocks from
conventional zones, since the number of conventional zones is
generally smaller than sequential zones in some zoned block devices
like SMR HDDs (to achieve higher volume capacity).

While this patch series ensures metadata/data can be allocated in any
type of zone and everything works in any zones, we will be able to
improve metadata allocation by making the extent allocator
priority/zone-type aware in the future.

> > [...]
> > Naohiro Aota (17):
> >   btrfs: introduce HMZONED feature flag
> >   btrfs: Get zone information of zoned block devices
> >   btrfs: Check and enable HMZONED mode
> >   btrfs: limit super block locations in HMZONED mode
> >   btrfs: disable fallocate in HMZONED mode
> >   btrfs: disable direct IO in HMZONED mode
> >   btrfs: disable device replace in HMZONED mode
> >   btrfs: align extent allocation to zone boundary
> 
> According to the patch name, I though it's about extent allocation, but
> in fact it's about dev extent allocation.
> Renaming the patch would make more sense.
>
> >   btrfs: do sequential allocation on HMZONED drives
> 
> And this is the patch modifying extent allocator.

Thanks. I will fix the names of the patches in the next version.

> Despite that, the support zoned storage looks pretty interesting and
> have something in common with planned priority-aware extent allocator.
> 
> Thanks,
> Qu

Regards,
Naohiro
