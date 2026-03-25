Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7418029BD90
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 22:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477472; cv=none; b=rl8eeFZ9i4MXd2/NTPrAiw+tHAoSvk8XR94sfY4/5I+GMfERcnVEHTshjNa+98c5tPpNBSmbbIk6BqyuHVJnvFsqTy1GA1b2Ca5jve2KolKboI1D3SUOm27CiFb20K+69MiYRXgy157+89kKlm6gRYV2V7Pk5cTeJLKReV8nGhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477472; c=relaxed/simple;
	bh=DNEDYMVlfeRvJSguwTClBo8rDCe6r+Kt4Tw0NsCcJSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iucyA+//XMSx6kCX5S8mVolZlPOIqGQ9t5/am6buMC6cD6LR7DhyJGbcb4OXLrPlmC64RUj13MKwkVPtpwGY7bInZLrw3qgR56msWOix5YaVrlv2Jbs0km+V1rSid6mUN/dcPnzKP9jWoWZHHHmu+rRJ55nG0EwBIJ3zqOQQUZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=jRf8zMGv; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RZQj0vUu; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="jRf8zMGv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RZQj0vUu"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id C24E9EC02B2;
	Wed, 25 Mar 2026 18:24:29 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 25 Mar 2026 18:24:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1774477469;
	 x=1774563869; bh=lt5Z0EK7Ii+4dql0dN7P8Yv5WN4r3okvmGe4aj4zwOg=; b=
	jRf8zMGvVut5BfIbJeBa5ldWsRhi5+O+21N5c4jODdo6C74Q0jgUKLppppJBUusm
	iq0fxFthOPeB4ku/MvIA9PegnX+XkHrLrZ3ILnVTuZ/76ImheEmfTd4mofaSePbO
	vxyoNIc7m2C5bqvdxUN6AlrmFVdDSjPlrSl22+FsjTKi6nqvQ+C9nI7if9kdo+f6
	dqkMHDrqtD9u+ISS7fwhy+AehXIqrPpkUVfVo7YX0B+DN9a1p5DGRwMq2TmaJTMk
	0CWAoFipntJFObEnXOFnQBs0GaFW8Hf+VrOPZQHu2nu0iSNTIEg093ig93xkZWdf
	k8R0foUi/XjCmL5IIMluIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774477469; x=
	1774563869; bh=lt5Z0EK7Ii+4dql0dN7P8Yv5WN4r3okvmGe4aj4zwOg=; b=R
	ZQj0vUuueP21XOmpVhB5o8iL4f8hIG8UoqYAUGXsOaV3AoeVSepc/7hGuSt0K9JE
	2t2UBuhT7InU/z9u93hFgRw1cxITiHcM6B4JYfW/eKjXX8J+B/4DdeB+aeFjNYRz
	Ko/yzOp9v7x2clAqbtP+y/l0jDFiqjegcNA41IpuXWkhWSsypYO9gPIAqoDev635
	2hsE9tjkcXAykPHBKmLgjwpbAIsiQ3+ox2aqYiiwtN1xeqkjTHSg0obi2Yr0Jfmj
	DKoyxtithv9Et5wOCw/HVX++VZRYL8Q7BEC0QvN+zmEEvWVn4i8iLMDnDK6GQ2Ih
	WRcS6S18biMezQjw8pzJw==
X-ME-Sender: <xms:nWDEaRvpBG-U3psyp1VduwvrA4CpbycHOrZ0fh62ehNEwMC34lJg3Q>
    <xme:nWDEaR56O68ILvmFkz_pUCp2kKX_q5mrnL2U8kYe2oPpbF7ZE6wpSeYqJUm4XJBCn
    mKxGryu1XYwoziASnOA46vlInAP3p5FNlvf5LFPOOdqW9GDWPcERIY>
X-ME-Received: <xmr:nWDEaSL7L9igAGFT2MGmqQSIAdxCIC7Yhs96VDwcDWlPAzO46yVVFcqUXvh3BT5XycLzfakmjz62IMrfPMsmaNWbOo4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdehieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepud
    elhfdthfetuddvtefhfedtiedtteehvddtkedvledtvdevgedtuedutdeitdeinecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihhopdhnsggprhgtphhtthhopeefpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehfughmrghnrghnrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugi
    dqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgv
    lhdqthgvrghmsehfsgdrtghomh
