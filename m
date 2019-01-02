Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477BBC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 09:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 068552171F
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 09:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbfABJNP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 04:13:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:36560 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726782AbfABJNP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 04:13:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7F503AEB3
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Jan 2019 09:13:11 +0000 (UTC)
Subject: Re: [PATCH 3/3] btrfs-progs: Create uuid tree with proper contents
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181227071333.10964-1-wqu@suse.com>
 <20181227071333.10964-4-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <ac1e6b87-f4e3-36c0-af1a-72e3b623c80a@suse.com>
Date:   Wed, 2 Jan 2019 11:13:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181227071333.10964-4-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 27.12.18 г. 9:13 ч., Qu Wenruo wrote:
> Commit 2a496a5b8b74 ("btrfs-progs: mkfs: precreate the uuid tree")
> creates uuid tree at mkfs time.
> 
> However it doesn't populate uuid tree correctly nor just create an empty
> root.
> It uses create_tree(), which just copies the content of fs root,
> containing meaningless INODE_ITEM:
> 
> v4.15 mkfs (no uuid tree creation) + kernel mount:
>   uuid tree key (UUID_TREE ROOT_ITEM 0)
>   leaf 30572544 items 1 free space 16250 generation 7 owner UUID_TREE
>   leaf 30572544 flags 0x1(WRITTEN) backref revision 1
>   fs uuid 33ecddef-fc86-481a-93ce-846b01c11376
>   chunk uuid 9e58f646-b0da-43ca-9c7d-8bbe3e120246
> 	item 0 key (0x92457c59d31491be UUID_KEY_SUBVOL 0xef908b5e79aa76a1) itemoff 16275 itemsize 8
> 		subvol_id 5
> 
> v4.19.1 mkfs (incorrect one), no kernel mount:
>   uuid tree key (UUID_TREE ROOT_ITEM 0)
>   leaf 30507008 items 2 free space 16061 generation 4 owner UUID_TREE
>   leaf 30507008 flags 0x1(WRITTEN) backref revision 1
>   fs uuid 162f5333-9b5d-4217-877c-ddaeaa79398e
>   chunk uuid 7bc2c5c6-a6d2-4eec-a513-142b549c6541
> 	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
> 		generation 3 transid 0 size 0 nbytes 16384
> 		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
> 		sequence 0 flags 0x0(none)
> 	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
> 		index 0 namelen 2 name: ..
> 
> This patchset will fix it by populuating uuid tree properly:
> (NOTE: due to tree-checker, kernel doesn't accept empty uuid tree, so we
>  can only fix it by populating uuid tree correctly)
> 
> w/ this patchset, no kernel mount:
>   uuid tree key (UUID_TREE ROOT_ITEM 0)
>   leaf 30507008 items 1 free space 16250 generation 4 owner UUID_TREE
>   leaf 30507008 flags 0x1(WRITTEN) backref revision 1
>   fs uuid ae53079e-dbbc-409b-a565-5326c7b27731
>   chunk uuid b5fb1bea-f20d-4af1-80f8-6ca3f0038d67
> 	item 0 key (0x334ba6b032d89c07 UUID_KEY_SUBVOL 0x86cde09cb78bcca0) itemoff 16275 itemsize 8
> 		subvol_id 5
> 
> For kernel, except tree-checker needs an non-empty uuid tree, both all
> above behavior won't cause problem, but it's always better to keep a
> good standardized behavior.
> 
> Furthermore, to avoid such problem from happening again, rename the
> function create_tree() to create_empty_tree() and create_inode_tree(),
> without an @root parameter to avoid such problem.
> 
> Fixes: 2a496a5b8b74 ("btrfs-progs: mkfs: precreate the uuid tree")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  disk-io.c     |   4 ++
>  mkfs/common.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  mkfs/common.h |   3 ++
>  mkfs/main.c   |  36 +-----------------
>  4 files changed, 112 insertions(+), 34 deletions(-)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 5fafa144c0d3..2cb7f2097fc9 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -694,6 +694,8 @@ void btrfs_free_fs_info(struct btrfs_fs_info *fs_info)
>  {
>  	if (fs_info->quota_root)
>  		free(fs_info->quota_root);
> +	if (fs_info->uuid_root)
> +		free(fs_info->uuid_root);
>  
>  	free(fs_info->tree_root);
>  	free(fs_info->extent_root);
> @@ -964,6 +966,8 @@ void btrfs_release_all_roots(struct btrfs_fs_info *fs_info)
>  		free_extent_buffer(fs_info->log_root_tree->node);
>  	if (fs_info->chunk_root)
>  		free_extent_buffer(fs_info->chunk_root->node);
> +	if (fs_info->uuid_root)
> +		free_extent_buffer(fs_info->uuid_root->node);
>  }
>  
>  static void free_map_lookup(struct cache_extent *ce)
> diff --git a/mkfs/common.c b/mkfs/common.c
> index f7e3badcf2b9..1f5e1d03a6e3 100644
> --- a/mkfs/common.c
> +++ b/mkfs/common.c
> @@ -23,6 +23,7 @@
>  #include "disk-io.h"
>  #include "volumes.h"
>  #include "utils.h"
> +#include "transaction.h"
>  #include "mkfs/common.h"
>  
>  static u64 reference_root_table[] = {
> @@ -822,4 +823,106 @@ int test_minimum_size(const char *file, u64 min_dev_size)
>  	return 0;
>  }
>  
> +/*
> + * Create a tree with all its content copied from @source
> + *
> + * Caller must ensure @source only has one leaf.
> + */
> +static int __create_tree(struct btrfs_trans_handle *trans,
> +			 struct btrfs_root *root, u64 objectid)
> +{
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
> +	struct btrfs_key location;
> +	struct btrfs_root_item root_item;
> +	struct extent_buffer *tmp;
> +	u8 uuid[BTRFS_UUID_SIZE] = {0};
> +	int ret;
> +
> +	ASSERT(btrfs_header_level(root->node) == 0);
> +
> +	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
> +	if (ret)
> +		return ret;
> +
> +	memcpy(&root_item, &root->root_item, sizeof(root_item));
> +	btrfs_set_root_bytenr(&root_item, tmp->start);
> +	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
> +	btrfs_set_root_generation(&root_item, trans->transid);
> +	/* clear uuid and o/ctime of source tree */
> +	memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
> +	btrfs_set_stack_timespec_sec(&root_item.otime, 0);
> +	btrfs_set_stack_timespec_sec(&root_item.ctime, 0);
> +	free_extent_buffer(tmp);
> +
> +	location.objectid = objectid;
> +	location.type = BTRFS_ROOT_ITEM_KEY;
> +	location.offset = 0;
> +	ret = btrfs_insert_root(trans, fs_info->tree_root,
> +				&location, &root_item);
> +
> +	return ret;
> +}
> +
> +/*
> + * Create an *EMPTY* tree
> + *
> + * Caller must ensure at the time of calling, csum tree is still empty
> + */
> +static int create_empty_tree(struct btrfs_trans_handle *trans, u64 objectid)
> +{
> +	struct btrfs_root *csum_root = trans->fs_info->csum_root;
> +
> +	ASSERT(btrfs_header_level(csum_root->node) == 0 &&
> +	       btrfs_header_nritems(csum_root->node) == 0);
> +	return __create_tree(trans, csum_root, objectid);

nit: IMO this approach (of using a tree as a prototype) is rather bogus
since you exploit the fact that an arbitrary tree (in this case csum)
*should* be empty and so you use it as the source for another empty
tree. Analogically, further down you exploit the fact that the fs_tree
has a default inode and copy that.

I'd prefer it if every tree was created explicitly so that in the future
when its layout might change we touch the respective function. This is
not critical but it's something to think about.

> +}
>  
> +/*
> + * Create a tree containing an root inode
> + *
> + * Caller must ensure at the time of calling, fs tree only contains 2 items
> + * (one for INODE_ITEM and one for INODE_REF)
> + */
> +int create_inode_tree(struct btrfs_trans_handle *trans, u64 objectid)

