Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19996 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755098Ab3GYIZ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 04:25:59 -0400
Message-ID: <51F0E150.6080203@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 16:26:56 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: Andi Shyti <andi@etezian.org>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: avoid double allocation
References: <1374710980-5707-1-git-send-email-andi@etezian.org> <20130725081840.GB5202@localhost.localdomain>
In-Reply-To: <20130725081840.GB5202@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 25 Jul 2013 16:18:41 +0800, Liu Bo wrote:
> On Thu, Jul 25, 2013 at 02:09:40AM +0200, Andi Shyti wrote:
>> alloc_rbio frees already bbio and raid_map, therefore they don't
>> need to be freed in case it fails
>>
> 
> Looks good to me.
> 
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Dan Carpenter has fixed this problem in patch
https://patchwork.kernel.org/patch/2831091/

Thanks
Miao

> 
>> Signed-off-by: Andi Shyti <andi@etezian.org>
>> ---
>>  fs/btrfs/raid56.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
>> index 0525e13..35fe775 100644
>> --- a/fs/btrfs/raid56.c
>> +++ b/fs/btrfs/raid56.c
>> @@ -1687,11 +1687,9 @@ int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
>>  	struct blk_plug_cb *cb;
>>  
>>  	rbio = alloc_rbio(root, bbio, raid_map, stripe_len);
>> -	if (IS_ERR(rbio)) {
>> -		kfree(raid_map);
>> -		kfree(bbio);
>> +	if (IS_ERR(rbio))
>>  		return PTR_ERR(rbio);
>> -	}
>> +
>>  	bio_list_add(&rbio->bio_list, bio);
>>  	rbio->bio_list_bytes = bio->bi_size;
>>  
>> -- 
>> 1.8.3.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> -liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

