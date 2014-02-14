Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:49681 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaBNSzv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 13:55:51 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Josef Bacik <jbacik@fb.com>
Cc: <linux-btrfs@vger.kernel.org>, <bfields@fieldses.org>
References: <1392403428-4593-1-git-send-email-jbacik@fb.com>
Date: Fri, 14 Feb 2014 10:55:43 -0800
In-Reply-To: <1392403428-4593-1-git-send-email-jbacik@fb.com> (Josef Bacik's
	message of "Fri, 14 Feb 2014 13:43:48 -0500")
Message-ID: <878utdsevk.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [PATCH] Btrfs: unset DCACHE_DISCONNECTED when mounting default subvol
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <jbacik@fb.com> writes:

> A user was running into errors from an NFS export of a subvolume that had a
> default subvol set.  When we mount a default subvol we will use d_obtain_alias()
> to find an existing dentry for the subvolume in the case that the root subvol
> has already been mounted, or a dummy one is allocated in the case that the root
> subvol has not already been mounted.  This allows us to connect the dentry later
> on if we wander into the path.  However if we don't ever wander into the path we
> will keep DCACHE_DISCONNECTED set for a long time, which angers NFS.  It doesn't
> appear to cause any problems but it is annoying nonetheless, so simply unset
> DCACHE_DISCONNECTED in the get_default_root case and switch btrfs_lookup() to
> use d_materialise_unique() instead which will make everything play nicely
> together and reconnect stuff if we wander into the defaul subvol path from a
> different way.  With this patch I'm no longer getting the NFS errors when
> exporting a volume that has been mounted with a default subvol set.  Thanks,
>
> cc: bfields@fieldses.org
> cc: ebiederm@xmission.com
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/inode.c | 2 +-
>  fs/btrfs/super.c | 9 ++++++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 197edee..8dba152 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5157,7 +5157,7 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
>  			return ERR_CAST(inode);
>  	}
>  
> -	return d_splice_alias(inode, dentry);
> +	return d_materialise_unique(dentry, inode);
>  }
>  
>  unsigned char btrfs_filetype_table[] = {
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 147ca1d..dc0a315 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -855,6 +855,7 @@ static struct dentry *get_default_root(struct super_block *sb,
>  	struct btrfs_path *path;
>  	struct btrfs_key location;
>  	struct inode *inode;
> +	struct dentry *dentry;
>  	u64 dir_id;
>  	int new = 0;
>  
> @@ -925,7 +926,13 @@ setup_root:
>  		return dget(sb->s_root);
>  	}
>  
> -	return d_obtain_alias(inode);
> +	dentry = d_obtain_alias(inode);
> +	if (!IS_ERR(dentry)) {
> +		spin_lock(&dentry->d_lock);
> +		dentry->d_flags &= ~DCACHE_DISCONNECTED;
> +		spin_unlock(&dentry->d_lock);
> +	}
> +	return dentry;
>  }
>  
>  static int btrfs_fill_super(struct super_block *sb,
