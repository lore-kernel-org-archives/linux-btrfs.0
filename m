Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52304 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933471AbdIYODR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 10:03:17 -0400
Date: Mon, 25 Sep 2017 16:00:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: josef@toxicpanda.com, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] Btrfs: rework outstanding_extents
Message-ID: <20170925140009.GE31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1502989289-22098-1-git-send-email-jbacik@fb.com>
 <20170824093114.GA9506@fnst>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170824093114.GA9506@fnst>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 24, 2017 at 05:31:15PM +0800, Lu Fengqi wrote:
> On Thu, Aug 17, 2017 at 01:01:29PM -0400, josef@toxicpanda.com wrote:
> >From: Josef Bacik <jbacik@fb.com>
> >
> >Right now we do a lot of weird hoops around outstanding_extents in order
> >to keep the extent count consistent.  This is because we logically
> >transfer the outstanding_extent count from the initial reservation
> >through the set_delalloc_bits.  This makes it pretty difficult to get a
> >handle on how and when we need to mess with outstanding_extents.
> >
> >Fix this by revamping the rules of how we deal with outstanding_extents.
> >Now instead everybody that is holding on to a delalloc extent is
> >required to increase the outstanding extents count for itself.  This
> >means we'll have something like this
> >
> >btrfs_dealloc_reserve_metadata	- outstanding_extents = 1
> > btrfs_set_delalloc		- outstanding_extents = 2
> >btrfs_release_delalloc_extents	- outstanding_extents = 1
> >
> >for an initial file write.  Now take the append write where we extend an
> >existing delalloc range but still under the maximum extent size
> >
> >btrfs_delalloc_reserve_metadata - outstanding_extents = 2
> >  btrfs_set_delalloc
> >    btrfs_set_bit_hook		- outstanding_extents = 3
> >    btrfs_merge_bit_hook	- outstanding_extents = 2
> >btrfs_release_delalloc_extents	- outstanding_extnets = 1
> >
> >In order to make the ordered extent transition we of course must now
> >make ordered extents carry their own outstanding_extent reservation, so
> >for cow_file_range we end up with
> >
> >btrfs_add_ordered_extent	- outstanding_extents = 2
> >clear_extent_bit		- outstanding_extents = 1
> >btrfs_remove_ordered_extent	- outstanding_extents = 0
> >
> >This makes all manipulations of outstanding_extents much more explicit.
> >Every successful call to btrfs_reserve_delalloc_metadata _must_ now be
> >combined with btrfs_release_delalloc_extents, even in the error case, as
> >that is the only function that actually modifies the
> >outstanding_extents counter.
> 
> s/btrfs_reserve_delalloc_metadata/btrfs_delalloc_reserve_metadata
> s/btrfs_release_delalloc_extents/btrfs_delalloc_release_extents
> 
> Acked-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

BTW,

Documentation/process/5.Posting.rst

216  - Acked-by: indicates an agreement by another developer (often a
217    maintainer of the relevant code) that the patch is appropriate for
218    inclusion into the kernel.

and is commonly used by maintainers when someone else modifies the
respective codebase by tree-wide, API or similar.

If you agree with the way the patch is solving a particular problem and
think it's important enough to be stated, you can write that in plain
text.
