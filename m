Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753123AbeDZIAQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 04:00:16 -0400
Subject: Re: [PATCH] btrfs: remove unused fs_info parameter
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1524728942-14403-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <cab085a1-94d0-3df1-5ce2-883036a50486@suse.com>
Date: Thu, 26 Apr 2018 11:00:14 +0300
MIME-Version: 1.0
In-Reply-To: <1524728942-14403-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.04.2018 10:49, Gu Jinxiang wrote:
> Since the commit below parameter fs_info in alloc_reloc_control
> be no used. So remove it.
> commit c6100a4b4e3d ("Btrfs: replace tree->mapping with
> tree->private_data")
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/relocation.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 00b7d3231821..d7b7b86f4931 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4299,7 +4299,7 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
>  	return inode;
>  }
>  
> -static struct reloc_control *alloc_reloc_control(struct btrfs_fs_info *fs_info)
> +static struct reloc_control *alloc_reloc_control(void)
>  {
>  	struct reloc_control *rc;
>  
> @@ -4366,7 +4366,7 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
>  	int rw = 0;
>  	int err = 0;
>  
> -	rc = alloc_reloc_control(fs_info);
> +	rc = alloc_reloc_control();
>  	if (!rc)
>  		return -ENOMEM;
>  
> @@ -4562,7 +4562,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
>  	if (list_empty(&reloc_roots))
>  		goto out;
>  
> -	rc = alloc_reloc_control(fs_info);
> +	rc = alloc_reloc_control();
>  	if (!rc) {
>  		err = -ENOMEM;
>  		goto out;
> 
