Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762A2391828
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 17:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775497253; cv=none; b=myt1G7mDh7lIu6EPPUBvXkdN/hsOgy1w9Ylx2qohSq+IC4Y2CKXxnOQi++eLbp7Lb3TPLpCIDylW7OW9rpWMrPjKtJni9n6n7TCCAbBB1FaKs7NKGruPqPPgU2phVyO1DfCbvmSHH8P8WEaKY4+FLvzYAgW/wCIEY9mRJsa4++U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775497253; c=relaxed/simple;
	bh=N8UMe6zaMZ1mJZ5UUa9gejWg7ljeFWJ3/mR5bHx7/lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKkabkdecw9tZZyM5WP7jJjJAIL7Cfqogc5do+wAyh4m+nd5Wn7n+RAJB4KLs0S1TNfpbsfR8BLiz4FWcQagI9dQv+3zo5EA9ZfhrV7jTd0GxVtpKWnpdxTFJ4gliHRzFuee6KH3tjDi4KJlP56zEyDwOaE4CRTuI9rkvHncvII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=OJCMT601; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EbiL5MZA; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="OJCMT601";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EbiL5MZA"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id AC088EC00BD;
	Mon,  6 Apr 2026 13:40:50 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 06 Apr 2026 13:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1775497250;
	 x=1775583650; bh=MeCytMy8n9z0vT+CClJf4HxstgiommEgIwn6S6+mt6U=; b=
	OJCMT601HcP6+Pp8zzFyIboLfBOzpsK4YtinJwdMfXekFRVDoAPETGUP3buhw+fQ
	miUQgyANEKJgeXKZlMlZrYIKgb5VNyJPs/czOCl4j5qrS4CXz91PbxbGwpuYF56L
	RyfFrxBnSElBg8BuCmYh4/KoZ9g7VKF3qwz8RRrei9Nqq5C9cvx6Qz/PdbjSxvOy
	B7oKCidoM+VORGftnzCeziX5sYWy40/CQW/MCwCLyInIxHcTsstuRJg5ulMj8s4+
	P9S+cxUcZz9YpBZ7pp/XyPLjbCm1a31tFXczogw3HLZjr81mKQxbsWeLI61kykZO
	8/+0O+uCYU87QOZhx+BvEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775497250; x=
	1775583650; bh=MeCytMy8n9z0vT+CClJf4HxstgiommEgIwn6S6+mt6U=; b=E
	biL5MZAsepkQtH1sZy+yjiltEvuK0rj1280Z5tk6dAwa8kmFI4Qnbr+oEN53a/sd
	ZLwYQp3KM9S5LLwPaSvvvpFGh2ma9i78iZ+6edPTFhCJzKPIk+AY+O8E/niYFkFi
	fw6IXOKgL1FtUKMJRRPVZDjTXQUiFA5IVPvMS1tmukQ1qpPKslWWb1WQVtpoG9n3
	VxK6JFMFloslXrVrteqw0nNoO+dmqDg1nNUiCVEO8/HNSJoCZnVivoBOxQKLSjwC
	iOPMYz3M2Cvq8rFA5fLEea9eEWCDfKHtyaixe3W0+B08TweeXaGBBkfieq8UwU+w
	cMJZ50F/sqidtjnpCXSlg==
X-ME-Sender: <xms:IvDTaUrsx5nxamzzKIyNzovJ8-rsLhujFvYTKNKed3BPSQtr2KH0Gg>
    <xme:IvDTaSEPdMpeA_Z53LQDksYkJWJVMxSIzMJhPnPgX_M948Sla87qAK2PV576Kt_nz
    m-QybizXTYS-5wqDphPCFiMbtT9GJ18VavWWI27lAEdXAakZiFJ1ec>
