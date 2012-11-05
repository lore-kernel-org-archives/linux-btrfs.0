Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:59701 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab2KEHjg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Nov 2012 02:39:36 -0500
Message-ID: <50976D36.5050904@jan-o-sch.net>
Date: Mon, 05 Nov 2012 08:39:34 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Anand jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add label to snapshot and subvol
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com> <1351766770-4044-4-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1351766770-4044-4-git-send-email-Anand.Jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

Some comments on your kernel patch from a quick jump through:

On 01.11.2012 11:46, Anand jain wrote:
> From: Anand Jain <anand.jain@oracle.com>
> 
> This modifies the struct btrfs_root_item to hold the label,
> and make it v3 of this structure.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/ctree.h       |   14 ++++++++++++++
>  fs/btrfs/ioctl.c       |   32 ++++++++++++++++++++++++++++++++
>  fs/btrfs/ioctl.h       |    2 ++
>  fs/btrfs/root-tree.c   |   44 +++++++++++++++++++++++---------------------
>  fs/btrfs/transaction.c |    1 +
>  5 files changed, 72 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 994d255..b280256 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -759,6 +759,10 @@ struct btrfs_root_item {
>  	struct btrfs_timespec otime;
>  	struct btrfs_timespec stime;
>  	struct btrfs_timespec rtime;
> +
> +	__le64 generation_v3;

What is that supposed to be?

> +	char label[BTRFS_LABEL_SIZE]; /* Add label to subvol */
> +	
>  	__le64 reserved[8]; /* for future */
>  } __attribute__ ((__packed__));

You can't do that. There's a reason why we've got reserved bytes for
future use. Never change the struct's size.

