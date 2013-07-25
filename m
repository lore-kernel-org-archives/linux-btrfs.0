Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab3GYVbh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 17:31:37 -0400
Date: Thu, 25 Jul 2013 14:31:35 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: check to see if root_list is empty before adding
 it to dead roots
Message-ID: <20130725213135.GK26554@lenny.home.zabbo.net>
References: <1374779620-28788-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1374779620-28788-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -int btrfs_add_dead_root(struct btrfs_root *root)
> +void btrfs_add_dead_root(struct btrfs_root *root)
>  {
>  	spin_lock(&root->fs_info->trans_lock);
> -	list_add_tail(&root->root_list, &root->fs_info->dead_roots);
> +	if (list_empty(&root->root_list))
> +		list_add_tail(&root->root_list, &root->fs_info->dead_roots);
>  	spin_unlock(&root->fs_info->trans_lock);
> -	return 0;
>  }
>  
>  /*
> @@ -1925,7 +1925,7 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
>  	}
>  	root = list_first_entry(&fs_info->dead_roots,
>  			struct btrfs_root, root_list);
> -	list_del(&root->root_list);
> +	list_del_init(&root->root_list);

Looking at other root_list deletions.. do we also need _del_init() in
btrfs_recover_relocation() or del_fs_roots()?  (Maybe for consistency
and peace of mind, if nothing else?)

- z
