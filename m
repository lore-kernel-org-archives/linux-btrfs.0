Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C3FC282CE
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 16:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DB9220700
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 16:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfBKOXk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 09:23:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:53272 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729024AbfBKOXi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 09:23:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 35738AE6B
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 14:23:36 +0000 (UTC)
Subject: Re: [PATCH v3 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190211051653.3167-1-wqu@suse.com>
 <20190211051653.3167-2-wqu@suse.com>
 <216f4acf-faf9-6ca3-c9f2-68a9eaa763fa@suse.com>
 <77f7ed38-aca5-f799-08eb-e8a3100fe57c@suse.de>
 <8e4f62e1-f0ab-5f1f-6fc6-684d3e53b8b8@suse.com>
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
Message-ID: <51a84783-2eaf-8f90-ec0d-8bc175279ef8@suse.de>
Date:   Mon, 11 Feb 2019 22:23:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <8e4f62e1-f0ab-5f1f-6fc6-684d3e53b8b8@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[snip]
>>> Looking at the dev
>>> docs and the description for 'offset' field in btrfs_file_extent_item I
>>> can sort of deduce that this field will only be different than null if
>>> this reference is for an extent which is shared between 2 snapshots.
>>
>> Don't forget reflink and data CoW.
>>
>> Like this:
>>
>> 	item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
>> 		generation 6 type 1 (regular)
>> 		extent data disk byte 13631488 nr 1048576
>> 		extent data offset 0 nr 4096 ram 1048576
>> 	item 7 key (257 EXTENT_DATA 4096) itemoff 15760 itemsize 53
>> 		generation 7 type 1 (regular)
>> 		extent data disk byte 14680064 nr 4096
>> 		extent data offset 0 nr 4096 ram 4096
>> 	item 8 key (257 EXTENT_DATA 8192) itemoff 15707 itemsize 53
>> 		generation 6 type 1 (regular)
>> 		extent data disk byte 13631488 nr 1048576
>> 		extent data offset 8192 nr 1040384 ram 1048576
>>
>> EXTENT_DATA items at 0 and 8K offset are original from one larger
>> extent, EXTENT_DATA item at 4K offset is newly written one.
> 
> Okay this makes sense, however if we take item 8 being inserted then
> according to the comments, the 'offset' member for this data ref will be
> 0 since 8k (from key.offset) - 8k (from btrfs_file_extent_offset)?  WHy
> is that, shouldn't the offset here be 8k rather than 0?

To avoid creating a new data backref item.

I don't like this idea too, it makes btrfs check, especially lowmem
mode, pretty slow.

If I'm going to re-design the on-disk format, this is definitely going
to disappear.
But the design is already here for a long long time, even it caused
problems before, we still need to follow the behavior.

Thanks,
Qu
