Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33888 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727857AbeGPM6Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 08:58:25 -0400
Subject: Re: [PATCH v5 1/2] btrfs: make fs_devices to be a local variable
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com
References: <1531732277-23517-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d1584880-3783-fcad-f368-5241d62495e1@suse.com>
Date: Mon, 16 Jul 2018 15:31:07 +0300
MIME-Version: 1.0
In-Reply-To: <1531732277-23517-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.07.2018 12:11, Gu Jinxiang wrote:
> fs_devices is always passed to btrfs_scan_one_device which
> overrides it. And in the call stack below fs_devices is passed to
> btrfs_scan_one_device from btrfs_mount_root.
> And in btrfs_mount_root the output fs_devices of this call stack
> is not used.
> btrfs_mount_root
>         -> btrfs_parse_early_options
>                 ->btrfs_scan_one_device
> So, there is no necessary to pass fs_devices from btrfs_mount_root,
> use a local variable in btrfs_parse_early_options is enough.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> Reviewed-by: Anand Jain <Anand.Jain@oracle.com>
> ---
> 
> Changelog:
> v5: change a line wrap, and rebase to misc-next.
> v4: changed a line warp, and adjusted the order of two rows.
> v3: rebase to misc-next.
> v2: deal with Nikolay's comment, make changelog more clair.
> 
>  fs/btrfs/super.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 28ab75ebb983..dcab4a0244e5 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -884,10 +884,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   * only when we need to allocate a new super block.
>   */
>  static int btrfs_parse_early_options(const char *options, fmode_t flags,
> -		void *holder, struct btrfs_fs_devices **fs_devices)
> +					void *holder)
>  {
>  	substring_t args[MAX_OPT_ARGS];
>  	char *device_name, *opts, *orig, *p;
> +	struct btrfs_fs_devices *fs_devices = NULL;
>  	int error = 0;
>  
>  	lockdep_assert_held(&uuid_mutex);
> @@ -917,8 +918,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>  				error = -ENOMEM;
>  				goto out;
>  			}
> -			error = btrfs_scan_one_device(device_name,
> -					flags, holder, fs_devices);
> +			error = btrfs_scan_one_device(device_name, flags,
> +							holder, &fs_devices);

You are line wraps are in fact worse than before, the first letter of
the "holder.." line has to be aligned exactly under the first letter of
"device_name". I assume David will fix this while merging so no need to
resend but fix your editor for future submissions.

>  			kfree(device_name);
>  			if (error)
>  				goto out;
> @@ -1554,7 +1555,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>  	}
>  
>  	mutex_lock(&uuid_mutex);
> -	error = btrfs_parse_early_options(data, mode, fs_type, &fs_devices);
> +	error = btrfs_parse_early_options(data, mode, fs_type);
>  	if (error) {
>  		mutex_unlock(&uuid_mutex);
>  		goto error_fs_info;
> 