X-ME-Proxy: <xmx:nWDEaR79MBA5JdZyuqhy4czPdv75NQDly0ROp0Dk5_B0epewvRJ6nQ>
    <xmx:nWDEaVw1Tq7Mcjypm5wT9IyI474IKoX6OMlmI3FratUE72Bye99pWA>
    <xmx:nWDEaVbhnn5p8x65DJ4I3DivWcsZgDSOZC-X4Vwzt9Pyg9qNGMDhvg>
    <xmx:nWDEaXQ_NGUmC9TWSSG5BDPTlnOhKNhJEk8lPA442VcDvS0MLej5dA>
    <xmx:nWDEacZ3zgDavsCF0QQt3PqXIEeIUfT3cQ7z0UUx_exP5LxZiklRMnLk>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Mar 2026 18:24:29 -0400 (EDT)
Date: Wed, 25 Mar 2026 15:24:13 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/5] btrfs: reserve space for delayed_refs in delalloc
Message-ID: <20260325222413.GA3065561@zen.localdomain>
References: <cover.1774398665.git.boris@bur.io>
 <4828515e28d350985e7b7b9d3a58a5990b74362d.1774398665.git.boris@bur.io>
 <CAL3q7H6nx=Jm_pVRpyBA=dh7WkHo_zvW66SLt6k3Tiw4KWCDtg@mail.gmail.com>
 <20260325183916.GB2908386@zen.localdomain>
 <CAL3q7H7h6U4RC+6GS7Utk=ruGQKE9kCNFmTxC68Jd_KnCu2P8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H7h6U4RC+6GS7Utk=ruGQKE9kCNFmTxC68Jd_KnCu2P8Q@mail.gmail.com>

