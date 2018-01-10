Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751561AbeAJOOu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 09:14:50 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 993F0AE03
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 14:14:48 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: Prevent temporary system chunk to
 use space in reserved 1M range
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180110045648.3239-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7f154974-b14a-17c0-d04c-905e3305f1bf@suse.com>
Date: Wed, 10 Jan 2018 16:14:47 +0200
MIME-Version: 1.0
In-Reply-To: <20180110045648.3239-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.01.2018 06:56, Qu Wenruo wrote:
> When creating btrfs, mkfs.btrfs will firstly create a temporary system
> chunk as basis, and then created needed trees or new devices.
> 
> However the layout temporary system chunk is hard-coded and uses
> reserved [0, 1M) range of devid 1.
> 
> Change the temporary chunk layout from old:
> 
> 0	1M				4M	5M
> |<----------- temp chunk -------------->|
>   And it's 1:1 mapped, which means it's a SINGLE chunk,
>   and stripe offset is also 0.
> 
> to new layout:
> 
> 0	1M				4M	5M
> 	|<----------- temp chunk -------------->|
>   And still keeps the 1:1 mapping.
> 
> The problem can only be exposed by "-m single" or "-M" where we reuse the
> temporary chunk.
> 
> With other meta profiles, system and meta chunks are allocated by later
> btrfs_alloc_chunk() call, and old SINGLE chunks are removed, so it will
> be no such problem for other meta profiles.
> 
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>


Those changes break existing xfs tests:

