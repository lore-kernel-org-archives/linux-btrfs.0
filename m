Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55164 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751423AbeGJHEd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 03:04:33 -0400
Subject: Re: [PATCH 1/2] btrfs: make fs_devices to be a local variable
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1531204433-11570-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <018883de-4d46-b96c-8bd4-9306ee5cd360@suse.com>
Date: Tue, 10 Jul 2018 10:04:31 +0300
MIME-Version: 1.0
In-Reply-To: <1531204433-11570-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.07.2018 09:33, Gu Jinxiang wrote:
> Since output parameter fs_devices of btrfs_parse_early_options is
> not used in the caller, make it be a local variable.

The changelog is a bit misleading, because 'fs_devices' is in fact used
in the caller, however it's always passed to btrfs_scan_one_device which
overrides it. Finally it is assigned to fs_info->fs_devices. So the
patch is correct however put more detail in the changelog explaining
it's overriden by btrfs_scan_one_device.

> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  fs/btrfs/super.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index bf546d6c286c..4ee082e96d51 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -886,11 +886,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   * only when we need to allocate a new super block.
>   */
>  static int btrfs_parse_early_options(const char *options, fmode_t flags,
> -		void *holder, struct btrfs_fs_devices **fs_devices)
> +		void *holder)
>  {
>  	substring_t args[MAX_OPT_ARGS];
>  	char *device_name, *opts, *orig, *p;
>  	int error = 0;
> +	struct btrfs_fs_devices *fs_devices = NULL;
>  
>  	if (!options)
>  		return 0;
> @@ -918,7 +919,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>  				goto out;
>  			}
>  			error = btrfs_scan_one_device(device_name,
> -					flags, holder, fs_devices);
> +					flags, holder, &fs_devices);
>  			kfree(device_name);
>  			if (error)
>  				goto out;
> @@ -1526,8 +1527,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>  	if (!(flags & SB_RDONLY))
>  		mode |= FMODE_WRITE;
>  
> -	error = btrfs_parse_early_options(data, mode, fs_type,
> -					  &fs_devices);
> +	error = btrfs_parse_early_options(data, mode, fs_type);
>  	if (error) {
>  		return ERR_PTR(error);
>  	}
> 
