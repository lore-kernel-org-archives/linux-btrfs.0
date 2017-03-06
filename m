Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36209 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753658AbdCFTvP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 14:51:15 -0500
Date: Mon, 6 Mar 2017 11:49:22 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 2/7] Btrfs: separate DISCARD from __btrfs_map_block
Message-ID: <20170306194922.GC13180@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
 <1487381301-865-3-git-send-email-bo.li.liu@oracle.com>
 <1f27d01e-0599-5153-6c15-1eaef243838d@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1f27d01e-0599-5153-6c15-1eaef243838d@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 20, 2017 at 11:54:31AM +0800, Qu Wenruo wrote:
> 
> 
> At 02/18/2017 09:28 AM, Liu Bo wrote:
> > Since DISCARD is not as important as an operation like write, we don't
> > copy it to target device during replace, and it makes __btrfs_map_block
> > less complex.
> 
> Makes sense to me.
> 
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/volumes.c | 306 +++++++++++++++++++++++++++++++++--------------------
> >  1 file changed, 192 insertions(+), 114 deletions(-)
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index c52b0fe..96228f3 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -5294,6 +5294,175 @@ void btrfs_put_bbio(struct btrfs_bio *bbio)
> >  		kfree(bbio);
> >  }
> > 
> > +/* can REQ_OP_DISCARD be sent with other REQ like REQ_OP_WRITE? */
> > +/*
> > + * Please note that, discard won't be sent to target device of device
> > + * replace.
> > + */
> > +static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
> > +					 u64 logical, u64 length,
> > +					 struct btrfs_bio **bbio_ret)
> > +{
> > +	struct extent_map_tree *em_tree = &fs_info->mapping_tree.map_tree;
> > +	struct extent_map *em;
> > +	struct map_lookup *map;
> > +	struct btrfs_bio *bbio;
> > +	u64 offset;
> > +	u64 stripe_nr;
> > +	u64 stripe_nr_end;
> > +	u64 stripe_end_offset;
> > +	u64 stripe_cnt;
> > +	u64 stripe_len;
> > +	u64 stripe_offset;
> > +	u64 num_stripes;
> > +	u32 stripe_index;
> > +	u32 factor = 0;
> > +	u32 sub_stripes = 0;
> > +	u64 stripes_per_dev = 0;
> > +	u32 remaining_stripes = 0;
> > +	u32 last_stripe = 0;
> > +	int ret = 0;
> > +	int i;
> > +
> > +	/* discard always return a bbio */
> > +	ASSERT(bbio_ret);
> > +
> > +	read_lock(&em_tree->lock);
> > +	em = lookup_extent_mapping(em_tree, logical, length);
> > +	read_unlock(&em_tree->lock);
> 
> It seems that get_chunk_map() in previous patch can replace such searching
> and error message.
>

Yeah, I forgot to update with it.

> > +
> > +	if (!em) {
> > +		btrfs_crit(fs_info, "unable to find logical %llu len %llu",
> > +			logical, length);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (em->start > logical || em->start + em->len < logical) {
> > +		btrfs_crit(fs_info,
> > +			   "found a bad mapping, wanted %Lu, found %Lu-%Lu",
> > +			   logical, em->start, em->start + em->len);
> > +		free_extent_map(em);
> > +		return -EINVAL;
> > +	}
> > +
> > +	map = em->map_lookup;
> > +	/* we don't discard raid56 yet */
> > +	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	offset = logical - em->start;
> > +	length = min_t(u64, em->len - offset, length);
> > +
> > +	stripe_len = map->stripe_len;
> > +	/*
> > +	 * stripe_nr counts the total number of stripes we have to stride
> > +	 * to get to this block
> > +	 */
> > +	stripe_nr = div64_u64(offset, stripe_len);
> > +	stripe_offset = stripe_nr * stripe_len;
> > +	ASSERT(offset >= stripe_offset);
> 
> What about a DIV_ROUND_DOWN helper?
> Surprisingly we only have DIR_ROUND_UP, not not DIV_ROUND_DOWN.
> 
> And if we're only going to support 64K stripe len, then round_down() is good
> for current usage.
> 
> > +
> > +	/* stripe_offset is the offset of this block in its stripe */
> > +	stripe_offset = offset - stripe_offset;
> 
> This is a little confusing.
> What about using another variable called @stripe_start instead of using the
> same variable @stripe_offset to temporarily store stripe start bytenr.
> 
> I prefer to do it in one run without resuing @stripe_offset variable to
> avoid confusion.

Right, I was trying to keep the check of (offset >= stripe_offset), but it's not
necessary.

> 
> > +
> > +	stripe_nr_end = ALIGN(offset + length, map->stripe_len);
> 
> round_up() causes less confusion.
> 
> And IIRC, ALIGN/round_up can only handle power of 2, this implies the
> stripe_len must be power of 2, which is OK for now.
> If using ALIGN here, we can also use round_down() in previous stripe_nr.
>

Good point.

Thanks,

-liubo
