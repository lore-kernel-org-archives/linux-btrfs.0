From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [patch] Btrfs: fix bitwise vs logical condition
Date: Fri, 20 Jan 2012 18:00:50 +0200
Message-ID: <20120120160050.GA25145@zambezi.lan>
References: <20120120075454.GA2295@elgon.mountain>
 <20120120142437.GA2499@zambezi.lan>
 <20120120152129.GO3356@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120120152129.GO3356@mwanda>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 20, 2012 at 06:21:29PM +0300, Dan Carpenter wrote:
> On Fri, Jan 20, 2012 at 04:24:37PM +0200, Ilya Dryomov wrote:
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -2375,12 +2375,11 @@ static int should_balance_chunk(struct btrfs_root *root,
> >  	struct btrfs_balance_control *bctl = root->fs_info->balance_ctl;
> >  	struct btrfs_balance_args *bargs = NULL;
> >  	u64 chunk_type = btrfs_chunk_type(leaf, chunk);
> > +	u64 mask = chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK;
> >  
> >  	/* type filter */
> > -	if (!((chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK) &
> > -	      (bctl->flags & BTRFS_BALANCE_TYPE_MASK))) {
> > +	if (((bctl->flags & BTRFS_BALANCE_TYPE_MASK) & mask) != mask)
> 
> I don't know if it matters, but semantically this is not
> equivalent to the original.  If mask has no flags set then this will
> pass.  This says that every flag in mask but has to be set in
> ->flags but in the original code, only one needed to be.

Yeah, that's why I said "we can strengthen that check".

> 
> The original code was equivalent to:
> 	if (!(chunk_type & bctl->flags & BTRFS_BLOCK_GROUP_TYPE_MASK &
> 	      BTRFS_BALANCE_TYPE_MASK)) {...
> 
> It's weird that we have BTRFS_BLOCK_GROUP_TYPE_MASK and
> BTRFS_BALANCE_TYPE_MASK which are the same except that the bitfields
> have been renamed.  Can't we just reuse the first definition?
> 
> But really, if this isn't a bug, then I don't care.  The original is
> fine, or whatever you choose.

This is not a bug.

Thanks,

		Ilya

