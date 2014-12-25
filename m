Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56424 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaLYB2w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 20:28:52 -0500
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 9EB833EE0C1
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:28:51 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 9F592AC06AD
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:28:50 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 4A652E08005
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:28:50 +0900 (JST)
Message-ID: <549B6841.6030202@jp.fujitsu.com>
Date: Thu, 25 Dec 2014 10:28:33 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>, <linux-btrfs@vger.kernel.org>
CC: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 3/8] Add verbose option to btrfs_add_to_fsid()
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it> <1418847252-14184-4-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418847252-14184-4-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/12/18 5:14, Goffredo Baroncelli wrote:
> Add verbose option to btrfs_add_to_fsid() in order to avoid to print
> the information to console when not needed.
> The same information is print in the summary of the mkfs.btrfs command.
> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   mkfs.c  | 3 ++-
>   utils.c | 7 ++++---
>   utils.h | 2 +-
>   3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/mkfs.c b/mkfs.c
> index a5f19cc..042d12e 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1638,7 +1638,8 @@ int main(int ac, char **av)
>   		mixed = old_mixed;
>   
>   		ret = btrfs_add_to_fsid(trans, root, fd, file, dev_block_count,
> -					sectorsize, sectorsize, sectorsize);
> +					sectorsize, sectorsize, sectorsize,
> +					verbose);
>   		BUG_ON(ret);
>   		btrfs_register_one_device(file);
>   	}
> diff --git a/utils.c b/utils.c
> index 19049bb..dcb4f74 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -610,7 +610,7 @@ static int zero_dev_clamped(int fd, off_t start, ssize_t len, u64 dev_size)
>   int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
>   		      struct btrfs_root *root, int fd, char *path,
>   		      u64 block_count, u32 io_width, u32 io_align,
> -		      u32 sectorsize)
> +		      u32 sectorsize, int verbose)
>   {
>   	struct btrfs_super_block *disk_super;
>   	struct btrfs_super_block *super = root->fs_info->super_copy;
> @@ -659,8 +659,9 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
>   
>   	memcpy(disk_super, super, sizeof(*disk_super));
>   
> -	printf("adding device %s id %llu\n", path,
> -	       (unsigned long long)device->devid);
> +	if (verbose)
> +		printf("adding device %s id %llu\n", path,
> +		       (unsigned long long)device->devid);
>   
>   	btrfs_set_super_bytenr(disk_super, BTRFS_SUPER_INFO_OFFSET);
>   	btrfs_set_stack_device_id(dev_item, device->devid);
> diff --git a/utils.h b/utils.h
> index bb8a449..9218199 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -79,7 +79,7 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
>   int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
>   		      struct btrfs_root *root, int fd, char *path,
>   		      u64 block_count, u32 io_width, u32 io_align,
> -		      u32 sectorsize);
> +		      u32 sectorsize, int verbose);
>   int btrfs_scan_for_fsid(int run_ioctls);
>   int btrfs_register_one_device(const char *fname);
>   int btrfs_register_all_devices(void);
> 

