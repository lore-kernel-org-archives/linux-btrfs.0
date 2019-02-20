Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10D4C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 09:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 798FE208E4
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 09:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfBTJKd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 04:10:33 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:3703 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725813AbfBTJKc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 04:10:32 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A008AE51137714A20048;
        Wed, 20 Feb 2019 17:10:29 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.408.0; Wed, 20 Feb 2019
 17:10:24 +0800
Subject: Re: [PATCH -next] btrfs: Fix type conversion in btrfs_read_root_item
To:     Dan Carpenter <dan.carpenter@oracle.com>
References: <20190220030840.188854-1-yuehaibing@huawei.com>
 <20190220055621.GM17104@kadam> <20190220061009.GN17104@kadam>
CC:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <916bcaa1-8e55-ed93-4d77-9a82d7443703@huawei.com>
Date:   Wed, 20 Feb 2019 17:10:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190220061009.GN17104@kadam>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


On 2019/2/20 14:10, Dan Carpenter wrote:
> On Wed, Feb 20, 2019 at 08:58:43AM +0300, Dan Carpenter wrote:
>> On Wed, Feb 20, 2019 at 03:08:40AM +0000, YueHaibing wrote:
>>> btrfs_item_size_nr return value is u32, convert it to int may result
>>> in truncation.Also read_extent_buffer expect a unsigned param, so
>>> min_t should use type u32 to compare.
>>>
>>> Fixes: 8ea05e3a4262 ("Btrfs: introduce subvol uuids and times")
>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>> ---
>>>  fs/btrfs/root-tree.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
>>> index 02d1a57af78b..893d12fbfda0 100644
>>> --- a/fs/btrfs/root-tree.c
>>> +++ b/fs/btrfs/root-tree.c
>>> @@ -21,12 +21,12 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
>>>  				struct btrfs_root_item *item)
>>>  {
>>>  	uuid_le uuid;
>>> -	int len;
>>> +	u32 len;
>>>  	int need_reset = 0;
>>>  
>>>  	len = btrfs_item_size_nr(eb, slot);
>>>  	read_extent_buffer(eb, item, btrfs_item_ptr_offset(eb, slot),
>>> -			min_t(int, len, (int)sizeof(*item)));
>>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> Yeah, min_t() should normally cast to unsigned and the extra cast is
>> silly.
>>
> 
> Btw, I shouldn't have had to dig through the patch to find the *real*
> reason you wrote it.  A better description would have said:
> 
>     There is a messy cast here:
> 
> 	min_t(int, len, (int)sizeof(*item)));
> 
>     min_t() should normally cast to unsigned.  It's not possible for
>     "len" to be negative, but if it were then then we definitely
>     wouldn't want to pass negatives to read_extent_buffer().  Also there
>     is an extra cast.
> 
>     This patch shouldn't affect runtime, it's just a clean up.

Yes, This just a cleanup, Thanks!

> 
> regards,
> dan carpenter
> 
> 
> .
> 

