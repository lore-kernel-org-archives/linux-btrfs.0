Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E82C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 11:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F90F208E4
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 11:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbeL0L2x (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 06:28:53 -0500
Received: from mout.gmx.net ([212.227.17.22]:41975 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbeL0L2w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 06:28:52 -0500
Received: from Damenlys-MBP.lan ([180.110.127.154]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lomql-1hIxCS3Nkp-00gm8h; Thu, 27
 Dec 2018 12:28:44 +0100
Subject: Re: [PATCH 3/3] btrfs-progs: Create uuid tree with proper contents
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181227071333.10964-1-wqu@suse.com>
 <20181227071333.10964-4-wqu@suse.com>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <48804351-b8b3-b876-529a-807d05259664@gmx.com>
Date:   Thu, 27 Dec 2018 19:28:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0)
 Gecko/20100101 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20181227071333.10964-4-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:sXgroHrlPInJY6nJD3tovBWraTap98VOYVBjOEHEI6NlvZpfqUy
 bmqlGBoKXWPhUEuhupUbbHY9J5YcGhLUByWB0iahdXCSrB0jGbWO7J02nWUzCkH7nqB7Kjs
 1en50OjbkCIgDWND3jsa4hDsmkMDPHG+bYMQe4XHK2HVj7NxpVOdPklhRjLhFf/qFQX4J3N
 uL3MyFlRe2/+vUVHeCnow==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6cczss+gKu4=:uYkqWE+0TYELk4hfXNNJy+
 cMdnMtr3Cw3xTstcumlHVcwq2nWRXd0/g+mfmYwub3JiqQ16ATFsXs26KilEHtTEnHnWVE3yl
 fBUwn6gBWuw+U0PUceiuyXznmJFXjkkSF4nic51bfKPfblbUjUelnqObA88+CEd7LgWiIce0t
 Q0dAXevV3VuXJZTHykPNBuCumdtfnvFRG2r0om/SDHTkm4G5IIUTF9FhuUE+Ze2c+Q5AMazbU
 RTKElTD97Ean3tjSiwdf6XfU2uV2dpCz4LsfKkuzKdHj3BL44+v6xdDC7uKuJn0/GXYGY1F0K
 DC2GwzEKPhmmP+FHO7Eb8m1fPAi9xB8dgRt9tktN69MkRetjvPby+RnXZaIDr+JH5cNt1ZNQM
 pmRx8VBORVyA4hu26FZNw4tMai4p7h8R1hSXDFXU6jwdcusjJ3diKWUJMMbOi/1VdG3h6v1+3
 PN9mG1MiPR05zP/CV/DvePSkJy1zi6KiIPc/IouGmIjSNdayzzwLpwntv0aDTcHq4kEULgy6M
 WIFGgo52wIkDqNQBV2ffdMgPioV1wfHIozedxChjfPQr6QJge86nEiN11a2gxpFYsjXzgbJtE
 w3IqMkN4mzqz0p7p1eV9/Ng0+jcgU9PcDs8h6c9lPKkIb46xX7TAV9ibmwRrro4OgmA9cM5P+
 8zC/UrA2tcTqFPBKkstT4bgfy37enBL08wzhNBJNH8ZAYEFH7TuHz/GLq9u56+Qmg/V24MyXB
 Qzt2dnZpth933GoDBY1nNynkL8OEyGFgIoFSgs4fg3l90jctoggS2uIC8GlQgus/JUdH01/Tb
 TVXEVqz6loJeLUx5+R8bnOpkkQ7a3ErESUooUiOU9rdFW0ahUVmNFFRbiTiPnbgf4YdTyK4sJ
 fqYqSpCqIq0N7ounZytdA2rHXqCljPus9eFKn+F069NV4+H5X7J5OCqplq3l2u
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/27 3:13 PM, Qu Wenruo wrote:
> Commit 2a496a5b8b74 ("btrfs-progs: mkfs: precreate the uuid tree")
> creates uuid tree at mkfs time.
> 
> However it doesn't populate uuid tree correctly nor just create an empty
> root.
> It uses create_tree(), which just copies the content of fs root,
> containing meaningless INODE_ITEM:
> 
> v4.15 mkfs (no uuid tree creation) + kernel mount:
>    uuid tree key (UUID_TREE ROOT_ITEM 0)
>    leaf 30572544 items 1 free space 16250 generation 7 owner UUID_TREE
>    leaf 30572544 flags 0x1(WRITTEN) backref revision 1
>    fs uuid 33ecddef-fc86-481a-93ce-846b01c11376
>    chunk uuid 9e58f646-b0da-43ca-9c7d-8bbe3e120246
> 	item 0 key (0x92457c59d31491be UUID_KEY_SUBVOL 0xef908b5e79aa76a1) itemoff 16275 itemsize 8
> 		subvol_id 5
> 
> v4.19.1 mkfs (incorrect one), no kernel mount:
>    uuid tree key (UUID_TREE ROOT_ITEM 0)
>    leaf 30507008 items 2 free space 16061 generation 4 owner UUID_TREE
>    leaf 30507008 flags 0x1(WRITTEN) backref revision 1
>    fs uuid 162f5333-9b5d-4217-877c-ddaeaa79398e
>    chunk uuid 7bc2c5c6-a6d2-4eec-a513-142b549c6541
> 	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
> 		generation 3 transid 0 size 0 nbytes 16384
> 		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
> 		sequence 0 flags 0x0(none)
> 	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
> 		index 0 namelen 2 name: ..
> 
> This patchset will fix it by populuating uuid tree properly:
> (NOTE: due to tree-checker, kernel doesn't accept empty uuid tree, so we
>   can only fix it by populating uuid tree correctly)
> 
> w/ this patchset, no kernel mount:
>    uuid tree key (UUID_TREE ROOT_ITEM 0)
>    leaf 30507008 items 1 free space 16250 generation 4 owner UUID_TREE
>    leaf 30507008 flags 0x1(WRITTEN) backref revision 1
>    fs uuid ae53079e-dbbc-409b-a565-5326c7b27731
>    chunk uuid b5fb1bea-f20d-4af1-80f8-6ca3f0038d67
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
>   disk-io.c     |   4 ++
>   mkfs/common.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   mkfs/common.h |   3 ++
>   mkfs/main.c   |  36 +-----------------
>   4 files changed, 112 insertions(+), 34 deletions(-)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 5fafa144c0d3..2cb7f2097fc9 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -694,6 +694,8 @@ void btrfs_free_fs_info(struct btrfs_fs_info *fs_info)
>   {
>   	if (fs_info->quota_root)
>   		free(fs_info->quota_root);
> +	if (fs_info->uuid_root)
> +		free(fs_info->uuid_root);
>   
>   	free(fs_info->tree_root);
>   	free(fs_info->extent_root);
> @@ -964,6 +966,8 @@ void btrfs_release_all_roots(struct btrfs_fs_info *fs_info)
>   		free_extent_buffer(fs_info->log_root_tree->node);
>   	if (fs_info->chunk_root)
>   		free_extent_buffer(fs_info->chunk_root->node);
> +	if (fs_info->uuid_root)
> +		free_extent_buffer(fs_info->uuid_root->node);
>   }
>   
>   static void free_map_lookup(struct cache_extent *ce)
> diff --git a/mkfs/common.c b/mkfs/common.c
> index f7e3badcf2b9..1f5e1d03a6e3 100644
> --- a/mkfs/common.c
> +++ b/mkfs/common.c
> @@ -23,6 +23,7 @@
>   #include "disk-io.h"
>   #include "volumes.h"
>   #include "utils.h"
> +#include "transaction.h"
>   #include "mkfs/common.h"
>   
>   static u64 reference_root_table[] = {
> @@ -822,4 +823,106 @@ int test_minimum_size(const char *file, u64 min_dev_size)
>   	return 0;
>   }
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
> +}
>   
> +/*
> + * Create a tree containing an root inode
> + *
> + * Caller must ensure at the time of calling, fs tree only contains 2 items
> + * (one for INODE_ITEM and one for INODE_REF)
> + */
> +int create_inode_tree(struct btrfs_trans_handle *trans, u64 objectid)
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
> +		ret = create_empty_tree(trans, BTRFS_UUID_TREE_OBJECTID);
> +		if (ret < 0) {
> +			errno = -ret;
> +			error("failed to create uuid root: %m");

In personal taste, I don't like such assignment.
Let the community say.

Others look nice to me.

Thanks,
Su

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
>   int test_status_for_mkfs(const char *file, bool force_overwrite);
>   int test_dev_for_mkfs(const char *file, int force_overwrite);
>   
> +int create_uuid_tree(struct btrfs_trans_handle *trans);
> +int create_inode_tree(struct btrfs_trans_handle *trans, u64 objectid);
> +
>   #endif
> diff --git a/mkfs/main.c b/mkfs/main.c
> index b6748f7fe853..ea3d1ae80e5e 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -309,38 +309,6 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
>   	return ret;
>   }
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
>   static void print_usage(int ret)
>   {
>   	printf("Usage: mkfs.btrfs [options] dev [ dev ... ]\n");
> @@ -1203,13 +1171,13 @@ raid_groups:
>   		goto out;
>   	}
>   
> -	ret = create_tree(trans, root, BTRFS_DATA_RELOC_TREE_OBJECTID);
> +	ret = create_inode_tree(trans, BTRFS_DATA_RELOC_TREE_OBJECTID);
>   	if (ret) {
>   		error("unable to create data reloc tree: %d", ret);
>   		goto out;
>   	}
>   
> -	ret = create_tree(trans, root, BTRFS_UUID_TREE_OBJECTID);
> +	ret = create_uuid_tree(trans);
>   	if (ret)
>   		warning(
>   	"unable to create uuid tree, will be created after mount: %d", ret);
> 
