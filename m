Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50130 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751621AbdJ0Hyb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 03:54:31 -0400
Subject: Re: [PATCH] btrfs-progs: reserve < 0 return value for errnos
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171027073133.24874-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <76b167be-990a-c90e-8e14-067d2d07480e@suse.com>
Date: Fri, 27 Oct 2017 10:54:28 +0300
MIME-Version: 1.0
In-Reply-To: <20171027073133.24874-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.10.2017 10:31, Anand Jain wrote:
> btrfs_read_dev_super() returns -1 upon not finding a suitable SB,
> change that to return 1 instead, so that it can reserve the < 0
> values for the errno communications.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

I believe this is buggy since it will be masking errors. We call
btrfs_read_dev_super in open_ctree_with_broken_chunk if the function
returns 1 we eventually exit as: return ERR_PTR(ret); And then perform
IS_ERR on the returned value. IS_ERR is essentially:
((x) >= (unsigned long)-MAX_ERRNO) where x could be 1 and MAX_ERRNO is 4095

So you just broke all functions which return the ret of
btrfs_read_dev_super as ERR_PTR.


NAK

> ---
> An independent patch, not related to any recent patch sent to ML.
> 
>  disk-io.c | 2 +-
>  utils.c   | 2 +-
>  volumes.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/disk-io.c b/disk-io.c
> index f5edc4796619..ba87bb4ce6da 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1491,7 +1491,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
>  		}
>  	}
>  
> -	return transid > 0 ? 0 : -1;
> +	return transid > 0 ? 0 : 1;
>  }
>  
>  static int write_dev_supers(struct btrfs_fs_info *fs_info,
> diff --git a/utils.c b/utils.c
> index 524f463d3140..7574cda8151c 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1678,7 +1678,7 @@ int get_fs_info(const char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>  		disk_super = (struct btrfs_super_block *)buf;
>  		ret = btrfs_read_dev_super(fd, disk_super,
>  					   BTRFS_SUPER_INFO_OFFSET, 0);
> -		if (ret < 0) {
> +		if (ret) {
>  			ret = -EIO;
>  			goto out;
>  		}
> diff --git a/volumes.c b/volumes.c
> index 2209e5a9100b..87008bfdd586 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -268,7 +268,7 @@ int btrfs_scan_one_device(int fd, const char *path,
>  
>  	disk_super = (struct btrfs_super_block *)buf;
>  	ret = btrfs_read_dev_super(fd, disk_super, super_offset, sbflags);
> -	if (ret < 0)
> +	if (ret)
>  		return -EIO;
>  	devid = btrfs_stack_device_id(&disk_super->dev_item);
>  	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_METADUMP)
> 
