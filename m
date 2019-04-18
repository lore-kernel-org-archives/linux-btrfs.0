Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D327C10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 11:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 641402083D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 11:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="JNgYMj9Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388872AbfDRLys (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 07:54:48 -0400
Received: from mout.gmx.net ([212.227.15.18]:39879 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388833AbfDRLys (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 07:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555588479;
        bh=x+cdPRwLMzawBis+ZvUtU+RzAuQIBL6bolkOKrEFfwQ=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=JNgYMj9YKp+N0RTp8WAeMExltSRngHbZdjgBrbMgRpDGVmziPsYSsu/7+VJEVmJby
         2A3/t2hb6iuzJd0C/JZsMtKYc0U35RNRFHnDmyPtb+z4SA1Wpgmy55Ffm7xCf/aF39
         1c3A2235q8JEfuJNEKvCUSH9IjTzZTTIQQ14Jak0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MLNpK-1hHdr53Cza-000Ycs; Thu, 18
 Apr 2019 13:54:38 +0200
Subject: Re: [PATCH] btrfs: extent_io: Handle memory allocation failure in
 __clear_extent_bit()
To:     Qu Wenruo <wqu@suse.de>, dsterba@suse.cz,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20190418072114.4573-1-wqu@suse.com>
 <b2ff0fa1-9fec-46e1-75f5-e7903523063f@suse.com>
 <f96176af-6e8a-4257-e49a-4ca2604e7226@suse.de>
 <20190418113853.GJ20156@twin.jikos.cz>
 <324dd379-1794-eb65-f4f7-84e78d70435c@suse.de>
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
Message-ID: <a7d7c706-6e42-21bb-c42d-c60529bcd946@gmx.com>
Date:   Thu, 18 Apr 2019 19:54:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <324dd379-1794-eb65-f4f7-84e78d70435c@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:duLwtnR+guzx+hFi4od/Uz7NHvdrHVqiTpimoLLNiUkwBX0S4aD
 98s+B2YWWkZzSmaq1H++dvMIs3tqa4NaqYePQ3DD1m0vWb4hknF2hPaKgzqzGgRgCcsnLM8
 DigLpP9WFdgHZdiNAhX+WNjttYMNDuHxVkJO9g3cViFpsmjTjJgif25yKeJZOBWdmIoLsdB
 WmjsvG8ht74QuYP8SV2Wg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:suQ96T/ce8Q=:z7Nh9vdHMeza4vlN8H86jM
 Lto+/zw1frrrUz6MV+4BP2RbD3Qfc4b6qsGr4I3wpptsjGeEu1URmQ1hw245aVHcwtn52/d3G
 c7cqkZdh+SGvr0Tn9ee3ZdjX4PjhzaYn0BU90Gw2JpTbmSLbwfI+TqnSPTexwMVWOzUYuPUrD
 CKwd4VqAtt7uddpsuXsBBVIdqD82gCg9DV8Wn0a0qXkwwzD1sIWQQgS6DQJuRC8dmXhsAKiu5
 icktPkQpUxrhoe1ITp1369Os06qDjK16L85QCXD2QgyUpf/U5I2QWaIljl6hprLCdA7rC5Kgt
 z8EEQwK79Wv0H8o7WsfRspqQ3xxZ9d5/qK3kq369dQ7yOTZsDMTUaBGktodbKSIbeBQUVQM/J
 AvvQDvzWCI92AP3PkIMXTn8u3FBRp4H0vJYJxAqOoXb8aaOEBeO6GnCRxE/IlEMxAKjYpuqqL
 rehE/WF3gI60WuU2cO+OjtaYvqvvFrqAZIc9g6RfBIxzhGVptUDQTRrRbdzhjw/hagQkarpc+
 5EvNMGSVYY7unciW+bI80ZFxlHEYX7anjJ38vnEt2OCF2LIfZPtY7kNKFMZGj1KBUxZkL1nh8
 fUneVSC1zmtatzXvpM8GKVVCAP1nGaM2zJIf3c8gzIxCj8zbZZWL5Z9pdqjw4e0rbTpo6f0rH
 10okjRNCzdgT1aV7R4fi42fe2JZjUPNZoJEZ3g/lWd5fkgJa/cLwJzDIIloDC04Y0lsDd1A9O
 Iiwgzntecra07BDhPKhRH2GWeQpHf2C1rrG3tkL27AHqQ0uMlZjlvPwV/jQGamqvbq3D+z3NQ
 rKLOnG3RChtOjyzxSWfnO7KbIrG+5B45yS4soaqk0zrn+3LCfNvtZQwyEktTD9gVBjF1OBcJW
 x85z/iNMOipJq8Tf6SGFnU1Mam5oJZmdtmECngjYHDGcDz7jxl5z6+HAWbpc2DLj9U3/T0jMV
 zNoWi+G09Cw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/18 =E4=B8=8B=E5=8D=887:51, Qu Wenruo wrote:
>
>
> On 2019/4/18 =E4=B8=8B=E5=8D=887:38, David Sterba wrote:
>> On Thu, Apr 18, 2019 at 03:30:20PM +0800, Qu Wenruo wrote:
>>>
>>>
>>> On 2019/4/18 =E4=B8=8B=E5=8D=883:24, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On 18.04.19 =D0=B3. 10:21 =D1=87., Qu Wenruo wrote:
>>>>> There is a BUG_ON() in __clear_extent_bit() for memory allocation
>>>>> failure.
>>>>>
>>>>> While comment of __clear_extent_bit() says it can return error, but =
we
>>>>> always return 0.
>>>>>
>>>>> Some __clear_extent_bit() callers just ignore the return value, whil=
e
>>>>> some still expect error.
>>>>>
>>>>> Let's return proper error for this memory allocation anyway, to remo=
ve
>>>>> that BUG_ON() as a first step, so at least we can continue test.
>>>>
>>>> I remember Josef did some changes into this code and said that preall=
oc
>>>> shouldn't fail because this will cause mayhem down the road i.e. prop=
er
>>>> error handling is missing. If anything I think it should be added fir=
st
>>>> and then remove the BUG_ONs.
>>>
>>> That's true, we could have some strange lockup due to
>>> lock_extent_bits(), as if some clear_extent_bits() failed due to ENOME=
M
>>> and caller just ignore the error, we could have a lockup.
>>
>> Not only lockup but unhandled failed extent range locking totally break=
s
>> assumptions that the following code makes and this would lead to
>> unpredictable corruptions. Just count how many lock_extent_bits calls
>> are there. And any caller of __set_extent_bit. There are so many that
>> the BUG_ON is the measure of last resort to prevent worse problems.
>>
>>> I'll try to pre-allocate certain amount of extent_state as the last
>>> chance of redemption.
>>
>> This only lowers the chances to hit the allocation error but there's
>> always a case when certain amount + 1 would be needed.
>
> Lower chance is already good enough (TM) for low possibility (0.001)
> error injection.
>
> And, for real world low memory case, lower chance in btrfs means higher
> chance in other subsystem, less chance user will blame btrfs. :)
>
>>
>>> Anyway, such BUG_ON() right after kmalloc() is really a blockage for
>>> error injection test.
>>
>> Maybe, but the code is not yet in the state to inject memory allocation
>> faiulres to that particular path (ie. the state changes).
>
> With last-chance reservation, we can make state related memory
> allocation almost always to success even memory allocation failure
> injected (if the possibility is low and low concurrency)
> And the last-chance reservation can be configured at compile/module load
> time, making it flex enough for most cases.

Forgot to mention, for that method, I'll definitely keep the BUG_ON() on
@prealloc.

Just make the allocation part fall back to use fs_info->last_chance[] to
grab a valid memory slot.

Thanks,
Qu

>
> The main reason I'm doing such error injection test is to ensure write
> time tree checker is not the cause of the lockup.
>
> Of course I can directly inject error into btrfs_check_leaf_full() and
> btrfs_check_node(), and filter the stack to ensure it only happen in
> write time, and that's already what I'm crafting, based on the bcc error
> inject example and kprobe return value overriding.
>
> But it will never be a bad idea to explore what can go wrong.
> And "always BUG_ON()" -> "good enough (TM)" already looks like a
> improvement to me.
>
> Thanks,
> Qu
>
