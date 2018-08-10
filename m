Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42213 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbeHJQyf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 12:54:35 -0400
Date: Fri, 10 Aug 2018 23:24:24 +0900
From: Naohiro Aota <naota@elisp.net>
To: Hannes Reinecke <hare@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>
Subject: Re: [RFC PATCH 00/17] btrfs zoned block device support
Message-ID: <20180810142424.62linovnguszljzf@zazie>
References: <20180809180450.5091-1-naota@elisp.net>
 <b60c72ff-8fba-839f-4c42-df68318b9222@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <b60c72ff-8fba-839f-4c42-df68318b9222@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2018 at 09:04:59AM +0200, Hannes Reinecke wrote:
> On 08/09/2018 08:04 PM, Naohiro Aota wrote:
> > This series adds zoned block device support to btrfs.
> > 
> > A zoned block device consists of a number of zones. Zones are either
> > conventional and accepting random writes or sequential and requiring that
> > writes be issued in LBA order from each zone write pointer position. This
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
> > 
> > While the introduction of the allocation pointer ensure that blocks will be
> > allocated sequentially, I/Os to write out newly allocated blocks may be
> > issued out of order, causing errors when writing to sequential zones. This
> > problem s solved by introducing a submit_buffer() function and changes to
> > the internal I/O scheduler to ensure in-order issuing of write I/Os for
> > each chunk and corresponding to the block allocation order in the chunk.
> > 
> > The zones of a chunk are reset to allow reusing of the zone only when the
> > block group is being freed, that is, when all the extents of the block group
> > are unused.
> > 
> > For btrfs volumes composed of multiple zoned disks, restrictions are added
> > to ensure that all disks have the same zone size. This matches the existing
> > constraint that all dev extents in a chunk must have the same size.
> > 
> > It requires zoned block devices to test the patchset. Even if you don't
> > have zone devices, you can use tcmu-runner [1] to emulate zoned block
> > devices. It can export emulated zoned block devices via iSCSI. Please see
> > the README.md of tcmu-runner [2] for howtos to generate a zoned block
> > device on tcmu-runner.
> > 
> > [1] https://github.com/open-iscsi/tcmu-runner
> > [2] https://github.com/open-iscsi/tcmu-runner/blob/master/README.md
> > 
> > Patch 1 introduces the HMZONED incompatible feature flag to indicate that
> > the btrfs volume was formatted for use on zoned block devices.
> > 
> > Patches 2 and 3 implement functions to gather information on the zones of
> > the device (zones type and write pointer position).
> > 
> > Patch 4 restrict the possible locations of super blocks to conventional
> > zones to preserve the existing update in-place mechanism for the super
> > blocks.
> > 
> > Patches 5 to 7 disable features which are not compatible with the sequential
> > write constraints of zoned block devices. This includes fallocate and
> > direct I/O support. Device replace is also disabled for now.
> > 
> > Patches 8 and 9 tweak the extent buffer allocation for HMZONED mode to
> > implement sequential block allocation in block groups and chunks.
> > 
> > Patches 10 to 12 implement the new submit buffer I/O path to ensure sequential
> > write I/O delivery to the device zones.
> > 
> > Patches 13 to 16 modify several parts of btrfs to handle free blocks
> > without breaking the sequential block allocation and sequential write order
> > as well as zone reset for unused chunks.
> > 
> > Finally, patch 17 adds the HMZONED feature to the list of supported
> > features.
> > 
> Thanks for doing all the work.
> However, the patches don't apply cleanly to current master branch.
> Can you please rebase them?

I'm currently basing on
https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
for-next branch, since my previous bug-fix patch 266e010932ce ("btrfs:
revert fs_devices state on error of btrfs_init_new_device") is
necessary to avoid use-after-free bug in error handling path of
btrfs_init_new_device() in the patch 2. I'm sorry for not mentioning
it.

I'll rebase on the master branch when the patch reach the master.

Regards,
Naohiro

> Thanks.
> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.com			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
> HRB 21284 (AG Nürnberg)
