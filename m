Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5195BC7112C
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24486206B5
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24486206B5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbeJXMAu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 08:00:50 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:1940 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726301AbeJXMAu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 08:00:50 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46629775"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 24 Oct 2018 09:19:54 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id A607B4B7117E;
        Wed, 24 Oct 2018 09:19:54 +0800 (CST)
Received: from [10.167.226.24] (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 24 Oct 2018 09:20:00 +0800
Subject: Re: [PATCH 03/13] btrfs-progs: lowmem: fix false alert if extent item
 has been repaired
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-4-suy.fnst@cn.fujitsu.com>
 <3363e342-9acc-95d4-cf70-2872fc8b6258@gmx.com>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <825f4755-1f86-e778-7c9b-3798ea5c7185@cn.fujitsu.com>
Date:   Wed, 24 Oct 2018 09:27:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <3363e342-9acc-95d4-cf70-2872fc8b6258@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: A607B4B7117E.ABD2A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/23/18 6:30 PM, Qu Wenruo wrote:
> 
> 
> On 2018/10/23 下午5:41, Su Yue wrote:
>> Previously, @err are assigned immediately after check but before
>> repair.
>> repair_extent_item()'s return value also confuses the caller. If
>> error has been repaired and returns 0, check_extent_item() will try
>> to continue check the nonexistent and cause flase alerts.
>>
>> Here make repair_extent_item()'s return codes only represents status
>> of the extent item, error bits are passed by pointer.
>> Move the change of @err after repair.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>   check/mode-lowmem.c | 106 ++++++++++++++++++++++++++++----------------
>>   1 file changed, 68 insertions(+), 38 deletions(-)
>>
>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>> index 76e7be81ceb1..769b3141de8b 100644
>> --- a/check/mode-lowmem.c
>> +++ b/check/mode-lowmem.c
>> @@ -3788,35 +3788,35 @@ out:
>>   /*
>>    * Only delete backref if REFERENCER_MISSING now
>>    *
>> - * Returns <0   the extent was deleted
>> - * Returns >0   the backref was deleted but extent still exists, returned value
>> - *               means error after repair
>> + * Returns <0   the whole extent item was deleted
>> + * Returns >0   the backref was deleted but extent still exists, @err_ret
>> + *		will be set to be error bits after repair.
> 
> Well, I have to admit the parameter list is really human friendly from
> the initial design.
> 

As my previous design, callers of repair_xxx functions just take
care of successes, failures and pathes. If exposing the logic
to the callers is acceptable, will do it as your suggestions.

Thanks,
Su

> In fact, the only real user of @err is just that "if ((err &
> (REFERENCER_MISSING | REFERENCER_MISMATCH)) == 0)" line.
> 
> We can in fact get rid of that @err parameter and do that check at the
> only caller of repair_extent_item().
> 
> 
> And then redefine the return value.
> 
> Like "Return < 0 if we failed to repair backref for the extent.
> Return 0 if we repaired the backref for the extent".
> 
> [snip]
>>   
>> -	if (err && repair) {
>> +	if (tmp_err && repair) {
>>   		ret = repair_extent_item(fs_info->extent_root, path,
>>   			 key.objectid, num_bytes, parent, root_objectid,
>> -			 owner, owner_offset, ret);
>> -		if (ret < 0)
> 
> If follow my above method, here the code can be a little easier:
> 	if (tmp_err && repair) {
> 		if (!(tmp_err & (REFERENCER_MISSING |
> 		    REFENCER_MISMATCH)) {
> 			err |= tmp_err;
> 			goto next;
> 		}
> 		ret = repair_extent_item(...);
> 		if (ret < 0)
> 			err |= tmp_err;
> 	} else if (tmp_err) {
> 		err |= tmp_err;
> 	}
> 

> Without the need to passing @err into repair_extent_item() nor modifying
> @err in that function.
> 
> Thanks,
> Qu
> 
>> +			 owner, owner_offset, &tmp_err);
>> +		err |= tmp_err;
>> +
>> +		if (tmp_err & FATAL_ERROR || ret < 0)
>>   			goto out;
>> -		if (ret) {
>> +		/*
>> +		 * the error has been repaired which means the extent item
>> +		 * is still existed with other backrefs, go to check next.
>> +		 */> +		if (ret > 0) {
>> +			eb = path->nodes[0];
>> +			slot = path->slots[0];
>> +			ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
>> +			item_size = btrfs_item_size_nr(eb, slot);
>>   			goto next;
>> -			err = ret;
>>   		}
>> +	} else {
>> +		err |= tmp_err;
>>   	}
>>   
>> -	ptr += btrfs_extent_inline_ref_size(type);
>> +	ptr_offset += btrfs_extent_inline_ref_size(type);
>>   	goto next;
>>   
>>   out:
>>
> 
> 


