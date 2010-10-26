From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] Btrfs: allow subvol deletion by unprivileged user with
 -o user_subvol_rm_allowed
Date: Tue, 26 Oct 2010 11:32:01 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1010261130510.20055@cobra.newdream.net>
References: <1288041840-28431-1-git-send-email-sage@newdream.net>
 <201010261951.01368.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010261951.01368.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 26 Oct 2010, Goffredo Baroncelli wrote:
> >  	inode = dentry->d_inode;
> > +	dest = BTRFS_I(inode)->root;
> > +	if (!capable(CAP_SYS_ADMIN)){
> > +		/*
> > +		 * Regular user.  Only allow this with a special mount
> > +		 * option, and when rmdir(2) would have been allowed.
> > +		 *
> > +		 * Note that this is _not_ check that the subvol is
> > +		 * empty or doesn't contain data that we wouldn't
> > +		 * otherwise be able to delete.
> > +		 *
> > +		 * Users who want to delete empty subvols should try
> > +		 * rmdir(2).
> > +		 */
> > +		err = -EPERM;
> > +		if (!btrfs_test_opt(root, USER_SUBVOL_RM_ALLOWED))
> > +			goto out_dput;
> > +
> > +		/*
> > +		 * Do not allow deletion if the parent dir is the same
> > +		 * as the dir to be deleted.  That means the ioctl
> > +		 * must be called on the dentry referencing the root
> > +		 * of the subvol, not a random directory contained
> > +		 * within it.
> > +		 */
> > +		err = -EINVAL;
> > +		if (root == dest)
> > +			goto out_dput;
> > +
> > +		/* check if subvolume may be deleted by a non-root user */	
> > +		err = btrfs_may_delete(dir, dentry, 1);
> > +		if (err)
> > +			goto out_dput;
> 
> If I read correctly, an user now is capable to remove a "not owned" subvolume. 
> Is this the intended behavior ?
> I am not arguing against, but I want to highlight this fact.

Good point.  This was mirroring the rmdir(2) checks, but given that we can 
remove a non-empty subvol, we should add

+		err = inode_permission(inode, MAY_WRITE | MAY_EXEC);
+		if (err)
+			goto out_dput;

as well.  I'll resend.

Thanks!
sage


> 
> 
> > +	}
> > +
> >  	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
> >  		err = -EINVAL;
> >  		goto out_dput;
> >  	}
> >  
> > -	dest = BTRFS_I(inode)->root;
> > -
> >  	mutex_lock(&inode->i_mutex);
> >  	err = d_invalidate(dentry);
> >  	if (err)
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 4da2680..8ff5a3a 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -68,7 +68,7 @@ enum {
> >  	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, 
> Opt_ssd,
> >  	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
> >  	Opt_compress_force, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
> > -	Opt_discard, Opt_err,
> > +	Opt_discard, Opt_user_subvol_rm_allowed, Opt_err,
> >  };
> >  
> >  static match_table_t tokens = {
> > @@ -92,6 +92,7 @@ static match_table_t tokens = {
> >  	{Opt_flushoncommit, "flushoncommit"},
> >  	{Opt_ratio, "metadata_ratio=%d"},
> >  	{Opt_discard, "discard"},
> > +	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
> >  	{Opt_err, NULL},
> >  };
> >  
> > @@ -235,6 +236,9 @@ int btrfs_parse_options(struct btrfs_root *root, char 
> *options)
> >  		case Opt_discard:
> >  			btrfs_set_opt(info->mount_opt, DISCARD);
> >  			break;
> > +		case Opt_user_subvol_rm_allowed:
> > +			btrfs_set_opt(info->mount_opt, 
> USER_SUBVOL_RM_ALLOWED);
> > +			break;
> >  		case Opt_err:
> >  			printk(KERN_INFO "btrfs: unrecognized mount option "
> >  			       "'%s'\n", p);
> > -- 
> > 1.6.6.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> -- 
> gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
> Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
> 
> 
