Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:60127 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752603AbeCQNXT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Mar 2018 09:23:19 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [RFC PATCH v2 6/8] btrfs-progs: sub list: Allow normal user to
 call "subvolume list/show"
Reply-To: kreijack@inwind.it
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <226b6805-c5aa-c40d-4ea6-f81dc1b7de20@jp.fujitsu.com>
 <d02c973d-5ebc-46e4-f2a7-bd89da24e46d@jp.fujitsu.com>
Message-ID: <d1839d67-2ab5-d07b-e459-318bdcd3bd16@libero.it>
Date: Sat, 17 Mar 2018 14:23:16 +0100
MIME-Version: 1.0
In-Reply-To: <d02c973d-5ebc-46e4-f2a7-bd89da24e46d@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/15/2018 09:15 AM, Misono, Tomohiro wrote:
> Allow normal user to call "subvolume list/show" by using 3 new
> unprivileged ioctls (BTRFS_IOC_GET_SUBVOL_INFO,
> BTRFS_IOC_GET_SUBVOL_ROOTREF and BTRFS_IOC_INO_LOOKUP_USER).
> 
> Note that for root, "subvolume list" returns all the subvolume in the
> filesystem by default, but for normal user, it returns subvolumes
> which exist under the specified path (including the path itself).

I found the original "btrfs sub list" behavior quite confusing. I think that the problem is that the output is too technical. And the '-a' switch increase this confusion. May be that I am no smart enough :(

The "normal user behavior" seems to me more coherent. However I am not sure that this differences should be acceptable. In any case it should be tracked in the man page.

Time to add another command (something like "btrfs sub ls") with a more "human friendly" output ?

> The specified path itself is not needed to be a subvolume.
> If the subvolume cannot be opened but the parent directory can be,
> the information other than name or id would be zeroed out.
> 
> Also, for normal user, snapshot filed of "subvolume show" just lists
> the snapshots under the specified subvolume.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  btrfs-list.c     | 326 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  cmds-subvolume.c |  13 +++
>  2 files changed, 332 insertions(+), 7 deletions(-)
> 

[....]

>  static void print_subvolume_column(struct root_info *subv,
>  				   enum btrfs_list_column_enum column)
>  {
> @@ -1527,17 +1826,28 @@ static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup,
>  {
>  	int ret;
>  
> -	ret = list_subvol_search(fd, root_lookup);
> -	if (ret) {
> -		error("can't perform the search: %m");
> -		return ret;
> +	ret = check_perm_for_tree_search(fd);
> +	if (ret < 0) {
> +		error("can't check the permission for tree search: %s",
> +				strerror(-ret));
> +		return -1;
>  	}
>  
>  	/*
>  	 * now we have an rbtree full of root_info objects, but we need to fill
>  	 * in their path names within the subvol that is referencing each one.
>  	 */
> -	ret = list_subvol_fill_paths(fd, root_lookup);
> +	if (ret) {
> +		ret = list_subvol_search(fd, root_lookup);
> +		if (ret) {
> +			error("can't perform the search: %s", strerror(-ret));
> +			return ret;
> +		}
> +		ret = list_subvol_fill_paths(fd, root_lookup);
> +	} else {
> +		ret = list_subvol_user(fd, root_lookup, path);
> +	}
> +
>  	return ret;

I think that the check above should be refined: if I run "btrfs sub list" patched in a kernel without patch I don't get any error and/or warning:

ghigo@venice:~/btrfs/btrfs-progs$ # kernel w/o patch; btrfs-progs w/patch
ghigo@venice:~/btrfs/btrfs-progs$ ./btrfs sub list /
ghigo@venice:~/btrfs/btrfs-progs$ # kernel w/o patch; btrfs-progs w/o patch
ghigo@venice:~/btrfs/btrfs-progs$ btrfs sub list /
ERROR: can't perform the search: Operation not permitted

I think that in both case an error should be raised


>  }
>  
> @@ -1631,12 +1941,14 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri, const char *path)
>  		return ret;
>  	}
>  
> +	ret = -ENOENT;
>  	rbn = rb_first(&rl.root);
>  	while(rbn) {
>  		ri = rb_entry(rbn, struct root_info, rb_node);
>  		rr = resolve_root(&rl, ri, root_id);
> -		if (rr == -ENOENT) {
> -			ret = -ENOENT;
> +		if (rr == -ENOENT ||
> +		    ri->root_id == BTRFS_FS_TREE_OBJECTID ||
> +		    uuid_is_null(ri->uuid)) {
>  			rbn = rb_next(rbn);
>  			continue;
>  		}
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index faa10c5a..7a7c6f3b 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -596,6 +596,19 @@ static int cmd_subvol_list(int argc, char **argv)
>  		goto out;
>  	}
>  
> +	ret = check_perm_for_tree_search(fd);
> +	if (ret < 0) {
> +		ret = -1;
> +		error("can't check the permission for tree search: %s",
> +				strerror(-ret));
> +		goto out;
> +	}
> +	if (!ret && is_list_all) {
> +		ret = -1;
> +		error("only root can use -a option");
> +		goto out;
> +	}
> +
>  	if (flags)
>  		btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_FLAGS,
>  					flags);
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