On Wed, Mar 25, 2026 at 06:55:49PM +0000, Filipe Manana wrote:
> On Wed, Mar 25, 2026 at 6:39 PM Boris Burkov <boris@bur.io> wrote:
> >
> > On Wed, Mar 25, 2026 at 03:36:21PM +0000, Filipe Manana wrote:
> > > On Wed, Mar 25, 2026 at 12:45 AM Boris Burkov <boris@bur.io> wrote:
> > > >
> > > > delalloc uses a per-inode block_rsv to perform metadata reservations for
> > > > the cow operations it anticipates based on the number of outstanding
> > > > extents. This calculation is done based on inode->outstanding_extents in
> > > > btrfs_calculate_inode_block_rsv_size(). The reservation is *not*
> > > > meticulously tracked as each ordered_extent is actually created in
> > > > writeback, but rather delalloc attempts to over-estimate and the
> > > > writeback and ordered_extent finish portions are responsible to release
> > > > all the reservation.
> > > >
> > > > However, there is a notable gap in this reservation, it reserves no
> > > > space for the resulting delayed_refs. If you compare to how
> > > > btrfs_start_transaction() reservations work, this is a noteable
> > > > difference.
> > > >
> > > > As writeback actually occurs, and we trigger btrfs_finish_one_ordered(),
> > > > that function will start generating delayed refs, which will draw from
> > > > the trans_handle's delayed_refs_rsv via btrfs_update_delayed_refs_rsv():
> > > >
> > > > btrfs_finish_one_ordered()
> > > >   insert_ordered_extent_file_extent()
> > > >     insert_reserved_file_extent()
> > > >       btrfs_alloc_reserved_file_extent()
> > > >         btrfs_add_delayed_data_ref()
> > > >           add_delayed_ref()
> > > >             btrfs_update_delayed_refs_rsv();
> > > >
> > > > This trans_handle was created in finish_one_ordered() with
> > > > btrfs_join_transaction() which calls start_transaction with
> > > > num_items=0 and BTRFS_RESERVE_NO_FLUSH. As a result, this trans_handle
> > > > has no reserved in h->delayed_rsv, as neither the num_items reservation
> > > > nor the btrfs_delayed_refs_rsv_refill() reservation is run.
> > > >
> > > > Thus, when btrfs_update_delayed_refs_rsv() runs, reserved_bytes is 0 and
> > > > fs_info->delayed_rsv->size grows but not fs_info->delayed_rsv->reserved.
> > > >
> > > > If a large amount of writeback happens all at once (perhaps due to
> > > > dirty_ratio being tuned too high), this results in, among other things,
> > > > erroneous assessments of the amount of delayed_refs reserved in the
> > > > metadata space reclaim logic, like need_preemptive_reclaim() which
> > > > relies on fs_info->delayed_rsv->reserved and even worse, poor decision
> > > > making in btrfs_preempt_reclaim_metadata_space() which counts
> > > > delalloc_bytes like so:
> > > >
> > > >   block_rsv_size = global_rsv_size +
> > > >           btrfs_block_rsv_reserved(delayed_block_rsv) +
> > > >           btrfs_block_rsv_reserved(delayed_refs_rsv) +
> > > >           btrfs_block_rsv_reserved(trans_rsv);
> > > >   delalloc_size = bytes_may_use - block_rsv_size;
> > > >
> > > > So all that lost delayed refs usage gets accounted as delalloc_size and
> > > > leads to preemptive reclaim continuously choosing FLUSH_DELALLOC, which
> > > > further exacerbates the problem.
> > > >
> > > > With enough writeback around, we can run enough delalloc that we get
> > > > into async reclaim which starts blocking start_transaction() and
> > > > eventually hits FLUSH_DELALLOC_WAIT/FLUSH_DELALLOC_FULL at which point
> > > > the filesystem gets heavily blocked on metadata space in reserve_space(),
> > > > blocking all new transaction work until all the ordered_extents finish.
> > > >
> > > > If we had an accurate view of the reservation for delayed refs, then we
> > > > could mostly break this feedback loop in preemptive reclaim, and
> > > > generally would be able to make more accurate decisions with regards to
> > > > metadata space reclamation.
> > > >
> > > > This patch introduces the mechanism of a per-inode delayed_refs rsv
> > > > which is modeled closely after the same in trans_handle. The delalloc
> > > > reservation also reserves delayed refs and then finish_one_ordered
> > > > transfers the inode delayed_refs rsv into the trans_handle one, just
> > > > like inode->block_rsv.
> > > >
> > > > This is not a perfect fix for the most pathological cases, but is the
> > > > infrastructure needed to keep working on the problem.
> > > >
> > > > Signed-off-by: Boris Burkov <boris@bur.io>
> > > > ---
> > > >  fs/btrfs/btrfs_inode.h    |  3 +++
> > > >  fs/btrfs/delalloc-space.c | 34 ++++++++++++++++++++++++++++++----
> > > >  fs/btrfs/delayed-ref.c    |  2 +-
> > > >  fs/btrfs/inode.c          |  9 ++++++++-
> > > >  fs/btrfs/transaction.c    |  7 ++++---
> > > >  fs/btrfs/transaction.h    |  3 ++-
> > > >  6 files changed, 48 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > > > index 55c272fe5d92..dca4f6df7e95 100644
> > > > --- a/fs/btrfs/btrfs_inode.h
> > > > +++ b/fs/btrfs/btrfs_inode.h
> > > > @@ -328,6 +328,9 @@ struct btrfs_inode {
> > > >
> > > >         struct btrfs_block_rsv block_rsv;
> > > >
> > > > +       /* Reserve for delayed refs generated by ordered extent completion. */
> > > > +       struct btrfs_block_rsv delayed_rsv;
> > >
> > > Not that long ago we had an effort to decrease the btrfs_inode
> > > structure size down to less than 1024 bytes, so that we could have 4
> > > inodes per 4K page instead of 3, and this change now makes the
> > > structure larger than 1024 bytes again.
> >
> > Good catch, thanks. And sorry for missing it.
> >
> > >
> > > Instead of adding another block reserve to the inode we could:
> > >
> > > 1) Add the reservations for delayed refs in the existing block reserve
> > > (inode->block_rsv);
> > >
> > > 2) When finishing the ordered extent, after joining the transaction
> > > and setting trans->block to inode->block_rsv, we could migrate the
> > > space reserved for delayed refs from the inode->block_rsv into
> > > trans->delayed_rsv.
> >
> > At first blush, without trying very hard yet, I don't love this because I
> > think it means tracking or re-computing the delayed_refs portion of
> > inode->block_rsv for the migration.
> 
> Re-computing (calling btrfs_calc_delayed_ref_bytes()) is not
> expensive, and it's done in workqueue for finishing ordered extents.
> I wouldn't worry about that. But tracking it somewhere, implies
> increasing the structure size - if it stays under or at 1024 bytes,
> it's fine.
> 

I'm more concerned about the code being unclear and carrying latent
state in an overloaded block_rsv. Metadata reservations are complicated
enough as it is so I was really hoping to increase clarity with the
explicit block_rsv mirroring the design of trans_handle.

