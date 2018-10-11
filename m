Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D16C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 11:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 835AE2077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 11:43:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 835AE2077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbeJKTKR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 15:10:17 -0400
Received: from mout.gmx.net ([212.227.17.21]:33871 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbeJKTKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 15:10:17 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Ldspr-1fRqbt2TTv-00izYn; Thu, 11
 Oct 2018 13:42:47 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Ldspr-1fRqbt2TTv-00izYn; Thu, 11
 Oct 2018 13:42:47 +0200
Subject: Re: [PATCH v2 2/4] btrfs: Refactor clustered extent allocation into
 find_free_extent_clustered()
To:     Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180821084426.7858-1-wqu@suse.com>
 <20180821084426.7858-3-wqu@suse.com>
 <00a2d29a-767a-c883-29cd-ea83328dc2d2@cn.fujitsu.com>
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
Message-ID: <ed22a5fe-aebf-fb79-dd5a-a928983482b0@gmx.com>
Date:   Thu, 11 Oct 2018 19:42:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <00a2d29a-767a-c883-29cd-ea83328dc2d2@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Dn5p4rNM6/1sEuPLouYN3/aCAPH/I/6ApOyz13/XQRFeIWkSqhw
 c1E9xvJsKgKtw1ocDlK7X7LDkVXIdBCMVJNkdq8ncUHpPmubBtPPbB8vrIuQji8QCJ7omCs
 WuuW8rKT3VJPJh4H9sue0RGl7bsFfCdakMxKqV4eWaUBnXr2a3ytrUwmKf/4gTtkcXBXa2/
 sJbWpQWNrPZp+112dg9DQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:/ntNgB/VapU=:CNZzar6xsSjoy1t/X0LKPn
 NXyAz8cuyUt8orx56rtmF3KicIWgzYBJypyygy/DnTlLQKQ/qFQOyc0Zh1GVskSyT+FTwKYew
 JhXtWHiYcyfbgNfA4r/m4beWdfn+reKLvglIBfIzOVsymupO6+b1V2CPzI/6d0xKXZgiMnWTa
 hr1AjtJ79UvqDrr0cPRPyraFYhU6pr93wzI/m2gx+LYE8MxqL4R14o8L6UnZwoOeXV6hYvl8C
 /2+iOrqC9gN5u32n9SQ1Uya/Y39wqhZs0ldFCGTjftTEeKiJZI4CbeGZGEjFgC6U+xg+Wu8Hj
 qXLe3XiMCVCxHQYT0vBwyEMvVK6DJNz0mQ6mkqxWbItpFfZvpJJRecA7Oe5y4j7VVBe4+G2M4
 q7ZIi32r7aySMVCzu3hFuBhec6/RKCVoS783uztG84kUgw8hAL9u68cSgj5Ss4WcIGBjThDFE
 lNPe13vXqojwfb6TdtcZOrV9n7MYCpOrRS/i6q8x9s893PpNL8FTYT9n6+ZP+NJCQyqTf/rI4
 wNbMpfsCNqSUZjDH/sVFWGn1pK8BHT2+thPrtVdl9cQXSFQB3UH6Jcx23K1rK1oxaYrstHS7W
 Xw7x8BPiThTmHIzwazW8XabYifPa98Yw/Xpfupvhda7IgCy0Zr6Mgi9Xp+VAZw5fKfcOdyLs2
 P7+Uw7whzsnuQ3eQ5eAHLJt6k8zvM5nd+ruBIkklV7CrsA4rC74zARS8D8AgvFtQDT7afVWaQ
 LitUhXJ/ezEuPYQ/pSu8GGLuAYFqXhDegXl8uZGGZsJpx92bl1NA1R/mtbtpHujVPZI3f9UkS
 +NwX87RskHLIvIKm9oUhUZdPQ9gHaaXtUhvVQyzasOM+SIpxMM=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[snip]
>> +            /* ret == -ENOENT case falss through */
> 
> falls?

Nice catch.

Thanks,
Qu

> 
> Thanks,
> Su
>>           }
>>   -unclustered_alloc:
>>           /*
>>            * We are doing an unclustered alloc, set the fragmented
>> flag so
>>            * we don't bother trying to setup a cluster again until we get
>>
> 
> 
