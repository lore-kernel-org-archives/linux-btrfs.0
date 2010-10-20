From: Sage Weil <sage@newdream.net>
Subject: Re: [RFC] Allow to exec "btrfs subvolume delete" by a non root user
Date: Tue, 19 Oct 2010 17:00:23 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1010191653550.26790@cobra.newdream.net>
References: <201010182004.59352.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010182004.59352.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 18 Oct 2010, Goffredo Baroncelli wrote:

> Hi all
> 
> like my previous patch, this one allow to remove a subvolume by an ordinary
>  user. Instead of adding this capability to the rmdir(2) syscall, I update the
> BTRFS_IOC_SNAP_DESTROY ioctl, relaxing the rules to be execute.
> The checks are the ones performed by the rmdir(2) syscall. So a 
> subvolume must be empty to be removed by a non-root user. I think that this
>  increases a lot the usefulness of the snapshot/subvolume.
> 
> It is possible to pull the code from the branch named "rm-subvolume-not-root" 
> of the following repository:
> 
>       http://cassiopea.homelinux.net/git/btrfs-unstable.git  
> 
> Comments are welcome.

This looks okay to me.  I posted a similar patch a while back[1], but 
didn't want to duplicate the check_sticky and may_delete code and 
implemented a simpler set of checks instead.  The full checks are probably 
a better route, although it would be nice if we could avoid duplicating 
the VFS checks in the process.  Whether those helpers should be exported 
is someone else's call, though.  (The only other may_ functions that are 
exported are may_umount and may_umount_tree.)

sage

[1] http://marc.info/?l=linux-btrfs&m=128086492512628&w=2


> 
> Reagrds
> G.Baroncelli
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9254b3d..5bbb6bc 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -395,6 +395,76 @@ fail:
>  	return ret;
>  }
>  
> +/*  copy of check_sticky in fs/namei.c() 
> +* It's inline, so penalty for filesystems that don't use sticky bit is
> +* minimal.
> +*/
> +static inline int btrfs_check_sticky(struct inode *dir, struct inode *inode)
> +{
> +	uid_t fsuid = current_fsuid();
> +
> +	if (!(dir->i_mode & S_ISVTX))
> +		return 0;
> +	if (inode->i_uid == fsuid)
> +		return 0;
> +	if (dir->i_uid == fsuid)
> +		return 0;
> +	return !capable(CAP_FOWNER);
> +}
> +
> +/*  copy of may_delete in fs/namei.c() 
> + *	Check whether we can remove a link victim from directory dir, check
> + *  whether the type of victim is right.
> + *  1. We can't do it if dir is read-only (done in permission())
> + *  2. We should have write and exec permissions on dir
> + *  3. We can't remove anything from append-only dir
> + *  4. We can't do anything with immutable dir (done in permission())
> + *  5. If the sticky bit on dir is set we should either
> + *	a. be owner of dir, or
> + *	b. be owner of victim, or
> + *	c. have CAP_FOWNER capability
> + *  6. If the victim is append-only or immutable we can't do antyhing with
> + *     links pointing to it.
> + *  7. If we were asked to remove a directory and victim isn't one - ENOTDIR.
> + *  8. If we were asked to remove a non-directory and victim isn't one - EISDIR.
> + *  9. We can't remove a root or mountpoint.
> + * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
> + *     nfs_async_unlink().
> + */
> +
> +static int btrfs_may_delete(struct inode *dir,struct dentry *victim,int isdir)
> +{
> +	int error;
> +
> +	if (!victim->d_inode)
> +		return -ENOENT;
> +
> +	BUG_ON(victim->d_parent->d_inode != dir);
> +	audit_inode_child(victim, dir);
> +
> +	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
> +	if (error)
> +		return error;
> +	if (IS_APPEND(dir))
> +		return -EPERM;
> +	if (btrfs_check_sticky(dir, victim->d_inode)||
> +		IS_APPEND(victim->d_inode)||
> +	    IS_IMMUTABLE(victim->d_inode) || IS_SWAPFILE(victim->d_inode))
> +		return -EPERM;
> +	if (isdir) {
> +		if (!S_ISDIR(victim->d_inode->i_mode))
> +			return -ENOTDIR;
> +		if (IS_ROOT(victim))
> +			return -EBUSY;
> +	} else if (S_ISDIR(victim->d_inode->i_mode))
> +		return -EISDIR;
> +	if (IS_DEADDIR(dir))
> +		return -ENOENT;
> +	if (victim->d_flags & DCACHE_NFSFS_RENAMED)
> +		return -EBUSY;
> +	return 0;
> +}
> +
>  /* copy of may_create in fs/namei.c() */
>  static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
>  {
> @@ -1227,9 +1297,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  	int ret;
>  	int err = 0;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> -
>  	vol_args = memdup_user(arg, sizeof(*vol_args));
>  	if (IS_ERR(vol_args))
>  		return PTR_ERR(vol_args);
> @@ -1259,6 +1326,20 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  	}
>  
>  	inode = dentry->d_inode;
> +	if (!capable(CAP_SYS_ADMIN)){
> +		/* regolar user */
> +		/* check if subvolume is empty */
> +		if (inode->i_size > BTRFS_EMPTY_DIR_SIZE){
> +			err = -ENOTEMPTY;
> +			goto out_dput;
> +		}
> +		/* check if subvolume may be deleted by a non-root user */	
> +		if (btrfs_may_delete(dir, dentry, 1)){
> +			err = -EPERM;
> +			goto out_dput;
> +		}
> +	}
> +
>  	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
>  		err = -EINVAL;
>  		goto out_dput;
> 
> 
> 
> -- 
> gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
> Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
> 