> > However, I'm sure I can make it work
> > and it's certainly worth doing to not regress the size of struct
> > btrfs_inode.
> >
> > What do you think of just allocating inode->delayed_rsv indirectly with
> > btrfs_alloc_block_rsv? We can save another ~100 bytes on struct
> > btrfs_inode.
> 
> Adding an allocation adds potential for -ENOMEM failures.
> And for 4K pages we will still be able to allocate 4 inodes per page,
> so no gains here.
> For a 64K page we can get a few more inodes (7 or 8).
> 
> >  And we could do it for inode->block_rsv to save yet more
> > space. Do you know if we have experience that it's really important for
> > inode->block_rsv to be embedded in struct btrfs_inode?
> 
> The reason we have it embedded it's because it saves a memory
> allocation, and it may also be faster and maybe better cache line
> spatial locality.

I understand the general tradeoffs.

I was asking if we know that it's specifically important or if it's a
general rule. There are other structs in btrfs_inode that are allocated
and other allocations that occur while populating and using btrfs_inode.
(delayed_node, extent_io_tree, path/search_slot, extent_changeset in
delalloc, etc.) So we could allocate the block_rsvs in a similar way
(when loading the inode, when doing delalloc for the first time, etc.)

But I understand that you don't want to risk regressions, so I can go
ahead and do it your way if you feel it's the best way to go.

> In the end we won't get any benefit unless the page size is > 4K so
> that we can get more inodes per page.
> 

Well there is a benefit of more of a buffer for future additions to the
struct.

Thanks,
Boris