X-ME-Received: <xmr:IvDTaWkf7D2g1_2311ZiUtvVYX-lltS2-1rnE4nyK4RLGefmtZcz0bLfSerav1t7qR8u3-86nMn_-0s7aijJfG0j7qU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddukeefiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpedule
    fhtdfhteduvdethfeftdeitdethedvtdekvdeltddvveegtdeuuddtiedtieenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepfhgumhgrnhgrnhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqd
    gsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghl
    qdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:IvDTaVk5WG0bleMXsRz2md5g_FbuoQt3zR2b6_zDD-FVn0ba64Poqg>
    <xmx:IvDTaXvcg0hgf718h74iK49UfGGxw9hJl4oU6H7CMP_6kapdi233GA>
    <xmx:IvDTaYnjME52Dayc6hlEy-A83yuX_CtdX-vcXsQ5GocpDVFzRf0JSw>
    <xmx:IvDTaSsBXTXIsQhqK3xVG8a_LWlP1TtsrT0jVWZ3JHD9cr8x43ZFng>
    <xmx:IvDTafGe4aHUuOPjEfgkBWdTV4lJ5PamGWg1JjsrJ0Iwqd-YU_9SwOmx>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Apr 2026 13:40:50 -0400 (EDT)
Date: Mon, 6 Apr 2026 10:40:42 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 1/5] btrfs: reserve space for delayed_refs in delalloc
Message-ID: <20260406174042.GA1817546@zen.localdomain>
References: <cover.1775255085.git.boris@bur.io>
 <0f736c6cf8027adb16d7c6c29443afb03ceaf24b.1775255085.git.boris@bur.io>
 <CAL3q7H6ru-f8GG-idhx5JySeRkr1i_WUvw3aixi+ws2sCDD=Zw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H6ru-f8GG-idhx5JySeRkr1i_WUvw3aixi+ws2sCDD=Zw@mail.gmail.com>

