Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38828 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbeGPGH4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 02:07:56 -0400
Subject: Re: [PATCH v4 1/2] btrfs: make fs_devices to be a local variable
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: nborisov@suse.com
References: <1531376596-26333-1-git-send-email-gujx@cn.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <bc23cf94-f122-8816-c785-aa51c74ac249@oracle.com>
Date: Mon, 16 Jul 2018 13:45:26 +0800
MIME-Version: 1.0
In-Reply-To: <1531376596-26333-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/12/2018 02:23 PM, Gu Jinxiang wrote:
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
> ---
> 
> Changelog:
> v4: changed a line warp, and adjusted the order of two rows.
> v3: rebase to misc-next.
> v2: deal with Nikolay's comment, make changelog more clair.
> 
>   fs/btrfs/super.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 39d8e39b2fe1..44f58bdb5fa6 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -884,10 +884,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>    * only when we need to allocate a new super block.
>    */
>   static int btrfs_parse_early_options(const char *options, fmode_t flags,
> -		void *holder, struct btrfs_fs_devices **fs_devices)
> +				      void *holder)
>   {
>   	substring_t args[MAX_OPT_ARGS];
>   	char *device_name, *opts, *orig, *p;
> +	struct btrfs_fs_devices *fs_devices = NULL;
>   	int error = 0;
>   
>   	if (!options)
> @@ -916,7 +917,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>   				goto out;
>   			}
>   			error = btrfs_scan_one_device(device_name,
> -					flags, holder, fs_devices);
> +					flags, holder, &fs_devices);

1.
  Extend line until 8-char, and remain to start below the (.

-                       error = btrfs_scan_one_device(device_name,
-                                       flags, holder, fs_devices);
+                       error = btrfs_scan_one_device(device_name, flags,
+                                                     holder, &fs_devices);


2.
Fixed the conflict on top of the recent uuid_mutex changes from David.

I see this patch isn't in the misc-next yet, applied to my local WS,
pending pull request.

Thanks, Anand

>   			kfree(device_name);
>   			if (error)
>   				goto out;
> @@ -1524,8 +1525,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>   	if (!(flags & SB_RDONLY))
>   		mode |= FMODE_WRITE;
>   
> -	error = btrfs_parse_early_options(data, mode, fs_type,
> -					  &fs_devices);
> +	error = btrfs_parse_early_options(data, mode, fs_type);
>   	if (error) {
>   		return ERR_PTR(error);
>   	}
> 
