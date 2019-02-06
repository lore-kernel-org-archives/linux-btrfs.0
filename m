Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780B7C169C4
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 18:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50E7220823
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 18:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfBFSVD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 13:21:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:52490 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727129AbfBFSVD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Feb 2019 13:21:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 47312B6F4;
        Wed,  6 Feb 2019 18:21:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4C674DA823; Wed,  6 Feb 2019 19:20:21 +0100 (CET)
Date:   Wed, 6 Feb 2019 19:20:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 6/8] btrfs: loop in inode_rsv_refill
Message-ID: <20190206182020.GF2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20181203152459.21630-1-josef@toxicpanda.com>
 <20181203152459.21630-7-josef@toxicpanda.com>
 <6a7a6a50-9a58-032e-e62a-c551b257b0ac@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a7a6a50-9a58-032e-e62a-c551b257b0ac@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 12, 2018 at 06:01:57PM +0200, Nikolay Borisov wrote:
> 
> 
> On 3.12.18 г. 17:24 ч., Josef Bacik wrote:
> > With severe fragmentation we can end up with our inode rsv size being
> > huge during writeout, which would cause us to need to make very large
> > metadata reservations.  However we may not actually need that much once
> 
> The sentence beginning with "However" needs more information, why might
> we not need that much once writeout is complete?

Updated in changelog

> > writeout is complete.  So instead try to make our reservation, and if we
> > couldn't make it re-calculate our new reservation size and try again.
> 
> Why do you think that recalculating the requested bytes will be
> different the 2nd time ?

Partly answered in the comment in the code

> 
> > If our reservation size doesn't change between tries then we know we are
> > actually out of space and can error out.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/extent-tree.c | 58 +++++++++++++++++++++++++++++++++++++-------------
> >  1 file changed, 43 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 0ee77a98f867..0e1a499035ac 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -5787,6 +5787,21 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
> >  	return ret;
> >  }
> >  
> > +static inline void __get_refill_bytes(struct btrfs_block_rsv *block_rsv,
> > +				      u64 *metadata_bytes, u64 *qgroup_bytes)
> 
> This function needs a better name. Something like calc_required_bytes or
> calc_refill_bytes

renamed to calc_refill_bytes

> 
> > +{
> > +	*metadata_bytes = 0;
> > +	*qgroup_bytes = 0;
> > +
> > +	spin_lock(&block_rsv->lock);
> > +	if (block_rsv->reserved < block_rsv->size)
> > +		*metadata_bytes = block_rsv->size - block_rsv->reserved;
> > +	if (block_rsv->qgroup_rsv_reserved < block_rsv->qgroup_rsv_size)
> > +		*qgroup_bytes = block_rsv->qgroup_rsv_size -
> > +			block_rsv->qgroup_rsv_reserved;
> > +	spin_unlock(&block_rsv->lock);
> > +}
> > +
> >  /**
> >   * btrfs_inode_rsv_refill - refill the inode block rsv.
> >   * @inode - the inode we are refilling.
> > @@ -5802,25 +5817,39 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
> >  {
> >  	struct btrfs_root *root = inode->root;
> >  	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
> > -	u64 num_bytes = 0;
> > +	u64 num_bytes = 0, last = 0;
> >  	u64 qgroup_num_bytes = 0;
> >  	int ret = -ENOSPC;
> >  
> > -	spin_lock(&block_rsv->lock);
> > -	if (block_rsv->reserved < block_rsv->size)
> > -		num_bytes = block_rsv->size - block_rsv->reserved;
> > -	if (block_rsv->qgroup_rsv_reserved < block_rsv->qgroup_rsv_size)
> > -		qgroup_num_bytes = block_rsv->qgroup_rsv_size -
> > -				   block_rsv->qgroup_rsv_reserved;
> > -	spin_unlock(&block_rsv->lock);
> > -
> > +	__get_refill_bytes(block_rsv, &num_bytes, &qgroup_num_bytes);
> >  	if (num_bytes == 0)
> >  		return 0;
> >  
> > -	ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_num_bytes, true);
> > -	if (ret)
> > -		return ret;
> > -	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
> > +	do {
> > +		ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_num_bytes, true);
> > +		if (ret)
> > +			return ret;
> > +		ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
> > +		if (ret) {
> > +			btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
> > +			last = num_bytes;
> > +			/*
> > +			 * If we are fragmented we can end up with a lot of
> > +			 * outstanding extents which will make our size be much
> > +			 * larger than our reserved amount.  If we happen to
> > +			 * try to do a reservation here that may result in us
> > +			 * trying to do a pretty hefty reservation, which we may
> > +			 * not need once delalloc flushing happens.  If this is
> 
> The "If we happen" sentence needs to be reworded because it's -ENOPARSE.
> Perhaps one of the "to do a reservation" should go away?

Reworded
