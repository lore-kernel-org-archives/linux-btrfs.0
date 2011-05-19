From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2] fs: add a DCACHE_NEED_LOOKUP flag for d_flags
Date: Thu, 19 May 2011 15:43:51 -0400
Message-ID: <20110519194350.GE18123@dhcp231-156.rdu.redhat.com>
References: <1305827929-18491-1-git-send-email-josef@redhat.com> <C0F9F322-F0EF-424D-A92A-9B9DF7644783@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk, hch@lst.de
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <C0F9F322-F0EF-424D-A92A-9B9DF7644783@dilger.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 19, 2011 at 01:03:18PM -0600, Andreas Dilger wrote:
> On May 19, 2011, at 11:58, Josef Bacik wrote:
> > Btrfs (and I'd venture most other fs's) stores its indexes in nice disk order
> > for readdir, but unfortunately in the case of anything that stats the files in
> > order that readdir spits back (like oh say ls) that means we still have to do
> > the normal lookup of the file, which means looking up our other index and then
> > looking up the inode.  What I want is a way to create dummy dentries when we
> > find them in readdir so that when ls or anything else subsequently does a
> > stat(), we already have the location information in the dentry and can go
> > straight to the inode itself.  The lookup stuff just assumes that if it finds a
> > dentry it is done, it doesn't perform a lookup.  So add a DCACHE_NEED_LOOKUP
> > flag so that the lookup code knows it still needs to run i_op->lookup() on the
> > parent to get the inode for the dentry.  I have tested this with btrfs and I
> > went from something that looks like this
> > 
> > http://people.redhat.com/jwhiter/ls-noreada.png
> > 
> > To this
> > 
> > http://people.redhat.com/jwhiter/ls-good.png
> > 
> > Thats a savings of 1300 seconds, or 22 minutes.  That is a significant savings.
> > Thanks,
> 
> This comment should probably mention the number of files being tested, in order
> to make a 1300s savings meaningful.  Similarly, it would be better to provide
> the absolute times of tests in case these URLs disappear in the future.
> 
> "That reduces the time to do "ls -l" on a 1M file directory from 2181s to 855s."
> 

Good point, I will include that in my next posting.

> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> > fs/namei.c             |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
> > include/linux/dcache.h |    1 +
> > 2 files changed, 49 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/namei.c b/fs/namei.c
> > index e3c4f11..a1bff4f 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -1198,6 +1198,29 @@ static struct dentry *d_alloc_and_lookup(struct dentry *parent,
> > }
> > 
> > /*
> > + * We already have a dentry, but require a lookup to be performed on the parent
> > + * directory to fill in d_inode. Returns the new dentry, or ERR_PTR on error.
> > + * parent->d_inode->i_mutex must be held. d_lookup must have verified that no
> > + * child exists while under i_mutex.
> > + */
> > +static struct dentry *d_inode_lookup(struct dentry *parent, struct dentry *dentry,
> > +				     struct nameidata *nd)
> > +{
> > +	struct inode *inode = parent->d_inode;
> > +	struct dentry *old;
> > +
> > +	/* Don't create child dentry for a dead directory. */
> > +	if (unlikely(IS_DEADDIR(inode)))
> > +		return ERR_PTR(-ENOENT);
> > +
> > +	old = inode->i_op->lookup(inode, dentry, nd);
> > +	if (unlikely(old)) {
> > +		dput(dentry);
> > +		dentry = old;
> > +	}
> > +	return dentry;
> > +}
> > +/*
> > *  It's more convoluted than I'd like it to be, but... it's still fairly
> > *  small and for now I'd prefer to have fast path as straight as possible.
> > *  It _is_ time-critical.
> > @@ -1236,6 +1259,13 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
> > 				goto unlazy;
> > 			}
> > 		}
> > +		if (unlikely(dentry->d_flags & DCACHE_NEED_LOOKUP)) {
> > +			if (nameidata_dentry_drop_rcu(nd, dentry))
> > +				return -ECHILD;
> > +			dput(dentry);
> > +			dentry = NULL;
> > +			goto retry;
> > +		}
> > 		path->mnt = mnt;
> > 		path->dentry = dentry;
> > 		if (likely(__follow_mount_rcu(nd, path, inode, false)))
> > @@ -1250,6 +1280,12 @@ unlazy:
> > 		}
> > 	} else {
> > 		dentry = __d_lookup(parent, name);
> > +		if (unlikely(!dentry))
> > +			goto retry;
> > +		if (unlikely(dentry->d_flags & DCACHE_NEED_LOOKUP)) {
> > +			dput(dentry);
> > +			dentry = NULL;
> > +		}
> > 	}
> > 
> > retry:
> > @@ -1268,6 +1304,18 @@ retry:
> > 			/* known good */
> > 			need_reval = 0;
> > 			status = 1;
> > +		} else if (unlikely(dentry->d_flags & DCACHE_NEED_LOOKUP)) {
> > +			struct dentry *old;
> > +
> > +			dentry->d_flags &= ~DCACHE_NEED_LOOKUP;
> > +			dentry = d_inode_lookup(parent, dentry, nd);
> 
> Would it make sense to keep DCACHE_NEED_LOOKUP set in d_flags until _after_
> the call to d_inode_lookup()?  That way the filesystem can positively know
> it is doing the inode lookup from d_fsdata, instead of just inferring it
> from the presence of d_fsdata?  It is already the filesystem that is setting
> DCACHE_NEED_LOOKUP, so it should really be the one clearing this flag also.
> 
> I'm concerned that there may be filesystems that need d_fsdata for something
> already, so the presence/absence of d_fsdata is not a clear indication to
> the underlying filesystem of whether to do an inode lookup based on d_fsdata,
> which might mean that it needs to keep yet another flag for this purpose.
> 

Another good point, I had toyed with the thought of just having helpers do all
the dirty work so all fs's could be using the same interface for using this
trick, I'll push this work into those helpers to make sure its done
consistently.  Thanks,

Josef
