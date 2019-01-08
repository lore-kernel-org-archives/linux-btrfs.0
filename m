Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AC1C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 07:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B48B82183F
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 07:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfAHHr1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 02:47:27 -0500
Received: from mout.gmx.net ([212.227.15.18]:54797 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbfAHHr1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 02:47:27 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MNHqL-1geqAZ17rl-006urO; Tue, 08
 Jan 2019 08:47:19 +0100
Subject: Re: [PATCH] btrfs: Remove impossible condition from mergable_maps
To:     Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <20181218131002.12480-1-nborisov@suse.com>
 <20190107191019.GD23615@twin.jikos.cz>
 <29983e2d-b525-5b9f-0f37-eb06614cc454@suse.com>
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
Message-ID: <88996f56-2740-c3be-1a5c-72a7f40af1f8@gmx.com>
Date:   Tue, 8 Jan 2019 15:47:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <29983e2d-b525-5b9f-0f37-eb06614cc454@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:iV6SiNsRcRfY/E/m2nTAg94ATRMFJTvyNnYFd5upN/6h9GwQaIG
 DKBoKe5JRnvzmpGEGDnsu8gxqbRFH1qfxGlpTFJkaw0qWmkPyaxNq64Y93tXM57EAaobCmD
 o3inCjnY8xh8TPsmtjljRz8ylrFVbs2Astv9zb8ZHqcg3Hd76tVVgUN9qvBvwMMILOPmNrY
 nk14IOeX3wquOkUzxXIsA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:t0QUZBUe15U=:/qkI858AAobmuzAQAMThlc
 7Lwwb6TS0ReJLjeBIur4w5/CDdh2aeZkhpQkhi1BK0AQkDRv3HuNSLYnmsxnSIHbOhbCaVcLk
 buT5FJ6eeL0E7UEufxByunfp251qK/1ZM9vUqHBUCFng5T7MSONnOR0cFvBTu3rsBqW56U7Pn
 EjhzpjF5Seut3dvdH8rFZfeLF9EMJkABlM38EK34Wjtu5a/sRvphR7JtiwmsYtkQv7r5a6X07
 BUyJnxQcHolfb8+trsNGxKvgsST25CXp0VyRUYnxHGZOz/Y9hKCz/SB5WS30tFCOeWp44o+4o
 TbEr7N2ZZBU7XvBcWi7oWfubhPTZVbKDZ6R1ApirlmExjPHVKm+ErNwMRytxua6DSD6xfyBz1
 f56HzQyRX778DUjhESkAUoOPyVmMxi4eNiafPmncs4Ni/9tI5OZuAJdKYL25YlAPjmzXAoUXF
 FfVLVzeUFk3zsPyfAI6QQOjM9tNC9LexP4VROo/L5BBlw3/tLByCqom32A5DF/balPOyGD2pP
 TRpjp96xMGBCGupgjl33LA3nC7GdyVcr/Y4nYEvdtFm3FXEC380ByyD961UJA74j7rFV0ZHW0
 1O8/JtOuDx7dIxdX0Y+pa+bdg2BGETrRcixm3hoMl1k7Sb3D6I4M2JaeMnVVPh3AbWBGkgQre
 QTo02LANKod2oIiMN8Sk14pQE+8jtTOGNfmeT/goA0zeirku2GvtMjP6fkAoPvYtXz2XJ9/o7
 hlHVH1CNCYi0tmnoUiBAuWpyss3o6WVswf3KVQggAPqkrqkZ4SQqN9N4VKC8Gu6B/bp+pKCAc
 zoTVVZvv/N2UP4S4W9OTMvJrH/Hm9u3vDRFDll0AkZ/wXDB6eCP5yrI0fItXuQUj1/5yKEbgy
 932GmwwObwPSJEosh6KwxQHeS0gtV0AxHDO7IozB2TCq9jdFWSvoaFe9cv43OTOVHv3Zn1pxK
 78K48+wN3yw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/1/8 下午3:30, Nikolay Borisov wrote:
> 
> 
> On 7.01.19 г. 21:10 ч., David Sterba wrote:
>> On Tue, Dec 18, 2018 at 03:10:02PM +0200, Nikolay Borisov wrote:
>>> We can never have extents marked as EXTENT_MAP_DELALLOC since this
>>> value is only ever used by btrfs_get_extent_fiemap. In this case the
>>> extent map is created by btrfs_get_extent_fiemap and is never really
>>> published, this flag is used to return the corresponding userspace one.
>>> Considering this, it's pointless having a check for EXTENT_MAP_DELALLOC
>>> in mergable_maps. Just remove it.
>>
>> An assert would be good and a comment at EXTENT_MAP_DELALLOC definition
>> repeating what's in the changelog. Otherwise ok.
> 
> Do we really need the assert though, it's plainly obvious
> EXTENT_MAP_DELALLOC is only set in a single function?

IMHO ASSERT() is not for now, but for the future.
Later on maybe some modification would change when and who sets DELALLOC
bit.
(And that's why there are a lot of seemingly stupid ASSERT(), it won't
hurt anyway).

Thanks,
Qu

> 
>>
