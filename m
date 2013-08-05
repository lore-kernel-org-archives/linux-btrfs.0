Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab3HEWLB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 18:11:01 -0400
Date: Mon, 5 Aug 2013 15:10:59 -0700
From: Zach Brown <zab@redhat.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: race free update of super flags
Message-ID: <20130805221059.GJ12314@lenny.home.zabbo.net>
References: <1375555397-10886-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375555397-10886-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 03, 2013 at 07:43:17PM +0100, Filipe David Borba Manana wrote:
> Before updating the super block's flags, which is a non-atomic
> operation, grab the super_lock in the fs_info structure. At
> the moment only 2 different code paths can update these flags
> in parallel:

Hmm.  You say "the" super block, but it's not clear to me that it's that
simple.

> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3357,8 +3357,10 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
>  		memcpy(dev_item->uuid, dev->uuid, BTRFS_UUID_SIZE);
>  		memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_UUID_SIZE);
>  
> +		spin_lock(&root->fs_info->super_lock);
>  		flags = btrfs_super_flags(sb);
>  		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
> +		spin_unlock(&root->fs_info->super_lock);

        sb = root->fs_info->super_for_commit;

> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1862,9 +1862,11 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
>  	generate_random_uuid(fs_devices->fsid);
>  	memcpy(root->fs_info->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
>  	memcpy(disk_super->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
> +	spin_lock(&root->fs_info->super_lock);
>  	super_flags = btrfs_super_flags(disk_super) &
>  		      ~BTRFS_SUPER_FLAG_SEEDING;
>  	btrfs_set_super_flags(disk_super, super_flags);
> +	spin_unlock(&root->fs_info->super_lock);

        struct btrfs_super_block *disk_super = root->fs_info->super_copy;

Can you explain why the lock is needed given the different super blocks
and the mutexes that each path holds?

What lead you to write this patch?

- z