> >
> > If that's a no-go, I will work on using just inode->block_rsv and doing
> > the migration.
> >
> > >
> > > This would not require increasing the btrfs_inode structure and
> > > neither add a _local_delayed_rsv field to the transaction handle (and
> > > btw, we don't use the _ prefix for any structure fields anywhere in
> > > btrfs).
> >
> > Noted, thanks.
> >
> > >
> > > Thanks.
> > >
> > >
> > > > +
> > > >         struct btrfs_delayed_node *delayed_node;
> > > >
> > > >         /* File creation time. */
> > > > diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> > > > index 0970799d0aa4..e2944ff4fe47 100644
> > > > --- a/fs/btrfs/delalloc-space.c
> > > > +++ b/fs/btrfs/delalloc-space.c
> > > > @@ -3,6 +3,7 @@
> > > >  #include "messages.h"
> > > >  #include "ctree.h"
> > > >  #include "delalloc-space.h"
> > > > +#include "delayed-ref.h"
> > > >  #include "block-rsv.h"
> > > >  #include "btrfs_inode.h"
> > > >  #include "space-info.h"
> > > > @@ -240,6 +241,13 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
> > > >         if (released > 0)
> > > >                 trace_btrfs_space_reservation(fs_info, "delalloc",
> > > >                                               btrfs_ino(inode), released, 0);
> > > > +
> > > > +       released = btrfs_block_rsv_release(fs_info, &inode->delayed_rsv,
> > > > +                                          0, NULL);
> > > > +       if (released > 0)
> > > > +               trace_btrfs_space_reservation(fs_info, "delalloc_delayed_refs",
> > > > +                                             btrfs_ino(inode), released, 0);
> > > > +
> > > >         if (qgroup_free)
> > > >                 btrfs_qgroup_free_meta_prealloc(inode->root, qgroup_to_release);
> > > >         else
> > > > @@ -251,7 +259,9 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
> > > >                                                  struct btrfs_inode *inode)
> > > >  {
> > > >         struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
> > > > +       struct btrfs_block_rsv *delayed_rsv = &inode->delayed_rsv;
> > > >         u64 reserve_size = 0;
> > > > +       u64 delayed_refs_size = 0;
> > > >         u64 qgroup_rsv_size = 0;
> > > >         unsigned outstanding_extents;
> > > >
> > > > @@ -266,6 +276,8 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
> > > >                 reserve_size = btrfs_calc_insert_metadata_size(fs_info,
> > > >                                                 outstanding_extents);
> > > >                 reserve_size += btrfs_calc_metadata_size(fs_info, 1);
> > > > +               delayed_refs_size += btrfs_calc_delayed_ref_bytes(fs_info,
> > > > +                                               outstanding_extents);
> > > >         }
> > > >         if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
> > > >                 u64 csum_leaves;
> > > > @@ -285,11 +297,17 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
> > > >         block_rsv->size = reserve_size;
> > > >         block_rsv->qgroup_rsv_size = qgroup_rsv_size;
> > > >         spin_unlock(&block_rsv->lock);
> > > > +
> > > > +       spin_lock(&delayed_rsv->lock);
> > > > +       delayed_rsv->size = delayed_refs_size;
> > > > +       spin_unlock(&delayed_rsv->lock);
> > > >  }
> > > >
> > > >  static void calc_inode_reservations(struct btrfs_inode *inode,
> > > >                                     u64 num_bytes, u64 disk_num_bytes,
> > > > -                                   u64 *meta_reserve, u64 *qgroup_reserve)
> > > > +                                   u64 *meta_reserve,
> > > > +                                   u64 *delayed_refs_reserve,
> > > > +                                   u64 *qgroup_reserve)
> > > >  {
> > > >         struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > > >         u64 nr_extents = count_max_extents(fs_info, num_bytes);
> > > > @@ -309,6 +327,10 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
> > > >          * for an inode update.
> > > >          */
> > > >         *meta_reserve += inode_update;
> > > > +
> > > > +       *delayed_refs_reserve = btrfs_calc_delayed_ref_bytes(fs_info,
> > > > +                                                            nr_extents);
> > > > +
> > > >         *qgroup_reserve = nr_extents * fs_info->nodesize;
> > > >  }
> > > >
> > > > @@ -318,7 +340,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
> > > >         struct btrfs_root *root = inode->root;
> > > >         struct btrfs_fs_info *fs_info = root->fs_info;
> > > >         struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
> > > > -       u64 meta_reserve, qgroup_reserve;
> > > > +       u64 meta_reserve, delayed_refs_reserve, qgroup_reserve;
> > > >         unsigned nr_extents;
> > > >         enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
> > > >         int ret = 0;
> > > > @@ -353,12 +375,14 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
> > > >          * over-reserve slightly, and clean up the mess when we are done.
> > > >          */
> > > >         calc_inode_reservations(inode, num_bytes, disk_num_bytes,
> > > > -                               &meta_reserve, &qgroup_reserve);
> > > > +                               &meta_reserve, &delayed_refs_reserve,
> > > > +                               &qgroup_reserve);
> > > >         ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_reserve, true,
> > > >                                                  noflush);
> > > >         if (ret)
> > > >                 return ret;
> > > > -       ret = btrfs_reserve_metadata_bytes(block_rsv->space_info, meta_reserve,
> > > > +       ret = btrfs_reserve_metadata_bytes(block_rsv->space_info,
> > > > +                                          meta_reserve + delayed_refs_reserve,
> > > >                                            flush);
> > > >         if (ret) {
> > > >                 btrfs_qgroup_free_meta_prealloc(root, qgroup_reserve);
> > > > @@ -383,6 +407,8 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
> > > >         btrfs_block_rsv_add_bytes(block_rsv, meta_reserve, false);
> > > >         trace_btrfs_space_reservation(root->fs_info, "delalloc",
> > > >                                       btrfs_ino(inode), meta_reserve, 1);
> > > > +       btrfs_block_rsv_add_bytes(&inode->delayed_rsv, delayed_refs_reserve,
> > > > +                                 false);
> > > >
> > > >         spin_lock(&block_rsv->lock);
> > > >         block_rsv->qgroup_rsv_reserved += qgroup_reserve;
> > > > diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> > > > index 605858c2d9a9..9fe9cec1bef3 100644
> > > > --- a/fs/btrfs/delayed-ref.c
> > > > +++ b/fs/btrfs/delayed-ref.c
> > > > @@ -89,7 +89,7 @@ void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans)
> > > >  {
> > > >         struct btrfs_fs_info *fs_info = trans->fs_info;
> > > >         struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_refs_rsv;
> > > > -       struct btrfs_block_rsv *local_rsv = &trans->delayed_rsv;
> > > > +       struct btrfs_block_rsv *local_rsv = trans->delayed_rsv;
> > > >         u64 num_bytes;
> > > >         u64 reserved_bytes;
> > > >
> > > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > > > index 1a4e6a9239ae..1f0f3282e4b8 100644
> > > > --- a/fs/btrfs/inode.c
> > > > +++ b/fs/btrfs/inode.c
> > > > @@ -653,6 +653,7 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode,
> > > >                 goto out;
> > > >         }
> > > >         trans->block_rsv = &inode->block_rsv;
> > > > +       trans->delayed_rsv = &inode->delayed_rsv;
> > > >
> > > >         drop_args.path = path;
> > > >         drop_args.start = 0;
> > > > @@ -3256,6 +3257,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
> > > >         }
> > > >
> > > >         trans->block_rsv = &inode->block_rsv;
> > > > +       trans->delayed_rsv = &inode->delayed_rsv;
> > > >
> > > >         ret = btrfs_insert_raid_extent(trans, ordered_extent);
> > > >         if (unlikely(ret)) {
> > > > @@ -8074,9 +8076,12 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
> > > >
> > > >         spin_lock_init(&ei->lock);
> > > >         ei->outstanding_extents = 0;
> > > > -       if (sb->s_magic != BTRFS_TEST_MAGIC)
> > > > +       if (sb->s_magic != BTRFS_TEST_MAGIC) {
> > > >                 btrfs_init_metadata_block_rsv(fs_info, &ei->block_rsv,
> > > >                                               BTRFS_BLOCK_RSV_DELALLOC);
> > > > +               btrfs_init_metadata_block_rsv(fs_info, &ei->delayed_rsv,
> > > > +                                             BTRFS_BLOCK_RSV_DELREFS);
> > > > +       }
> > > >         ei->runtime_flags = 0;
> > > >         ei->prop_compress = BTRFS_COMPRESS_NONE;
> > > >         ei->defrag_compress = BTRFS_COMPRESS_NONE;
> > > > @@ -8132,6 +8137,8 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
> > > >         WARN_ON(vfs_inode->i_data.nrpages);
> > > >         WARN_ON(inode->block_rsv.reserved);
> > > >         WARN_ON(inode->block_rsv.size);
> > > > +       WARN_ON(inode->delayed_rsv.reserved);
> > > > +       WARN_ON(inode->delayed_rsv.size);
> > > >         WARN_ON(inode->outstanding_extents);
> > > >         if (!S_ISDIR(vfs_inode->i_mode)) {
> > > >                 WARN_ON(inode->delalloc_bytes);
> > > > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > > > index 4358f4b63057..a55f8996cd59 100644
> > > > --- a/fs/btrfs/transaction.c
> > > > +++ b/fs/btrfs/transaction.c
> > > > @@ -737,7 +737,8 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
> > > >
> > > >         h->type = type;
> > > >         INIT_LIST_HEAD(&h->new_bgs);
> > > > -       btrfs_init_metadata_block_rsv(fs_info, &h->delayed_rsv, BTRFS_BLOCK_RSV_DELREFS);
> > > > +       h->delayed_rsv = &h->_local_delayed_rsv;
> > > > +       btrfs_init_metadata_block_rsv(fs_info, h->delayed_rsv, BTRFS_BLOCK_RSV_DELREFS);
> > > >
> > > >         smp_mb();
> > > >         if (cur_trans->state >= TRANS_STATE_COMMIT_START &&
> > > > @@ -758,7 +759,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
> > > >                                                       h->transid,
> > > >                                                       delayed_refs_bytes, 1);
> > > >                         h->delayed_refs_bytes_reserved = delayed_refs_bytes;
> > > > -                       btrfs_block_rsv_add_bytes(&h->delayed_rsv, delayed_refs_bytes, true);
> > > > +                       btrfs_block_rsv_add_bytes(h->delayed_rsv, delayed_refs_bytes, true);
> > > >                         delayed_refs_bytes = 0;
> > > >                 }
> > > >                 h->reloc_reserved = reloc_reserved;
> > > > @@ -1067,7 +1068,7 @@ static void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans)
> > > >         trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rsv",
> > > >                                       trans->transid,
> > > >                                       trans->delayed_refs_bytes_reserved, 0);
> > > > -       btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> > > > +       btrfs_block_rsv_release(fs_info, trans->delayed_rsv,
> > > >                                 trans->delayed_refs_bytes_reserved, NULL);
> > > >         trans->delayed_refs_bytes_reserved = 0;
> > > >  }
> > > > diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> > > > index 7d70fe486758..268a415c4f32 100644
> > > > --- a/fs/btrfs/transaction.h
> > > > +++ b/fs/btrfs/transaction.h
> > > > @@ -162,7 +162,8 @@ struct btrfs_trans_handle {
> > > >         bool in_fsync;
> > > >         struct btrfs_fs_info *fs_info;
> > > >         struct list_head new_bgs;
> > > > -       struct btrfs_block_rsv delayed_rsv;
> > > > +       struct btrfs_block_rsv *delayed_rsv;
> > > > +       struct btrfs_block_rsv _local_delayed_rsv;
> > > >         /* Extent buffers with writeback inhibited by this handle. */
> > > >         struct xarray writeback_inhibited_ebs;
> > > >  };
> > > > --
> > > > 2.53.0
> > > >
> > > >
