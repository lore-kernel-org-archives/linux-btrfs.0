Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7674 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754807AbbHGCIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 22:08:07 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t77269pJ006348
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Aug 2015 10:06:09 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Tsutomu Itoh'" <t-itoh@jp.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <201508070020.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
In-Reply-To: <201508070020.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
Subject: RE: [PATCH V2] btrfs-progs: add newline to some error messages
Date: Fri, 7 Aug 2015 10:07:48 +0800
Message-ID: <0c9a01d0d0b5$ddecb540$99c61fc0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reviewed-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Thanks
Zhaolei

> -----Original Message-----
> From: Tsutomu Itoh [mailto:t-itoh@jp.fujitsu.com]
> Sent: Friday, August 07, 2015 8:20 AM
> To: linux-btrfs@vger.kernel.org
> Cc: Zhao Lei
> Subject: [PATCH V2] btrfs-progs: add newline to some error messages
> 
> Added a missing newline to some error messages.
> Also printf() was changed to fprintf(stderr) for error message.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
>  btrfs-corrupt-block.c |  2 +-
>  cmds-check.c          |  4 ++--
>  cmds-send.c           |  4 ++--
>  dir-item.c            |  6 +++---
>  free-space-cache.c    | 24 +++++++++++++++---------
>  mkfs.c                |  2 +-
>  6 files changed, 24 insertions(+), 18 deletions(-)
> 
> diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c index 1a2aa23..ea871f4
> 100644
> --- a/btrfs-corrupt-block.c
> +++ b/btrfs-corrupt-block.c
> @@ -1010,7 +1010,7 @@ int find_chunk_offset(struct btrfs_root *root,
>  		goto out;
>  	}
>  	if (ret < 0) {
> -		fprintf(stderr, "Error searching chunk");
> +		fprintf(stderr, "Error searching chunk\n");
>  		goto out;
>  	}
>  out:
> diff --git a/cmds-check.c b/cmds-check.c index 50bb6f3..d0ffc94 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -2399,7 +2399,7 @@ static int repair_inode_nlinks(struct
> btrfs_trans_handle *trans,
>  				  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
>  				  mode);
>  		if (ret < 0) {
> -			fprintf(stderr, "Failed to create '%s' dir: %s",
> +			fprintf(stderr, "Failed to create '%s' dir: %s\n",
>  				dir_name, strerror(-ret));
>  			goto out;
>  		}
> @@ -2427,7 +2427,7 @@ static int repair_inode_nlinks(struct
> btrfs_trans_handle *trans,
>  		}
>  		if (ret < 0) {
>  			fprintf(stderr,
> -				"Failed to link the inode %llu to %s dir: %s",
> +				"Failed to link the inode %llu to %s dir: %s\n",
>  				rec->ino, dir_name, strerror(-ret));
>  			goto out;
>  		}
> diff --git a/cmds-send.c b/cmds-send.c
> index a0b7f95..6f2f340 100644
> --- a/cmds-send.c
> +++ b/cmds-send.c
> @@ -193,13 +193,13 @@ static int write_buf(int fd, const void *buf, int size)
>  		ret = write(fd, (char*)buf + pos, size - pos);
>  		if (ret < 0) {
>  			ret = -errno;
> -			fprintf(stderr, "ERROR: failed to dump stream. %s",
> +			fprintf(stderr, "ERROR: failed to dump stream. %s\n",
>  					strerror(-ret));
>  			goto out;
>  		}
>  		if (!ret) {
>  			ret = -EIO;
> -			fprintf(stderr, "ERROR: failed to dump stream. %s",
> +			fprintf(stderr, "ERROR: failed to dump stream. %s\n",
>  					strerror(-ret));
>  			goto out;
>  		}
> diff --git a/dir-item.c b/dir-item.c
> index a5bf861..f3ad98f 100644
> --- a/dir-item.c
> +++ b/dir-item.c
> @@ -285,7 +285,7 @@ int verify_dir_item(struct btrfs_root *root,
>  	u8 type = btrfs_dir_type(leaf, dir_item);
> 
>  	if (type >= BTRFS_FT_MAX) {
> -		fprintf(stderr, "invalid dir item type: %d",
> +		fprintf(stderr, "invalid dir item type: %d\n",
>  		       (int)type);
>  		return 1;
>  	}
> @@ -294,7 +294,7 @@ int verify_dir_item(struct btrfs_root *root,
>  		namelen = XATTR_NAME_MAX;
> 
>  	if (btrfs_dir_name_len(leaf, dir_item) > namelen) {
> -		fprintf(stderr, "invalid dir item name len: %u",
> +		fprintf(stderr, "invalid dir item name len: %u\n",
>  		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
>  		return 1;
>  	}
> @@ -302,7 +302,7 @@ int verify_dir_item(struct btrfs_root *root,
>  	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
>  	if ((btrfs_dir_data_len(leaf, dir_item) +
>  	     btrfs_dir_name_len(leaf, dir_item)) >
> BTRFS_MAX_XATTR_SIZE(root)) {
> -		fprintf(stderr, "invalid dir item name + data len: %u + %u",
> +		fprintf(stderr, "invalid dir item name + data len: %u + %u\n",
>  		       (unsigned)btrfs_dir_name_len(leaf, dir_item),
>  		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
>  		return 1;
> diff --git a/free-space-cache.c b/free-space-cache.c index 67f00fd..19ab0c9
> 100644
> --- a/free-space-cache.c
> +++ b/free-space-cache.c
> @@ -107,7 +107,8 @@ static int io_ctl_prepare_pages(struct io_ctl *io_ctl,
> struct btrfs_root *root,
> 
>  	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>  	if (ret) {
> -		printf("Couldn't find file extent item for free space inode"
> +		fprintf(stderr,
> +		       "Couldn't find file extent item for free space inode"
>  		       " %Lu\n", ino);
>  		btrfs_release_path(path);
>  		return -EINVAL;
> @@ -138,7 +139,7 @@ static int io_ctl_prepare_pages(struct io_ctl *io_ctl,
> struct btrfs_root *root,
>  				    struct btrfs_file_extent_item);
>  		if (btrfs_file_extent_type(path->nodes[0], fi) !=
>  		    BTRFS_FILE_EXTENT_REG) {
> -			printf("Not the file extent type we wanted\n");
> +			fprintf(stderr, "Not the file extent type we wanted\n");
>  			ret = -EINVAL;
>  			break;
>  		}
> @@ -307,7 +308,7 @@ static int __load_free_space_cache(struct btrfs_root
> *root,
> 
>  	ret = btrfs_search_slot(NULL, root, &inode_location, path, 0, 0);
>  	if (ret) {
> -		printf("Couldn't find free space inode %d\n", ret);
> +		fprintf(stderr, "Couldn't find free space inode %d\n", ret);
>  		return 0;
>  	}
> 
> @@ -322,7 +323,8 @@ static int __load_free_space_cache(struct btrfs_root
> *root,
>  	}
> 
>  	if (btrfs_inode_generation(leaf, inode_item) != generation) {
> -		printf("free space inode generation (%llu) did not match "
> +		fprintf(stderr,
> +		       "free space inode generation (%llu) did not match "
>  		       "free space cache generation (%llu)\n",
>  		       (unsigned long long)btrfs_inode_generation(leaf,
>  								  inode_item),
> @@ -372,7 +374,8 @@ static int __load_free_space_cache(struct btrfs_root
> *root,
>  		if (type == BTRFS_FREE_SPACE_EXTENT) {
>  			ret = link_free_space(ctl, e);
>  			if (ret) {
> -				printf("Duplicate entries in free space cache, dumping");
> +				fprintf(stderr,
> +				       "Duplicate entries in free space cache\n");
>  				free(e);
>  				goto free_cache;
>  			}
> @@ -387,7 +390,8 @@ static int __load_free_space_cache(struct btrfs_root
> *root,
>  			ret = link_free_space(ctl, e);
>  			ctl->total_bitmaps++;
>  			if (ret) {
> -				printf("Duplicate entries in free space cache, dumping");
> +				fprintf(stderr,
> +				       "Duplicate entries in free space cache\n");
>  				free(e->bitmap);
>  				free(e);
>  				goto free_cache;
> @@ -444,7 +448,8 @@ int load_free_space_cache(struct btrfs_fs_info
> *fs_info,
>  				       block_group->bytes_super));
>  	if (ret == 1 && !matched) {
>  		__btrfs_remove_free_space_cache(ctl);
> -		printf("block group %llu has wrong amount of free space",
> +		fprintf(stderr,
> +		       "block group %llu has wrong amount of free space\n",
>  		       block_group->key.objectid);
>  		ret = -1;
>  	}
> @@ -452,8 +457,9 @@ int load_free_space_cache(struct btrfs_fs_info
> *fs_info,
>  	if (ret < 0) {
>  		ret = 0;
> 
> -		printf("failed to load free space cache for block group %llu\n",
> -			block_group->key.objectid);
> +		fprintf(stderr,
> +		       "failed to load free space cache for block group %llu\n",
> +		       block_group->key.objectid);
>  	}
> 
>  	return ret;
> diff --git a/mkfs.c b/mkfs.c
> index 7d635dc..5cea8dd 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -600,7 +600,7 @@ static int add_symbolic_link(struct btrfs_trans_handle
> *trans,
>  		goto fail;
>  	}
>  	if (ret >= sectorsize) {
> -		fprintf(stderr, "symlink too long for %s", path_name);
> +		fprintf(stderr, "symlink too long for %s\n", path_name);
>  		ret = -1;
>  		goto fail;
>  	}
> --
> 2.4.5

