Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60796 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758277AbcG1BEC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 21:04:02 -0400
Subject: Re: [PATCH 1/5] Add some helper functions
To: Goffredo Baroncelli <kreijack@libero.it>, <linux-btrfs@vger.kernel.org>
References: <1469641398-3879-1-git-send-email-kreijack@libero.it>
 <1469641398-3879-2-git-send-email-kreijack@libero.it>
CC: <dsterba@suse.cz>, Chris Mason <clm@fb.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <62d161d6-4eea-32a7-7b47-8efbc2c5730f@cn.fujitsu.com>
Date: Thu, 28 Jul 2016 09:03:48 +0800
MIME-Version: 1.0
In-Reply-To: <1469641398-3879-2-git-send-email-kreijack@libero.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/28/2016 01:43 AM, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
>
> Add the following functions:
> - int is_btrfs_fs(const char *path) -> returns 0 if path is a btrfs filesystem
> - void check_root_or_exit() -> checks if the user has the root capability or
>                                it exits writing an error message
> - void check_btrfs_or_exit(const char *path)
> 				checks if path is a valid btrfs filesystem,
> 				otherwise it exits
>
> Signed-off-by: Goffredo baroncelli <kreijack@inwind.it>
> ---
>  utils.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  utils.h | 14 ++++++++++++++
>  2 files changed, 55 insertions(+)
>
> diff --git a/utils.c b/utils.c
> index 578fdb0..b99706c 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -4131,3 +4131,44 @@ unsigned int rand_range(unsigned int upper)
>  	 */
>  	return (unsigned int)(jrand48(rand_seed) % upper);
>  }
> +
> +/*
> + * check if path is a btrfs filesystem
> + */
> +int is_btrfs_fs(const char *path)
> +{
> +	struct statfs stfs;
> +
> +	if (statfs(path, &stfs) != 0) {
> +		/* cannot access */
> +		return -1;
> +	}
> +
> +	if (stfs.f_type != BTRFS_SUPER_MAGIC) {
> +		/* not a btrfs filesystem */
> +		return -2;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * check if the user is root
> + */
> +void check_root_or_exit()
> +{
> +    if (geteuid() == 0)
> +        return;
> +
> +    error("You need to be root to execute this command");
> +    exit(100);
No immediate exit value, especially such like 100.

Normally we only use 1 and 0 as exit value.

Another concern about the function is, we don't really do such early 
check on root privilege.

Under most case, we just call privilege function, like tree search 
ioctl, and when it fails, it will return -EPERM to info user that they 
lacks the privilege.

Such behavior makes code more extendable, for case like the ioctl 
becomes non-privilege, btrfs-progs don't need any modification.

So I think it's better to let ioctl itself to do the privilege check 
other than in btrfs-progs.
> +}
> +
> +void check_btrfs_or_exit(const char *path)
> +{
> +    if (!is_btrfs_fs(path))
> +        return;
> +
> +    error("'%s' must be a valid btrfs filesystem", path);
> +    exit(100);
> +}

Same exit value problem.

This btrfs check seems quite good.

What about merge it into functions like open_file_or_dir?
As most caller uses such function to open file/dir inside a btrfs mount 
point.

Thanks,
Qu
> diff --git a/utils.h b/utils.h
> index 98bfb34..0bd6ecb 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -399,4 +399,18 @@ unsigned int rand_range(unsigned int upper);
>  /* Also allow setting the seed manually */
>  void init_rand_seed(u64 seed);
>
> +/* return 0 if path is a valid btrfs filesystem */
> +int is_btrfs_fs(const char *path);
> +
> +/*
> + * check if the user has the root capability, otherwise it exits printing an
> + * error message
> + */
> +void check_root_or_exit();
> +/*
> + * check if path is a valid btrfs filesystem, otherwise it exits printing an
> + * error message
> + */
> +void check_btrfs_or_exit(const char *path);
> +
>  #endif
>


