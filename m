Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:46005 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3AVVxe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 16:53:34 -0500
Received: from eastrmimpo110 ([68.230.241.223]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122215333.QEPV6475.eastrmfepo202.cox.net@eastrmimpo110>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 16:53:33 -0500
Message-ID: <50FF0A5C.1040104@czarc.net>
Date: Tue, 22 Jan 2013 16:53:32 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: chris.mason@fusionio.com, jbacik@fusionio.com
Subject: Re: [PATCH 4/6] Fedora 18 - modified valgrind.patch
References: <1358618781-26629-1-git-send-email-gene@czarc.net> <1358618781-26629-5-git-send-email-gene@czarc.net>
In-Reply-To: <1358618781-26629-5-git-send-email-gene@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Finally, here is the source for this patch:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg02659.html

On 01/19/2013 01:06 PM, Gene Czarcinski wrote:
> A small part of this patch proved unnecessary because it was
> already corrected by the plug a memory leak reported by cppcheck
> patch.
>
> Signed-off-by: Gene Czarcinski <gene@czarc.net>
> ---
>   disk-io.c      | 16 +++++++++++-----
>   extent-cache.c | 11 +++++++++++
>   extent-cache.h |  1 +
>   extent-tree.c  | 10 ++++++++++
>   volumes.c      | 16 +++++++++++++++-
>   volumes.h      |  1 +
>   6 files changed, 49 insertions(+), 6 deletions(-)
>
> diff --git a/disk-io.c b/disk-io.c
> index c4d4631..5b6c6b1 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -631,7 +631,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>   	struct btrfs_root *chunk_root = malloc(sizeof(struct btrfs_root));
>   	struct btrfs_root *dev_root = malloc(sizeof(struct btrfs_root));
>   	struct btrfs_root *csum_root = malloc(sizeof(struct btrfs_root));
> -	struct btrfs_fs_info *fs_info = malloc(sizeof(*fs_info));
> +	struct btrfs_fs_info *fs_info = malloc(sizeof(struct btrfs_fs_info));
>   	int ret;
>   	struct btrfs_super_block *disk_super;
>   	struct btrfs_fs_devices *fs_devices = NULL;
> @@ -655,7 +655,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>   			goto out;
>   	}
>   
> -	memset(fs_info, 0, sizeof(*fs_info));
> +	memset(fs_info, 0, sizeof(struct btrfs_fs_info));
>   	fs_info->tree_root = tree_root;
>   	fs_info->extent_root = extent_root;
>   	fs_info->chunk_root = chunk_root;
> @@ -1084,15 +1084,19 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
>   {
>   	struct list_head *list;
>   	struct list_head *next;
> +	struct list_head *tmp;
>   	struct btrfs_device *device;
>   
> -	return 0;
> -
>   	list = &fs_info->fs_devices->devices;
> -	list_for_each(next, list) {
> +	list_for_each_safe(next, tmp, list) {
>   		device = list_entry(next, struct btrfs_device, dev_list);
>   		close(device->fd);
> +		list_del(&device->dev_list);
> +		free(device->name);
> +		free(device->label);
> +		free(device);
>   	}
> +	free(fs_info->fs_devices);
>   	return 0;
>   }
>   
> @@ -1142,12 +1146,14 @@ int close_ctree(struct btrfs_root *root)
>   	extent_io_tree_cleanup(&fs_info->pinned_extents);
>   	extent_io_tree_cleanup(&fs_info->pending_del);
>   	extent_io_tree_cleanup(&fs_info->extent_ins);
> +	btrfs_mapping_tree_free(&fs_info->mapping_tree);
>   
>   	free(fs_info->tree_root);
>   	free(fs_info->extent_root);
>   	free(fs_info->chunk_root);
>   	free(fs_info->dev_root);
>   	free(fs_info->csum_root);
> +	free(fs_info->log_root_tree);
>   	free(fs_info);
>   
>   	return 0;
> diff --git a/extent-cache.c b/extent-cache.c
> index 3dd6434..84d4bbc 100644
> --- a/extent-cache.c
> +++ b/extent-cache.c
> @@ -168,3 +168,14 @@ void remove_cache_extent(struct cache_tree *tree,
>   	rb_erase(&pe->rb_node, &tree->root);
>   }
>   
> +void free_cache_tree(struct cache_tree *tree)
> +{
> +	struct rb_node *node;
> +	struct cache_extent *cache;
> +
> +	while ((node = rb_last(&tree->root)) != NULL) {
> +		cache = rb_entry(node, struct cache_extent, rb_node);
> +		remove_cache_extent(tree, cache);
> +		free(cache);
> +	}
> +}
> diff --git a/extent-cache.h b/extent-cache.h
> index 7f2f2a6..1696bc2 100644
> --- a/extent-cache.h
> +++ b/extent-cache.h
> @@ -43,6 +43,7 @@ struct cache_extent *find_cache_extent(struct cache_tree *tree,
>   int insert_cache_extent(struct cache_tree *tree, u64 start, u64 size);
>   int insert_existing_cache_extent(struct cache_tree *tree,
>   				 struct cache_extent *pe);
> +void free_cache_tree(struct cache_tree *tree);
>   
>   static inline int cache_tree_empty(struct cache_tree *tree)
>   {
> diff --git a/extent-tree.c b/extent-tree.c
> index 20cdffa..d644d9a 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -2999,6 +2999,7 @@ out:
>   
>   int btrfs_free_block_groups(struct btrfs_fs_info *info)
>   {
> +	struct btrfs_space_info *space_info;
>   	u64 start;
>   	u64 end;
>   	u64 ptr;
> @@ -3022,6 +3023,15 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
>   		clear_extent_dirty(&info->free_space_cache, start,
>   				   end, GFP_NOFS);
>   	}
> +
> +	while (!list_empty(&info->space_info)) {
> +		space_info = list_entry(info->space_info.next,
> +					struct btrfs_space_info,
> +					list);
> +		list_del(&space_info->list);
> +		kfree(space_info);
> +	}
> +
>   	return 0;
>   }
>   
> diff --git a/volumes.c b/volumes.c
> index 581c298..37b0074 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -959,6 +959,20 @@ void btrfs_mapping_init(struct btrfs_mapping_tree *tree)
>   	cache_tree_init(&tree->cache_tree);
>   }
>   
> +void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree)
> +{
> +	struct cache_extent *cache;
> +	struct rb_node *node;
> +	struct map_lookup *map;
> +
> +	while ((node = rb_last(&tree->cache_tree.root)) != NULL) {
> +		cache = rb_entry(node, struct cache_extent, rb_node);
> +		map = container_of(cache, struct map_lookup, ce);
> +		remove_cache_extent(&tree->cache_tree, cache);
> +		free(map);
> +	}
> +}
> +
>   int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
>   {
>   	struct cache_extent *ce;
> @@ -1486,7 +1500,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
>   	if (!sb)
>   		return -ENOMEM;
>   	btrfs_set_buffer_uptodate(sb);
> -	write_extent_buffer(sb, super_copy, 0, BTRFS_SUPER_INFO_SIZE);
> +	write_extent_buffer(sb, super_copy, 0, sizeof(*super_copy));
>   	array_size = btrfs_super_sys_array_size(super_copy);
>   
>   	/*
> diff --git a/volumes.h b/volumes.h
> index 9ff6182..ce1e413 100644
> --- a/volumes.h
> +++ b/volumes.h
> @@ -182,4 +182,5 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
>   			   struct btrfs_root *root, struct btrfs_key *key,
>   			   struct btrfs_chunk *chunk, int item_size);
>   int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
> +void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree);
>   #endif

