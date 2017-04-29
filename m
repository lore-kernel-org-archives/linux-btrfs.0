Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35946 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165189AbdD2F1F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Apr 2017 01:27:05 -0400
Received: by mail-lf0-f67.google.com with SMTP id 75so8817604lfs.3
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 22:27:04 -0700 (PDT)
Subject: Re: [PATCH] btrfs: check options during subsequent mount
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20170428091409.19621-1-anand.jain@oracle.com>
Cc: dsterba@suse.cz
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <e554523d-0c30-fb5b-a186-6732f320753a@gmail.com>
Date: Sat, 29 Apr 2017 08:26:56 +0300
MIME-Version: 1.0
In-Reply-To: <20170428091409.19621-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1251
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

28.04.2017 12:14, Anand Jain пишет:
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

But if subvol= was passed, it should not reach this place at all -
btrfs_mount() returns earlier in

        if (subvol_name || subvol_objectid != BTRFS_FS_TREE_OBJECTID) {
                /* mount_subvol() will free subvol_name. */
                return mount_subvol(subvol_name, subvol_objectid, flags,
                                    device_name, data);
        }

So check for subvol here seems redundant.

>  	} else {
>  		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
>  		btrfs_sb(s)->bdev_holder = fs_type;
> 

