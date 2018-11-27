Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D17C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 07:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75B1120989
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 07:35:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75B1120989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbeK0Sce (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 13:32:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:58860 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727631AbeK0Sce (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 13:32:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9F221AEB7
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 07:35:33 +0000 (UTC)
Subject: Re: [PATCH 4/5] btrfs-progs: image: Rebuild dev extents using chunk
 tree
To:     Qu Wenruo <wqu@suse.de>, linux-btrfs@vger.kernel.org
References: <20181127023315.28176-1-wqu@suse.com>
 <20181127023315.28176-5-wqu@suse.com>
 <3def8323-9497-dd90-b53f-f1abaea140da@suse.com>
 <7f10b526-ce85-b7cf-99f8-a5202155c5c4@suse.de>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <973598ea-c9aa-357c-e62b-1d43e376a460@suse.com>
Date:   Tue, 27 Nov 2018 09:35:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <7f10b526-ce85-b7cf-99f8-a5202155c5c4@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 27.11.18 г. 9:30 ч., Qu Wenruo wrote:
> 
> 
> On 2018/11/27 下午3:28, Nikolay Borisov wrote:
>>
>>
>> On 27.11.18 г. 4:33 ч., Qu Wenruo wrote:
>>> With existing dev extents cleaned up, now we can rebuild dev extents
>>> using the correct chunk tree.
>>>
>>> Since new dev extents are all rebuild from scratch, even we're restoring
>>> image from multi-device fs to single disk, we won't have any problem
>>> reported by btrfs check.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  image/main.c | 34 ++++++++++++++++++++++++++++++++++
>>>  volumes.c    | 10 +++++-----
>>>  volumes.h    |  4 ++++
>>>  3 files changed, 43 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/image/main.c b/image/main.c
>>> index 707568f22e01..626eb933d5cc 100644
>>> --- a/image/main.c
>>> +++ b/image/main.c
>>> @@ -2265,12 +2265,46 @@ out:
>>>  static int fixup_dev_extents(struct btrfs_trans_handle *trans,
>>>  			     struct btrfs_fs_info *fs_info)
>>>  {
>>> +	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>>> +	struct btrfs_device *dev;
>>> +	struct cache_extent *ce;
>>> +	struct map_lookup *map;
>>> +	u64 devid = btrfs_stack_device_id(&fs_info->super_copy->dev_item);
>>> +	int i;
>>>  	int ret;
>>>  
>>>  	ret = remove_all_dev_extents(trans, fs_info);
>>>  	if (ret < 0)
>>>  		error("failed to remove all existing dev extents: %s",
>>>  			strerror(-ret));
>>> +
>>> +	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
>>> +	if (!dev) {
>>> +		error("faild to find devid %llu", devid);
>>> +		return -ENODEV;
>>> +	}
>>> +
>>> +	/* Rebuild all dev extents using chunk maps */
>>> +	for (ce = search_cache_extent(&map_tree->cache_tree, 0); ce;
>>> +	     ce = next_cache_extent(ce)) {
>>> +		u64 stripe_len;
>>> +
>>> +		map = container_of(ce, struct map_lookup, ce);
>>> +		stripe_len = calc_stripe_length(map->type, ce->size,
>>> +						map->num_stripes);
>>> +		for (i = 0; i < map->num_stripes; i++) {
>>> +			ret = btrfs_alloc_dev_extent(trans, dev, ce->start,
>>> +				stripe_len, &map->stripes[i].physical, 1);
>>> +			if (ret < 0) {
>>> +				error(
>>> +				"failed to insert dev extent %llu %llu: %s",
>>> +					devid, map->stripes[i].physical,
>>> +					strerror(-ret));
>>> +				goto out;
>>> +			}
>>> +		}
>>> +	}
>>> +out:
>>>  	return ret;
>>>  }
>>>  
>>> diff --git a/volumes.c b/volumes.c
>>> index 30090ce5f8e8..73c9204fa7d1 100644
>>> --- a/volumes.c
>>> +++ b/volumes.c
>>> @@ -530,10 +530,10 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
>>>  	return find_free_dev_extent_start(device, num_bytes, 0, start, len);
>>>  }
>>>  
>>> -static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>>> -				  struct btrfs_device *device,
>>> -				  u64 chunk_offset, u64 num_bytes, u64 *start,
>>> -				  int convert)
>>> +int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>>> +			   struct btrfs_device *device,
>>> +			   u64 chunk_offset, u64 num_bytes, u64 *start,
>>> +			   int insert_asis)
>>
>> Make that parameter a bool. Also why do you rename it ?
> 
> Since it's no longer only used by convert.
> 
> The best naming may be two function, one called
> btrfs_insert_device_extent(), and then btrfs_alloc_device_extent().
> 
> As for convert and this use case, we are not allocating, but just
> inserting one.
> 
> What about above naming change?

Indeed  two functions seem better, btrfs_alloc_device_extent will be a
wrapper of btrfs_insert_device_extent + the added find_free_dev_extent,
whereas btrfs_insert_device_extent will be the function doing the actual
insert.

> 
> Thanks,
> Qu
> 
>>
>>>  {
>>>  	int ret;
>>>  	struct btrfs_path *path;
>>> @@ -550,7 +550,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>>>  	 * For convert case, just skip search free dev_extent, as caller
>>>  	 * is responsible to make sure it's free.
>>>  	 */
>>> -	if (!convert) {
>>> +	if (!insert_asis) {
>>>  		ret = find_free_dev_extent(device, num_bytes, start, NULL);
>>>  		if (ret)
>>>  			goto err;
>>> diff --git a/volumes.h b/volumes.h
>>> index b4ea93f0bec3..5ca2779ebd45 100644
>>> --- a/volumes.h
>>> +++ b/volumes.h
>>> @@ -271,6 +271,10 @@ void btrfs_close_all_devices(void);
>>>  int btrfs_add_device(struct btrfs_trans_handle *trans,
>>>  		     struct btrfs_fs_info *fs_info,
>>>  		     struct btrfs_device *device);
>>> +int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>>> +			   struct btrfs_device *device,
>>> +			   u64 chunk_offset, u64 num_bytes, u64 *start,
>>> +			   int insert_asis);
>>>  int btrfs_update_device(struct btrfs_trans_handle *trans,
>>>  			struct btrfs_device *device);
>>>  int btrfs_scan_one_device(int fd, const char *path,
>>>
> 