On Mon, Apr 06, 2026 at 06:20:39PM +0100, Filipe Manana wrote:
> On Fri, Apr 3, 2026 at 11:29 PM Boris Burkov <boris@bur.io> wrote:
> >
> > delalloc uses a per-inode block_rsv to perform metadata reservations for
> > the cow operations it anticipates based on the number of outstanding
> > extents. This calculation is done based on inode->outstanding_extents in
> > btrfs_calculate_inode_block_rsv_size(). The reservation is *not*
> > meticulously tracked as each ordered_extent is actually created in
> > writeback, but rather delalloc attempts to over-estimate and the
> > writeback and ordered_extent finish portions are responsible to release
> > all the reservation.
> >
> > However, there is a notable gap in this reservation, it reserves no
> > space for the resulting delayed_refs. If you compare to how
> > btrfs_start_transaction() reservations work, this is a noteable
> > difference.
> >
> > As writeback actually occurs, and we trigger btrfs_finish_one_ordered(),
> > that function will start generating delayed refs, which will draw from
> > the trans_handle's delayed_refs_rsv via btrfs_update_delayed_refs_rsv():
> >
> > btrfs_finish_one_ordered()
> >   insert_ordered_extent_file_extent()
> >     insert_reserved_file_extent()
> >       btrfs_alloc_reserved_file_extent()
> >         btrfs_add_delayed_data_ref()
> >           add_delayed_ref()
> >             btrfs_update_delayed_refs_rsv();
> >
> > This trans_handle was created in finish_one_ordered() with
> > btrfs_join_transaction() which calls start_transaction with
> > num_items=0 and BTRFS_RESERVE_NO_FLUSH. As a result, this trans_handle
> > has no reserved in h->delayed_rsv, as neither the num_items reservation
> > nor the btrfs_delayed_refs_rsv_refill() reservation is run.
> >
> > Thus, when btrfs_update_delayed_refs_rsv() runs, reserved_bytes is 0 and
> > fs_info->delayed_rsv->size grows but not fs_info->delayed_rsv->reserved.
> >
> > If a large amount of writeback happens all at once (perhaps due to
> > dirty_ratio being tuned too high), this results in, among other things,
> > erroneous assessments of the amount of delayed_refs reserved in the
> > metadata space reclaim logic, like need_preemptive_reclaim() which
> > relies on fs_info->delayed_rsv->reserved and even worse, poor decision
> > making in btrfs_preempt_reclaim_metadata_space() which counts
> > delalloc_bytes like so:
> >
> >   block_rsv_size = global_rsv_size +
> >           btrfs_block_rsv_reserved(delayed_block_rsv) +
> >           btrfs_block_rsv_reserved(delayed_refs_rsv) +
> >           btrfs_block_rsv_reserved(trans_rsv);
> >   delalloc_size = bytes_may_use - block_rsv_size;
> >
> > So all that lost delayed refs usage gets accounted as delalloc_size and
> > leads to preemptive reclaim continuously choosing FLUSH_DELALLOC, which
> > further exacerbates the problem.
> >
> > With enough writeback around, we can run enough delalloc that we get
> > into async reclaim which starts blocking start_transaction() and
> > eventually hits FLUSH_DELALLOC_WAIT/FLUSH_DELALLOC_FULL at which point
> > the filesystem gets heavily blocked on metadata space in reserve_space(),
> > blocking all new transaction work until all the ordered_extents finish.
> >
> > If we had an accurate view of the reservation for delayed refs, then we
> > could mostly break this feedback loop in preemptive reclaim, and
> > generally would be able to make more accurate decisions with regards to
> > metadata space reclamation.
> >
> > This patch adds extra metadata reservation to the inode's block_rsv to
> > account for the delayed refs. When the ordered_extent finishes and we
> > are about to do work in the transaction that uses delayed refs, we
> > migrate enough for 1 extent. Since this is not necessarily perfect, we
> > have to be careful and do a "soft" migrate which succeeds even if there
> > is not enough reservation. This is strictly better than what we have and
> > also matches how the delayed ref rsv gets used in the transaction at
> > btrfs_update_delayed_refs_rsv()
> >
> > This is not a perfect fix for the most pathological cases, but is the
> > infrastructure needed to keep working on the problem.
> >
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >  fs/btrfs/delalloc-space.c | 43 ++++++++++++++++++++++++++++++++++++---
> >  fs/btrfs/delalloc-space.h |  3 +++
> >  fs/btrfs/inode.c          |  5 ++++-
> >  fs/btrfs/transaction.c    | 36 ++++++++++++++------------------
> >  4 files changed, 62 insertions(+), 25 deletions(-)
> >
> > diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> > index 0970799d0aa4..a087be55409f 100644
> > --- a/fs/btrfs/delalloc-space.c
> > +++ b/fs/btrfs/delalloc-space.c
> > @@ -3,11 +3,13 @@
> >  #include "messages.h"
> >  #include "ctree.h"
> >  #include "delalloc-space.h"
> > +#include "delayed-ref.h"
> >  #include "block-rsv.h"
> >  #include "btrfs_inode.h"
> >  #include "space-info.h"
> >  #include "qgroup.h"
> >  #include "fs.h"
> > +#include "transaction.h"
> >
> >  /*
> >   * HOW DOES THIS WORK
> > @@ -240,6 +242,7 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
> >         if (released > 0)
> >                 trace_btrfs_space_reservation(fs_info, "delalloc",
> >                                               btrfs_ino(inode), released, 0);
> > +
> 
> Stray new line change. No other surrounding code changed.
> 
> >         if (qgroup_free)
> >                 btrfs_qgroup_free_meta_prealloc(inode->root, qgroup_to_release);
> >         else
> > @@ -247,6 +250,16 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
> >                                                    qgroup_to_release);
> >  }
> >
> > +/*
> > + * Each delalloc extent could become an ordered_extent and end up inserting a
> > + * new extent into the extent and free space trees. So we must reserve
> > + * delayed ref space up front for that.
> 
> Ok, so that's 2 delayed refs, one to modify the extent tree and
> another to modify the free space tree.
> So below, techically we should account for nr_extents * 2.
> 
> And we actually need to modify more trees: the csum tree if we have
> csums to insert and the new raid stripe tree.
> 
> > + */
> > +static u64 delalloc_calc_delayed_refs_rsv(const struct btrfs_fs_info *fs_info, u64 nr_extents)
> > +{
> > +       return btrfs_calc_delayed_ref_bytes(fs_info, nr_extents);
> > +}
> > +
> >  static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
> >                                                  struct btrfs_inode *inode)
> >  {
> > @@ -266,6 +279,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
> >                 reserve_size = btrfs_calc_insert_metadata_size(fs_info,
> >                                                 outstanding_extents);
> >                 reserve_size += btrfs_calc_metadata_size(fs_info, 1);
> > +               reserve_size += delalloc_calc_delayed_refs_rsv(fs_info, outstanding_extents);
> >         }
> >         if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
> >                 u64 csum_leaves;
> > @@ -289,7 +303,8 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
> >
> >  static void calc_inode_reservations(struct btrfs_inode *inode,
> >                                     u64 num_bytes, u64 disk_num_bytes,
> > -                                   u64 *meta_reserve, u64 *qgroup_reserve)
> > +                                   u64 *meta_reserve,
> > +                                   u64 *qgroup_reserve)
> 
> Another style change only, without any functional changes.
> 
> >  {
> >         struct btrfs_fs_info *fs_info = inode->root->fs_info;
> >         u64 nr_extents = count_max_extents(fs_info, num_bytes);
> > @@ -309,9 +324,31 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
> >          * for an inode update.
> >          */
> >         *meta_reserve += inode_update;
> > +
> > +       *meta_reserve += delalloc_calc_delayed_refs_rsv(fs_info, nr_extents);
> > +
> >         *qgroup_reserve = nr_extents * fs_info->nodesize;
> >  }
> >
> > +u64 btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *trans,
> > +                                           struct btrfs_inode *inode)
> > +{
> > +       struct btrfs_block_rsv *inode_rsv = &inode->block_rsv;
> > +       struct btrfs_block_rsv *trans_rsv = &trans->delayed_rsv;
> > +       u64 num_bytes = delalloc_calc_delayed_refs_rsv(trans->fs_info, 1);
> > +
> > +       spin_lock(&inode_rsv->lock);
> > +       num_bytes = min(num_bytes, inode_rsv->reserved);
> > +       inode_rsv->reserved -= num_bytes;
> > +       inode_rsv->full = (inode_rsv->reserved >= inode_rsv->size);
> > +       spin_unlock(&inode_rsv->lock);
> > +
> > +       btrfs_block_rsv_add_bytes(trans_rsv, num_bytes, true);
> > +       trans->delayed_refs_bytes_reserved += num_bytes;
> > +
> > +       return num_bytes;
> 
> Why return the number of bytes?
> None of the callers cares about the return value, it can be just void.
> 
> > +}
> > +
> >  int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
> >                                     u64 disk_num_bytes, bool noflush)
> >  {
> > @@ -358,8 +395,8 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
> >                                                  noflush);
> >         if (ret)
> >                 return ret;
> > -       ret = btrfs_reserve_metadata_bytes(block_rsv->space_info, meta_reserve,
> > -                                          flush);
> > +       ret = btrfs_reserve_metadata_bytes(block_rsv->space_info,
> > +                                          meta_reserve, flush);
> 
> Yet another style change, without any surrounding functional changes.
> 
> >         if (ret) {
> >                 btrfs_qgroup_free_meta_prealloc(root, qgroup_reserve);
> >                 return ret;
> > diff --git a/fs/btrfs/delalloc-space.h b/fs/btrfs/delalloc-space.h
> > index 6119c0d3f883..b058e884879b 100644
> > --- a/fs/btrfs/delalloc-space.h
> > +++ b/fs/btrfs/delalloc-space.h
> > @@ -8,6 +8,7 @@
> >  struct extent_changeset;
> >  struct btrfs_inode;
> >  struct btrfs_fs_info;
> > +struct btrfs_trans_handle;
> >
> >  int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64 bytes);
> >  int btrfs_check_data_free_space(struct btrfs_inode *inode,
> > @@ -27,5 +28,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
> >                                     u64 disk_num_bytes, bool noflush);
> >  void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes);
> >  void btrfs_delalloc_shrink_extents(struct btrfs_inode *inode, u64 reserved_len, u64 new_len);
> > +u64 btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *trans,
> > +                                           struct btrfs_inode *inode);
> >
> >  #endif /* BTRFS_DELALLOC_SPACE_H */
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 808e52aa6ef2..c57473030814 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -653,6 +653,7 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode,
> >                 goto out;
> >         }
> >         trans->block_rsv = &inode->block_rsv;
> > +       btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
> >
> >         drop_args.path = path;
> >         drop_args.start = 0;
> > @@ -3297,6 +3298,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
> >                 }
> >         } else {
> >                 BUG_ON(root == fs_info->tree_root);
> > +               btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
> 
> So for the other case, writing into a prealloc extent, we should also
> migrate space space because we will update the fs tree to modify a
> file extent item (the call to btrfs_mark_extent_written()) and that
> can generate delayed refs if we need to COW blocks from the fs tree
> for that.
> 
> >                 ret = insert_ordered_extent_file_extent(trans, ordered_extent);
> >                 if (unlikely(ret < 0)) {
> >                         btrfs_abort_transaction(trans, ret);
> > @@ -8074,9 +8076,10 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
> >
> >         spin_lock_init(&ei->lock);
> >         ei->outstanding_extents = 0;
> > -       if (sb->s_magic != BTRFS_TEST_MAGIC)
> > +       if (sb->s_magic != BTRFS_TEST_MAGIC) {
> >                 btrfs_init_metadata_block_rsv(fs_info, &ei->block_rsv,
> >                                               BTRFS_BLOCK_RSV_DELALLOC);
> > +       }
> 
> Another style change and this one goes against our style preference -
> no { } for single statement if.
> 
> This is just a quick pass over the change, I'll look into the
> following patches soon.
> 

Sorry for the leaked style changes. Those were places I modified in the
first try using a new block_rsv and I didn't properly undo them while
changing it to the new migration design. I should have double checked
the full patch output for silly stuff like that.

Thanks for the review,
Boris

> >         ei->runtime_flags = 0;
> >         ei->prop_compress = BTRFS_COMPRESS_NONE;
> >         ei->defrag_compress = BTRFS_COMPRESS_NONE;
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 248adb785051..55791bb100a2 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -1047,29 +1047,23 @@ static void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans)
> >                 return;
> >         }
> >
> > -       if (!trans->bytes_reserved) {
> > -               ASSERT(trans->delayed_refs_bytes_reserved == 0,
> > -                      "trans->delayed_refs_bytes_reserved=%llu",
> > -                      trans->delayed_refs_bytes_reserved);
> > -               return;
> > +       if (trans->bytes_reserved) {
> > +               ASSERT(trans->block_rsv == &fs_info->trans_block_rsv);
> > +               trace_btrfs_space_reservation(fs_info, "transaction",
> > +                                       trans->transid, trans->bytes_reserved, 0);
> > +               btrfs_block_rsv_release(fs_info, trans->block_rsv,
> > +                                       trans->bytes_reserved, NULL);
> > +               trans->bytes_reserved = 0;
> >         }
> >
> > -       ASSERT(trans->block_rsv == &fs_info->trans_block_rsv);
> > -       trace_btrfs_space_reservation(fs_info, "transaction",
> > -                                     trans->transid, trans->bytes_reserved, 0);
> > -       btrfs_block_rsv_release(fs_info, trans->block_rsv,
> > -                               trans->bytes_reserved, NULL);
> > -       trans->bytes_reserved = 0;
> > -
> > -       if (!trans->delayed_refs_bytes_reserved)
> > -               return;
> > -
> > -       trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rsv",
> > -                                     trans->transid,
> > -                                     trans->delayed_refs_bytes_reserved, 0);
> > -       btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> > -                               trans->delayed_refs_bytes_reserved, NULL);
> > -       trans->delayed_refs_bytes_reserved = 0;
> > +       if (trans->delayed_refs_bytes_reserved) {
> > +               trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rsv",
> > +                                       trans->transid,
> > +                                       trans->delayed_refs_bytes_reserved, 0);
> > +               btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> > +                                       trans->delayed_refs_bytes_reserved, NULL);
> > +               trans->delayed_refs_bytes_reserved = 0;
> > +       }
> >  }
> >
> >  static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
> > --
> > 2.53.0
> >
> >
