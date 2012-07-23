Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:42455 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2GWBQC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jul 2012 21:16:02 -0400
Message-ID: <500CA5CB.7070800@huawei.com>
Date: Mon, 23 Jul 2012 09:15:55 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] Btrfs: Check INCOMPAT flags on remount and add
 helper function
References: <1342822601-18340-1-git-send-email-mitch.harder@sabayonlinux.org> <1342822601-18340-2-git-send-email-mitch.harder@sabayonlinux.org>
In-Reply-To: <1342822601-18340-2-git-send-email-mitch.harder@sabayonlinux.org>
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h

> index a0ee2f8..3a1a700 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3103,6 +3103,19 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
>  			       struct btrfs_root *root, const char *function,
>  			       unsigned int line, int errno);
>  
> +static inline void btrfs_chk_lzo_incompat(struct btrfs_root *root)


Isn't btrfs_set_lzo_incompat() is a better name?

> +{
> +	struct btrfs_super_block *disk_super;
> +	u64 features;
> +
> +	disk_super = root->fs_info->super_copy;
> +	features = btrfs_super_incompat_flags(disk_super);
> +	if (!(features & BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO)) {
> +		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
> +		btrfs_set_super_incompat_flags(disk_super, features);
> +	}
> +}
> +


