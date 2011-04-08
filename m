From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v4 1/8] btrfs: Balance progress monitoring
Date: Fri, 8 Apr 2011 18:00:38 +0200
Message-ID: <20110408160037.GD31675@twin.jikos.cz>
References: <1302195975-3088-1-git-send-email-hugo@carfax.org.uk>
 <1302195975-3088-2-git-send-email-hugo@carfax.org.uk>
 <20110408131221.GL31675@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110408131221.GL31675@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

> a missing check ...
ah, forget it, 

On Fri, Apr 08, 2011 at 03:12:21PM +0200, David Sterba wrote:
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 5fdb2ab..a8fbb07 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -2375,6 +2375,38 @@ static noinline long btrfs_ioctl_wait_sync(struct file *file, void __user *argp)
> >  	return btrfs_wait_for_commit(root, transid);
> >  }
> >  
> > +/*
> > + * Return the current status of any balance operation
> > + */
> > +long btrfs_ioctl_balance_progress(
> > +	struct btrfs_fs_info *fs_info,
> > +	struct btrfs_ioctl_balance_progress __user *user_dest)
> > +{
> > +	int ret = 0;
> > +	struct btrfs_ioctl_balance_progress dest;
> 
>         if (!access_ok(VERIFY_WRITE, user_dest, sizeof(*user_dest)))
> 	        return -EFAULT;
pointless of course ...

> 
> > +
> > +	spin_lock(&fs_info->balance_info_lock);
> > +	if (!fs_info->balance_info) {
> > +		ret = -EINVAL;
> > +		goto error;
> > +	}
> > +
> > +	dest.expected = fs_info->balance_info->expected;
> > +	dest.completed = fs_info->balance_info->completed;

this is _not_ the user supplied pointer

> > +
> > +	spin_unlock(&fs_info->balance_info_lock);
> > +
> > +	if (copy_to_user(user_dest, &dest,
> > +			 sizeof(struct btrfs_ioctl_balance_progress)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +
> > +error:
> > +	spin_unlock(&fs_info->balance_info_lock);
> > +	return ret;
> > +}
> > +
> >  long btrfs_ioctl(struct file *file, unsigned int
> >  		cmd, unsigned long arg)
> >  {
