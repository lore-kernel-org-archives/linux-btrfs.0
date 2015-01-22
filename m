Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42785 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbAVUBN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 15:01:13 -0500
Received: by mail-pa0-f52.google.com with SMTP id kx10so3843984pab.11
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Jan 2015 12:01:12 -0800 (PST)
Date: Thu, 22 Jan 2015 12:01:10 -0800
From: Zach Brown <zab@zabbo.net>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, chandan r <chandanrmail@gmail.com>
Subject: Re: [PATCH v2] Btrfs: Add code to support file creation time
Message-ID: <20150122200109.GA688@lenny.home.zabbo.net>
References: <1421947241-9323-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421947241-9323-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> @@ -5729,6 +5744,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  	struct btrfs_path *path;
>  	struct btrfs_inode_ref *ref;
>  	struct btrfs_key key[2];
> +	struct timespec current_time;
>  	u32 sizes[2];
>  	int nitems = name ? 2 : 1;
>  	unsigned long ptr;
> @@ -5824,7 +5840,13 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  
>  	inode_init_owner(inode, dir, mode);
>  	inode_set_bytes(inode, 0);
> -	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
> +
> +	current_time = CURRENT_TIME;
> +	inode->i_mtime = current_time;
> +	inode->i_atime = current_time;
> +	inode->i_ctime = current_time;
> +	BTRFS_I(inode)->i_otime = current_time;

I might have just set mtime to CURRENT_TIME then the rest to mtime.
It'd be a touch less noisy.  Author's choice, though :).

Any plans to add it to send/recv?

766702ef (Alexander Block           2012-07-28 14:11:31 +0200 2480)
	/* TODO Add otime support when the otime patches get into upstream */

- z
