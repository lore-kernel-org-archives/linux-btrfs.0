Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:39098 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935167AbeCSRJu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 13:09:50 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [RFC PATCH v3 5/7] btrfs-progs: sub list: Allow normal user to
 call "subvolume list/show"
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
 <124532ad-d4c9-de0f-a277-b8a7dd571fad@jp.fujitsu.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <2f420cf6-4f70-c573-ef7e-6ebf94152370@libero.it>
Date: Mon, 19 Mar 2018 18:09:45 +0100
MIME-Version: 1.0
In-Reply-To: <124532ad-d4c9-de0f-a277-b8a7dd571fad@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/19/2018 08:32 AM, Misono, Tomohiro wrote:
> Allow normal user to call "subvolume list/show" by using 3 new
> unprivileged ioctls (BTRFS_IOC_GET_SUBVOL_INFO,
> BTRFS_IOC_GET_SUBVOL_ROOTREF and BTRFS_IOC_INO_LOOKUP_USER).
> 
> Note that for root, "subvolume list" returns all the subvolume in the
> filesystem by default, but for normal user, it returns subvolumes
> which exist under the specified path (including the path itself).
> The specified path itself is not needed to be a subvolume.
> If the subvolume cannot be opend but the parent directory can be,
> the information other than name or id would be zeroed out.
> 
> Also, for normal user, snapshot filed of "subvolume show" just lists
> the snapshots under the specified subvolume.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  btrfs-list.c     | 344 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  cmds-subvolume.c |   8 ++
>  2 files changed, 341 insertions(+), 11 deletions(-)
> 
> diff --git a/btrfs-list.c b/btrfs-list.c
> index 833ff912..c819499f 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -33,6 +33,7 @@
>  #include <uuid/uuid.h>
>  #include "btrfs-list.h"
>  #include "rbtree-utils.h"
> +#include <sys/queue.h>
>  
>  #define BTRFS_LIST_NFILTERS_INCREASE	(2 * BTRFS_LIST_FILTER_MAX)
>  #define BTRFS_LIST_NCOMPS_INCREASE	(2 * BTRFS_LIST_COMP_MAX)
> @@ -549,6 +550,9 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
>  	int len = 0;
>  	struct root_info *found;
>  
> +	if (ri->full_path != NULL)
> +		return 0;
> +
>  	/*
>  	 * we go backwards from the root_info object and add pathnames
>  	 * from parent directories as we go.
> @@ -672,6 +676,50 @@ static int lookup_ino_path(int fd, struct root_info *ri)
>  	return 0;
>  }
>  
> +/* user version of lookup_ino_path which also cheks the access right */
> +static int lookup_ino_path_user(int fd, struct root_info *ri)
> +{
> +	struct btrfs_ioctl_ino_lookup_user_args args;
> +	int ret = 0;
> +
> +	if (ri->path)
> +		return 0;
> +	if (!ri->ref_tree)
> +		return -ENOENT;
> +
> +	memset(&args, 0, sizeof(args));
> +	args.dirid = ri->dir_id;
> +	args.subvolid = ri->root_id;
> +
> +	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP_USER, &args);
> +	if (ret < 0) {
> +		if (errno == ENOENT) {
> +			ri->ref_tree = 0;
> +			return -ENOENT;
> +		}
> +		if (errno != EACCES) {
> +			error("failed to lookup path for root %llu: %m",
> +			(unsigned long long)ri->ref_tree);
> +			return ret;
> +		} else {
> +			return -EACCES;
> +		}
> +	}
> +
> +	ri->path = malloc(strlen(args.path) + strlen(args.name) + 1);
> +	if (!ri->path)
> +		return -ENOMEM;
> +	strcpy(ri->path, args.path);
> +
> +	ri->name = malloc(strlen(args.name) + 1);
> +	if (!ri->name)
> +		return -ENOMEM;
> +	strcpy(ri->name, args.name);
> +
> +	strcat(ri->path, ri->name);
> +	return ret;
> +}
> +
>  /* finding the generation for a given path is a two step process.
>   * First we use the inode lookup routine to find out the root id
>   *
> @@ -1310,6 +1358,266 @@ static int list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
>  	return 0;
>  }
>  
> +static int fill_subvol_info(struct root_lookup *root_lookup, int fd)
> +{
> +	struct btrfs_ioctl_get_subvol_info_args subvol_info;
> +	u64 root_offset;
> +	int ret;
> +
> +	ret = ioctl(fd, BTRFS_IOC_GET_SUBVOL_INFO, &subvol_info);
> +	if (ret < 0)
> +		return -errno;
> +
> +	if (!uuid_is_null(subvol_info.parent_uuid))
> +		root_offset = subvol_info.otransid;
> +	else
> +		root_offset = 0;
> +
> +	add_root(root_lookup, subvol_info.id, 0,
> +		 root_offset, subvol_info.flags, subvol_info.dirid,
> +		 NULL, 0,
> +		 subvol_info.otransid, subvol_info.generation,
> +		 subvol_info.otime.sec, subvol_info.uuid,
> +		 subvol_info.parent_uuid, subvol_info.received_uuid);
> +
> +	return 0;
> +}
> +
> +static int fill_subvol_info_top(struct root_lookup *root_lookup, int fd)
> +{
> +	struct btrfs_ioctl_get_subvol_info_args subvol_info;
> +	struct root_info *ri;
> +	u64 root_offset;
> +	int ret;
> +
> +	ret = ioctl(fd, BTRFS_IOC_GET_SUBVOL_INFO, &subvol_info);
> +	if (ret < 0)
> +		return -errno;
> +
> +	if (!uuid_is_null(subvol_info.parent_uuid))
> +		root_offset = subvol_info.otransid;
> +	else
> +		root_offset = 0;
> +
> +	add_root(root_lookup, subvol_info.id, subvol_info.parent_id,
> +		 root_offset, subvol_info.flags, subvol_info.dirid,
> +		 subvol_info.name, strlen(subvol_info.name),
> +		 subvol_info.otransid, subvol_info.generation,
> +		 subvol_info.otime.sec, subvol_info.uuid,
> +		 subvol_info.parent_uuid, subvol_info.received_uuid);
> +
> +	/*
> +	 * fill the path since we won't lookup directory/subvolume
> +	 * above this subvolume and cannot use root_lookup()
> +	 */
> +	ri = root_tree_search(root_lookup, subvol_info.id);
> +	ri->top_id = subvol_info.parent_id;
> +	if (subvol_info.id == BTRFS_FS_TREE_OBJECTID) {
> +		ri->path = strdup("/");
> +		ri->name = strdup("<FS_TREE>");
> +		ri->full_path = strdup("/");
> +		if (!ri->path || !ri->name || !ri->full_path)
> +			return -ENOMEM;
> +	} else {
> +		ri->path = malloc(strlen(ri->name + 1));
> +		ri->full_path = malloc(strlen(ri->name + 1));
> +		if (!ri->path || !ri->full_path)
> +			return -ENOMEM;
> +
> +		strcpy(ri->path, ri->name);
> +		strcpy(ri->full_path, ri->name);
> +	}
> +
> +	return 0;
> +}
> +
> +static int fill_rootref(struct root_lookup *root_lookup, int fd, int parent_id)
> +{
> +	struct btrfs_ioctl_get_subvol_rootref_args rootrefs;
> +	bool continue_search = true;
> +	int i, ret;
> +
> +	memset(&rootrefs, 0, sizeof(rootrefs));
> +	while (continue_search) {
> +		ret = ioctl(fd, BTRFS_IOC_GET_SUBVOL_ROOTREF, &rootrefs);
> +		if (ret < 0) {
> +			if (errno != EOVERFLOW)
> +				return -errno;
> +			continue_search = true;
> +		} else {
> +			continue_search = false;
> +		}
> +
> +		for (i = 0; i < rootrefs.num_items; i++) {
> +			add_root(root_lookup, rootrefs.rootref[i].subvolid,
> +			    parent_id, 0, 0, rootrefs.rootref[i].dirid,
> +			    NULL, 0, 0, 0, 0, NULL, NULL, NULL);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int list_subvol_user(int top_fd, struct root_lookup *root_lookup,
> +				const char *path)
> +{
> +	struct root_info *ri, *parent;
> +	struct rb_node *n;
> +	char *fullpath;
> +	u64 top_id;
> +	/* fifo queue entry which holds subvolume's id */
> +	struct queue_entry {
> +		u64 id;
> +
> +		STAILQ_ENTRY(queue_entry) entries;
> +	} *e, *etemp;
> +	int fd;
> +	int ret = 0;
> +
> +	root_lookup->root.rb_node = NULL;
> +
> +	ret = btrfs_list_get_path_rootid(top_fd, &top_id);
> +	if (ret)
> +		return ret;
> +
> +	/* Add top_id to the queue */
> +	STAILQ_HEAD(slistead, queue_entry) head = STAILQ_HEAD_INITIALIZER(head);
> +	STAILQ_INIT(&head);
> +	e = malloc(sizeof(struct queue_entry));
> +	if (!e)
> +		return -ENOMEM;
> +	e->id = top_id;
> +	STAILQ_INSERT_TAIL(&head, e, entries);
> +
> +	/*
> +	 * Iterate until queue is empty:
> +	 * 1. Pop the first entry
> +	 * 2. Open the entry's path
> +	 * 3  Get the subvolume information by fill_subvol_info/fill_rootref
> +	 * 4. Iterate over rb_tree:
> +	 * 4-1. Searth the rb_tree whose ref_tree is e->id
> +	 *    (this means the subvolume exists under e->id's subvolume)
> +	 * 4-2. Call ino_lookup_user ioctl
> +	 * 4-3. If the call succeeds, add the subvolume id to the queue
> +	 */
> +	while (!STAILQ_EMPTY(&head)) {
> +		e = STAILQ_FIRST(&head);
> +		STAILQ_REMOVE_HEAD(&head, entries);
> +
> +		if (e->id == top_id) {
> +			fd = top_fd;
> +			ret = fill_subvol_info_top(root_lookup, fd);
> +			if (ret)
> +				goto err;
> +			ret = fill_rootref(root_lookup, fd, e->id);
> +			if (ret)
> +				goto err;
> +		} else {
> +			parent = root_tree_search(root_lookup, e->id);
> +			resolve_root(root_lookup, parent, top_id);
> +			fd = openat(top_fd, parent->full_path, O_RDONLY);
> +			if (fd == -1) {
> +				if (errno == EACCES) {
> +					/* skip this subvolume */
> +					continue;
> +				} else {
> +					error("error at open %s: %m",
> +							parent->full_path);
> +					goto err;
> +				}
> +			}
> +
> +			ret = fill_subvol_info(root_lookup, fd);
> +			if (ret)
> +				goto err;
> +			ret = fill_rootref(root_lookup, fd, e->id);
> +			if (ret)
> +				goto err;
> +		}
> +
> +		n = rb_first(&root_lookup->root);
> +		while (n) {
> +			ri = rb_entry(n, struct root_info, rb_node);
> +			if (ri->ref_tree == 0) {
> +			/* BTRFS_FS_TREE_OBJECTID or deleted subvolume */
> +				n = rb_next(n);
> +				continue;
> +			}
> +
> +			if (ri->ref_tree == e->id) {
> +				ret = lookup_ino_path_user(fd, ri);
> +				if (ret < 0 && ret != -ENOENT && ret != -EACCES)
> +					goto err;
> +
> +				/* add ths subvol id to queue */
> +				if (!ret) {
> +					etemp = malloc(sizeof(struct queue_entry));
> +
> +					if (!etemp) {
> +						ret = -ENOMEM;
> +						goto err;
> +					}
> +					etemp->id = ri->root_id;
> +					STAILQ_INSERT_TAIL(&head, etemp,
> +					    entries);
> +				}
> +			}
> +			n = rb_next(n);
> +		}
> +
> +		if (fd != top_fd)
> +			close(fd);
> +		free(e);
> +	}
> +
> +	/* If the specified path itself is not a subvolume, remove the entry */
> +	fullpath = realpath(path, NULL);
> +	if (!fullpath) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +	ret = test_issubvolume(fullpath);
> +	free(fullpath);
> +	if (ret < 0)
> +		goto err;
> +
> +	if (!ret) {
> +		ri = root_tree_search(root_lookup, top_id);
> +		rb_erase(&ri->rb_node, &root_lookup->root);
> +		free_root_info(&ri->rb_node);
> +	}
> +
> +	/* remove skipped entries */
> +	n = rb_first(&root_lookup->root);
> +	while (n) {
> +		ri = rb_entry(n, struct root_info, rb_node);
> +		if (!ri->path) {
> +			struct rb_node *next = rb_next(n);
> +
> +			rb_erase(n, &root_lookup->root);
> +			free_root_info(n);
> +			n = next;
> +		} else {
> +			n = rb_next(n);
> +		}
> +	}
> +
> +	return 0;
> +
> +err:
> +	if (fd != -1 && fd != top_fd)
> +		close(fd);
> +
> +	/* free remaining queue entries */
> +	while (!STAILQ_EMPTY(&head)) {
> +		e = STAILQ_FIRST(&head);
> +		STAILQ_REMOVE_HEAD(&head, entries);
> +		free(e);
> +	}
> +
> +	return ret;
> +}
> +
>  static void print_subvolume_column(struct root_info *subv,
>  				   enum btrfs_list_column_enum column)
>  {
> @@ -1492,19 +1800,33 @@ next:
>  static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup,
>  			const char *path)
>  {
> +	uid_t uid;
>  	int ret;
>  
> -	ret = list_subvol_search(fd, root_lookup);
> -	if (ret) {
> -		error("can't perform the search: %m");
> -		return ret;
> +	uid = geteuid();
> +	if (!uid) {

A minor tip: I think uid == 0 is better here, because we should check that uid is root

> +		ret = list_subvol_search(fd, root_lookup);
> +		if (ret) {
> +			error("can't perform the search: %s", strerror(-ret));
> +			return ret;
> +		}
> +		/*
> +		 * now we have an rbtree full of root_info objects, but we
> +		 * need to fill in their path names within the subvol that
> +		 * is referencing each one.
> +		 */
> +		ret = list_subvol_fill_paths(fd, root_lookup);
> +	} else {
> +		ret = list_subvol_user(fd, root_lookup, path);
> +		if (ret) {
> +			if (ret == -ENOTTY)
> +error("can't perform the search: Operation by non-privileged user is not supported by this kernel.");
> +			else
> +				error("can't perform the search: %s",
> +						    strerror(-ret));
> +		}

Sorry for noticing that only now: which is the reason to not using the new api also in "root" case? I know that the behavior is a bit different, so my question is: it is possible to extend the new ioctls to support also the old behavior in the root case? So we could get rid of the "tree search" ioctl, using it only for the old kernel

>  	}
>  
> -	/*
> -	 * now we have an rbtree full of root_info objects, but we need to fill
> -	 * in their path names within the subvol that is referencing each one.
> -	 */
> -	ret = list_subvol_fill_paths(fd, root_lookup);
>  	return ret;
>  }
>  
> @@ -1598,12 +1920,12 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri, const char *path)
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
> +		if (rr == -ENOENT || uuid_is_null(ri->uuid)) {
>  			rbn = rb_next(rbn);
>  			continue;
>  		}
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index faa10c5a..68de7db7 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -488,6 +488,7 @@ static int cmd_subvol_list(int argc, char **argv)
>  	int is_only_in_path = 0;
>  	DIR *dirstream = NULL;
>  	enum btrfs_list_layout layout = BTRFS_LIST_LAYOUT_DEFAULT;
> +	uid_t uid;
>  
>  	filter_set = btrfs_list_alloc_filter_set();
>  	comparer_set = btrfs_list_alloc_comparer_set();
> @@ -596,6 +597,13 @@ static int cmd_subvol_list(int argc, char **argv)
>  		goto out;
>  	}
>  
> +	uid = geteuid();
> +	if (uid != 0 && is_list_all) {
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
