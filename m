Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD16C10F0B
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 07:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F2D82083D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 07:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbfDRHa2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 03:30:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:56688 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729446AbfDRHa2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 03:30:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8A9B0AF38;
        Thu, 18 Apr 2019 07:30:26 +0000 (UTC)
Subject: Re: [PATCH] btrfs: extent_io: Handle memory allocation failure in
 __clear_extent_bit()
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>
References: <20190418072114.4573-1-wqu@suse.com>
 <b2ff0fa1-9fec-46e1-75f5-e7903523063f@suse.com>
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
Message-ID: <f96176af-6e8a-4257-e49a-4ca2604e7226@suse.de>
Date:   Thu, 18 Apr 2019 15:30:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b2ff0fa1-9fec-46e1-75f5-e7903523063f@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/18 下午3:24, Nikolay Borisov wrote:
> 
> 
> On 18.04.19 г. 10:21 ч., Qu Wenruo wrote:
>> There is a BUG_ON() in __clear_extent_bit() for memory allocation
>> failure.
>>
>> While comment of __clear_extent_bit() says it can return error, but we
>> always return 0.
>>
>> Some __clear_extent_bit() callers just ignore the return value, while
>> some still expect error.
>>
>> Let's return proper error for this memory allocation anyway, to remove
>> that BUG_ON() as a first step, so at least we can continue test.
> 
> I remember Josef did some changes into this code and said that prealloc
> shouldn't fail because this will cause mayhem down the road i.e. proper
> error handling is missing. If anything I think it should be added first
> and then remove the BUG_ONs.

That's true, we could have some strange lockup due to
lock_extent_bits(), as if some clear_extent_bits() failed due to ENOMEM
and caller just ignore the error, we could have a lockup.

I'll try to pre-allocate certain amount of extent_state as the last
chance of redemption.

Anyway, such BUG_ON() right after kmalloc() is really a blockage for
error injection test.

Thanks,
Qu

> 
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/extent_io.c | 12 ++++++++++--
>>  1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 828708f6510c..f1bfc632ef7b 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -743,7 +743,10 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>>  
>>  	if (state->start < start) {
>>  		prealloc = alloc_extent_state_atomic(prealloc);
>> -		BUG_ON(!prealloc);
>> +		if (!prealloc) {
>> +			err = -ENOMEM;
>> +			goto out;
>> +		}
>>  		err = split_state(tree, state, prealloc, start);
>>  		if (err)
>>  			extent_io_tree_panic(tree, err);
>> @@ -766,7 +769,10 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>>  	 */
>>  	if (state->start <= end && state->end > end) {
>>  		prealloc = alloc_extent_state_atomic(prealloc);
>> -		BUG_ON(!prealloc);
>> +		if (!prealloc) {
>> +			err = -ENOMEM;
>> +			goto out;
>> +		}
>>  		err = split_state(tree, state, prealloc, end + 1);
>>  		if (err)
>>  			extent_io_tree_panic(tree, err);
>> @@ -801,6 +807,8 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>>  	if (prealloc)
>>  		free_extent_state(prealloc);
>>  
>> +	if (err)
>> +		return err;
>>  	return 0;
>>  
>>  }
>>
