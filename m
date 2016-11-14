Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33301 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751643AbcKNBzn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Nov 2016 20:55:43 -0500
Subject: Re: [RFC] btrfs: make max inline data can be equal to sectorsize
To: <bo.li.liu@oracle.com>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
References: <20161011064742.17364-1-wangxg.fnst@cn.fujitsu.com>
 <20161111202210.GB30930@dhcp-whq-twvpn-1-vpnpool-10-159-131-21.vpn.oracle.com>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <1bbc9b5f-9bdb-d8b6-bbd5-7718ea33dcef@cn.fujitsu.com>
Date: Mon, 14 Nov 2016 09:55:34 +0800
MIME-Version: 1.0
In-Reply-To: <20161111202210.GB30930@dhcp-whq-twvpn-1-vpnpool-10-159-131-21.vpn.oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/12/2016 04:22 AM, Liu Bo wrote:
> On Tue, Oct 11, 2016 at 02:47:42PM +0800, Wang Xiaoguang wrote:
>> If we use mount option "-o max_inline=sectorsize", say 4096, indeed
>> even for a fresh fs, say nodesize is 16k, we can not make the first
>> 4k data completely inline, I found this conditon causing this issue:
>>   !compressed_size && (actual_end & (root->sectorsize - 1)) == 0
>>
>> If it retuns true, we'll not make data inline. For 4k sectorsize,
>> 0~4094 dara range, we can make it inline, but 0~4095, it can not.
>> I don't think this limition is useful, so here remove it which will
>> make max inline data can be equal to sectorsize.
>
> It's difficult to tell whether we need this, I'm not a big fan of using
> max_inline size more than the default size 2048, given that most reports
> about ENOSPC is due to metadata and inline may make it worse.

IMHO if we can use inline data extents to trigger ENOSPC more easily, 
then we should allow it to dig the problem further.

Just ignoring it because it may cause more bug will not solve the real 
problem anyway.

Thanks,
Qu

>
> Thanks,
>
> -liubo
>
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/inode.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index ea15520..c0db393 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -267,8 +267,6 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
>>  	if (start > 0 ||
>>  	    actual_end > root->sectorsize ||
>>  	    data_len > BTRFS_MAX_INLINE_DATA_SIZE(root) ||
>> -	    (!compressed_size &&
>> -	    (actual_end & (root->sectorsize - 1)) == 0) ||
>>  	    end + 1 < isize ||
>>  	    data_len > root->fs_info->max_inline) {
>>  		return 1;
>> --
>> 2.9.0
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
>