btrfs/140	 - output mismatch (see /root/xfstests-dev/results/ubuntu-virtual/4.15.0-rc5-nbor/2018-01-10-13-41-845986621//btrfs/btrfs/140.out.bad)
    --- tests/btrfs/140.out	2017-05-22 13:24:36.116301772 +0000
    +++ /root/xfstests-dev/results/ubuntu-virtual/4.15.0-rc5-nbor/2018-01-10-13-41-845986621//btrfs/btrfs/140.out.bad	2018-01-10 14:12:09.919034975 +0000
    @@ -1,39 +1,39 @@
     QA output created by 140
     wrote 131072/131072 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -wrote 65536/65536 bytes at offset 136708096
    +wrote 65536/65536 bytes at offset 137756672
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -08260000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
    ...
    (Run 'diff -u tests/btrfs/140.out /root/xfstests-dev/results/ubuntu-virtual/4.15.0-rc5-nbor/2018-01-10-13-41-845986621//btrfs/btrfs/140.out.bad'  to see the entire diff)
btrfs/141	 - output mismatch (see /root/xfstests-dev/results/ubuntu-virtual/4.15.0-rc5-nbor/2018-01-10-13-41-845986621//btrfs/btrfs/141.out.bad)
    --- tests/btrfs/141.out	2017-05-22 13:24:36.117301793 +0000
    +++ /root/xfstests-dev/results/ubuntu-virtual/4.15.0-rc5-nbor/2018-01-10-13-41-845986621//btrfs/btrfs/141.out.bad	2018-01-10 14:12:10.661035432 +0000
    @@ -1,39 +1,39 @@
     QA output created by 141
     wrote 131072/131072 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -wrote 65536/65536 bytes at offset 136708096
    +wrote 65536/65536 bytes at offset 137756672
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -08260000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
    ...
    (Run 'diff -u tests/btrfs/141.out /root/xfstests-dev/results/ubuntu-virtual/4.15.0-rc5-nbor/2018-01-10-13-41-845986621//btrfs/btrfs/141.out.bad'  to see the entire diff)
btrfs/142	 - output mismatch (see /root/xfstests-dev/results/ubuntu-virtual/4.15.0-rc5-nbor/2018-01-10-13-41-845986621//btrfs/btrfs/142.out.bad)
    --- tests/btrfs/142.out	2017-05-22 13:24:36.117301793 +0000
    +++ /root/xfstests-dev/results/ubuntu-virtual/4.15.0-rc5-nbor/2018-01-10-13-41-845986621//btrfs/btrfs/142.out.bad	2018-01-10 14:12:11.411035894 +0000
    @@ -1,39 +1,39 @@
     QA output created by 142
     wrote 131072/131072 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -wrote 65536/65536 bytes at offset 136708096
    +wrote 65536/65536 bytes at offset 137756672
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -08260000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
    ...
    (Run 'diff -u tests/btrfs/142.out /root/xfstests-dev/results/ubuntu-virtual/4.15.0-rc5-nbor/2018-01-10-13-41-845986621//btrfs/btrfs/142.out.bad'  to see the entire diff)
btrfs/143	 - output mismatch (see /root/xfstests-dev/results/ubuntu-virtual/4.15.0-rc5-nbor/2018-01-10-13-41-845986621//btrfs/btrfs/143.out.bad)
    --- tests/btrfs/143.out	2017-05-22 13:24:36.117301793 +0000
    +++ /root/xfstests-dev/results/ubuntu-virtual/4.15.0-rc5-nbor/2018-01-10-13-41-845986621//btrfs/btrfs/143.out.bad	2018-01-10 14:12:12.305036444 +0000
    @@ -1,39 +1,39 @@
     QA output created by 143
     wrote 131072/131072 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -wrote 65536/65536 bytes at offset 136708096
    +wrote 65536/65536 bytes at offset 137756672
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -08260000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
    ...
    (Run 'diff -u tests/btrfs/143.out /root/xfstests-dev/results/ubuntu-virtual/4.15.0-rc5-nbor/2018-01-10-13-41-845986621//btrfs/btrfs/143.out.bad'  to see the entire diff)


All of these are offset by a single megabyte

> ---
>  mkfs/common.c | 29 +++++++++++++++++++++++------
>  mkfs/main.c   |  7 ++++++-
>  2 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/mkfs/common.c b/mkfs/common.c
> index dd5e7ecff479..5c5e9c3b9e01 100644
> --- a/mkfs/common.c
> +++ b/mkfs/common.c
> @@ -100,6 +100,21 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
>   *
>   * The superblock signature is not valid, denotes a partially created
>   * filesystem, needs to be finalized.
> + *
> + * The temporary fs will have the following chunk layout:
> + * Device extent:
> + * 0		1M				5M	......
> + * | Reserved	| dev extent for SYS chunk      |
> + *
> + * And chunk mapping will be:
> + * Chunk mapping:
> + * 0		1M				5M
> + * |		| System chunk, 1:1 mapped	|
> + *
> + * That's to say, there will only be *ONE* system chunk, mapped to
> + * [1M, 5M) physical offset.
> + * And the only chunk is also in logical address [1M, 5M), containing
> + * all essential tree blocks.
>   */
>  int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  {
> @@ -154,8 +169,8 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  
>  	cfg->blocks[MKFS_SUPER_BLOCK] = BTRFS_SUPER_INFO_OFFSET;
>  	for (i = 1; i < MKFS_BLOCK_COUNT; i++) {
> -		cfg->blocks[i] = BTRFS_SUPER_INFO_OFFSET + SZ_1M +
> -			cfg->nodesize * i;
> +		cfg->blocks[i] = BTRFS_BLOCK_RESERVED_1M_FOR_SUPER +
> +			cfg->nodesize * (i - 1);
>  	}
>  
>  	btrfs_set_super_bytenr(&super, cfg->blocks[MKFS_SUPER_BLOCK]);
> @@ -309,7 +324,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  
>  	/* then we have chunk 0 */
>  	btrfs_set_disk_key_objectid(&disk_key, BTRFS_FIRST_CHUNK_TREE_OBJECTID);
> -	btrfs_set_disk_key_offset(&disk_key, 0);
> +	btrfs_set_disk_key_offset(&disk_key, BTRFS_BLOCK_RESERVED_1M_FOR_SUPER);
>  	btrfs_set_disk_key_type(&disk_key, BTRFS_CHUNK_ITEM_KEY);
>  	btrfs_set_item_key(buf, &disk_key, nritems);
>  	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
> @@ -325,7 +340,8 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	btrfs_set_chunk_sector_size(buf, chunk, cfg->sectorsize);
>  	btrfs_set_chunk_num_stripes(buf, chunk, 1);
>  	btrfs_set_stripe_devid_nr(buf, chunk, 0, 1);
> -	btrfs_set_stripe_offset_nr(buf, chunk, 0, 0);
> +	btrfs_set_stripe_offset_nr(buf, chunk, 0,
> +				   BTRFS_BLOCK_RESERVED_1M_FOR_SUPER);
>  	nritems++;
>  
>  	write_extent_buffer(buf, super.dev_item.uuid,
> @@ -363,7 +379,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  		sizeof(struct btrfs_dev_extent);
>  
>  	btrfs_set_disk_key_objectid(&disk_key, 1);
> -	btrfs_set_disk_key_offset(&disk_key, 0);
> +	btrfs_set_disk_key_offset(&disk_key, BTRFS_BLOCK_RESERVED_1M_FOR_SUPER);
>  	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_EXTENT_KEY);
>  	btrfs_set_item_key(buf, &disk_key, nritems);
>  	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
> @@ -374,7 +390,8 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  					BTRFS_CHUNK_TREE_OBJECTID);
>  	btrfs_set_dev_extent_chunk_objectid(buf, dev_extent,
>  					BTRFS_FIRST_CHUNK_TREE_OBJECTID);
> -	btrfs_set_dev_extent_chunk_offset(buf, dev_extent, 0);
> +	btrfs_set_dev_extent_chunk_offset(buf, dev_extent,
> +					  BTRFS_BLOCK_RESERVED_1M_FOR_SUPER);
>  
>  	write_extent_buffer(buf, chunk_tree_uuid,
>  		    (unsigned long)btrfs_dev_extent_chunk_tree_uuid(dev_extent),
> diff --git a/mkfs/main.c b/mkfs/main.c
> index d817ad8dfd1a..8e3d19acb6f2 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -81,10 +81,15 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
>  	bytes_used = btrfs_super_bytes_used(fs_info->super_copy);
>  
>  	root->fs_info->system_allocs = 1;
> +	/*
> +	 * First temporary system chunk must match the chunk layout
> +	 * created in make_btrfs().
> +	 */
>  	ret = btrfs_make_block_group(trans, fs_info, bytes_used,
>  				     BTRFS_BLOCK_GROUP_SYSTEM,
>  				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
> -				     0, BTRFS_MKFS_SYSTEM_GROUP_SIZE);
> +				     BTRFS_BLOCK_RESERVED_1M_FOR_SUPER,
> +				     BTRFS_MKFS_SYSTEM_GROUP_SIZE);
>  	allocation->system += BTRFS_MKFS_SYSTEM_GROUP_SIZE;
>  	if (ret)
>  		return ret;
> 
