Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60810 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751218AbdHRIjR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 04:39:17 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: add necessary close(fd) in mkfs
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1503045166-18612-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <53be12bf-da8c-440a-d00c-8ae3ee224d45@suse.com>
Date: Fri, 18 Aug 2017 11:39:14 +0300
MIME-Version: 1.0
In-Reply-To: <1503045166-18612-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 18.08.2017 11:32, Gu Jinxiang wrote:
> Add some close(fd) when error occures in mkfs.
> And add close(fd) when end use it.

When a process exits all of its fds (and all other runtime resources
tracked by the kernel) are freed, so we don't leak fds if that's your
worry. Admittedly, it's good practice to manage the lifetime of fds
correctly in a program, so I don't have any strong preferences either ways.


> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  mkfs/main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 2b109a5..ec82565 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -1694,6 +1694,7 @@ int main(int argc, char **argv)
>  					file,
>  					(unsigned long long)block_count,
>  					(unsigned long long)dev_block_count);
> +			close(fd);
>  			exit(1);
>  		}
>  	} else {
> @@ -1711,6 +1712,7 @@ int main(int argc, char **argv)
>  		ret = zero_output_file(fd, block_count);
>  		if (ret) {
>  			error("unable to zero the output file");
> +			close(fd);
>  			exit(1);
>  		}
>  		/* our "device" is the new image file */
> @@ -1721,6 +1723,7 @@ int main(int argc, char **argv)
>  	if (dev_block_count < BTRFS_MKFS_SYSTEM_GROUP_SIZE) {
>  		error("device is too small to make filesystem, must be at least %llu",
>  				(unsigned long long)BTRFS_MKFS_SYSTEM_GROUP_SIZE);
> +		close(fd);
>  		exit(1);
>  	}
>  
> @@ -1740,6 +1743,7 @@ int main(int argc, char **argv)
>  	ret = make_btrfs(fd, &mkfs_cfg);
>  	if (ret) {
>  		error("error during mkfs: %s", strerror(-ret));
> +		close(fd);
>  		exit(1);
>  	}
>  
> @@ -1750,6 +1754,7 @@ int main(int argc, char **argv)
>  		close(fd);
>  		exit(1);
>  	}
> +	close(fd);
>  	root = fs_info->fs_root;
>  	fs_info->alloc_start = alloc_start;
>  
> @@ -1827,6 +1832,7 @@ int main(int argc, char **argv)
>  					sectorsize, sectorsize, sectorsize);
>  		if (ret) {
>  			error("unable to add %s to filesystem: %d", file, ret);
> +			close(fd);
>  			goto out;
>  		}
>  		if (verbose >= 2) {
> 
