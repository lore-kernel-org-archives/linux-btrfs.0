Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43451 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdG0HTV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 03:19:21 -0400
Subject: Re: [PATCH] btrfs: prepare for extensions in compression options
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20170717162222.16926-1-dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ad1a3fdc-fe64-cf84-ba02-746c3eaa0a3b@oracle.com>
Date: Thu, 27 Jul 2017 15:25:37 +0800
MIME-Version: 1.0
In-Reply-To: <20170717162222.16926-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/18/2017 12:22 AM, David Sterba wrote:
> This is a minimal patch intended to be backported to older kernels.
> We're going to extend the string specifying the compression method and
> this would fail on kernels before that change (the string is compared
> exactly).
> 
> Relax the string matching only to the prefix, ie. ignoring anything that
> goes after "zlib" or "lzo", regardless of th format extension we decide
> to use. This applies to the mount options and properties.
> 
> That way, patched old kernels could be booted on systems already
> utilizing the new compression spec.

  In the view of older kernel with this patch, we need extra logic to
  continue to fail bad string after lzo..
   ----
         mount -o compress=lzoJUNK /dev/sdb /btrfs
           mount: wrong fs type, bad option, bad superblock on /dev/sdb,

           [ 2128.045252] BTRFS error (device sdb): open_ctree failed
    ----

   With this patch. I guess the above mount (or for that matter property
   as well) will be successful. ?

Thanks, Anand


> Applicable since commit 63541927c8d11, v3.14.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/props.c | 4 ++--
>   fs/btrfs/super.c | 4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index 4b23ae5d0e5c..f41654f05719 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -408,9 +408,9 @@ static int prop_compression_apply(struct inode *inode,
>   		return 0;
>   	}
>   
> -	if (!strncmp("lzo", value, len))
> +	if (!strncmp("lzo", value, 3))
>   		type = BTRFS_COMPRESS_LZO;
> -	else if (!strncmp("zlib", value, len))
> +	else if (!strncmp("zlib", value, 4))
>   		type = BTRFS_COMPRESS_ZLIB;
>   	else
>   		return -EINVAL;
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 74e47794e63f..147330454c17 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -498,14 +498,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   				btrfs_test_opt(info, FORCE_COMPRESS);
>   			if (token == Opt_compress ||
>   			    token == Opt_compress_force ||
> -			    strcmp(args[0].from, "zlib") == 0) {
> +			    strncmp(args[0].from, "zlib", 4) == 0) {
>   				compress_type = "zlib";
>   				info->compress_type = BTRFS_COMPRESS_ZLIB;
>   				btrfs_set_opt(info->mount_opt, COMPRESS);
>   				btrfs_clear_opt(info->mount_opt, NODATACOW);
>   				btrfs_clear_opt(info->mount_opt, NODATASUM);
>   				no_compress = 0;
> -			} else if (strcmp(args[0].from, "lzo") == 0) {
> +			} else if (strncmp(args[0].from, "lzo", 3) == 0) {
>   				compress_type = "lzo";
>   				info->compress_type = BTRFS_COMPRESS_LZO;
>   				btrfs_set_opt(info->mount_opt, COMPRESS);
> 
