Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbcD0XGH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 19:06:07 -0400
Date: Thu, 28 Apr 2016 01:05:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: remove BUG_ON()'s in btrfs_map_block
Message-ID: <20160427230553.GR29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460480080-27063-1-git-send-email-jbacik@fb.com>
 <570EFD84.90104@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <570EFD84.90104@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 14, 2016 at 10:16:36AM +0800, Anand Jain wrote:
> > -	BUG_ON(offset < stripe_offset);
> > +	if (offset < stripe_offset) {
> > +		btrfs_crit(fs_info, "stripe math has gone wrong, "
> > +			   "stripe_offset=%llu, offset=%llu, start=%llu, "
> 
> 
> > +			   "logical=%llu, stripe_len=%llu\n",
> 
>   btrfs_crit adds \n suffix by its own.

Right,

> 
> > +			   (unsigned long long)stripe_offset,
> > +			   (unsigned long long)offset,
> > +			   (unsigned long long)em->start,
> > +			   (unsigned long long)logical,
> > +			   (unsigned long long)stripe_len);

and we don't have to cast u64 to ULL anymore.

> > +		free_extent_map(em);
> > +		return -EINVAL;
> > +	}
> >
> >   	/* stripe_offset is the offset of this block in its stripe*/
> >   	stripe_offset = offset - stripe_offset;
> > @@ -5519,7 +5530,14 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
> >   				&stripe_index);
> >   		mirror_num = stripe_index + 1;
> >   	}
> > -	BUG_ON(stripe_index >= map->num_stripes);
> > +	if (stripe_index >= map->num_stripes) {
> > +		btrfs_crit(fs_info, "stripe index math went horribly wrong, "
> 
> > +			   "got stripe_index=%lu, num_stripes=%lu\n",
> 
>   -same-
> 
> Thanks, Anand
> 
> > +			   (unsigned long)stripe_index,
> > +			   (unsigned long)map->num_stripes);

typecasts dropped and format string updated.

Fixed and added to for-next.
