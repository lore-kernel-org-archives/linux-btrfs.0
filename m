Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:38104 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab3AaT6J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 14:58:09 -0500
Date: Thu, 31 Jan 2013 11:58:08 -0800
From: Zach Brown <zab@zabbo.net>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix how we discard outstanding ordered extents on
 abort
Message-ID: <20130131195808.GG14246@lenny.home.zabbo.net>
References: <1359660760-3137-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1359660760-3137-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -	struct list_head splice;
>  	struct btrfs_ordered_extent *ordered;

>  	struct inode *inode;

Remove this too?

> +	/*
> +	 * This will just short circuit the ordered completion stuff which will
> +	 * make sure the ordered extent gets properly cleaned up.
> +	 */
> +	list_for_each_entry(ordered, &root->fs_info->ordered_extents,
> +			    root_extent_list)
> +		set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
>  	spin_unlock(&root->fs_info->ordered_extent_lock);
>  }

fs/btrfs/disk-io.c: In function ‘btrfs_destroy_ordered_extents’:
fs/btrfs/disk-io.c:3548:16: warning: unused variable ‘inode’ [-Wunused-variable]

- z
