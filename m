Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDB1C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 00:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0044B206B2
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 00:30:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0044B206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbeK2Ldt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 06:33:49 -0500
Received: from mout.gmx.net ([212.227.15.15]:57023 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbeK2Ldt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 06:33:49 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M0y47-1fXSX50Md5-00vBS5; Thu, 29
 Nov 2018 01:30:13 +0100
Subject: Re: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed iput
To:     fdmanana@gmail.com, dsterba@suse.cz,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Kernel-team@fb.com
References: <20181121190922.25038-1-josef@toxicpanda.com>
 <20181121190922.25038-3-josef@toxicpanda.com>
 <4e8aad56-42e2-d666-c909-d5d058b799c9@suse.com>
 <20181127195450.fjor2gewhp3hri56@macbook-pro-91.dhcp.thefacebook.com>
 <13D3592A-3719-4F9E-8E8A-944FE88F30D4@fb.com>
 <20181127200807.bdnvwap2kuuwuarg@macbook-pro-91.dhcp.thefacebook.com>
 <20181128190633.GZ2842@twin.jikos.cz>
 <CAL3q7H52+ELQBw4kn7aUJqX+TR=NMFHvtY4QTVvsM0UNJauQvw@mail.gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <eccfdd03-9f33-d319-2dc0-d27a24348421@gmx.com>
Date:   Thu, 29 Nov 2018 08:30:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H52+ELQBw4kn7aUJqX+TR=NMFHvtY4QTVvsM0UNJauQvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:+JZjD7WRdb+q1KTYOXTJIHYDNrSv/AFzEEPoxWvLBK/kPbxENZK
 c3pDf5YqTCuE7LzeJclwNC9A7NtptGZwYuSo9P2f/ZZDeMH8IEIh64rdpqPGrbfpuFgdVDL
 VJRo1clLoQZyFZrQoG2IjxC3lvV8XBuWH8qYW3N/7eokSTDXDkSRJsAOzmWlymkSxLPRn7/
 c1MILPtVfymiHYy4/+V/A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3JSxhnAhAzI=:9H6mC7FkVHuUvwvaF7AsKW
 SNxRxoHPEoVIgzUx0HXft2Jbces2PYiPyTzJBjRXMNm/Uasfd3P/gYaseXKSxQbpecG9F1wO9
 0rnQykrk3W/mqnk3D/Y6BWN28R7iXh4cnl9UPA8q1bC0SCa3gy53WiHJLjc/8jdvbG1l5xzq3
 hFGhsFamYLhaWEpsq2oDulWbpzYZ9EiL9G2Qn2378TRQHM6UjQ56+tMAKSvTYuxc6AQDui3xF
 iiT15hb8qNdXvxH3JNgKAZCBKz1OMQ6r2P/Ph/naSyJ5wmyj/ACtLG58H2ExIpgXGf3Yl7g+U
 yuUjQLSoNWaaxfnvkh7xv/AcuWh82166/l0kPLWGpqSX1RIHhVoJo8OowqZMhLt3bjdSbMBBj
 801ZS+BNrs5Bfflczr/SINsNcBwogjjA+ThQhOudmXHLf2rLhMI5IweNfYqNs+fsPI3fTr5ac
 ASl6gC5m0kYSV4mkHhdBHfRZnq/6w+snFz4X6wnUZ93KFvB7xhPhd3QQkSHyQqzKOzmNa4Yor
 AfVhTTS2fIxF9BVU2htCo93Uc2uWcX2G/TxtV6BDA3lren8twRi9zx4Mpvv+jKYFR3q+jxcro
 31EQPhnyAXSHhNOGq8X3P9hU6ZuDkgrb5HLz5JTQHr4ESAnDI4Xk2dsIy236xmwGVIXeIhMIk
 LFmPCegIKhqeCxq/3IqTP1q5EW2S2y9TJ3VYELJrW2LCZ83mPx+E58lcGh/icc8Iz2S5k39m1
 gfOTUcpi/O2rIcVUCM2xNArSEbV1M9A4M1Tf5ZAP5HJr06LWOrZJqe4h4VWNBS/mpp6FmCOIV
 D4H3uTh00gsYcSh+QVexldk5nZMx5KEVGEKp1fI0uWvmhndK54PEV0OVT++jIhYufuRXEd11h
 jn2A+1Drurhf/MRDAGsy41MQiJEbEpRjtnguRQfwrl2UcRUuA7Z/rMmp7UGqOaKbfbpw4Q68w
 6xR//6KFOeA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/29 上午4:08, Filipe Manana wrote:
> On Wed, Nov 28, 2018 at 7:09 PM David Sterba <dsterba@suse.cz> wrote:
>>
>> On Tue, Nov 27, 2018 at 03:08:08PM -0500, Josef Bacik wrote:
>>> On Tue, Nov 27, 2018 at 07:59:42PM +0000, Chris Mason wrote:
>>>> On 27 Nov 2018, at 14:54, Josef Bacik wrote:
>>>>
>>>>> On Tue, Nov 27, 2018 at 10:26:15AM +0200, Nikolay Borisov wrote:
>>>>>>
>>>>>>
>>>>>> On 21.11.18 г. 21:09 ч., Josef Bacik wrote:
>>>>>>> The cleaner thread usually takes care of delayed iputs, with the
>>>>>>> exception of the btrfs_end_transaction_throttle path.  The cleaner
>>>>>>> thread only gets woken up every 30 seconds, so instead wake it up to
>>>>>>> do
>>>>>>> it's work so that we can free up that space as quickly as possible.
>>>>>>
>>>>>> Have you done any measurements how this affects the overall system. I
>>>>>> suspect this introduces a lot of noise since now we are going to be
>>>>>> doing a thread wakeup on every iput, does this give a chance to have
>>>>>> nice, large batches of iputs that  the cost of wake up can be
>>>>>> amortized
>>>>>> across?
>>>>>
>>>>> I ran the whole patchset with our A/B testing stuff and the patchset
>>>>> was a 5%
>>>>> win overall, so I'm inclined to think it's fine.  Thanks,
>>>>
>>>> It's a good point though, a delayed wakeup may be less overhead.
>>>
>>> Sure, but how do we go about that without it sometimes messing up?  In practice
>>> the only time we're doing this is at the end of finish_ordered_io, so likely to
>>> not be a constant stream.  I suppose since we have places where we force it to
>>> run that we don't really need this.  IDK, I'm fine with dropping it.  Thanks,
>>
>> The transaction thread wakes up cleaner periodically (commit interval,
>> 30s by default), so the time to process iputs is not unbounded.
>>
>> I have the same concerns as Nikolay, coupling the wakeup to all delayed
>> iputs could result in smaller batches. But some of the callers of
>> btrfs_add_delayed_iput might benefit from the extra wakeup, like
>> btrfs_remove_block_group, so I don't want to leave the idea yet.
> 
> I'm curious, why do you think it would benefit btrfs_remove_block_group()?

Just as Filipe said, I'm not sure why btrfs_remove_block_group() would
get some benefit from more frequent cleaner thread wake up.

For an empty block group to really be removed, it also needs to have 0
pinned bytenr, which is only possible after a transaction get committed.

Thanks,
Qu
