Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57280 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752329AbdLLUMP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 15:12:15 -0500
Date: Tue, 12 Dec 2017 21:10:14 +0100
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, anand.jain@oracle.com
Subject: Re: [PATCH 3/4] btrfs: split parse_early_options() in two
Message-ID: <20171212201014.GZ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4786f7cc-adc7-1b99-5abf-d068acee56c2@jp.fujitsu.com>
 <bdace123-46f7-9381-4421-c96615e5bd35@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bdace123-46f7-9381-4421-c96615e5bd35@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 25, 2017 at 04:28:36PM +0900, Misono, Tomohiro wrote:
> Now parse_early_options() is used by both btrfs_mount() and mount_root().
> However, the former only needs subvol related part and the latter needs
> the others.
> 
> Therefore extract the subvol related parts from parse_early_options() and
> move it to new parse function (parse_subvol_options()).
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  fs/btrfs/super.c | 85 +++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 60 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 1c34ca6..7edd74d 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -448,7 +448,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  		case Opt_subvolrootid:
>  		case Opt_device:
>  			/*
> -			 * These are parsed by btrfs_parse_early_options
> +			 * These are parsed by btrfs_parse_subvol_options
> +			 * and btrfs_parse_early_options
>  			 * and can be happily ignored here.
>  			 */
>  			break;
> @@ -855,11 +856,63 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   * only when we need to allocate a new super block.
>   */
>  static int btrfs_parse_early_options(const char *options, fmode_t flags,
> -		void *holder, char **subvol_name, u64 *subvol_objectid,
> -		struct btrfs_fs_devices **fs_devices)
> +		void *holder, struct btrfs_fs_devices **fs_devices)
>  {
>  	substring_t args[MAX_OPT_ARGS];
>  	char *device_name, *opts, *orig, *p;
> +	int error = 0;
> +
> +	if (!options)
> +		return 0;
> +
> +	/*
> +	 * strsep changes the string, duplicate it because btrfs_parse_options
> +	 * gets called later
> +	 */
> +	opts = kstrdup(options, GFP_KERNEL);
> +	if (!opts)
> +		return -ENOMEM;
> +	orig = opts;
> +
> +	while ((p = strsep(&opts, ",")) != NULL) {
> +		int token;
> +		if (!*p)
> +			continue;
> +
> +		token = match_token(p, tokens, args);
> +		switch (token) {
> +		case Opt_device:

Please rewrite this as a simple 'if'.

> +			device_name = match_strdup(&args[0]);
> +			if (!device_name) {
> +				error = -ENOMEM;
> +				goto out;
> +			}
> +			error = btrfs_scan_one_device(device_name,
> +					flags, holder, fs_devices);
> +			kfree(device_name);
> +			if (error)
> +				goto out;
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +
> +out:
> +	kfree(orig);
> +	return error;
> +}
> +
> +/*
> + * Parse mount options that are related to subvolume id
> + *
> + * The value is later passed to mount_subvol()
> + */
> +static int btrfs_parse_subvol_options(const char *options, fmode_t flags,
> +		void *holder, char **subvol_name, u64 *subvol_objectid)
> +{
> +	substring_t args[MAX_OPT_ARGS];
> +	char *opts, *orig, *p;
>  	char *num = NULL;
>  	int error = 0;
>  
> @@ -867,8 +920,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>  		return 0;
>  
>  	/*
> -	 * strsep changes the string, duplicate it because parse_options
> -	 * gets called twice
> +	 * strsep changes the string, duplicate it because
> +	 * btrfs_parse_early_options gets called later
>  	 */
>  	opts = kstrdup(options, GFP_KERNEL);
>  	if (!opts)
> @@ -907,18 +960,6 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>  		case Opt_subvolrootid:
>  			pr_warn("BTRFS: 'subvolrootid' mount option is deprecated and has no effect\n");
>  			break;
> -		case Opt_device:
> -			device_name = match_strdup(&args[0]);
> -			if (!device_name) {
> -				error = -ENOMEM;
> -				goto out;
> -			}
> -			error = btrfs_scan_one_device(device_name,
> -					flags, holder, fs_devices);
> -			kfree(device_name);
> -			if (error)
> -				goto out;
> -			break;
>  		default:
>  			break;
>  		}
> @@ -1492,18 +1533,14 @@ static struct dentry *mount_root(struct file_system_type *fs_type, int flags,
>  	struct btrfs_fs_info *fs_info = NULL;
>  	struct security_mnt_opts new_sec_opts;
>  	fmode_t mode = FMODE_READ;
> -	char *subvol_name = NULL;
> -	u64 subvol_objectid = 0;
>  	int error = 0;
>  
>  	if (!(flags & MS_RDONLY))
>  		mode |= FMODE_WRITE;
>  
>  	error = btrfs_parse_early_options(data, mode, fs_type,
> -					  &subvol_name, &subvol_objectid,
>  					  &fs_devices);
>  	if (error) {
> -		kfree(subvol_name);
>  		return ERR_PTR(error);
>  	}
>  
> @@ -1614,7 +1651,6 @@ static struct dentry *mount_root(struct file_system_type *fs_type, int flags,
>  static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  		const char *device_name, void *data)
>  {
> -	struct btrfs_fs_devices *fs_devices = NULL;
>  	struct vfsmount *mnt_root;
>  	struct dentry *root;
>  	fmode_t mode = FMODE_READ;
> @@ -1625,9 +1661,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  	if (!(flags & MS_RDONLY))
>  		mode |= FMODE_WRITE;
>  
> -	error = btrfs_parse_early_options(data, mode, fs_type,
> -					  &subvol_name, &subvol_objectid,
> -					  &fs_devices);
> +	error = btrfs_parse_subvol_options(data, mode, fs_type,
> +					  &subvol_name, &subvol_objectid);
>  	if (error) {
>  		kfree(subvol_name);
>  		return ERR_PTR(error);
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
