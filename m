Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42621 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751716AbeDIIGL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 04:06:11 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AAEC3AC71
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 08:06:09 +0000 (UTC)
Subject: Re: [PATCH] btrfs-progs: dump-super: Refactor print function and add
 extra check
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180409074702.18572-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <08b8e3af-3ed4-e600-7dee-c85ee83e3028@suse.com>
Date: Mon, 9 Apr 2018 11:06:08 +0300
MIME-Version: 1.0
In-Reply-To: <20180409074702.18572-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  9.04.2018 10:47, Qu Wenruo wrote:
> When manually patching super blocks, current validation check is pretty
> weak (limited to magic number and csum) and doesn't provide extra check
> for some obvious corruption (like invalid sectorsize).
> 
> This patch will enhance dump-super by:
> 
> 1) Refactor print function and add checker helper macro
>    Instead of manually call printf() and takes 2 lines to just print one
>    member, introduce several helper macros to print/check value.
>    Most of the callers just need 1 line.
>    (Although the macro and helper itself offsets the saved lines)
> 
> 2) Add extra check for some members
>    The following members will be checked, and if invalid the suffix
>    " [INVALID]" will be pended:
> 	bytenr:			alignment check
> 	sys_array_size:		maximum check
> 	root:			alignment check
> 	root_level:		maximum check
> 	chunk_root:		alignment check
> 	chunk_root_level:	maximum check
> 	chunk_root_generation:	maximum check against root generation
> 	log_root:		alignment check
> 	log_root_level:		maximum check
> 	log_root_transid:	maximum check against root generation + 1
> 	bytes_used:		alignment check
> 	sectorsize:		power of 2 and 4K~64K range check
> 	nodesize:		the same as sectorsize, plus minimum check
> 	stripesize:		the same as kernel check
> 	cache_generation:	maximum check against root generation
> 	uuid_tree_generation:	maximum check against root generation
> 
> 3) output sequence change
>    Put bytenr/level/generation together for the same root (tree root,
>    chunk root, and log root).
> 
> 4) Minor output change
>    To make dev_item macro easier, the following output is changed:
> 	dev_item.devid		->	dev_item.id
> 	dev_item.dev_group	->	dev_item.group
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  cmds-inspect-dump-super.c | 168 ++++++++++++++++++++++----------------
>  1 file changed, 99 insertions(+), 69 deletions(-)
> 
> diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
> index 24588c87cce6..8000d2ace663 100644
> --- a/cmds-inspect-dump-super.c
> +++ b/cmds-inspect-dump-super.c
> @@ -312,11 +312,42 @@ static void print_readable_super_flag(u64 flag)
>  				     super_flags_num, BTRFS_SUPER_FLAG_SUPP);
>  }
>  
> +/* Helper to print member in %llu */
> +#define print_super(sb, member, spacer)					\
> +	printf("%s%s%llu\n", #member, spacer, (u64) btrfs_super_##member(sb));
> +
> +/* Helper to print member in %llx */
> +#define print_super_hex(sb, member, spacer)				\
> +	printf("%s%s%llx\n", #member, spacer, (u64) btrfs_super_##member(sb));

nit: I like the idea of the patch, however, I think the presence of the
"spacer" argument is a bit annoying. Why don't you make all the print
out to be aligned to the same level i.e hardcode \t\t\ or \t\t or whatever?
> +
> +/*
> + * Helper macro to wrap member checker
> + *
> + * Only support %llu output for member.
> + */
> +#define print_check_super(sb, member, spacer, bad_condition)		\
> +({									\
> +	u64 value;							\
> +									\
> +	value = btrfs_super_##member(sb);				\
> +	printf("%s%s%llu", #member, spacer, (u64) value);		\
> +	if (bad_condition)						\
> +		printf(" [INVALID]");					\
> +	printf("\n");							\
> +})
> +
> +/* Helper to print sb->dev_item members */
> +#define print_super_dev(sb, member, spacer)				\
> +	printf("dev_item.%s%s%llu\n", #member, spacer,			\
> +	       (u64) btrfs_stack_device_##member(&sb->dev_item));
> +
>  static void dump_superblock(struct btrfs_super_block *sb, int full)
>  {
>  	int i;
>  	char *s, buf[BTRFS_UUID_UNPARSED_SIZE];
> +	int max_level = BTRFS_MAX_LEVEL; /* to save several chars */
>  	u8 *p;
> +	u64 super_gen;
>  	u32 csum_size;
>  	u16 csum_type;
>  
> @@ -348,10 +379,16 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
>  		printf(" [DON'T MATCH]");
>  	putchar('\n');
>  
> -	printf("bytenr\t\t\t%llu\n",
> -		(unsigned long long)btrfs_super_bytenr(sb));
> -	printf("flags\t\t\t0x%llx\n",
> -		(unsigned long long)btrfs_super_flags(sb));
> +	/*
> +	 * Use btrfs minimal sector size as basic check for bytenr, since we
> +	 * can't trust sector size from super block.
> +	 * This 4K check should works fine for most architecture, and will be
> +	 * just a little loose for 64K page system.
> +	 *
> +	 * And such 4K check will be used for other members too.
> +	 */
> +	print_check_super(sb, bytenr, "\t\t\t", (!IS_ALIGNED(value, SZ_4K)));
> +	print_super_hex(sb, flags, "\t\t\t");
>  	print_readable_super_flag(btrfs_super_flags(sb));
>  
>  	printf("magic\t\t\t");
> @@ -372,53 +409,56 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
>  		putchar(isprint(s[i]) ? s[i] : '.');
>  	putchar('\n');
>  
> -	printf("generation\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_generation(sb));
> -	printf("root\t\t\t%llu\n", (unsigned long long)btrfs_super_root(sb));
> -	printf("sys_array_size\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_sys_array_size(sb));
> -	printf("chunk_root_generation\t%llu\n",
> -	       (unsigned long long)btrfs_super_chunk_root_generation(sb));
> -	printf("root_level\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_root_level(sb));
> -	printf("chunk_root\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_chunk_root(sb));
> -	printf("chunk_root_level\t%llu\n",
> -	       (unsigned long long)btrfs_super_chunk_root_level(sb));
> -	printf("log_root\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_log_root(sb));
> -	printf("log_root_transid\t%llu\n",
> -	       (unsigned long long)btrfs_super_log_root_transid(sb));
> -	printf("log_root_level\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_log_root_level(sb));
> -	printf("total_bytes\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_total_bytes(sb));
> -	printf("bytes_used\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_bytes_used(sb));
> -	printf("sectorsize\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_sectorsize(sb));
> -	printf("nodesize\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_nodesize(sb));
> +	print_check_super(sb, sys_array_size, "\t\t",
> +			  (value > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE));
> +
> +	super_gen = btrfs_super_generation(sb);
> +	print_check_super(sb, root, "\t\t\t", (!IS_ALIGNED(value, SZ_4K)));
> +	print_check_super(sb, root_level, "\t\t", (value >= max_level));
> +	print_super(sb, generation, "\t\t");
> +
> +	print_check_super(sb, chunk_root, "\t\t", (!IS_ALIGNED(value, SZ_4K)));
> +	print_check_super(sb, chunk_root_level, "\t", (value >= max_level));
> +	/*
> +	 * Here we trust super generation, and use it as checker for other
> +	 * tree roots. Applies to all other trees.
> +	 */
> +	print_check_super(sb, chunk_root_generation, "\t", (value > super_gen));
> +
> +	print_check_super(sb, log_root, "\t\t", (!IS_ALIGNED(value, SZ_4K)));
> +	print_check_super(sb, log_root_level, "\t\t", (value >= max_level));
> +	print_check_super(sb, log_root_transid, "\t", (value > super_gen + 1));
> +
> +	/*
> +	 * For total bytes, it's possible that old kernel is using unaligned
> +	 * size, not critical so don't do 4K check here.
> +	 */
> +	print_super(sb, total_bytes, "\t\t");
> +
> +	/* Used bytes must be aligned to 4K */
> +	print_check_super(sb, bytes_used, "\t\t", (!IS_ALIGNED(value, SZ_4K)));
> +	print_check_super(sb, sectorsize, "\t\t",
> +			  (!(is_power_of_2(value) && value >= SZ_4K &&
> +			     value <= SZ_64K)));
> +	print_check_super(sb, nodesize, "\t\t",
> +			  (!(is_power_of_2(value) && value >= SZ_4K &&
> +			     value <= SZ_64K &&
> +			     value > btrfs_super_sectorsize(sb))));
>  	printf("leafsize (deprecated)\t%u\n",
>  	       le32_to_cpu(sb->__unused_leafsize));
> -	printf("stripesize\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_stripesize(sb));
> -	printf("root_dir\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_root_dir(sb));
> -	printf("num_devices\t\t%llu\n",
> -	       (unsigned long long)btrfs_super_num_devices(sb));
> -	printf("compat_flags\t\t0x%llx\n",
> -	       (unsigned long long)btrfs_super_compat_flags(sb));
> -	printf("compat_ro_flags\t\t0x%llx\n",
> -	       (unsigned long long)btrfs_super_compat_ro_flags(sb));
> +
> +	/* Not really used, just check it the same way as kernel */
> +	print_check_super(sb, stripesize, "\t\t", (!is_power_of_2(value)));
> +	print_super(sb, root_dir, "\t\t");
> +	print_super(sb, num_devices, "\t\t");
> +	print_super_hex(sb, compat_flags, "\t\t");
> +	print_super_hex(sb, compat_ro_flags, "\t\t");
>  	print_readable_compat_ro_flag(btrfs_super_compat_ro_flags(sb));
> -	printf("incompat_flags\t\t0x%llx\n",
> -	       (unsigned long long)btrfs_super_incompat_flags(sb));
> +	print_super_hex(sb, incompat_flags, "\t\t");
>  	print_readable_incompat_flag(btrfs_super_incompat_flags(sb));
> -	printf("cache_generation\t%llu\n",
> -	       (unsigned long long)btrfs_super_cache_generation(sb));
> -	printf("uuid_tree_generation\t%llu\n",
> -	       (unsigned long long)btrfs_super_uuid_tree_generation(sb));
> +	print_check_super(sb, cache_generation, "\t",
> +			  (value > super_gen && value != (u64)-1));
> +	print_check_super(sb, uuid_tree_generation, "\t", (value > super_gen));
>  
>  	uuid_unparse(sb->dev_item.uuid, buf);
>  	printf("dev_item.uuid\t\t%s\n", buf);
> @@ -428,28 +468,18 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
>  		!memcmp(sb->dev_item.fsid, sb->fsid, BTRFS_FSID_SIZE) ?
>  			"[match]" : "[DON'T MATCH]");
>  
> -	printf("dev_item.type\t\t%llu\n", (unsigned long long)
> -	       btrfs_stack_device_type(&sb->dev_item));
> -	printf("dev_item.total_bytes\t%llu\n", (unsigned long long)
> -	       btrfs_stack_device_total_bytes(&sb->dev_item));
> -	printf("dev_item.bytes_used\t%llu\n", (unsigned long long)
> -	       btrfs_stack_device_bytes_used(&sb->dev_item));
> -	printf("dev_item.io_align\t%u\n", (unsigned int)
> -	       btrfs_stack_device_io_align(&sb->dev_item));
> -	printf("dev_item.io_width\t%u\n", (unsigned int)
> -	       btrfs_stack_device_io_width(&sb->dev_item));
> -	printf("dev_item.sector_size\t%u\n", (unsigned int)
> -	       btrfs_stack_device_sector_size(&sb->dev_item));
> -	printf("dev_item.devid\t\t%llu\n",
> -	       btrfs_stack_device_id(&sb->dev_item));
> -	printf("dev_item.dev_group\t%u\n", (unsigned int)
> -	       btrfs_stack_device_group(&sb->dev_item));
> -	printf("dev_item.seek_speed\t%u\n", (unsigned int)
> -	       btrfs_stack_device_seek_speed(&sb->dev_item));
> -	printf("dev_item.bandwidth\t%u\n", (unsigned int)
> -	       btrfs_stack_device_bandwidth(&sb->dev_item));
> -	printf("dev_item.generation\t%llu\n", (unsigned long long)
> -	       btrfs_stack_device_generation(&sb->dev_item));
> +	/* For embedded device item, don't do extra check, just like kernel */
> +	print_super_dev(sb, type, "\t\t");
> +	print_super_dev(sb, total_bytes, "\t");
> +	print_super_dev(sb, bytes_used, "\t");
> +	print_super_dev(sb, io_align, "\t");
> +	print_super_dev(sb, io_width, "\t");
> +	print_super_dev(sb, sector_size, "\t");
> +	print_super_dev(sb, id, "\t");
> +	print_super_dev(sb, group, "\t");
> +	print_super_dev(sb, seek_speed, "\t");
> +	print_super_dev(sb, bandwidth, "\t");
> +	print_super_dev(sb, generation, "\t");
>  	if (full) {
>  		printf("sys_chunk_array[%d]:\n", BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
>  		print_sys_chunk_array(sb);
> 
