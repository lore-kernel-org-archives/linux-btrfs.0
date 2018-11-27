Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24D6C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 07:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B582B20873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 07:30:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B582B20873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbeK0S11 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 13:27:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:58258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729104AbeK0S11 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 13:27:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B215AEB7
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 07:30:27 +0000 (UTC)
Subject: Re: [PATCH 4/5] btrfs-progs: image: Rebuild dev extents using chunk
 tree
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20181127023315.28176-1-wqu@suse.com>
 <20181127023315.28176-5-wqu@suse.com>
 <3def8323-9497-dd90-b53f-f1abaea140da@suse.com>
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
Message-ID: <7f10b526-ce85-b7cf-99f8-a5202155c5c4@suse.de>
Date:   Tue, 27 Nov 2018 15:30:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <3def8323-9497-dd90-b53f-f1abaea140da@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/27 下午3:28, Nikolay Borisov wrote:
> 
> 
> On 27.11.18 г. 4:33 ч., Qu Wenruo wrote:
>> With existing dev extents cleaned up, now we can rebuild dev extents
>> using the correct chunk tree.
>>
>> Since new dev extents are all rebuild from scratch, even we're restoring
>> image from multi-device fs to single disk, we won't have any problem
>> reported by btrfs check.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  image/main.c | 34 ++++++++++++++++++++++++++++++++++
>>  volumes.c    | 10 +++++-----
>>  volumes.h    |  4 ++++
>>  3 files changed, 43 insertions(+), 5 deletions(-)
>>
>> diff --git a/image/main.c b/image/main.c
>> index 707568f22e01..626eb933d5cc 100644
>> --- a/image/main.c
>> +++ b/image/main.c
>> @@ -2265,12 +2265,46 @@ out:
>>  static int fixup_dev_extents(struct btrfs_trans_handle *trans,
>>  			     struct btrfs_fs_info *fs_info)
>>  {
>> +	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>> +	struct btrfs_device *dev;
>> +	struct cache_extent *ce;
>> +	struct map_lookup *map;
>> +	u64 devid = btrfs_stack_device_id(&fs_info->super_copy->dev_item);
>> +	int i;
>>  	int ret;
>>  
>>  	ret = remove_all_dev_extents(trans, fs_info);
>>  	if (ret < 0)
>>  		error("failed to remove all existing dev extents: %s",
>>  			strerror(-ret));
>> +
>> +	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
>> +	if (!dev) {
>> +		error("faild to find devid %llu", devid);
>> +		return -ENODEV;
>> +	}
>> +
>> +	/* Rebuild all dev extents using chunk maps */
>> +	for (ce = search_cache_extent(&map_tree->cache_tree, 0); ce;
>> +	     ce = next_cache_extent(ce)) {
>> +		u64 stripe_len;
>> +
>> +		map = container_of(ce, struct map_lookup, ce);
>> +		stripe_len = calc_stripe_length(map->type, ce->size,
>> +						map->num_stripes);
>> +		for (i = 0; i < map->num_stripes; i++) {
>> +			ret = btrfs_alloc_dev_extent(trans, dev, ce->start,
>> +				stripe_len, &map->stripes[i].physical, 1);
>> +			if (ret < 0) {
>> +				error(
>> +				"failed to insert dev extent %llu %llu: %s",
>> +					devid, map->stripes[i].physical,
>> +					strerror(-ret));
>> +				goto out;
>> +			}
>> +		}
>> +	}
>> +out:
>>  	return ret;
>>  }
>>  
>> diff --git a/volumes.c b/volumes.c
>> index 30090ce5f8e8..73c9204fa7d1 100644
>> --- a/volumes.c
>> +++ b/volumes.c
>> @@ -530,10 +530,10 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
>>  	return find_free_dev_extent_start(device, num_bytes, 0, start, len);
>>  }
>>  
>> -static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>> -				  struct btrfs_device *device,
>> -				  u64 chunk_offset, u64 num_bytes, u64 *start,
>> -				  int convert)
>> +int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>> +			   struct btrfs_device *device,
>> +			   u64 chunk_offset, u64 num_bytes, u64 *start,
>> +			   int insert_asis)
> 
> Make that parameter a bool. Also why do you rename it ?

Since it's no longer only used by convert.

The best naming may be two function, one called
btrfs_insert_device_extent(), and then btrfs_alloc_device_extent().

As for convert and this use case, we are not allocating, but just
inserting one.

What about above naming change?

Thanks,
Qu

> 
>>  {
>>  	int ret;
>>  	struct btrfs_path *path;
>> @@ -550,7 +550,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>>  	 * For convert case, just skip search free dev_extent, as caller
>>  	 * is responsible to make sure it's free.
>>  	 */
>> -	if (!convert) {
>> +	if (!insert_asis) {
>>  		ret = find_free_dev_extent(device, num_bytes, start, NULL);
>>  		if (ret)
>>  			goto err;
>> diff --git a/volumes.h b/volumes.h
>> index b4ea93f0bec3..5ca2779ebd45 100644
>> --- a/volumes.h
>> +++ b/volumes.h
>> @@ -271,6 +271,10 @@ void btrfs_close_all_devices(void);
>>  int btrfs_add_device(struct btrfs_trans_handle *trans,
>>  		     struct btrfs_fs_info *fs_info,
>>  		     struct btrfs_device *device);
>> +int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>> +			   struct btrfs_device *device,
>> +			   u64 chunk_offset, u64 num_bytes, u64 *start,
>> +			   int insert_asis);
>>  int btrfs_update_device(struct btrfs_trans_handle *trans,
>>  			struct btrfs_device *device);
>>  int btrfs_scan_one_device(int fd, const char *path,
>>
