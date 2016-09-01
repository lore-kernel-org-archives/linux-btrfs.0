Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28582 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754393AbcIAAsp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 20:48:45 -0400
Date: Wed, 31 Aug 2016 17:54:07 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix endless loop in balancing block groups
Message-ID: <20160901005407.GA6076@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1472687013-463-1-git-send-email-bo.li.liu@oracle.com>
 <1c3b14d3-dd15-238f-8378-a10bdcba394d@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1c3b14d3-dd15-238f-8378-a10bdcba394d@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 01, 2016 at 08:32:00AM +0800, Qu Wenruo wrote:
> 
> 
> At 09/01/2016 07:43 AM, Liu Bo wrote:
> > Qgroup function may overwrite the saved error 'err' with 0
> > in case quota is not enabled, and this ends up with a
> > endless loop in balance because we keep going back to balance
> > the same block group.
> 
> In which case?
> 
> If join_trans() fails, we won't go through qgroup fix.
> And before join_trans(), they all go to out_free/out tag.
> Nothing to do with qgroup fix.

I don't think so.

It doesn't always go to out_free, in the while() loop, it'd break the
loop on any error and record it in @err, then go through
prepare_to_merge() + merge_reloc_roots() and other stuff.

Here's an example for keeping err after the above while loop(),
...
err = prepare_to_merge(rc, err);
...

Thanks,

-liubo

> 
> And if we hit qgroup_fix_relocated_data_extents(), then 'err' is alreayd 0,
> nothing we need to save.
> 
> And even for quota disabled case, qgroup_fix_relocated_data_extents() will
> just return 0. Nothing wrong at all.
> 
> Or did I miss something?
> 
> Thanks,
> Qu
> > 
> > It really should use 'ret' instead.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/relocation.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> > index 8a2c2a0..c0c13dc 100644
> > --- a/fs/btrfs/relocation.c
> > +++ b/fs/btrfs/relocation.c
> > @@ -4200,9 +4200,11 @@ restart:
> >  		err = PTR_ERR(trans);
> >  		goto out_free;
> >  	}
> > -	err = qgroup_fix_relocated_data_extents(trans, rc);
> > -	if (err < 0) {
> > -		btrfs_abort_transaction(trans, err);
> > +	ret = qgroup_fix_relocated_data_extents(trans, rc);
> > +	if (ret < 0) {
> > +		btrfs_abort_transaction(trans, ret);
> > +		if (!err)
> > +			err = ret;
> >  		goto out_free;
> >  	}
> >  	btrfs_commit_transaction(trans, rc->extent_root);
> > 
> 
> 