> @@ -2428,6 +2432,8 @@ BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
>  			 last_snapshot, 64);
>  BTRFS_SETGET_STACK_FUNCS(root_generation_v2, struct btrfs_root_item,
>  			 generation_v2, 64);
> +BTRFS_SETGET_STACK_FUNCS(root_generation_v3, struct btrfs_root_item,
> +			 generation_v3, 64);
>  BTRFS_SETGET_STACK_FUNCS(root_ctransid, struct btrfs_root_item,
>  			 ctransid, 64);
>  BTRFS_SETGET_STACK_FUNCS(root_otransid, struct btrfs_root_item,
> @@ -2441,6 +2447,14 @@ static inline bool btrfs_root_readonly(struct btrfs_root *root)
>  {
>  	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_RDONLY)) != 0;
>  }
> +static inline char * btrfs_root_label(struct btrfs_root *root)
> +{
> +	return (root->root_item.label);
> +}
> +static inline void btrfs_root_set_label(struct btrfs_root *root, char *val)
> +{
> +	memcpy(root->root_item.label,val,BTRFS_LABEL_SIZE);
> +}
>  
>  /* struct btrfs_root_backup */
>  BTRFS_SETGET_STACK_FUNCS(backup_tree_root, struct btrfs_root_backup,
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e58bd9d..cce0128 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3725,6 +3725,34 @@ static int btrfs_ioctl_set_label(struct btrfs_root *root, void __user *arg)
>  	return 0;
>  }
>  
> +static int btrfs_ioctl_subvol_getlabel(struct btrfs_root *root,
> +						void __user *arg)
> +{
> +	char *label;
> +
> +	label = btrfs_root_label(root);
> +	if (copy_to_user(arg, label, BTRFS_LABEL_SIZE))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int btrfs_ioctl_subvol_setlabel(struct btrfs_root *root,
> +						void __user *arg)
> +{
> +	char label[BTRFS_LABEL_SIZE];
> +	struct btrfs_trans_handle *trans;
> +
> +	if (copy_from_user(label, arg, BTRFS_LABEL_SIZE))
> +		return -EFAULT;
> +	trans = btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
> +	btrfs_root_set_label(root, label);
> +	btrfs_commit_transaction(trans, root);

Why use start/commit instead of join/end here?

> +	return 0;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {
> @@ -3827,6 +3855,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_get_label(root, argp);
>  	case BTRFS_IOC_SET_LABEL:
>  		return btrfs_ioctl_set_label(root, argp);
> +	case BTRFS_IOC_SUBVOL_GETLABEL:
> +		return btrfs_ioctl_subvol_getlabel(root, argp);
> +	case BTRFS_IOC_SUBVOL_SETLABEL:
> +		return btrfs_ioctl_subvol_setlabel(root, argp);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 0c60fcb..1009a0c 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -455,4 +455,6 @@ struct btrfs_ioctl_send_args {
>  				      struct btrfs_ioctl_get_dev_stats)
>  #define BTRFS_IOC_GET_LABEL _IOR(BTRFS_IOCTL_MAGIC, 53, __u64)
>  #define BTRFS_IOC_SET_LABEL _IOW(BTRFS_IOCTL_MAGIC, 54, __u64)
> +#define BTRFS_IOC_SUBVOL_GETLABEL _IOWR(BTRFS_IOCTL_MAGIC, 55, __u64)
> +#define BTRFS_IOC_SUBVOL_SETLABEL _IOW(BTRFS_IOCTL_MAGIC, 56, __u64)
>  #endif
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index eb923d0..2a9ae5f 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -35,32 +35,34 @@ void btrfs_read_root_item(struct btrfs_root *root,
>  {
>  	uuid_le uuid;
>  	int len;
> -	int need_reset = 0;
>  
>  	len = btrfs_item_size_nr(eb, slot);
>  	read_extent_buffer(eb, item, btrfs_item_ptr_offset(eb, slot),
>  			min_t(int, len, (int)sizeof(*item)));
> -	if (len < sizeof(*item))
> -		need_reset = 1;
> -	if (!need_reset && btrfs_root_generation(item)
> -		!= btrfs_root_generation_v2(item)) {
> -		if (btrfs_root_generation_v2(item) != 0) {
> -			printk(KERN_WARNING "btrfs: mismatching "
> -					"generation and generation_v2 "
> -					"found in root item. This root "
> -					"was probably mounted with an "
> -					"older kernel. Resetting all "
> -					"new fields.\n");

Please argue why removing this without replacement should be a good idea.

> -		}
> -		need_reset = 1;
> -	}
> -	if (need_reset) {
> -		memset(&item->generation_v2, 0,
> -			sizeof(*item) - offsetof(struct btrfs_root_item,
> -					generation_v2));
>  
> -		uuid_le_gen(&uuid);
> -		memcpy(item->uuid, uuid.b, BTRFS_UUID_SIZE);
> +	/* when len is gt sizeof(*item) that means its downgrade and
> +	   the new members won't be touched anyways
> +	   if len is lt sizeof(*item) its upgrade, we need to take
> +	   care to set/reset newer members.
> +	*/
> +	if (len < sizeof(*item)) {
> +		/* there is an upgrade need to set/reset the new members 
> +		   assume v1 v2 v3 it can be upgrade from
> +			v1 to v2 (set/reset only new members of v2)
> +			v2 to v3 (set/reset only new members of v3)
> +			v1 to v3 (set/reset new to v1)
> +		*/
> +		if (btrfs_root_generation(item) != btrfs_root_generation_v2(item)) {
> +			//memset(&item->generation_v2, 0, 
> +				//sizeof(*item) - offsetof(struct btrfs_root_item, generation_v2));
> +			memset(&item->generation_v2, 0, sizeof(*item) - len);
> +			uuid_le_gen(&uuid);
> +			memcpy(item->uuid, uuid.b, BTRFS_UUID_SIZE);
> +		} else if (btrfs_root_generation_v2(item) != btrfs_root_generation_v3(item)) {
> +			//memset(&item->generation_v3, 0,
> +			//	sizeof(*item) - offsetof(struct btrfs_root_item, generation_v3));
> +			memset(&item->generation_v3, 0, sizeof(*item) - len);
> +		}
>  	}
>  }
>  
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 04bbfb1..45bff43 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1116,6 +1116,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  	btrfs_set_root_otransid(new_root_item, trans->transid);
>  	memset(&new_root_item->stime, 0, sizeof(new_root_item->stime));
>  	memset(&new_root_item->rtime, 0, sizeof(new_root_item->rtime));
> +	memset(new_root_item->label, 0, BTRFS_LABEL_SIZE);
>  	btrfs_set_root_stransid(new_root_item, 0);
>  	btrfs_set_root_rtransid(new_root_item, 0);
>  
> 

-Jan
