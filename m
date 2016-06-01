Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431AbcFAPJr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 11:09:47 -0400
Date: Wed, 1 Jun 2016 17:09:08 +0200
From: David Sterba <dsterba@suse.cz>
To: luke <lufq.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix check_shared for fiemap ioctl
Message-ID: <20160601150908.GE29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463369030-15434-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160530152506.GC29147@twin.jikos.cz>
 <f7e6d563-9964-5427-d9ad-cf7db858ad24@cn.fujitsu.com>
 <20160531161555.GI29147@suse.cz>
 <283c34ba-3ae5-c2c1-1b3e-e0d98c5e4f52@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <283c34ba-3ae5-c2c1-1b3e-e0d98c5e4f52@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 01, 2016 at 09:23:57AM +0800, luke wrote:
> 
> 
> At 06/01/2016 12:15 AM, David Sterba wrote:
> > On Tue, May 31, 2016 at 11:08:39AM +0800, luke wrote:
> >>>> +};
> >>>> +
> >>>> +/* dynamically allocate and initialize a ref_root */
> >>>> +static struct ref_root *ref_root_alloc(gfp_t gfp_mask)
> >>>> +{
> >>>> +	struct ref_root *ref_tree;
> >>>> +
> >>>> +	ref_tree = kmalloc(sizeof(*ref_tree), gfp_mask);
> >>> Drop the gfp_mask and make it GFP_KERNEL
> >> OK, I'll drop the gfp_mask, but can you tell me why should use
> >> GFP_KERNEL instead of GFP_NOFS?
> > Because there's no need to narrow the allocation constraints. GFP_NOFS
> > is necessary when the caller is on a critical path that must not recurse
> > back to the filesystem through the allocation (ie. if the allocator
> > decides to free some memory and tries tro write dirty data). FIEMAP is
> > called from an ioctl.
> OK, I'll update this patch with GFP_KERNEL.
> >
> >>>>    			disko = em->block_start + offset_in_extent;
> >>>>    
> >>>>    			/*
> >>>> +			 * We need a trans handle to get delayed refs
> >>>> +			 */
> >>>> +			trans = btrfs_join_transaction(root);
> >>> What are the implications of join/end transaction here? It's just
> >>> fiemap, I would not expect messing with transaction here.
> >> This transaction is used to handle delayed_refs, if trans = NULL, we
> >> have to ignore the delayed_refs.
> > Yes that's what the comment says as well, but I still don't understand
> > why, so I need somebody else to review that part.
> If not checking delayed refs, shared_flag will not be set for reflink 
> until transaction committed.
> Test case to test this misbehavior is already submitted(generic/353).
> 
> The simplest test procedure would be like  the following:
> 
> # xfs_io -f -c "pwrite 0 128K" test
> # cp --reflink test test2
> # xfs_io -c "fiemap" test2
> 
> And normally, the SHARED flag should be set, but since the trans isn't 
> committed yet, if not checking delayed refs, we can't determine whether 
> it is shared by others.

Ok, thanks.
