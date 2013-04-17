Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965558Ab3DQWRN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 18:17:13 -0400
Date: Thu, 18 Apr 2013 00:17:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: use a lock to protect incompat/compat flag of
 the super block
Message-ID: <20130417221710.GD16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <516690B8.8020904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <516690B8.8020904@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 11, 2013 at 06:30:16PM +0800, Miao Xie wrote:
> In order to avoid this problem, we introduce a lock named super_lock into
> the btrfs_fs_info structure. If we want to update incompat/compat flags
> of the super block, we must hold it.
> 
> +	/*
> +	 * Used to protect the incompat_flags, compat_flags, compat_ro_flags
> +	 * when they are updated.

> +	spinlock_t super_lock;

The lock name is too general for protecting just *_flags, do you have
plans to add more items from superblock under this lock?  If no, I
suggest to pick a different name.

> @@ -3663,8 +3674,15 @@ static inline void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info,
>  	disk_super = fs_info->super_copy;
>  	features = btrfs_super_incompat_flags(disk_super);
>  	if (!(features & flag)) {
> -		features |= flag;
> -		btrfs_set_super_incompat_flags(disk_super, features);
> +		spin_lock(&fs_info->super_lock);
> +		features = btrfs_super_incompat_flags(disk_super);
> +		if (!(features & flag)) {
> +			features |= flag;
> +			btrfs_set_super_incompat_flags(disk_super, features);
> +			printk(KERN_INFO "btrfs: setting %llu feature flag\n",
> +					 flag);

flag is u64, please use (unsigned long long)flag and possibly the new
btrfs_info replacement of printks.

> +		}
> +		spin_unlock(&fs_info->super_lock);
>  	}
>  }

otherwise ok.

Reviewed-by: David Sterba <dsterba@suse.cz>
