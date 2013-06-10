Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab3FJUAf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 16:00:35 -0400
Message-ID: <51B63050.9080808@redhat.com>
Date: Mon, 10 Jun 2013 15:00:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/9] btrfs-progs: btrfs_scan_for_fsid doesn't need all
 the arguments
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com> <1370876190-16520-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1370876190-16520-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/10/13 9:56 AM, Anand Jain wrote:
> btrfs_scan_for_fsid uses only one argument run_ioctl out of 3
> so remove the rest two of them

and run_ioctl is only ever '1' (and it's completely unobvious
at the call point what '1' means).

Why not just go with 0 args?

Then only btrfs_scan_one_dir and btrfs_scan_block_devices
will have a non-obvious 0/1 arg.... :(

-Eric


> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  btrfs-find-root.c | 2 +-
>  disk-io.c         | 2 +-
>  utils.c           | 5 ++---
>  utils.h           | 3 +--
>  4 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/btrfs-find-root.c b/btrfs-find-root.c
> index 810d835..e736cb5 100644
> --- a/btrfs-find-root.c
> +++ b/btrfs-find-root.c
> @@ -110,7 +110,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
>  	}
>  
>  	if (total_devs != 1) {
> -		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
> +		ret = btrfs_scan_for_fsid(1);
>  		if (ret)
>  			goto out;
>  	}
> diff --git a/disk-io.c b/disk-io.c
> index 9ffe6e4..acd5480 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -838,7 +838,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>  	}
>  
>  	if (total_devs != 1) {
> -		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
> +		ret = btrfs_scan_for_fsid(1);
>  		if (ret)
>  			goto out;
>  	}
> diff --git a/utils.c b/utils.c
> index 7b4cd74..25f3cb4 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -928,7 +928,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
>  
>  	/* scan other devices */
>  	if (is_btrfs && total_devs > 1) {
> -		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1)))
> +		if((ret = btrfs_scan_for_fsid(1)))
>  			return ret;
>  	}
>  
> @@ -1110,8 +1110,7 @@ fail:
>  	return ret;
>  }
>  
> -int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
> -			int run_ioctls)
> +int btrfs_scan_for_fsid(int run_ioctls)
>  {
>  	int ret;
>  
> diff --git a/utils.h b/utils.h
> index 3c17e14..dba37e8 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -35,8 +35,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
>  		      struct btrfs_root *root, int fd, char *path,
>  		      u64 block_count, u32 io_width, u32 io_align,
>  		      u32 sectorsize);
> -int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
> -			int run_ioctls);
> +int btrfs_scan_for_fsid(int run_ioctls);
>  void btrfs_register_one_device(char *fname);
>  int btrfs_scan_one_dir(char *dirname, int run_ioctl);
>  int check_mounted(const char *devicename);
> 

