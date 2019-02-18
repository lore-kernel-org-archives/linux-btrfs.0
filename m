Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED3CC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 05:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FB5D218B0
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 05:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725829AbfBRFAi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 00:00:38 -0500
Received: from mout.gmx.net ([212.227.15.15]:60399 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbfBRFAh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 00:00:37 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MFLhE-1gsFWC2stQ-00ELRs; Mon, 18
 Feb 2019 06:00:29 +0100
Subject: Re: [PATCH v3 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
To:     Qu Wenruo <wqu@suse.de>, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190211051653.3167-1-wqu@suse.com>
 <20190211051653.3167-2-wqu@suse.com>
 <216f4acf-faf9-6ca3-c9f2-68a9eaa763fa@suse.com>
 <77f7ed38-aca5-f799-08eb-e8a3100fe57c@suse.de>
 <8e4f62e1-f0ab-5f1f-6fc6-684d3e53b8b8@suse.com>
 <51a84783-2eaf-8f90-ec0d-8bc175279ef8@suse.de>
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
Message-ID: <72de8715-1a20-94b1-496e-dddb0983da87@gmx.com>
Date:   Mon, 18 Feb 2019 13:00:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <51a84783-2eaf-8f90-ec0d-8bc175279ef8@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:6th5F7rLk+7XcCeojdNAZ+LgzzQ+eR3EyZByo+YE4uXfkqzXejh
 U1KDsxKl2S0m2fUrg31RyzXXcsmT81Z3Up0oUannfm5CNm+pH0YYxai4MW50ZeDSjPu178I
 ju3L5V5+eQTnuO3kWG+GTH2hc0ZYvyGEseT1HHh/zJz6WoNyfBdvi2FF/4T/HJb4k6z2hqe
 xFKDSxkt64UAzHe/8j4kg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:4pKVnpc3L1Q=:bmqXmJDWNi5buUCwRNRMUQ
 idgcIOaJDVA/6ibRE84nqAfi8Y+j43Dn7zTwFpxrNl9qg2/IS20lSI1ZCYzEyuqpIh6AgmjCM
 VQsZZelvM6OVzI0oUtu9BvYWfYIHlKmTBITXyAygd/2aN5n4SrD2q5nxLESbhLr46W9Du+4bP
 YxnWtNDO/qLlkve3xz7JyXnC+CLip0iwqOTISKooerUoFf3iB7kkEERWlhz9ZTNmknvz9I6St
 8GPSfrvoIaSY4dMn/PZwbhY/ZmRDXhUwsAolyaSuUTZXvj4/86VN++9y7CQ5ePcH/2oSkqPHH
 Blm36yF2T2KY34lx4Y1wL1XCHN68eODkHQq4w9+JQ5eH38wjroPinnii+dA+V6D4OaR28hMw4
 YxTnTuY9J1fwoSJyysiIqCoJZ1WeGgLhVZotndWZro4L7C1JaBX3EmAZ5aE5Z1+cyt6ST4EGZ
 /RtVAOXEsjYgTaFDsjGbMVoq03JP+dfCN1ATWz8b2gBCk4aiAxDiG1IqD7vZTPhI/EbvoTk/x
 BoW7lqahb9W0/XRRQT38JjEFqyGxBa8TpibWwvtfPyQx7I/RMhZX++bf7F8wyfI4XQKaERDvd
 /zgFfxc9M8WmbUIvX2w7mz9HpX8sQ/wFp7muY/dntD61snrnmg0kiONWIZzKx4iWL1d5RmHCW
 ptoGe1e0afOPWya1jFAM9K6sSAZwupCQm05hCdNBe60XBTnnQKsPUolQjABpfY6CIvKoiYrYU
 faiVbJSJ0H1lrtjdUXb4ZyrGTFK5kYZB4984wu+2Eiz6tadYHp/uyxoPlZ0Q1dEzWCHCRheuz
 hA4gtZvt03ppH0xB/VcpuQ7fMp0c1FT/8VdLiEw1uSLuFmwEG4+imEP4TVV+ZhJIfbkojxc86
 CRohQpmR9OUdX0/J5Nj4yGBsok6lM9CONSS2RcSzSo3zVr9l4tR3ZBkcxYEEdSpZGtVQHiP2f
 6USKFEPAX/w==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/2/11 下午10:23, Qu Wenruo wrote:
> [snip]
>>>> Looking at the dev
>>>> docs and the description for 'offset' field in btrfs_file_extent_item I
>>>> can sort of deduce that this field will only be different than null if
>>>> this reference is for an extent which is shared between 2 snapshots.
>>>
>>> Don't forget reflink and data CoW.
>>>
>>> Like this:
>>>
>>> 	item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
>>> 		generation 6 type 1 (regular)
>>> 		extent data disk byte 13631488 nr 1048576
>>> 		extent data offset 0 nr 4096 ram 1048576
>>> 	item 7 key (257 EXTENT_DATA 4096) itemoff 15760 itemsize 53
>>> 		generation 7 type 1 (regular)
>>> 		extent data disk byte 14680064 nr 4096
>>> 		extent data offset 0 nr 4096 ram 4096
>>> 	item 8 key (257 EXTENT_DATA 8192) itemoff 15707 itemsize 53
>>> 		generation 6 type 1 (regular)
>>> 		extent data disk byte 13631488 nr 1048576
>>> 		extent data offset 8192 nr 1040384 ram 1048576
>>>
>>> EXTENT_DATA items at 0 and 8K offset are original from one larger
>>> extent, EXTENT_DATA item at 4K offset is newly written one.
>>
>> Okay this makes sense, however if we take item 8 being inserted then
>> according to the comments, the 'offset' member for this data ref will be
>> 0 since 8k (from key.offset) - 8k (from btrfs_file_extent_offset)?  WHy
>> is that, shouldn't the offset here be 8k rather than 0?
> 
> To avoid creating a new data backref item.
> 
> I don't like this idea too, it makes btrfs check, especially lowmem
> mode, pretty slow.
> 
> If I'm going to re-design the on-disk format, this is definitely going
> to disappear.
> But the design is already here for a long long time, even it caused
> problems before, we still need to follow the behavior.

Is there any extra suggestion on the wording about the anti-initiative
offset used in data backref?

Thanks,
Qu

> 
> Thanks,
> Qu
> 
