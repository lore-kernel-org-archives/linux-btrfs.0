Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42037 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753926AbdHURlN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 13:41:13 -0400
Date: Mon, 21 Aug 2017 19:39:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: Replace number with enum
Message-ID: <20170821173948.GU2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170628095924.3276-1-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170628095924.3276-1-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 05:59:24PM +0800, Gu Jinxiang wrote:
> For code maintainability and scalability,
> replace hardcoded constant with a meaningful enum.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Sorry for late reply. Patch applied with some tweaks, the added enum
names are too generic, so I've added some prefix.
> ---
>  mkfs/common.c | 47 ++++++++++++++++++++++++-----------------------
>  mkfs/common.h | 14 +++++++++++++-
>  2 files changed, 37 insertions(+), 24 deletions(-)
> 
> diff --git a/mkfs/common.c b/mkfs/common.c
> index e4785c5..f34c4eb 100644
> --- a/mkfs/common.c
> +++ b/mkfs/common.c
> @@ -93,18 +93,18 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	uuid_generate(super.dev_item.uuid);
>  	uuid_generate(chunk_tree_uuid);
>  
> -	cfg->blocks[0] = BTRFS_SUPER_INFO_OFFSET;
> -	for (i = 1; i < 7; i++) {
> +	cfg->blocks[SUPER_BLOCK] = BTRFS_SUPER_INFO_OFFSET;
> +	for (i = 1; i < BLOCK_COUNT; i++) {
>  		cfg->blocks[i] = BTRFS_SUPER_INFO_OFFSET + 1024 * 1024 +
>  			cfg->nodesize * i;
>  	}
>  
> -	btrfs_set_super_bytenr(&super, cfg->blocks[0]);
> +	btrfs_set_super_bytenr(&super, cfg->blocks[SUPER_BLOCK]);
>  	btrfs_set_super_num_devices(&super, 1);
>  	btrfs_set_super_magic(&super, BTRFS_MAGIC_PARTIAL);
>  	btrfs_set_super_generation(&super, 1);
> -	btrfs_set_super_root(&super, cfg->blocks[1]);
> -	btrfs_set_super_chunk_root(&super, cfg->blocks[3]);
> +	btrfs_set_super_root(&super, cfg->blocks[ROOT_TREE]);
> +	btrfs_set_super_chunk_root(&super, cfg->blocks[CHUNK_TREE]);
>  	btrfs_set_super_total_bytes(&super, num_bytes);
>  	btrfs_set_super_bytes_used(&super, 6 * cfg->nodesize);
>  	btrfs_set_super_sectorsize(&super, cfg->sectorsize);
> @@ -121,7 +121,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	/* create the tree of root objects */
>  	memset(buf->data, 0, cfg->nodesize);
>  	buf->len = cfg->nodesize;
> -	btrfs_set_header_bytenr(buf, cfg->blocks[1]);
> +	btrfs_set_header_bytenr(buf, cfg->blocks[ROOT_TREE]);
>  	btrfs_set_header_nritems(buf, 4);
>  	btrfs_set_header_generation(buf, 1);
>  	btrfs_set_header_backref_rev(buf, BTRFS_MIXED_BACKREF_REV);
> @@ -151,7 +151,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	nritems = 0;
>  
>  	itemoff = __BTRFS_LEAF_DATA_SIZE(cfg->nodesize) - sizeof(root_item);
> -	btrfs_set_root_bytenr(&root_item, cfg->blocks[2]);
> +	btrfs_set_root_bytenr(&root_item, cfg->blocks[EXTENT_TREE]);
>  	btrfs_set_disk_key_objectid(&disk_key, BTRFS_EXTENT_TREE_OBJECTID);
>  	btrfs_set_item_key(buf, &disk_key, nritems);
>  	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
> @@ -162,7 +162,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	nritems++;
>  
>  	itemoff = itemoff - sizeof(root_item);
> -	btrfs_set_root_bytenr(&root_item, cfg->blocks[4]);
> +	btrfs_set_root_bytenr(&root_item, cfg->blocks[DEV_TREE]);
>  	btrfs_set_disk_key_objectid(&disk_key, BTRFS_DEV_TREE_OBJECTID);
>  	btrfs_set_item_key(buf, &disk_key, nritems);
>  	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
> @@ -174,7 +174,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	nritems++;
>  
>  	itemoff = itemoff - sizeof(root_item);
> -	btrfs_set_root_bytenr(&root_item, cfg->blocks[5]);
> +	btrfs_set_root_bytenr(&root_item, cfg->blocks[FS_TREE]);
>  	btrfs_set_disk_key_objectid(&disk_key, BTRFS_FS_TREE_OBJECTID);
>  	btrfs_set_item_key(buf, &disk_key, nritems);
>  	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
> @@ -186,7 +186,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	nritems++;
>  
>  	itemoff = itemoff - sizeof(root_item);
> -	btrfs_set_root_bytenr(&root_item, cfg->blocks[6]);
> +	btrfs_set_root_bytenr(&root_item, cfg->blocks[CSUM_TREE]);
>  	btrfs_set_disk_key_objectid(&disk_key, BTRFS_CSUM_TREE_OBJECTID);
>  	btrfs_set_item_key(buf, &disk_key, nritems);
>  	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
> @@ -199,7 +199,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  
>  
>  	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> -	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[1]);
> +	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[ROOT_TREE]);
>  	if (ret != cfg->nodesize) {
>  		ret = (ret < 0 ? -errno : -EIO);
>  		goto out;
> @@ -210,7 +210,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  		cfg->nodesize - sizeof(struct btrfs_header));
>  	nritems = 0;
>  	itemoff = __BTRFS_LEAF_DATA_SIZE(cfg->nodesize);
> -	for (i = 1; i < 7; i++) {
> +	for (i = 1; i < BLOCK_COUNT; i++) {
>  		item_size = sizeof(struct btrfs_extent_item);
>  		if (!skinny_metadata)
>  			item_size += sizeof(struct btrfs_tree_block_info);
> @@ -267,11 +267,11 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  		btrfs_set_item_size(buf, btrfs_item_nr(nritems), 0);
>  		nritems++;
>  	}
> -	btrfs_set_header_bytenr(buf, cfg->blocks[2]);
> +	btrfs_set_header_bytenr(buf, cfg->blocks[EXTENT_TREE]);
>  	btrfs_set_header_owner(buf, BTRFS_EXTENT_TREE_OBJECTID);
>  	btrfs_set_header_nritems(buf, nritems);
>  	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> -	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[2]);
> +	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[EXTENT_TREE]);
>  	if (ret != cfg->nodesize) {
>  		ret = (ret < 0 ? -errno : -EIO);
>  		goto out;
> @@ -354,11 +354,11 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	ptr += item_size;
>  	btrfs_set_super_sys_array_size(&super, array_size);
>  
> -	btrfs_set_header_bytenr(buf, cfg->blocks[3]);
> +	btrfs_set_header_bytenr(buf, cfg->blocks[CHUNK_TREE]);
>  	btrfs_set_header_owner(buf, BTRFS_CHUNK_TREE_OBJECTID);
>  	btrfs_set_header_nritems(buf, nritems);
>  	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> -	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[3]);
> +	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[CHUNK_TREE]);
>  	if (ret != cfg->nodesize) {
>  		ret = (ret < 0 ? -errno : -EIO);
>  		goto out;
> @@ -393,11 +393,11 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  				    BTRFS_MKFS_SYSTEM_GROUP_SIZE);
>  	nritems++;
>  
> -	btrfs_set_header_bytenr(buf, cfg->blocks[4]);
> +	btrfs_set_header_bytenr(buf, cfg->blocks[DEV_TREE]);
>  	btrfs_set_header_owner(buf, BTRFS_DEV_TREE_OBJECTID);
>  	btrfs_set_header_nritems(buf, nritems);
>  	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> -	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[4]);
> +	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[DEV_TREE]);
>  	if (ret != cfg->nodesize) {
>  		ret = (ret < 0 ? -errno : -EIO);
>  		goto out;
> @@ -406,11 +406,11 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	/* create the FS root */
>  	memset(buf->data + sizeof(struct btrfs_header), 0,
>  		cfg->nodesize - sizeof(struct btrfs_header));
> -	btrfs_set_header_bytenr(buf, cfg->blocks[5]);
> +	btrfs_set_header_bytenr(buf, cfg->blocks[FS_TREE]);
>  	btrfs_set_header_owner(buf, BTRFS_FS_TREE_OBJECTID);
>  	btrfs_set_header_nritems(buf, 0);
>  	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> -	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[5]);
> +	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[FS_TREE]);
>  	if (ret != cfg->nodesize) {
>  		ret = (ret < 0 ? -errno : -EIO);
>  		goto out;
> @@ -418,11 +418,11 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	/* finally create the csum root */
>  	memset(buf->data + sizeof(struct btrfs_header), 0,
>  		cfg->nodesize - sizeof(struct btrfs_header));
> -	btrfs_set_header_bytenr(buf, cfg->blocks[6]);
> +	btrfs_set_header_bytenr(buf, cfg->blocks[CSUM_TREE]);
>  	btrfs_set_header_owner(buf, BTRFS_CSUM_TREE_OBJECTID);
>  	btrfs_set_header_nritems(buf, 0);
>  	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> -	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[6]);
> +	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[CSUM_TREE]);
>  	if (ret != cfg->nodesize) {
>  		ret = (ret < 0 ? -errno : -EIO);
>  		goto out;
> @@ -433,7 +433,8 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	memcpy(buf->data, &super, sizeof(super));
>  	buf->len = BTRFS_SUPER_INFO_SIZE;
>  	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> -	ret = pwrite(fd, buf->data, BTRFS_SUPER_INFO_SIZE, cfg->blocks[0]);
> +	ret = pwrite(fd, buf->data, BTRFS_SUPER_INFO_SIZE,
> +			cfg->blocks[SUPER_BLOCK]);
>  	if (ret != BTRFS_SUPER_INFO_SIZE) {
>  		ret = (ret < 0 ? -errno : -EIO);
>  		goto out;
> diff --git a/mkfs/common.h b/mkfs/common.h
> index 666a75b..4d8a314 100644
> --- a/mkfs/common.h
> +++ b/mkfs/common.h
> @@ -28,6 +28,18 @@
>  #define BTRFS_MKFS_SYSTEM_GROUP_SIZE SZ_4M
>  #define BTRFS_MKFS_SMALL_VOLUME_SIZE SZ_1G
>  
> +/* roots: root tree, extent tree, chunk tree, dev tree, fs tree, csum tree */
> +enum btrfs_mkfs_block {
> +	SUPER_BLOCK = 0,
> +	ROOT_TREE,
> +	EXTENT_TREE,
> +	CHUNK_TREE,
> +	DEV_TREE,
> +	FS_TREE,
> +	CSUM_TREE,
> +	BLOCK_COUNT
> +};
> +
>  struct btrfs_mkfs_config {
>  	/* Label of the new filesystem */
>  	const char *label;
> @@ -43,7 +55,7 @@ struct btrfs_mkfs_config {
>  	/* Output fields, set during creation */
>  
>  	/* Logical addresses of superblock [0] and other tree roots */
> -	u64 blocks[8];
> +	u64 blocks[BLOCK_COUNT];
>  	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE];
>  	char chunk_uuid[BTRFS_UUID_UNPARSED_SIZE];
>  
> -- 
> 2.9.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
