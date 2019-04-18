Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44434C10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 11:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D0F92183E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 11:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388749AbfDRLvS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 07:51:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:45608 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727807AbfDRLvR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 07:51:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EAECDAEBC;
        Thu, 18 Apr 2019 11:51:15 +0000 (UTC)
Subject: Re: [PATCH] btrfs: extent_io: Handle memory allocation failure in
 __clear_extent_bit()
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20190418072114.4573-1-wqu@suse.com>
 <b2ff0fa1-9fec-46e1-75f5-e7903523063f@suse.com>
 <f96176af-6e8a-4257-e49a-4ca2604e7226@suse.de>
 <20190418113853.GJ20156@twin.jikos.cz>
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
Message-ID: <324dd379-1794-eb65-f4f7-84e78d70435c@suse.de>
Date:   Thu, 18 Apr 2019 19:51:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190418113853.GJ20156@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/18 下午7:38, David Sterba wrote:
> On Thu, Apr 18, 2019 at 03:30:20PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/4/18 下午3:24, Nikolay Borisov wrote:
>>>
>>>
>>> On 18.04.19 г. 10:21 ч., Qu Wenruo wrote:
>>>> There is a BUG_ON() in __clear_extent_bit() for memory allocation
>>>> failure.
>>>>
>>>> While comment of __clear_extent_bit() says it can return error, but we
>>>> always return 0.
>>>>
>>>> Some __clear_extent_bit() callers just ignore the return value, while
>>>> some still expect error.
>>>>
>>>> Let's return proper error for this memory allocation anyway, to remove
>>>> that BUG_ON() as a first step, so at least we can continue test.
>>>
>>> I remember Josef did some changes into this code and said that prealloc
>>> shouldn't fail because this will cause mayhem down the road i.e. proper
>>> error handling is missing. If anything I think it should be added first
>>> and then remove the BUG_ONs.
>>
>> That's true, we could have some strange lockup due to
>> lock_extent_bits(), as if some clear_extent_bits() failed due to ENOMEM
>> and caller just ignore the error, we could have a lockup.
> 
> Not only lockup but unhandled failed extent range locking totally breaks
> assumptions that the following code makes and this would lead to
> unpredictable corruptions. Just count how many lock_extent_bits calls
> are there. And any caller of __set_extent_bit. There are so many that
> the BUG_ON is the measure of last resort to prevent worse problems.
> 
>> I'll try to pre-allocate certain amount of extent_state as the last
>> chance of redemption.
> 
> This only lowers the chances to hit the allocation error but there's
> always a case when certain amount + 1 would be needed.

Lower chance is already good enough (TM) for low possibility (0.001)
error injection.

And, for real world low memory case, lower chance in btrfs means higher
chance in other subsystem, less chance user will blame btrfs. :)

> 
>> Anyway, such BUG_ON() right after kmalloc() is really a blockage for
>> error injection test.
> 
> Maybe, but the code is not yet in the state to inject memory allocation
> faiulres to that particular path (ie. the state changes).

With last-chance reservation, we can make state related memory
allocation almost always to success even memory allocation failure
injected (if the possibility is low and low concurrency)
And the last-chance reservation can be configured at compile/module load
time, making it flex enough for most cases.

The main reason I'm doing such error injection test is to ensure write
time tree checker is not the cause of the lockup.

Of course I can directly inject error into btrfs_check_leaf_full() and
btrfs_check_node(), and filter the stack to ensure it only happen in
write time, and that's already what I'm crafting, based on the bcc error
inject example and kprobe return value overriding.

But it will never be a bad idea to explore what can go wrong.
And "always BUG_ON()" -> "good enough (TM)" already looks like a
improvement to me.

Thanks,
Qu
