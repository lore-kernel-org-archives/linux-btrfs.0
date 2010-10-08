From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/18] fs: rework icount to be a locked variable
Date: Fri, 8 Oct 2010 18:50:01 +1100
Message-ID: <20101008075001.GT4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-10-git-send-email-david@fromorbit.com>
 <20101008072749.GB7831@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101008072749.GB7831@lst.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 08, 2010 at 03:27:49AM -0400, Christoph Hellwig wrote:
> > index 2953e9f..9f04478 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -1964,8 +1964,14 @@ void btrfs_add_delayed_iput(struct inode *inode)
> >  	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
> >  	struct delayed_iput *delayed;
> >  
> > -	if (atomic_add_unless(&inode->i_count, -1, 1))
> > +	/* XXX: filesystems should not play refcount games like this */
> > +	spin_lock(&inode->i_lock);
> > +	if (inode->i_ref > 1) {
> > +		inode->i_ref--;
> > +		spin_unlock(&inode->i_lock);
> >  		return;
> > +	}
> > +	spin_unlock(&inode->i_lock);
> 
> Yeah, all that i_count/i_ref mess in btrfs needs some serious work.
> Chris?
> 
> > +
> > +/*
> > + * inode_lock must be held
> > + */
> > +void iref_locked(struct inode *inode)
> > +{
> > +	inode->i_ref++;
> > +}
> >  EXPORT_SYMBOL_GPL(iref_locked);
> 
> I'm a big fan of _GPL exports, but adding this for a trivial counter
> increment seems a bit weird. 

OK, will drop the _GPL.
> 
> >  int iref_read(struct inode *inode)
> >  {
> > -	return atomic_read(&inode->i_count);
> > +	int ref;
> > +
> > +	spin_lock(&inode->i_lock);
> > +	ref = inode->i_ref;
> > +	spin_unlock(&inode->i_lock);
> > +	return ref;
> >  }
> 
> There's no need to lock a normal 32-bit variable for readers.

Ok, but will need a memory barrier instead?

> 
> > +		inode->i_ref--;
> > +		if (inode->i_ref == 0) {
> 
> 		if (--inode->i_ref == 0) {
> 
> might be a bit more idiomatic.

OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
