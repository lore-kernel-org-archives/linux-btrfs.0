Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47513 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752015AbeAaIGa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 03:06:30 -0500
Subject: Re: [PATCH 1/2] btrfs: add mount option read_mirror_policy
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180130063020.14850-1-anand.jain@oracle.com>
 <20180130063020.14850-2-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f55fe4f5-cf50-d251-e147-3d6b6d20f496@suse.com>
Date: Wed, 31 Jan 2018 10:06:26 +0200
MIME-Version: 1.0
In-Reply-To: <20180130063020.14850-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.01.2018 08:30, Anand Jain wrote:
> In case of RAID1 and RAID10 devices are mirror-ed, a read IO can
> pick any device for reading. This choice of picking a device for
> reading should be configurable. In short not one policy would
> satisfy all types of workload and configs.
> 
> So before we add more policies, this patch-set makes existing
> $pid policy configurable from the mount option.
> 
> For example..
>   mount -o read_mirror_policy=pid (which is also default)
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/ctree.h   |  2 ++
>  fs/btrfs/super.c   | 10 ++++++++++
>  fs/btrfs/volumes.c |  8 +++++++-
>  fs/btrfs/volumes.h |  5 +++++
>  4 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 1a462ab85c49..4759e988b0df 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1100,6 +1100,8 @@ struct btrfs_fs_info {
>  	spinlock_t ref_verify_lock;
>  	struct rb_root block_tree;
>  #endif
> +	/* Policy to balance read across mirrored devices */
> +	int read_mirror_policy;

make that member enum btrfs_read_mirror_type

>  };
>  
>  static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 367ecbf477b9..dfe6b3c67df3 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -329,6 +329,7 @@ enum {
>  #ifdef CONFIG_BTRFS_FS_REF_VERIFY
>  	Opt_ref_verify,
>  #endif
> +	Opt_read_mirror_policy,
>  	Opt_err,
>  };
>  
> @@ -393,6 +394,7 @@ static const match_table_t tokens = {
>  #ifdef CONFIG_BTRFS_FS_REF_VERIFY
>  	{Opt_ref_verify, "ref_verify"},
>  #endif
> +	{Opt_read_mirror_policy, "read_mirror_policy=%s"},
>  	{Opt_err, NULL},
>  };
>  
> @@ -839,6 +841,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  			btrfs_set_opt(info->mount_opt, REF_VERIFY);
>  			break;
>  #endif
> +		case Opt_read_mirror_policy:
> +			if (strcmp(args[0].from, "pid") == 0) {
> +				info->read_mirror_policy =
> +					BTRFS_READ_MIRROR_BY_PID;
> +				break;
> +			}
> +			ret = -EINVAL;
> +			goto out;
>  		case Opt_err:
>  			btrfs_info(info, "unrecognized mount option '%s'", p);
>  			ret = -EINVAL;
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a61715677b67..39ba59832f38 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5269,7 +5269,13 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  	else
>  		num = map->num_stripes;
>  
> -	optimal = first + current->pid % num;
> +	switch(fs_info->read_mirror_policy) {
> +	case BTRFS_READ_MIRROR_DEFAULT:
> +	case BTRFS_READ_MIRROR_BY_PID:
> +	default:
> +		optimal = first + current->pid % num;
> +		break;
> +	}

Why not factor out this code in a separate function with descriptive
name and some documentation. It seems you have plans how to extend this
mechanism further so let's try and make it maintainable from the get-go.

>  
>  	if (dev_replace_is_ongoing &&
>  	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 28c28eeadff3..78f35d299a61 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -47,6 +47,11 @@ struct btrfs_pending_bios {
>  #define btrfs_device_data_ordered_init(device) do { } while (0)
>  #endif
>  
> +enum btrfs_read_mirror_type {
> +	BTRFS_READ_MIRROR_DEFAULT,
> +	BTRFS_READ_MIRROR_BY_PID,
> +};
> +
>  #define BTRFS_DEV_STATE_WRITEABLE	(0)
>  #define BTRFS_DEV_STATE_IN_FS_METADATA	(1)
>  #define BTRFS_DEV_STATE_MISSING		(2)
> 
