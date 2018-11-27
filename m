Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF35AC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 07:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A75542086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 07:16:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A75542086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbeK0SNo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 13:13:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:56880 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728521AbeK0SNo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 13:13:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 82188AF41
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 07:16:46 +0000 (UTC)
Subject: Re: [PATCH 2/5] btrfs-progs: image: Fix block group item flags when
 restoring multi-device image to single device
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20181127023315.28176-1-wqu@suse.com>
 <20181127023315.28176-3-wqu@suse.com>
 <39f8f85a-6469-ff5a-f745-fb4f97ff6593@suse.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <5be379c1-b3e0-2082-0379-b5947ff59df9@suse.de>
Date:   Tue, 27 Nov 2018 15:16:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <39f8f85a-6469-ff5a-f745-fb4f97ff6593@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/27 下午3:15, Nikolay Borisov wrote:
> 
> 
> On 27.11.18 г. 4:33 ч., Qu Wenruo wrote:
>> Since btrfs-image is just restoring tree blocks without really check if
>> that tree block contents makes sense, for multi-device image, block
>> group items will keep that incorrect block group flags.
>>
>> For example, for a metadata RAID1 data RAID0 btrfs recovered to a single
>> disk, its chunk tree will look like:
>>
>> 	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 22020096)
>> 		length 8388608 owner 2 stripe_len 65536 type SYSTEM
>> 	item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 30408704)
>> 		length 1073741824 owner 2 stripe_len 65536 type METADATA
>> 	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 1104150528)
>> 		length 1073741824 owner 2 stripe_len 65536 type DATA
>>
>> All chunks have correct type (SINGLE).
>>
>> While its block group items will look like:
>>
>> 	item 1 key (22020096 BLOCK_GROUP_ITEM 8388608)
>> 		block group used 16384 chunk_objectid 256 flags SYSTEM|RAID1
>> 	item 3 key (30408704 BLOCK_GROUP_ITEM 1073741824)
>> 		block group used 114688 chunk_objectid 256 flags METADATA|RAID1
>> 	item 11 key (1104150528 BLOCK_GROUP_ITEM 1073741824)
>> 		block group used 1572864 chunk_objectid 256 flags DATA|RAID0
>>
>> All block group items still have the wrong profiles.
>>
>> And btrfs check (lowmem mode for better output) will report error for such image:
>>
>>   ERROR: chunk[22020096 30408704) related block group item flags mismatch, wanted: 2, have: 18
>>   ERROR: chunk[30408704 1104150528) related block group item flags mismatch, wanted: 4, have: 20
>>   ERROR: chunk[1104150528 2177892352) related block group item flags mismatch, wanted: 1, have: 9
>>
>> This patch will do an extra repair for block group items to fix the
>> profile of them.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  image/main.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 47 insertions(+)
>>
>> diff --git a/image/main.c b/image/main.c
>> index 36b5c95ea146..9060f6b1b665 100644
>> --- a/image/main.c
>> +++ b/image/main.c
>> @@ -2164,6 +2164,52 @@ again:
>>  	return 0;
>>  }
>>  
>> +static void fixup_block_groups(struct btrfs_trans_handle *trans,
>> +			      struct btrfs_fs_info *fs_info)
> 
> You are not even using the trans handle in this function, why pass it?

Bad habit again.

Will definitely do something with that.

Thanks,
Qu

> 
>> +{
>> +	struct btrfs_block_group_cache *bg;
>> +	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>> +	struct cache_extent *ce;
>> +	struct map_lookup *map;
>> +	u64 extra_flags;
>> +
>> +	for (ce = search_cache_extent(&map_tree->cache_tree, 0); ce;
>> +	     ce = next_cache_extent(ce)) {
>> +		map = container_of(ce, struct map_lookup, ce);
>> +
>> +		bg = btrfs_lookup_block_group(fs_info, ce->start);
>> +		if (!bg) {
>> +			warning(
>> +		"can't find block group %llu, result fs may not be mountable",
>> +				ce->start);
>> +			continue;
>> +		}
>> +		extra_flags = map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
>> +
>> +		if (bg->flags == map->type)
>> +			continue;
>> +
>> +		/* Update the block group item and mark the bg dirty */
>> +		bg->flags = map->type;
>> +		btrfs_set_block_group_flags(&bg->item, bg->flags);
>> +		set_extent_bits(&fs_info->block_group_cache, ce->start,
>> +				ce->start + ce->size - 1, BLOCK_GROUP_DIRTY);
>> +
>> +		/*
>> +		 * Chunk and bg flags can be different, changing bg flags
>> +		 * without update avail_data/meta_alloc_bits will lead to
>> +		 * ENOSPC.
>> +		 * So here we set avail_*_alloc_bits to match chunk types.
>> +		 */
>> +		if (map->type & BTRFS_BLOCK_GROUP_DATA)
>> +			fs_info->avail_data_alloc_bits = extra_flags;
>> +		if (map->type & BTRFS_BLOCK_GROUP_METADATA)
>> +			fs_info->avail_metadata_alloc_bits = extra_flags;
>> +		if (map->type & BTRFS_BLOCK_GROUP_SYSTEM)
>> +			fs_info->avail_system_alloc_bits = extra_flags;
>> +	}
>> +}
>> +
>>  static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
>>  			 struct mdrestore_struct *mdres, off_t dev_size)
>>  {
>> @@ -2180,6 +2226,7 @@ static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
>>  		return PTR_ERR(trans);
>>  	}
>>  
>> +	fixup_block_groups(trans, fs_info);
>>  	ret = fixup_device_size(trans, fs_info, mdres, dev_size);
>>  	if (ret < 0)
>>  		goto error;
>>
