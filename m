Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58458 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132AbcE2KxI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 06:53:08 -0400
Subject: Re: [PATCH v3 05/22] btrfs-progs: Introduce function to setup
 temporary superblock
To: bo.li.liu@oracle.com, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1454043812-7893-6-git-send-email-quwenruo@cn.fujitsu.com>
 <20160528030459.GA31255@localhost.localdomain>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        David Sterba <dsterba@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9cd7dc82-184b-e5f0-0b7e-d359820202d2@gmx.com>
Date: Sun, 29 May 2016 18:52:41 +0800
MIME-Version: 1.0
In-Reply-To: <20160528030459.GA31255@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/28/2016 11:04 AM, Liu Bo wrote:
> On Fri, Jan 29, 2016 at 01:03:15PM +0800, Qu Wenruo wrote:
>> Introduce a new function, setup_temp_super(), to setup temporary super
>> for make_btrfs_v2().
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> ---
>>  utils.c | 117 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 117 insertions(+)
>>
>> diff --git a/utils.c b/utils.c
>> index bc10293..ed5476d 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -212,6 +212,98 @@ static int reserve_free_space(struct cache_tree *free_tree, u64 len,
>>  	return 0;
>>  }
>>
>> +static inline int write_temp_super(int fd, struct btrfs_super_block *sb,
>> +				   u64 sb_bytenr)
>> +{
>> +	u32 crc = ~(u32)0;
>> +	int ret;
>> +
>> +	crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE, crc,
>> +			      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
>> +	btrfs_csum_final(crc, (char *)&sb->csum[0]);
>> +	ret = pwrite(fd, sb, BTRFS_SUPER_INFO_SIZE, sb_bytenr);
>> +	if (ret < BTRFS_SUPER_INFO_SIZE)
>> +		ret = (ret < 0 ? -errno : -EIO);
>> +	else
>> +		ret = 0;
>> +	return ret;
>> +}
>> +
>> +/*
>> + * Setup temporary superblock at cfg->super_bynter
>> + * Needed info are extracted from cfg, and root_bytenr, chunk_bytenr
>> + *
>> + * For now sys chunk array will be empty and dev_item is empty
>> + * too.
>> + * They will be re-initialized at temp chunk tree setup.
>> + */
>> +static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
>> +			    u64 root_bytenr, u64 chunk_bytenr)
>> +{
>> +	unsigned char chunk_uuid[BTRFS_UUID_SIZE];
>> +	char super_buf[BTRFS_SUPER_INFO_SIZE];
>> +	struct btrfs_super_block *super = (struct btrfs_super_block *)super_buf;
>> +	int ret;
>> +
>> +	/*
>> +	 * We rely on cfg->chunk_uuid and cfg->fs_uuid to pass uuid
>> +	 * for other functions.
>> +	 * Caller must allocation space for them
>> +	 */
>> +	BUG_ON(!cfg->chunk_uuid || !cfg->fs_uuid);
>> +	memset(super_buf, 0, BTRFS_SUPER_INFO_SIZE);
>> +	cfg->num_bytes = round_down(cfg->num_bytes, cfg->sectorsize);
>> +
>> +	if (cfg->fs_uuid && *cfg->fs_uuid) {
>> +		if (uuid_parse(cfg->fs_uuid, super->fsid) != 0) {
>> +			error("cound not parse UUID: %s", cfg->fs_uuid);
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +		if (!test_uuid_unique(cfg->fs_uuid)) {
>> +			error("non-unique UUID: %s", cfg->fs_uuid);
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +	} else {
>> +		uuid_generate(super->fsid);
>> +		uuid_unparse(super->fsid, cfg->fs_uuid);
>> +	}
>> +	uuid_generate(chunk_uuid);
>> +	uuid_unparse(chunk_uuid, cfg->chunk_uuid);
>> +
>> +	btrfs_set_super_bytenr(super, cfg->super_bytenr);
>> +	btrfs_set_super_num_devices(super, 1);
>> +	btrfs_set_super_magic(super, BTRFS_MAGIC);
>> +	btrfs_set_super_generation(super, 1);
>> +	btrfs_set_super_root(super, root_bytenr);
>> +	btrfs_set_super_chunk_root(super, chunk_bytenr);
>> +	btrfs_set_super_total_bytes(super, cfg->num_bytes);
>> +	/*
>> +	 * Temporary btrfs will only has 6 tree roots:
>> +	 * chunk tree, root tree, extent_tree, device tree, fs tree
>> +	 * and csum tree.
>> +	 */
>> +	btrfs_set_super_bytes_used(super, 6 * cfg->nodesize);
>> +	btrfs_set_super_sectorsize(super, cfg->sectorsize);
>> +	btrfs_set_super_leafsize(super, cfg->nodesize);
>> +	btrfs_set_super_nodesize(super, cfg->nodesize);
>> +	btrfs_set_super_stripesize(super, cfg->stripesize);
>> +	btrfs_set_super_csum_type(super, BTRFS_CSUM_TYPE_CRC32);
>> +	btrfs_set_super_chunk_root(super, chunk_bytenr);
>> +	btrfs_set_super_cache_generation(super, -1);
>> +	btrfs_set_super_incompat_flags(super, cfg->features);
>> +	if (cfg->label)
>> +		strncpy(super->label, cfg->label, BTRFS_LABEL_SIZE - 1);
>
> Why not use __strncpy_null?
>
> Thanks,
>
> -liubo

Good idea, I'll add new patch to use it.

Thanks,
Qu
>
>> +
>> +	/* Sys chunk array will be re-initialized at chunk tree init time */
>> +	super->sys_chunk_array_size = 0;
>> +
>> +	ret = write_temp_super(fd, super, cfg->super_bytenr);
>> +out:
>> +	return ret;
>> +}
>> +
>>  /*
>>   * Improved version of make_btrfs().
>>   *
>> @@ -230,6 +322,10 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
>>  	struct cache_tree *used = &cctx->used;
>>  	u64 sys_chunk_start;
>>  	u64 meta_chunk_start;
>> +	/* chunk tree bytenr, in system chunk */
>> +	u64 chunk_bytenr;
>> +	/* metadata trees bytenr, in metadata chunk */
>> +	u64 root_bytenr;
>>  	int ret;
>>
>>  	/* Shouldn't happen */
>> @@ -260,6 +356,27 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
>>  	if (ret < 0)
>>  		goto out;
>>
>> +	/*
>> +	 * Inside the allocate metadata chunk, its layout will be:
>> +	 *  | offset		| contents	|
>> +	 *  -------------------------------------
>> +	 *  | +0		| tree root	|
>> +	 *  | +nodesize		| extent root	|
>> +	 *  | +nodesize * 2	| device root	|
>> +	 *  | +nodesize * 3	| fs tree	|
>> +	 *  | +nodesize * 4	| csum tree	|
>> +	 *  -------------------------------------
>> +	 * Inside the allocated system chunk, its layout will be:
>> +	 *  | offset		| contents	|
>> +	 *  -------------------------------------
>> +	 *  | +0		| chunk root	|
>> +	 *  -------------------------------------
>> +	 */
>> +	chunk_bytenr = sys_chunk_start;
>> +	root_bytenr = meta_chunk_start;
>> +	ret = setup_temp_super(fd, cfg, root_bytenr, chunk_bytenr);
>> +	if (ret < 0)
>> +		goto out;
>>  out:
>>  	return ret;
>>  }
>> --
>> 2.7.0
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
