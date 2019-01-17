Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FB7C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 08:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F62A20657
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 08:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfAQI2Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 03:28:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:33686 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725898AbfAQI2Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 03:28:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 43589AEE5
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 08:28:23 +0000 (UTC)
Subject: Re: [PATCH 3/5] btrfs: extent_io: Kill the BUG_ON() in
 flush_write_bio()
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190117074855.24818-1-wqu@suse.com>
 <20190117074855.24818-4-wqu@suse.com>
 <9a8c3273-9ae3-9df5-33c3-f3f1e665a172@suse.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <52327705-1e10-49f0-f05e-ab13d051c42b@suse.de>
Date:   Thu, 17 Jan 2019 16:28:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <9a8c3273-9ae3-9df5-33c3-f3f1e665a172@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/1/17 下午4:22, Nikolay Borisov wrote:
> 
> 
> On 17.01.19 г. 9:48 ч., Qu Wenruo wrote:
>> This BUG_ON() is really just a crappy way to workaround the _must_check
>> attribute of submit_one_bio().
>>
>> Now kill the BUG_ON() and allow flush_write_bio() to return error
>> number.
>>
>> Also add _must_check attribute to flush_write_bio(), and modify all
>> callers to handle the possible error returned.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/extent_io.c | 64 +++++++++++++++++++++++++++++++-------------
>>  1 file changed, 46 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 8a2335713a2d..a773bc46badc 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -169,15 +169,15 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
>>  	return blk_status_to_errno(ret);
>>  }
>>  
>> -static void flush_write_bio(struct extent_page_data *epd)
>> +static int __must_check flush_write_bio(struct extent_page_data *epd)
>>  {
>> -	if (epd->bio) {
>> -		int ret;
>> +	int ret = 0;
>>  
>> +	if (epd->bio) {
>>  		ret = submit_one_bio(epd->bio, 0, 0);
>> -		BUG_ON(ret < 0); /* -ENOMEM */
>>  		epd->bio = NULL;
>>  	}
>> +	return ret;
>>  }
>>  
>>  int __init extent_io_init(void)
>> @@ -3509,8 +3509,10 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>>  	int ret = 0;
>>  
>>  	if (!btrfs_try_tree_write_lock(eb)) {
>> +		ret = flush_write_bio(epd);
>> +		if (ret < 0)
>> +			return ret;
>>  		flush = 1;
>> -		flush_write_bio(epd);
>>  		btrfs_tree_lock(eb);
>>  	}
>>  
>> @@ -3519,7 +3521,9 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>>  		if (!epd->sync_io)
>>  			return 0;
>>  		if (!flush) {
>> -			flush_write_bio(epd);
>> +			ret = flush_write_bio(epd);
>> +			if (ret < 0)
>> +				return ret;
>>  			flush = 1;
>>  		}
>>  		while (1) {
>> @@ -3560,7 +3564,9 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>>  
>>  		if (!trylock_page(p)) {
>>  			if (!flush) {
>> -				flush_write_bio(epd);
>> +				ret = flush_write_bio(epd);
>> +				if (ret < 0)
>> +					return ret;
> 
> Can't you end up with partially locked pages here? Are you sure that
> flush_write_bio will ALWAYS be executed when i = 0? If that\'s the case
> then I think an assert(i == 0) is in order there.

An ASSERT() indeed makes sense here.

Although I could also make it better by recording the failed page number
and unlock those already locked pages.

I'm OK either way.

Thanks,
Qu

> 
>>  				flush = 1;
>>  			}
>>  			lock_page(p);
> 
> <snip>
> 
