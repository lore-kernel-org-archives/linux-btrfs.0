From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] btrfs: add new ioctl to determine size of compressed file
Date: Tue, 20 Dec 2011 18:26:58 +0100
Message-ID: <20111220172658.GD7322@twin.jikos.cz>
References: <1324304223-19079-1-git-send-email-dsterba@suse.cz> <4EEFE5D2.6020401@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EEFE5D2.6020401@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 20, 2011 at 09:33:06AM +0800, Liu Bo wrote:
> > +static long btrfs_ioctl_compr_size(struct file *file, void __user *argp)
> > +{
> > +	struct inode *inode = fdentry(file)->d_inode;
> > +	struct btrfs_ioctl_compr_size_args compr_args;
> > +	u64 len;
> > +	u64 compressed_size = 0;
> > +	u64 offset = 0;
> > +
> > +	if (S_ISDIR(inode->i_mode))
> > +		return -EISDIR;
> > +
> > +	if (copy_from_user(&compr_args, argp,
> > +				sizeof(struct btrfs_ioctl_compr_size_args)))
> > +		return -EFAULT;
> > +
> > +	if (compr_args.start > compr_args.end)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&inode->i_mutex);
> > +
> > +	offset = compr_args.start;
> > +	if (inode->i_size > compr_args.end)
> > +		len = compr_args.end;
> > +	else
> > +		len = inode->i_size;
> > +
> > +	/*
> > +	 * do any pending delalloc/csum calc on inode, one way or
> > +	 * another, and lock file content
> > +	 */
> > +	btrfs_wait_ordered_range(inode, compr_args.start, len);
> > +
> 
> missing a lock_extent() ?

yeah right, thanks, it was missing even in the original implementation
and was left unnoticed.

> and we may adjust i_mutex and [un]lock_extent.

adjusted which way? I have swapped order of unlock_extent/mutex_unlock
as it was in the wrong order wrt locking. I'll send V2 in a minute.


thanks,
david
