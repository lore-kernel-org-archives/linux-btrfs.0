Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab3BEXON (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Feb 2013 18:14:13 -0500
Date: Tue, 5 Feb 2013 15:14:05 -0800
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH] btrfs: add delayed_iput list head to btrfs inode
Message-ID: <20130205231405.GM14246@lenny.home.zabbo.net>
References: <511180E4.2020600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <511180E4.2020600@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +	struct btrfs_inode *b_inode = BTRFS_I(inode);
> +	struct btrfs_fs_info *fs_info = b_inode->root->fs_info;
>  
>  	if (atomic_add_unless(&inode->i_count, -1, 1))
>  		return;
>  
> -	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
> -	delayed->inode = inode;
> -
>  	spin_lock(&fs_info->delayed_iput_lock);
> -	list_add_tail(&delayed->list, &fs_info->delayed_iputs);
> +	list_add_tail(&b_inode->delayed_iput, &fs_info->delayed_iputs);
>  	spin_unlock(&fs_info->delayed_iput_lock);
>  }

Hmm.  I'm not great with inode life cycles, but isn't this only safe if
someone else can't get an i_count reference while this is in flight?  It
looks like the final iput does the unhashing, and so on, so couldn't an
iget/iput race with this and try to add the inode's list_head twice?

- z
