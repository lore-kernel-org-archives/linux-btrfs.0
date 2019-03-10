Return-Path: <SRS0=V0ug=RN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB2DC43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Mar 2019 09:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08F6420657
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Mar 2019 09:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbfCJJ5C (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Mar 2019 05:57:02 -0400
Received: from mout.gmx.net ([212.227.15.18]:49533 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfCJJ5C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Mar 2019 05:57:02 -0400
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LZhsq-1gdVXn3BAi-00lTze; Sun, 10
 Mar 2019 10:56:49 +0100
Subject: Re: [PATCH RFC 0/3] btrfs: Performance profiler support
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.de>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20190306061907.29685-1-wqu@suse.com>
 <857277d9-7a16-cea0-13c4-aec74cb77064@oracle.com>
 <0e04dd2c-a7b0-c4ce-6340-79c90578f4b5@suse.com>
 <bcd2e6de-cf5d-311d-ebdf-63eb1ae40222@suse.de>
 <913b2ba4-5a3c-974e-10d0-26d65d4175ee@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <d0f17d65-b357-840e-c333-9963e20d001d@gmx.com>
Date:   Sun, 10 Mar 2019 17:56:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <913b2ba4-5a3c-974e-10d0-26d65d4175ee@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:aO2K70/TruCvfQVsIKX0jSKyacWnQ3psjcHc07Ru11xd9aFoa/o
 f4O6bYW7/fpKpUAVNQmh0U+GWC6sb3TpClrh+frHqeB+NVeSW6X0CRfeI0Pu9TxB84G9DUY
 K/XgYxaIdhE0TkFeVyFeGcyqA/dPk6JfyI2hlI/3pYW5T3GrJuEZtj2f3zPPYBaH1kjggz4
 Qb7B9CDatiBLeyRYy0wFA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bNHCIaG6njI=:VORnN39vuJx3wr9hltz2qZ
 RUNfkgyLxMTV20hhszjAuDDJMfcRA3gLd1r2bZLl8e2Fnm5sisMQzDo6yJ99F7s5UJCCvzkcY
 zqUMLly71/gpCjRosjgwKSOMbA8PDI33aC+Bhc8fNFtZ3bwfi4V50UIsizGQDgTO/b6rBxn2t
 mwfg4GsSl+dxjydR2ENqO2d2LSl6G6OxbXNBsGComgkUHQ2aUS9F6so0UhcJn5U2OMRyRsHci
 4Kz+TeKhsyBbkPeHEzfHi1/ez/O2tSSDuwQJQqspYgRCLTftwxeWG3TqwT56/kaDaXMJkdrF7
 JGerr+1poQIdMg+BA1iFqvIHW6+Syk1zGKfdqxu+Z9rgvsIhFVKFpinKLHdT7zEoCf0RmUCn1
 JOfWFC/0xchhtSFxRA9OHfa+e0M638WEp+tf4dKLzC2YGHzvnd+4qHBp6FEH2CS9hrCJY4eke
 mVRozyDnXsmrZlJ0XzsiCziBEGiHJ3XoibKKwoEtkMUN+LeMaAlFeWpNgcpmMEu2F6ORd5h4k
 NxgvjB0nvpcdgKw+BiNV9im60xLBK3PWQ5XQplMexmLyWouMPYKI0APVCjutN38Hw9EWceN6v
 /YWmqW5+HNlLyFl/QoMcQ9o2LLXQ8z/8EVf86qP6wbc7nlG6Pcv1fMmzC6UCl1r1uhTdqb2T1
 htGVenX/LoW2RJOOPvSSLjVLp0rGer6R2IQzwmEVtsJklp3ibjICBgUcVOPqq1LjJYZeiyv1N
 VcybMM+ElD+56FSKr+YUFIHWTs5X9+hu/CQmzMreMH0efaX9JfosvW17hmvLxrJvhToDuqVBu
 z1QtTS/M5xZHNMyqsYWK+aE3lgeEwqnbKiz2iEy6sHfp5uQmj6x0Xb8BxKsoHUeTbE19u2awK
 hwPsaX0JUFXnvh6Brod6I3z+qWCR02TvdlWHRi87qZmbzGVoHayKVVFds9mXgp6yVfg6pnY/9
 CfTWdNg+86w==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/10 下午5:40, Nikolay Borisov wrote:
> 
> 
> On 10.03.19 г. 11:34 ч., Qu Wenruo wrote:
>>
>>
>> On 2019/3/10 下午5:29, Nikolay Borisov wrote:
>>>
>>>
>>> On 10.03.19 г. 5:08 ч., Anand Jain wrote:
>>>>
>>>>  I agree we need btrfs specific performance measurements and its
>>>>  my list too.
>>>>
>>>>  However my idea was to add it as a btrfs-progs subcommand such as
>>>>
>>>>    btrfs inspect perf ...
>>>>
>>>>  And implement by using the systemtap/perf/bpf/dtrace, as these
>>>>  can tap the kernel functions from the useland using which we
>>>>  can measure the time taken and no kernel changes will be required.
>>>>  But yes we need to update the btrfs-progs if we rename the kernel
>>>>  function, which I think is ok.
>>>>
>>>>  I was too early trying this with bpf before, probably there are
>>>>  more tools now to do that same thing.
>>>
>>> This is way too developer oriented to be included in the generic btrfs
>>> tools. Frankly bpf makes sense but only as a separate script being
>>> developed and possibly shared on github or whatnot so that other
>>> interested people can use it. However, integrating with btrfs-progs
>>> definitely seems the wrong thing to do.
>>>
>>> On the same note - I'm highly against this patchset landing in the kernel.
>>
>> Are you against the interface part or the btrfs specific perf part?
>>
>> For the first half, indeed the new sysfs is not good and I'm OK to move
>> to any more established interface.
>>
>> For the later half, if bfp/ftrace can do the same work, then I'm fine.
>> Otherwise the need is still here, both developer or experienced sys
>> admin will need this feature.
> 
> I'm against this functionality being part of btrfs. What would be more
> useful is a set of bpf scripts which might very well be developed
> alongside the main project. They will be a lot more flexible also they
> will add overhead only when you really need them, whereas the current
> approach AFAIK (I might be wrong, correct me if so) always accumulates
> certain stats irrespective of whether the sys admin needs them or not?

Since this patchset is mostly an RFC, I skipped a lot things like mount
option to skip all such events.

But the bfp part is really a good direction for me to investigate.
If we can do the same work using more established facility, then I'm
completely fine to discard the patchset.

Thanks,
Qu

> At the very least you will sprinkle code such as :
> 
> 'if (perf measurement enabled) ..... '
> 
> I'd really we didn't add this clutter.
> 
>>
>> Thanks,
>> Qu
>>
>>
