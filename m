Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62350 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135AbcE2LHl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 07:07:41 -0400
Subject: Re: [PATCH v3 16/22] btrfs-progs: convert: Introduce function to
 migrate reserved ranges
To: bo.li.liu@oracle.com, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1454043812-7893-17-git-send-email-quwenruo@cn.fujitsu.com>
 <20160528031652.GC31255@localhost.localdomain>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        David Sterba <dsterba@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <84f140c3-ecd6-5a16-e0c1-504178766dbf@gmx.com>
Date: Sun, 29 May 2016 19:07:18 +0800
MIME-Version: 1.0
In-Reply-To: <20160528031652.GC31255@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/28/2016 11:16 AM, Liu Bo wrote:
> On Fri, Jan 29, 2016 at 01:03:26PM +0800, Qu Wenruo wrote:
>> Introduce new function, migrate_reserved_ranges() to migrate used fs
>> data in btrfs reserved space.
>>
>> Unlike old implement, which will need to relocate all the complicated
>> csum and reference relocation, previous patches already ensure such
>> reserved ranges won't be allocated.
>> So here we only need copy these data out and create new
>> extent/csum/reference.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> ---
>>  btrfs-convert.c | 124 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 122 insertions(+), 2 deletions(-)
>>
>> diff --git a/btrfs-convert.c b/btrfs-convert.c
>> index 16e2309..f6126db 100644
>> --- a/btrfs-convert.c
>> +++ b/btrfs-convert.c
>> @@ -1679,6 +1679,123 @@ static int create_image_file_range_v2(struct btrfs_trans_handle *trans,
>>  	return ret;
>>  }
>>
>> +
>> +/*
>> + * Relocate old fs data in one reserved ranges
>> + *
>> + * Since all old fs data in reserved range is not covered by any chunk nor
>> + * data extent, we don't need to handle any reference but add new
>> + * extent/reference, which makes codes more clear
>> + */
>> +static int migrate_one_reserved_range(struct btrfs_trans_handle *trans,
>> +				      struct btrfs_root *root,
>> +				      struct cache_tree *used,
>> +				      struct btrfs_inode_item *inode, int fd,
>> +				      u64 ino, u64 start, u64 len, int datacsum)
>> +{
>> +	u64 cur_off = start;
>> +	u64 cur_len = len;
>> +	struct cache_extent *cache;
>> +	struct btrfs_key key;
>> +	struct extent_buffer *eb;
>> +	int ret = 0;
>> +
>> +	while (cur_off < start + len) {
>> +		cache = lookup_cache_extent(used, cur_off, cur_len);
>> +		if (!cache)
>> +			break;
>> +		cur_off = max(cache->start, cur_off);
>> +		cur_len = min(cache->start + cache->size, start + len) -
>> +			  cur_off;
>> +		BUG_ON(cur_len < root->sectorsize);
>> +
>> +		/* reserve extent for the data */
>> +		ret = btrfs_reserve_extent(trans, root, cur_len, 0, 0, (u64)-1,
>> +					   &key, 1);
>> +		if (ret < 0)
>> +			break;
>> +
>> +		eb = malloc(sizeof(*eb) + cur_len);
>> +		if (!eb) {
>> +			ret = -ENOMEM;
>> +			break;
>> +		}
>> +
>> +		ret = pread(fd, eb->data, cur_len, cur_off);
>> +		if (ret < cur_len) {
>> +			ret = (ret < 0 ? ret : -EIO);
>> +			free(eb);
>> +			break;
>> +		}
>> +		eb->start = key.objectid;
>> +		eb->len = key.offset;
>> +
>> +		/* Write the data */
>> +		ret = write_and_map_eb(trans, root, eb);
>> +		free(eb);
>> +		if (ret < 0)
>> +			break;
>
> With write_data_to_disk(), we don't have to create eb for write.
>
> Thanks,
>
> -liubo

Nice advice.

I didn't remember whether write_data_to_disk() was there when the 
patchset was written, but always a good idea to get rid of the temporary eb.

Thanks,
Qu

>> +
>> +		/* Now handle extent item and file extent things */
>> +		ret = btrfs_record_file_extent(trans, root, ino, inode, cur_off,
>> +					       key.objectid, key.offset);
>> +		if (ret < 0)
>> +			break;
>> +		/* Finally, insert csum items */
>> +		if (datacsum)
>> +			ret = csum_disk_extent(trans, root, key.objectid,
>> +					       key.offset);
>> +
>> +		cur_off += key.offset;
>> +		cur_len = start + len - cur_off;
>> +	}
>> +	return ret;
>> +}
>> +
>> +/*
>> + * Relocate the used ext2 data in reserved ranges
>> + * [0,1M)
>> + * [btrfs_sb_offset(1), +BTRFS_STRIPE_LEN)
>> + * [btrfs_sb_offset(2), +BTRFS_STRIPE_LEN)
>> + */
>> +static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
>> +				   struct btrfs_root *root,
>> +				   struct cache_tree *used,
>> +				   struct btrfs_inode_item *inode, int fd,
>> +				   u64 ino, u64 total_bytes, int datacsum)
>> +{
>> +	u64 cur_off;
>> +	u64 cur_len;
>> +	int ret = 0;
>> +
>> +	/* 0 ~ 1M */
>> +	cur_off = 0;
>> +	cur_len = 1024 * 1024;
>> +	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
>> +					 cur_off, cur_len, datacsum);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* second sb(fisrt sb is included in 0~1M) */
>> +	cur_off = btrfs_sb_offset(1);
>> +	cur_len = min(total_bytes, cur_off + BTRFS_STRIPE_LEN) - cur_off;
>> +	if (cur_off < total_bytes)
>> +		return ret;
>> +	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
>> +					 cur_off, cur_len, datacsum);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* Last sb */
>> +	cur_off = btrfs_sb_offset(2);
>> +	cur_len = min(total_bytes, cur_off + BTRFS_STRIPE_LEN) - cur_off;
>> +	if (cur_off < total_bytes)
>> +		return ret;
>> +	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
>> +					 cur_off, cur_len, datacsum);
>> +	return ret;
>> +}
>> +
>>  static int wipe_reserved_ranges(struct cache_tree *tree, u64 min_stripe_size,
>>  				int ensure_size);
>>
>> @@ -1687,11 +1804,10 @@ static int wipe_reserved_ranges(struct cache_tree *tree, u64 min_stripe_size,
>>   *
>>   * This is completely fs independent as we have cctx->used, only
>>   * need to create file extents point to all the posistions.
>> - * TODO: Add handler for reserved ranges in next patch
>>   */
>>  static int create_image_v2(struct btrfs_root *root,
>>  			   struct btrfs_mkfs_config *cfg,
>> -			   struct btrfs_convert_context *cctx,
>> +			   struct btrfs_convert_context *cctx, int fd,
>>  			   u64 size, char *name, int datacsum)
>>  {
>>  	struct btrfs_inode_item buf;
>> @@ -1769,6 +1885,10 @@ static int create_image_v2(struct btrfs_root *root,
>>  			goto out;
>>  		cur += len;
>>  	}
>> +	/* Handle the reserved ranges */
>> +	ret = migrate_reserved_ranges(trans, root, &cctx->used, &buf, fd, ino,
>> +				      cfg->num_bytes, datacsum);
>> +
>>
>>  	key.objectid = ino;
>>  	key.type = BTRFS_INODE_ITEM_KEY;
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
