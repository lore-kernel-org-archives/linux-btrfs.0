Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51895 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab2JRCAD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Oct 2012 22:00:03 -0400
Message-ID: <507F62B8.9090607@cn.fujitsu.com>
Date: Thu, 18 Oct 2012 10:00:24 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: [PATCH] Btrfs-progs: Filter out deleting or already-deleted subvolumes
 in lookup_ino_path.
References: <CAOcd+r2VUEjti7uNht-vaa603ZHE5XDXUdW1zODhrfO4iPMxUA@mail.gmail.com>
In-Reply-To: <CAOcd+r2VUEjti7uNht-vaa603ZHE5XDXUdW1zODhrfO4iPMxUA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 17 Oct 2012 18:06:52 +0200, Alex Lyakas wrote:
> -static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
> +static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup,
> +	struct root_lookup *root_lookup_final)
>  {
>  	struct rb_node *n;
> 
> +	root_lookup_init(root_lookup_final);
> +
>  	n = rb_first(&root_lookup->root);
>  	while (n) {
>  		struct root_info *entry;
>  		int ret;
>  		entry = rb_entry(n, struct root_info, rb_node);
>  		ret = lookup_ino_path(fd, entry);
> -		if(ret < 0)
> +		if(ret < 0 && ret != -ENOENT)
>  			return ret;
> -		n = rb_next(n);
> +		rb_erase(&entry->rb_node, &root_lookup->root);
> +		/*
> +		 * If lookup_ino_path() returned ENOENT, some of the path
> +		 * components are missing. Let's consider this subvolume
> +		 * as deleted then.
> +		 */
> +		if (ret == -ENOENT)
> +			__free_root_info(entry);
> +		else
> +			root_tree_insert(root_lookup_final, entry);
> +		n = rb_first(&root_lookup->root);

I don't think we need a final rb-tree since we have removed the deleted root entries from
the tree and freed them.

Beside that, this patch didn't fix the problem completely. Consider the following case:
Subv0
  |-> Subv1
	|-> Subv2

When we fill the path, we may deal with Subv2 firstly, and then deal with Subv1. But 
if someone deletes Subv2 and Subv1 after we fill the path of Subv2 and before we fill
the path of Subv1, we may deal with Subv2 successfully, then we will find Subv1 has been
deleted, so we will clean up Subv2 entry. If so, we will fail to resolve the full path of
Subv2 because we can not find Subv1.

My partner made a patch which can fix the above problem, I will send it out later.

Thanks
Miao

>  	}
> 
>  	return 0;
> @@ -1446,6 +1472,7 @@ int btrfs_list_subvols(int fd, struct
> btrfs_list_filter_set *filter_set,
>  		       int is_tab_result)
>  {
>  	struct root_lookup root_lookup;
> +	struct root_lookup root_lookup_final;
>  	struct root_lookup root_sort;
>  	int ret;
> 
> @@ -1460,15 +1487,15 @@ int btrfs_list_subvols(int fd, struct
> btrfs_list_filter_set *filter_set,
>  	 * now we have an rbtree full of root_info objects, but we need to fill
>  	 * in their path names within the subvol that is referencing each one.
>  	 */
> -	ret = __list_subvol_fill_paths(fd, &root_lookup);
> +	ret = __list_subvol_fill_paths(fd, &root_lookup, &root_lookup_final);
>  	if (ret < 0)
>  		return ret;
> 
> -	__filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
> +	__filter_and_sort_subvol(&root_lookup_final, &root_sort, filter_set,
>  				 comp_set, fd);
> 
>  	print_all_volume_info(&root_sort, is_tab_result);
> -	__free_all_subvolumn(&root_lookup);
> +	__free_all_subvolumn(&root_lookup_final);
>  	return ret;
>  }
> 
> @@ -1655,6 +1682,7 @@ int btrfs_list_find_updated_files(int fd, u64
> root_id, u64 oldest_gen)
>  char *btrfs_list_path_for_root(int fd, u64 root)
>  {
>  	struct root_lookup root_lookup;
> +	struct root_lookup root_lookup_final;
>  	struct rb_node *n;
>  	char *ret_path = NULL;
>  	int ret;
> @@ -1664,16 +1692,16 @@ char *btrfs_list_path_for_root(int fd, u64 root)
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> 
> -	ret = __list_subvol_fill_paths(fd, &root_lookup);
> +	ret = __list_subvol_fill_paths(fd, &root_lookup, &root_lookup_final);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> 
> -	n = rb_last(&root_lookup.root);
> +	n = rb_last(&root_lookup_final.root);
>  	while (n) {
>  		struct root_info *entry;
> 
>  		entry = rb_entry(n, struct root_info, rb_node);
> -		resolve_root(&root_lookup, entry, top_id);
> +		resolve_root(&root_lookup_final, entry, top_id);
>  		if (entry->root_id == root) {
>  			ret_path = entry->full_path;
>  			entry->full_path = NULL;
> @@ -1681,7 +1709,7 @@ char *btrfs_list_path_for_root(int fd, u64 root)
> 
>  		n = rb_prev(n);
>  	}
> -	__free_all_subvolumn(&root_lookup);
> +	__free_all_subvolumn(&root_lookup_final);
> 
>  	return ret_path;
>  }
> 


