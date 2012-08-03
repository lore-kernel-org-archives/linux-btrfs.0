Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:37589 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304Ab2HCVNU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Aug 2012 17:13:20 -0400
Date: Fri, 3 Aug 2012 17:13:17 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alexander Block <ablock84@googlemail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: remove mnt_want_write call in btrfs_mksubvol
Message-ID: <20120803211317.GA10080@localhost.localdomain>
References: <1343949380-15398-1-git-send-email-ablock84@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1343949380-15398-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2012 at 05:16:20PM -0600, Alexander Block wrote:
> We got a recursive lock in mksubvol because the caller already held
> a lock. I think we got into this due to a merge error. Commit a874a63
> removed the mnt_want_write call from btrfs_mksubvol and added a
> replacement call to mnt_want_write_file in btrfs_ioctl_snap_create_transid.
> Commit e7848683 however tried to move all calls to mnt_want_write above
> i_mutex. So somewhere while merging this, it got mixed up. The
> solution is to remove the mnt_want_write call completely from
> mksubvol.
> 
> Reported-by: David Sterba <dave@jikos.cz>
> Signed-off-by: Alexander Block <ablock84@googlemail.com>
> ---
>  fs/btrfs/ioctl.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 00ddf22..9df50fa 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -664,10 +664,6 @@ static noinline int btrfs_mksubvol(struct path *parent,
>  	struct dentry *dentry;
>  	int error;
>  
> -	error = mnt_want_write(parent->mnt);
> -	if (error)
> -		return error;
> -
>  	mutex_lock_nested(&dir->i_mutex, I_MUTEX_PARENT);
>  
>  	dentry = lookup_one_len(name, parent->dentry, namelen);
> @@ -703,7 +699,6 @@ out_dput:
>  	dput(dentry);
>  out_unlock:
>  	mutex_unlock(&dir->i_mutex);
> -	mnt_drop_write(parent->mnt);
>  	return error;
>  }
>  

I'm confused, this isn't here in btrfs-next, so is this a problem still?
Thanks,

Josef
