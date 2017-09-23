Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30894 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdIWAx0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 20:53:26 -0400
Date: Fri, 22 Sep 2017 17:49:39 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use btrfs_op instead of bio_op in
 __btrfs_map_block
Message-ID: <20170923004938.GE8109@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170919235009.30720-1-bo.li.liu@oracle.com>
 <87d16i5jdp.wl-satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87d16i5jdp.wl-satoru.takeuchi@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 23, 2017 at 09:49:38AM +0900, Satoru Takeuchi wrote:
> At Tue, 19 Sep 2017 17:50:09 -0600,
> Liu Bo wrote:
> > 
> > This seems to be a leftover of commit cf8cddd38bab ("btrfs: don't
> > abuse REQ_OP_* flags for btrfs_map_block").
> > 
> > It should use btrfs_op() helper to provide one of 'enum btrfs_map_op'
> > types.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Reviewed-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> 
> I checked all callers of the following functions and there is no leftover.
> 
> - btrfs_map_block
> - btrfs_map_sblock
> - __btrfs_map_block

I did check them, but thanks a lot for double checking.

thanks,
-liubo

> 
> Thanks,
> Satoru
> 
> > ---
> >  fs/btrfs/volumes.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index bd679bc..bd7b75d3 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -6229,7 +6229,7 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
> >  	map_length = length;
> >  
> >  	btrfs_bio_counter_inc_blocked(fs_info);
> > -	ret = __btrfs_map_block(fs_info, bio_op(bio), logical,
> > +	ret = __btrfs_map_block(fs_info, btrfs_op(bio), logical,
> >  				&map_length, &bbio, mirror_num, 1);
> >  	if (ret) {
> >  		btrfs_bio_counter_dec(fs_info);
> > -- 
> > 2.9.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