This function is really misnamed, since it's creating the
DATA_RELOC_TREE, yet it's called create_inode_tree. Why not simply
create_data_reloc_tree or are you planning on using this function more
than once?

> +{
> +	struct btrfs_root *fs_root = trans->fs_info->fs_root;
> +
> +	ASSERT(btrfs_header_level(fs_root->node) == 0 &&
> +	       btrfs_header_nritems(fs_root->node) == 2);
> +	return __create_tree(trans, fs_root, objectid);
> +}
> +
> +int create_uuid_tree(struct btrfs_trans_handle *trans)
> +{
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
> +	struct btrfs_root *uuid_root = fs_info->uuid_root;
> +	struct btrfs_key key;
> +	int ret;
> +
> +	if (!uuid_root) {

Isn't this always true,  so the conditional here is redundant?

> +		ret = create_empty_tree(trans, BTRFS_UUID_TREE_OBJECTID);
> +		if (ret < 0) {
> +			errno = -ret;
> +			error("failed to create uuid root: %m");
> +			return ret;
> +		}
> +		key.objectid = BTRFS_UUID_TREE_OBJECTID;
> +		key.type = BTRFS_ROOT_ITEM_KEY;
> +		key.offset = 0;
> +		uuid_root = btrfs_read_fs_root_no_cache(fs_info, &key);
> +		if (IS_ERR(uuid_root)) {
> +			errno = -PTR_ERR(uuid_root);
> +			error("failed to read uuid root: %m");
> +			return PTR_ERR(uuid_root);
> +		}
> +		fs_info->uuid_root = uuid_root;
> +	}
> +	ret = btrfs_uuid_tree_add(trans, fs_info->fs_root->root_item.uuid,
> +				  BTRFS_UUID_KEY_SUBVOL,
> +				  fs_info->fs_root->root_key.objectid);
> +	if (ret < 0) {
> +		errno = -ret;
> +		error("failed to add uuid tree entry for fs root: %m");
> +	}
> +	return ret;
> +}
> diff --git a/mkfs/common.h b/mkfs/common.h
> index 28912906d0a9..adb5d561c38d 100644
> --- a/mkfs/common.h
> +++ b/mkfs/common.h
> @@ -75,4 +75,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
>  int test_status_for_mkfs(const char *file, bool force_overwrite);
>  int test_dev_for_mkfs(const char *file, int force_overwrite);
>  
> +int create_uuid_tree(struct btrfs_trans_handle *trans);
> +int create_inode_tree(struct btrfs_trans_handle *trans, u64 objectid);
> +
>  #endif
> diff --git a/mkfs/main.c b/mkfs/main.c
> index b6748f7fe853..ea3d1ae80e5e 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -309,38 +309,6 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> -static int create_tree(struct btrfs_trans_handle *trans,
> -			struct btrfs_root *root, u64 objectid)
> -{
> -	struct btrfs_key location;
> -	struct btrfs_root_item root_item;
> -	struct extent_buffer *tmp;
> -	u8 uuid[BTRFS_UUID_SIZE] = {0};
> -	int ret;
> -
> -	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
> -	if (ret)
> -		return ret;
> -
> -	memcpy(&root_item, &root->root_item, sizeof(root_item));
> -	btrfs_set_root_bytenr(&root_item, tmp->start);
> -	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
> -	btrfs_set_root_generation(&root_item, trans->transid);
> -	/* clear uuid and o/ctime of source tree */
> -	memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
> -	btrfs_set_stack_timespec_sec(&root_item.otime, 0);
> -	btrfs_set_stack_timespec_sec(&root_item.ctime, 0);
> -	free_extent_buffer(tmp);
> -
> -	location.objectid = objectid;
> -	location.type = BTRFS_ROOT_ITEM_KEY;
> -	location.offset = 0;
> -	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
> -				&location, &root_item);
> -
> -	return ret;
> -}
> -
>  static void print_usage(int ret)
>  {
>  	printf("Usage: mkfs.btrfs [options] dev [ dev ... ]\n");
> @@ -1203,13 +1171,13 @@ raid_groups:
>  		goto out;
>  	}
>  
> -	ret = create_tree(trans, root, BTRFS_DATA_RELOC_TREE_OBJECTID);
> +	ret = create_inode_tree(trans, BTRFS_DATA_RELOC_TREE_OBJECTID);
>  	if (ret) {
>  		error("unable to create data reloc tree: %d", ret);
>  		goto out;
>  	}
>  
> -	ret = create_tree(trans, root, BTRFS_UUID_TREE_OBJECTID);
> +	ret = create_uuid_tree(trans);
>  	if (ret)
>  		warning(
>  	"unable to create uuid tree, will be created after mount: %d", ret);
> 
