Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbeERPmr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 11:42:47 -0400
Date: Fri, 18 May 2018 17:40:04 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V3 0/3] Btrfs: btrfs_dedupe_file_range() ioctl, remove
 16MiB restriction
Message-ID: <20180518154004.GQ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180502051538.26432-1-nefelim4ag@gmail.com>
 <20180511152258.GB6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180511152258.GB6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 05:22:58PM +0200, David Sterba wrote:
> On Wed, May 02, 2018 at 08:15:35AM +0300, Timofey Titovets wrote:
> > At now btrfs_dedupe_file_range() restricted to 16MiB range for
> > limit locking time and memory requirement for dedup ioctl()
> > 
> > For too big input range code silently set range to 16MiB
> > 
> > Let's remove that restriction by do iterating over dedup range.
> > That's backward compatible and will not change anything for request
> > less then 16MiB.
> > 
> > Changes:
> >   v1 -> v2:
> >     - Refactor btrfs_cmp_data_prepare and btrfs_extent_same
> >     - Store memory of pages array between iterations
> >     - Lock inodes once, not on each iteration
> >     - Small inplace cleanups
> >   v2 -> v3:
> >     - Split to several patches
> > 
> > Timofey Titovets (3):
> >   Btrfs: split btrfs_extent_same() for simplification
> >   Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB restriction
> >   Btrfs: btrfs_extent_same() reuse cmp workspace
> 
> Looks good to me, thanks. I'll edit the changlogs a bit and add the
> patches to 4.18 queue.

Patchset added to misc-next, so it's on the way to 4.18, thanks.
