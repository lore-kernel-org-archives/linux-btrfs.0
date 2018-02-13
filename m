Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49745 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933612AbeBMO06 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 09:26:58 -0500
Subject: Re: [PATCH] btrfs: manage thread_pool mount option as %u
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180213095048.9550-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <12714050-aece-8bfd-2e83-ef5da4590c81@suse.com>
Date: Tue, 13 Feb 2018 16:26:55 +0200
MIME-Version: 1.0
In-Reply-To: <20180213095048.9550-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.02.2018 11:50, Anand Jain wrote:
> -o thread_pool is alway unsigned. Manage it that way all around.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/ctree.h   |  2 +-
>  fs/btrfs/disk-io.c |  4 ++--
>  fs/btrfs/super.c   | 13 ++++++-------
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0b738f0a9a23..23b7e6756b15 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -935,7 +935,7 @@ struct btrfs_fs_info {
>  	struct btrfs_workqueue *extent_workers;
>  	struct task_struct *transaction_kthread;
>  	struct task_struct *cleaner_kthread;
> -	int thread_pool_size;
> +	u32 thread_pool_size;
>  
>  	struct kobject *space_info_kobj;
>  
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 87d24c903152..3cec2455b603 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2180,7 +2180,7 @@ static void btrfs_init_qgroup(struct btrfs_fs_info *fs_info)
>  static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info,
>  		struct btrfs_fs_devices *fs_devices)
>  {
> -	int max_active = fs_info->thread_pool_size;
> +	u32 max_active = fs_info->thread_pool_size;
>  	unsigned int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
>  
>  	fs_info->workers =
> @@ -2401,7 +2401,7 @@ int open_ctree(struct super_block *sb,
>  	int err = -EINVAL;
>  	int num_backups_tried = 0;
>  	int backup_index = 0;
> -	int max_active;
> +	u32 max_active;
>  	int clear_free_space_tree = 0;
>  
>  	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 02c7766e6849..8112619cac95 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -346,7 +346,7 @@ static const match_table_t tokens = {
>  	{Opt_barrier, "barrier"},
>  	{Opt_max_inline, "max_inline=%u"},
>  	{Opt_alloc_start, "alloc_start=%s"},
> -	{Opt_thread_pool, "thread_pool=%d"},
> +	{Opt_thread_pool, "thread_pool=%u"},
>  	{Opt_compress, "compress"},
>  	{Opt_compress_type, "compress=%s"},
>  	{Opt_compress_force, "compress-force"},
> @@ -596,12 +596,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  			ret = match_int(&args[0], &intarg);
>  			if (ret) {
>  				goto out;
> -			} else if (intarg > 0) {
> -				info->thread_pool_size = intarg;
> -			} else {
> +			} else if (intarg == 0) {

One thing I'm worried about is the fact that match_int parses a signed
int. So If someone pases -1 then it would be parsed to -1 but when you
set it to thread_pool_size the actual value is going to be the 2's
complement of the value i.e. a very large number. So a check for intarg
< 0 is required to avoid that. Same applies to your other patches

>  				ret = -EINVAL;
>  				goto out;
>  			}
> +			info->thread_pool_size = intarg;
>  			break;
>  		case Opt_max_inline:
>  			ret = match_int(&args[0], &intarg);
> @@ -1317,7 +1316,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
>  		seq_printf(seq, ",max_inline=%u", info->max_inline);
>  	if (info->thread_pool_size !=  min_t(unsigned long,
>  					     num_online_cpus() + 2, 8))
> -		seq_printf(seq, ",thread_pool=%d", info->thread_pool_size);
> +		seq_printf(seq, ",thread_pool=%u", info->thread_pool_size);
>  	if (btrfs_test_opt(info, COMPRESS)) {
>  		compress_type = btrfs_compress_type2str(info->compress_type);
>  		if (btrfs_test_opt(info, FORCE_COMPRESS))
> @@ -1723,7 +1722,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  }
>  
>  static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
> -				     int new_pool_size, int old_pool_size)
> +				     u32 new_pool_size, u32 old_pool_size)
>  {
>  	if (new_pool_size == old_pool_size)
>  		return;
> @@ -1791,7 +1790,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  	unsigned long old_opts = fs_info->mount_opt;
>  	unsigned long old_compress_type = fs_info->compress_type;
>  	u32 old_max_inline = fs_info->max_inline;
> -	int old_thread_pool_size = fs_info->thread_pool_size;
> +	u32 old_thread_pool_size = fs_info->thread_pool_size;
>  	unsigned int old_metadata_ratio = fs_info->metadata_ratio;
>  	int ret;
>  
> 
