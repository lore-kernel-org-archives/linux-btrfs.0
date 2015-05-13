Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:60651 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752868AbbEMQly (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 12:41:54 -0400
Message-ID: <55537ED2.2050801@inwind.it>
Date: Wed, 13 May 2015 18:41:54 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: make root id query unprivileged
References: <1431450889-27968-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1431450889-27968-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 2015-05-12 19:14, David Sterba wrote:
> The INO_LOOKUP ioctl can lookup path for a given inode number and is
> thus restricted. As a sideefect it can find the root id of the
> containing subvolume and we're using this int the 'btrfs inspect rootid'
> command.
> 
> The restriction is unnecessary in case we set the ioctl args
>  args::treeid    = 0
>  args::objectid  = 256 (BTRFS_FIRST_FREE_OBJECTID)
> 
> Then the path will be empty and the treeid is filled with the root id of
> the inode on which the ioctl is called. This behaviour is unchanged,
> after the root restriction is removed.


I think that make sense to add another ioctl instead of relaxing the privilege check
on the basis of the parameters.

If I read correctly the code, in this case the function 
btrfs_search_path_in_tree() is not even called: it is requested to return only 

	BTRFS_I(inode)->root->root_key.objectid;

Goffredo

> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
> 
>  fs/btrfs/ioctl.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 1c22c6518504..578ff63a9b74 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2271,10 +2271,7 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
>  {
>  	 struct btrfs_ioctl_ino_lookup_args *args;
>  	 struct inode *inode;
> -	 int ret;
> -
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> +	int ret = 0;
>  
>  	args = memdup_user(argp, sizeof(*args));
>  	if (IS_ERR(args))
> @@ -2282,13 +2279,28 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
>  
>  	inode = file_inode(file);
>  
> +	/*
> +	 * Unprivileged query to obtain the containing subvolume root id. The
> +	 * path is reset so it's consistent with btrfs_search_path_in_tree.
> +	 */
>  	if (args->treeid == 0)
>  		args->treeid = BTRFS_I(inode)->root->root_key.objectid;
>  
> +	if (args->objectid == BTRFS_FIRST_FREE_OBJECTID) {
> +		args->name[0] = 0;
> +		goto out;
> +	}
> +
> +	if (!capable(CAP_SYS_ADMIN)) {
> +		ret = -EPERM;
> +		goto out;
> +	}
> +
>  	ret = btrfs_search_path_in_tree(BTRFS_I(inode)->root->fs_info,
>  					args->treeid, args->objectid,
>  					args->name);
>  
> +out:
>  	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
>  		ret = -EFAULT;
>  
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
