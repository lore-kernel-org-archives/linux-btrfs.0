Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BC0C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 08:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D45320851
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 08:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfAQIwK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 03:52:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:39134 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbfAQIwJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 03:52:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9CC5BAD9C
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 08:52:07 +0000 (UTC)
Subject: Re: [PATCH 3/5] btrfs: extent_io: Kill the BUG_ON() in
 flush_write_bio()
To:     Qu Wenruo <wqu@suse.de>, linux-btrfs@vger.kernel.org
References: <20190117074855.24818-1-wqu@suse.com>
 <20190117074855.24818-4-wqu@suse.com>
 <9a8c3273-9ae3-9df5-33c3-f3f1e665a172@suse.com>
 <52327705-1e10-49f0-f05e-ab13d051c42b@suse.de>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <5a068056-c8ad-e6db-7f7d-c181b0842f01@suse.com>
Date:   Thu, 17 Jan 2019 10:52:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <52327705-1e10-49f0-f05e-ab13d051c42b@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 17.01.19 г. 10:28 ч., Qu Wenruo wrote:
> 
> 
> On 2019/1/17 下午4:22, Nikolay Borisov wrote:
>>
>>
>> On 17.01.19 г. 9:48 ч., Qu Wenruo wrote:
>>> This BUG_ON() is really just a crappy way to workaround the _must_check
>>> attribute of submit_one_bio().
>>>
>>> Now kill the BUG_ON() and allow flush_write_bio() to return error
>>> number.
>>>
>>> Also add _must_check attribute to flush_write_bio(), and modify all
>>> callers to handle the possible error returned.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  fs/btrfs/extent_io.c | 64 +++++++++++++++++++++++++++++++-------------
>>>  1 file changed, 46 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>> index 8a2335713a2d..a773bc46badc 100644
>>> --- a/fs/btrfs/extent_io.c
>>> +++ b/fs/btrfs/extent_io.c
>>> @@ -169,15 +169,15 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
>>>  	return blk_status_to_errno(ret);
>>>  }
>>>  
>>> -static void flush_write_bio(struct extent_page_data *epd)
>>> +static int __must_check flush_write_bio(struct extent_page_data *epd)
>>>  {
>>> -	if (epd->bio) {
>>> -		int ret;
>>> +	int ret = 0;
>>>  
>>> +	if (epd->bio) {
>>>  		ret = submit_one_bio(epd->bio, 0, 0);
>>> -		BUG_ON(ret < 0); /* -ENOMEM */
>>>  		epd->bio = NULL;
>>>  	}
>>> +	return ret;
>>>  }
>>>  
>>>  int __init extent_io_init(void)
>>> @@ -3509,8 +3509,10 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>>>  	int ret = 0;
>>>  
>>>  	if (!btrfs_try_tree_write_lock(eb)) {
>>> +		ret = flush_write_bio(epd);
>>> +		if (ret < 0)
>>> +			return ret;
>>>  		flush = 1;
>>> -		flush_write_bio(epd);
>>>  		btrfs_tree_lock(eb);
>>>  	}
>>>  
>>> @@ -3519,7 +3521,9 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>>>  		if (!epd->sync_io)
>>>  			return 0;
>>>  		if (!flush) {
>>> -			flush_write_bio(epd);
>>> +			ret = flush_write_bio(epd);
>>> +			if (ret < 0)
>>> +				return ret;
>>>  			flush = 1;
>>>  		}
>>>  		while (1) {
>>> @@ -3560,7 +3564,9 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>>>  
>>>  		if (!trylock_page(p)) {
>>>  			if (!flush) {
>>> -				flush_write_bio(epd);
>>> +				ret = flush_write_bio(epd);
>>> +				if (ret < 0)
>>> +					return ret;
>>
>> Can't you end up with partially locked pages here? Are you sure that
>> flush_write_bio will ALWAYS be executed when i = 0? If that\'s the case
>> then I think an assert(i == 0) is in order there.
> 
> An ASSERT() indeed makes sense here.
> 
> Although I could also make it better by recording the failed page number
> and unlock those already locked pages.

Unlocking is the correct way to handle it, the assert would be there to
prove that you won't ever need the unlocking code. If it triggers then
this case must be handled.

> 
> I'm OK either way.
> 
> Thanks,
> Qu
> 
>>
>>>  				flush = 1;
>>>  			}
>>>  			lock_page(p);
>>
>> <snip>
>>
