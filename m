Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45260 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753244AbbGYBS7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 21:18:59 -0400
Subject: Re: [PATCH 4/4] btrfs: convert: Avoid allocating metadata extent
 crossing stripe boundary
To: <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1437643090-13920-5-git-send-email-quwenruo@cn.fujitsu.com>
 <20150724123447.GX6306@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55B2E3FE.5060706@cn.fujitsu.com>
Date: Sat, 25 Jul 2015 09:18:54 +0800
MIME-Version: 1.0
In-Reply-To: <20150724123447.GX6306@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/07/24 14:34 +0200:
> On Thu, Jul 23, 2015 at 05:18:10PM +0800, Qu Wenruo wrote:
>> @@ -246,6 +247,14 @@ static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
>>   			continue;
>>   		}
>>
>> +		if (metadata) {
>> +			BUG_ON(num_bytes != root->nodesize);
>
> This caught my attention and looking at possible values of num_bytes,
> this can crash:
>
> 1291         for (last_byte = 0; last_byte < first_free; last_byte += sectorsize) {
> 1292                 ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);
>
> where sectorsize == num_bytes.
For that case, the last 0 means that's a data block,
and won't comes to the BUG_ON, as it is only designed for metadata.
And for metadata allocation, the size will only be nodes/leafsize

Thanks,
Qu
>
>> +			if (check_crossing_stripes(start, num_bytes)) {
>> +				last = round_down(start + num_bytes,
>> +						  BTRFS_STRIPE_LEN);
>> +				continue;
>> +			}
>> +		}
>>   		clear_extent_dirty(&root->fs_info->free_space_cache,
>>   				   start, start + num_bytes - 1, 0);
>>
>> @@ -1280,7 +1289,7 @@ static int create_ext2_image(struct btrfs_root *root, ext2_filsys ext2_fs,
>>   	 * special, we can't rely on relocate_extents_range to relocate it.
>>   	 */
>>   	for (last_byte = 0; last_byte < first_free; last_byte += sectorsize) {
>> -		ret = custom_alloc_extent(root, sectorsize, 0, &key);
>> +		ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);
>
> Same here.
>
>> -			ret = custom_alloc_extent(root, sectorsize, 0, &key);
>> +			ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);
>
> And here.
>
> I hope there's a way how to avoid the BUG_ON at all.
>
