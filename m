Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44946 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726854AbeGLGji (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 02:39:38 -0400
Subject: Re: [PATCH v4 1/2] btrfs: make fs_devices to be a local variable
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com
References: <1531376596-26333-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <859b62f1-9355-8f43-a22b-bfe53750e21f@suse.com>
Date: Thu, 12 Jul 2018 09:31:29 +0300
MIME-Version: 1.0
In-Reply-To: <1531376596-26333-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.07.2018 09:23, Gu Jinxiang wrote:
> fs_devices is always passed to btrfs_scan_one_device which
> overrides it. And in the call stack below fs_devices is passed to
> btrfs_scan_one_device from btrfs_mount_root.
> And in btrfs_mount_root the output fs_devices of this call stack
> is not used.
> btrfs_mount_root
> 	-> btrfs_parse_early_options
> 		->btrfs_scan_one_device
> So, there is no necessary to pass fs_devices from btrfs_mount_root,
> use a local variable in btrfs_parse_early_options is enough.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> Reviewed-by: Anand Jain <Anand.Jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> 
> Changelog:
> v4: changed a line warp, and adjusted the order of two rows.
> v3: rebase to misc-next.
> v2: deal with Nikolay's comment, make changelog more clair.
> 
>  fs/btrfs/super.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 39d8e39b2fe1..44f58bdb5fa6 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -884,10 +884,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   * only when we need to allocate a new super block.
>   */
>  static int btrfs_parse_early_options(const char *options, fmode_t flags,
> -		void *holder, struct btrfs_fs_devices **fs_devices)
> +				      void *holder)
>  {
>  	substring_t args[MAX_OPT_ARGS];
>  	char *device_name, *opts, *orig, *p;
> +	struct btrfs_fs_devices *fs_devices = NULL;
>  	int error = 0;
>  
>  	if (!options)
> @@ -916,7 +917,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>  				goto out;
>  			}
>  			error = btrfs_scan_one_device(device_name,
> -					flags, holder, fs_devices);
> +					flags, holder, &fs_devices);
>  			kfree(device_name);
>  			if (error)
>  				goto out;
> @@ -1524,8 +1525,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
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
