Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31423C10F05
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 00:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00253208E4
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 00:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbfC0ANl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 20:13:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:49610 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726982AbfC0ANl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 20:13:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1680B91B;
        Wed, 27 Mar 2019 00:13:39 +0000 (UTC)
Subject: Re: [PATCh v2 8/9] btrfs: tree-checker: Verify inode item
To:     dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-9-wqu@suse.com>
 <a8e3f871-370a-464b-a0ae-f4da93f0eed8@gmx.com>
 <20190326160248.GV10640@twin.jikos.cz>
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
Message-ID: <32920968-24ef-34c1-0216-ef2ebb999747@suse.de>
Date:   Wed, 27 Mar 2019 08:13:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190326160248.GV10640@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/27 上午12:02, David Sterba wrote:
> On Mon, Mar 25, 2019 at 12:27:24PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/3/20 下午2:37, Qu Wenruo wrote:
>>> There is a report in kernel bugzilla about mismatch file type in dir
>>> item and inode item.
>>>
>>> This inspires us to check inode mode in inode item.
>>>
>>> This patch will check the following members:
>>> - inode key objectid
>>>   Should be ROOT_DIR_DIR or [256, (u64)-256] or FREE_INO.
>>>
>>> - inode key offset
>>>   Should be 0
>>>
>>> - inode item generation
>>> - inode item transid
>>>   No newer than sb generation + 1.
>>>   The +1 is for log tree.
>>>
>>> - inode item mode
>>>   No unknown bits.
>>>   No invalid S_IF* bit.
>>>   NOTE: S_IFMT check is not enough, need to check every know type.
>>>
>>> - inode item nlink
>>>   Dir should have no more link than 1.
>>>
>>> - inode item flags
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>>
>> There is some bug report of kernel producing free space cache inode with
>> mode 0, which is invalid and can be detected by this patch.
>>
>> Although the patch itself is good, I'm afraid we need to address the
>> invalid inode mode created by old kernel in btrfs-progs at least before
>> merging this patch into upstream.
> 
> Can this be addressed on the kernel side? Like detecting the invalid
> mode, print a warning and the fix on the next write. The progs can
> detect and fix that too of course.

So far even on older fs images (like those in btrfs-progs fsck tests), I
noticed no such invalid free space inode at all.

And from the history of that code, the mode is fixed to 100600 since 2010.
Currently I believe it's uncommon to see that case.

Furthermore, the btrfs-progs fix for such case is already submitted, as
long as we have a minor release to include that fix, it should be OK.

> 
> So I'll keep the patch working as-is, we can relax the error to a
> warning if we're out of time or find out that it needs to be that way
> due to backward compatibilit reasons.
> 
