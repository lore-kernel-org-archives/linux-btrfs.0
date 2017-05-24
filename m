Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32515 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034125AbdEXJHf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 05:07:35 -0400
Subject: Re: [PATCH] btrfs: check options during subsequent mount
To: dsterba@suse.cz
References: <20170428091409.19621-1-anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <980ec218-167c-3326-1964-2ff086d278c9@oracle.com>
Date: Wed, 24 May 2017 17:13:24 +0800
MIME-Version: 1.0
In-Reply-To: <20170428091409.19621-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David,

  Can I ping you on this patch ? Wonder if there is any concern.

Thanks, Anand


On 04/28/2017 05:14 PM, Anand Jain wrote:
> We allow recursive mounts with subvol options such as [1]
>
> [1]
>  mount -o rw,compress=lzo /dev/sdc /btrfs1
>  mount -o ro,subvol=sv2 /dev/sdc /btrfs2
>
> And except for the btrfs-specific subvol and subvolid options
> all-other options are just ignored in the subsequent mounts.
>
> In the below example [2] the effect compression is only zlib,
> even though there was no error for the option -o compress=lzo.
>
> [2]
> ----
>  # mount -o compress=zlib /dev/sdc /btrfs1
>  #echo $?
>  0
>
>  # mount -o compress=lzo /dev/sdc /btrfs
>  #echo $?
>  0
>
>  #cat /proc/self/mounts
>  ::
>  /dev/sdc /btrfs1 btrfs rw,relatime,compress=zlib,space_cache,subvolid=5,subvol=/ 0 0
>  /dev/sdc /btrfs btrfs rw,relatime,compress=zlib,space_cache,subvolid=5,subvol=/ 0 0
> ----
>
> Further, random string .. has no error as well.
> -----
>  # mount -o compress=zlib /dev/sdc /btrfs1
>  #echo $?
>  0
>
>  # mount -o something /dev/sdc /btrfs
>  #echo $?
>  0
> -----
>
> This patch fixes the above issue, by checking the if the passed
> options are only subvol or subvolid in the subsequent mount.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/super.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 9530a333d302..e0e542345c38 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -389,6 +389,44 @@ static const match_table_t tokens = {
>  	{Opt_err, NULL},
>  };
>
> +static int parse_recursive_mount_options(char *data)
> +{
> +	substring_t args[MAX_OPT_ARGS];
> +	char *options, *orig;
> +	char *p;
> +	int ret = 0;
> +
> +	/*
> +	 * This is not a remount thread, but we allow recursive mounts
> +	 * with varying RO/RW flag to support subvol-mounts. So error-out
> +	 * if any other option being passed in here.
> +	 */
> +
> +	options = kstrdup(data, GFP_NOFS);
> +	if (!options)
> +		return -ENOMEM;
> +
> +	orig = options;
> +
> +	while ((p = strsep(&options, ",")) != NULL) {
> +		int token;
> +		if (!*p)
> +			continue;
> +
> +		token = match_token(p, tokens, args);
> +		switch(token) {
> +		case Opt_subvol:
> +		case Opt_subvolid:
> +			break;
> +		default:
> +			ret = -EBUSY;
> +		}
> +	}
> +
> +	kfree(orig);
> +	return ret;
> +}
> +
>  /*
>   * Regular mount options parser.  Everything that is needed only when
>   * reading in a new superblock is parsed here.
> @@ -1611,6 +1649,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  		free_fs_info(fs_info);
>  		if ((flags ^ s->s_flags) & MS_RDONLY)
>  			error = -EBUSY;
> +		if (parse_recursive_mount_options(data))
> +			error = -EBUSY;
>  	} else {
>  		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
>  		btrfs_sb(s)->bdev_holder = fs_type;
>
