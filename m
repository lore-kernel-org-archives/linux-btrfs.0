Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E9DC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 12:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A4D920657
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 12:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfCKMgG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:36:06 -0400
Received: from mout.gmx.net ([212.227.15.18]:42495 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbfCKMgG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 08:36:06 -0400
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MTTKZ-1hSJ9Y0TGJ-00SLnq; Mon, 11
 Mar 2019 13:35:57 +0100
Subject: Re: confusing behavior when supers mismatch
To:     Nikolay Borisov <nborisov@suse.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
 <cf8922ef-b7db-7779-c140-80090efc60d5@gmx.com>
 <62ad41ed-5fba-d641-9a19-9231a55f603c@suse.com>
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
Message-ID: <a79900be-5fc9-4c1d-18da-f4aa9fdda8ab@gmx.com>
Date:   Mon, 11 Mar 2019 20:35:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <62ad41ed-5fba-d641-9a19-9231a55f603c@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:0lpLowJwQzN0GHeNIwUGxvWiipfUftZDzJKHuj99b001X6BnIgF
 KrQSlA80MdLG4kWMnEYfma0eysw5/9YxJgsp7YxRus7u7tgLl0dAVI9ZUkAjeT9/aCQA45R
 6+EKjfiuQ/mWn5XvcNJPhf3h3owiem+SZcsOh1eNV2UPw/6W2BSOVw9M83cJdQe7dCMOiyz
 HmzDYDgGrxlNaDM9iDcDQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:r0+FECAwjgA=:MUhmsYduu7vXjJCKn0kym6
 GCdg/Wng7jIdr0G38aeI2qPTWRPEenuLDBbL6h0b6Hy0SxbhKg1pG455gMcDGJAALi3PuhBN0
 qib4E9Ml3qo4JhgpLSM97qP0IcC4hGLQXphd5q8OqO4OeYa7wJjPg0EZd9ey7GZJdlVjZoywr
 M9QU/9ZDVZ3FpeFuAne7RiKxUf0tp0ZPHVAMGuth+py7bKWfA+tVncoVY/Rw+iaF7xSVPL5Lb
 KPNDJOQdu5fPRSoXLwlqh98jm+bNXI3wetDdXTEtknNyXfYlXkZJlDEqm1WGfFdGZPtdPO59G
 1gQTOOOPjbrQ9JDL61X2Qz+0J8v64ASAcLlM0H+SmtRgTzLaEgzzLgM6gtZwptpBJWY+TP7Kd
 Hp5UxZxav2iHzQkltKsGX1Zo8gsSU/M4UYx5xwkb2lGu3Cqb5gxlzm8fprmZUdQ8dOgnxfV9J
 sxGygZHh54G1MdHOAOV9Xw0QyQBJFDXF5RYFc1DbLzOqTXkCijlsbNy+Mr8vxG5m3/nrpa1RO
 Nxjq1v3/ohUHFc9dLdP9ooF24LngTvZv6UVS0BHWDV0SZs58qdf7DuQntzQHog1vFQzYGRc0U
 NRD7X90XO5OP5hvYViZCCvhaYQqoU2YMrRv2fC+57JwR9pBKtKd0u3nkKxmm6Z2tWY1RO8oKz
 7cit5EGXaA9+FhrjRKg+CLDGxlLe/PuaHXVGWunAW5e3VyYNFAkQLjenyzSMN2b2ux+64KPrn
 C54yKOcaUGN0PTNDT6IzO6GcoTdHrGF1JDDp7fUEATs3OPKKWTi9pPLR4bs5Ps36/o1/z652j
 QNqts7g3fQl5svOehPcnU2cEoYIVhMS8a1P6otlzreFIButZLih5AXYUZUCWxXYExITzP3mqR
 MtjnnFhIV7cYuXe8g8isQgjotfcybN83LlA+asSDK8QhKj1AwtDyAKQF2B2fMWMal803oRm8Y
 dBMVmjbFkrQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/11 下午8:26, Nikolay Borisov wrote:
> 
> 
> On 11.03.19 г. 3:17 ч., Qu Wenruo wrote:
>>
>>
>> On 2019/3/11 上午7:09, Chris Murphy wrote:
>>> In the case where superblock 0 at 65536 is valid but stale (older than
>>> the others):
>>
>> Then this means either the fs is fuzzed, or the FUA implementation of
>> the disk is completely screwed up.
>>
>> Btrfs kernel submit super blocks as the following sequence:
>> 1) wait all metadata write
>> 2) flush
>> 3) FUA the primary superblock
> 
> SATA devices generally do not have FUA support. For example my evo 850
> ssds do not support it nor does my evo 860 PRO. IMO not having
> functioning FUA seems to be the norm rather than an exception.

Kernel block layer will translate FUA to write + flush.
So in that case we will do:

1) wait all metadata write
2) flush
3) write first sb, flush
4) write backup sb

For FUA -> write + flush, it's less atomic than native FUA, but it
should be good enough for pseudo-atomic.

Thanks,
Qu

> 
> 
>> 4) write the backup superblocks
>>
>> If backup is newer than primary, then the FUA write doesn't reach disk
>> before normal write.
>> This means any fs could be corrupted on that disk, not only btrfs.
>>
>>>
>>> 1. btrfs check doesn't complain, the stale super is used for the check
>>> 2. when mounting, super 0 is used, no complaints at mount time, fairly
>>> quickly the newer supers are overwritten
>>
>> The reason why kernel doesn't search backup roots is to avoid stale btrfs.
>> For case like mkfs.btrfs -> do btrfs write -> mkfs.xfs -> try mount as
>> btrfs again, this would cause problems.
>>
>> So IMHO always use the primary superblock is the designed behavior.
>>
>> Thanks,
>> Qu
>>
>>>
>>> Is this expected? In particular, in lieu of `btrfs rescue super`
>>> behavior which considers super 0 a bad super, and offers to fix it
>>> from the newer ones, and when I answer y, it replaces super 0 with
>>> newer information from the other supers.
>>>
>>> I think the `btrfs rescue` behavior is correct. I would expect that
>>> all the supers are read at mount time, and if there's discrepancy that
>>> either there's code to suspiciously sanity check the latest roots in
>>> the newest super, or it flat out fails to mount. Mounting based on
>>> stale super data seems risky doesn't it?
>>>
>>
