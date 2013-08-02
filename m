Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42907 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab3HBIRO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Aug 2013 04:17:14 -0400
Date: Fri, 2 Aug 2013 16:17:02 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allow compressed extents to be merged during
 defragment
Message-ID: <20130802081701.GF24158@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1375426194-28121-1-git-send-email-bo.li.liu@oracle.com>
 <51FB69A4.6040708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51FB69A4.6040708@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 02, 2013 at 04:11:16PM +0800, Miao Xie wrote:
> On fri, 2 Aug 2013 14:49:54 +0800, Liu Bo wrote:
> > The rule originally comes from nocow writing, but snapshot-aware
> > defrag is a different case, the extent has been writen and we're
> > not going to change the extent but add a reference on the data.
> > 
> > So we're able to allow such compressed extents to be merged into
> > one bigger extent if they're pointing to the same data.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/inode.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 55dda87..a7aeecc 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -2229,7 +2229,7 @@ static noinline bool record_extent_backrefs(struct btrfs_path *path,
> >  
> >  static int relink_is_mergable(struct extent_buffer *leaf,
> >  			      struct btrfs_file_extent_item *fi,
> > -			      u64 disk_bytenr)
> > +			      u64 disk_bytenr, u8 compress)
> >  {
> >  	if (btrfs_file_extent_disk_bytenr(leaf, fi) != disk_bytenr)
> >  		return 0;
> > @@ -2237,8 +2237,10 @@ static int relink_is_mergable(struct extent_buffer *leaf,
> >  	if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG)
> >  		return 0;
> >  
> > -	if (btrfs_file_extent_compression(leaf, fi) ||
> > -	    btrfs_file_extent_encryption(leaf, fi) ||
> > +	if (btrfs_file_extent_compression(leaf, fi) != compress)
> > +		return 0;
> > +
> > +	if (btrfs_file_extent_encryption(leaf, fi) ||
> >  	    btrfs_file_extent_other_encoding(leaf, fi))
> >  		return 0;
> >  
> > @@ -2382,8 +2384,9 @@ again:
> >  				    struct btrfs_file_extent_item);
> >  		extent_len = btrfs_file_extent_num_bytes(leaf, fi);
> >  
> > -		if (relink_is_mergable(leaf, fi, new->bytenr) &&
> > -		    extent_len + found_key.offset == start) {
> > +		if (extent_len + found_key.offset == start &&
> > +		    relink_is_mergable(leaf, fi, new->bytenr,
> > +				       new->compress_type)) {
> 
> There is a petty comment: Why not pass "new" to relink_is_mergable() directly?

I was thinking that there're only two args here, but the idea is nice,
I'll adopt it in v2, thanks,

-liubo

> 
> The other code is OK.
> 
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> 
> >  			btrfs_set_file_extent_num_bytes(leaf, fi,
> >  							extent_len + len);
> >  			btrfs_mark_buffer_dirty(leaf);
> > 
> 
