Return-Path: <SRS0=Q7pU=SY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5FFC282E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 05:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A49102077C
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 05:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="DCqdaC8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfDVFoR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Apr 2019 01:44:17 -0400
Received: from mout.gmx.net ([212.227.17.22]:36163 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbfDVFoR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Apr 2019 01:44:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555911848;
        bh=mCluTP5xwIB5flsBxEUEe/i1IaOfAcddyVgaBDBe8kA=;
        h=X-UI-Sender-Class:Subject:From:To:References:Date:In-Reply-To;
        b=DCqdaC8uBiQIV/aozTClCKa68+VuvIwwl/A16BBXOeer8YBmEuA+SpnPMa50/U0hh
         os/d1+hbqeXvblltOGwP6t9sa3dKuA/uMtwLlpZXX/VuiB8y/j0KYZl5QQMJJEWXFj
         11RPNAjeE6BoRj369/9dEGKAozPBmKy++sOJp3iw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MRCCJ-1hOC7M0imV-00Uewl; Mon, 22
 Apr 2019 07:44:08 +0200
Subject: Re: [PATCH] btrfs: extent_io: Handle memory allocation failure in
 __clear_extent_bit()
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
To:     Qu Wenruo <wqu@suse.de>, dsterba@suse.cz,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20190418072114.4573-1-wqu@suse.com>
 <b2ff0fa1-9fec-46e1-75f5-e7903523063f@suse.com>
 <f96176af-6e8a-4257-e49a-4ca2604e7226@suse.de>
 <20190418113853.GJ20156@twin.jikos.cz>
 <324dd379-1794-eb65-f4f7-84e78d70435c@suse.de>
 <a7d7c706-6e42-21bb-c42d-c60529bcd946@gmx.com>
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
Message-ID: <53b3998b-4bb0-6bd9-3a5f-0292f812ee81@gmx.com>
Date:   Mon, 22 Apr 2019 13:44:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a7d7c706-6e42-21bb-c42d-c60529bcd946@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:KpKwKuhx08/dsneWQpWSYHD8bomVuUzRnEePEwA4wNKqd8igkGN
 uOVJwS/xFNDy8w4JCZd9qjSPyHqe6kxQzQfjVFJrQ94tIFNRfh8pWv7r56LMFDESm9Bgpdt
 4qUfl2Zq5vqx0THtRXqfmzsW1J/weRjbeX6tJw7rzME6JPMSDbGrJbXTFz78k0tAqc5oeIS
 Rqhz2lsLeSfXoh+4PWfmg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:HJqKDC2n2bg=:HXMbjHnMdKvZyQhx6QVPCO
 U9dnzgaZ6ef5fdMQeSH7nyFkcSihqzzOOn9ZBRKDlmCSWhU+m9hoxXWMnqODjrQvGnXM5SFCh
 qeORYYEGZL4eR8Ly5kCQhahBtJoGrJ0hyQwbZwi2ddsjIwt2sii19IU16FzCMG7Q1YsMBd/uA
 i5xfBIM6EDTlCeEf6FLSF3skxNNnqUBft7jgQGlZP2uyg6ZCycBN8Yp6D0ck4dSCzmxB/nETi
 KGYo/1fiV7rXu6kQZwjDopapY8pdF6zTMoj2Wv7hY8rqkG8EL4U/8wzcUiauny0UFFiiAecSx
 Nz3k93J8iqVmXP9k3OloPaZyrJ2yUJEZlcHNzWdfZGuXNz/yveUjcc9Lzg62NMqxQ9BohXfcW
 Z3r8T+M3hn21+3ppt35iJhNQ1uAJ/F2ZLTJHSNwpEh22xIZBpmpOUwBdzgqIxx5rSBnt+SwPT
 IgURpkS5dxzOu3GPNq4cypl1jEu581RSn5OURPii+8i8Bd5uHgCkZ4uRnc0bkslp45APQvWin
 s6oKv/d896PF2dnthwHOhKo+QgIcjP+GpG30ka4scb1HyoW7otf5uxx5Ok1h5Jd8/FDfR6E0/
 tcD/tt4lmF8k8r3capMBn9BNNYPEGu7jtkGJjoK0Sc8lBEknWI+R9bFfIPV5bUhzZoN982rSe
 kGAXWD+vGnW69WFAT4VCXTu5Tp6tcyt531w4dQaZ2NN7TB2qm8RFZwAUrCcWYTPZQE4g8UZUC
 q967oJugHgkpJYT/2ehqF6RrZpmaiTJyfde7axALN9A6cSMlTeKQ2DbUhhFf56BbJaYEWUh0N
 iziuYukaKGJLrTiEx29ejF+zpHn5oOWR/Tp094Zx1OYIdrM+GYrJmvzEMBOfSYZ8ecJ8BCvIh
 W4UgSs5S8Mwrg7KcRY+PUX/7dOm9PlL9jU9cjLHMqYt9gDE0+CLfq42xsrM60gyteT1HIunen
 kXaAJaB0qyg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/18 =E4=B8=8B=E5=8D=887:54, Qu Wenruo wrote:
>
>
> On 2019/4/18 =E4=B8=8B=E5=8D=887:51, Qu Wenruo wrote:
>>
>>
>> On 2019/4/18 =E4=B8=8B=E5=8D=887:38, David Sterba wrote:
>>> On Thu, Apr 18, 2019 at 03:30:20PM +0800, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2019/4/18 =E4=B8=8B=E5=8D=883:24, Nikolay Borisov wrote:
>>>>>
>>>>>
>>>>> On 18.04.19 =D0=B3. 10:21 =D1=87., Qu Wenruo wrote:
>>>>>> There is a BUG_ON() in __clear_extent_bit() for memory allocation
>>>>>> failure.
>>>>>>
>>>>>> While comment of __clear_extent_bit() says it can return error, but=
 we
>>>>>> always return 0.
>>>>>>
>>>>>> Some __clear_extent_bit() callers just ignore the return value, whi=
le
>>>>>> some still expect error.
>>>>>>
>>>>>> Let's return proper error for this memory allocation anyway, to rem=
ove
>>>>>> that BUG_ON() as a first step, so at least we can continue test.
>>>>>
>>>>> I remember Josef did some changes into this code and said that preal=
loc
>>>>> shouldn't fail because this will cause mayhem down the road i.e. pro=
per
>>>>> error handling is missing. If anything I think it should be added fi=
rst
>>>>> and then remove the BUG_ONs.
>>>>
>>>> That's true, we could have some strange lockup due to
>>>> lock_extent_bits(), as if some clear_extent_bits() failed due to ENOM=
EM
>>>> and caller just ignore the error, we could have a lockup.
>>>
>>> Not only lockup but unhandled failed extent range locking totally brea=
ks
>>> assumptions that the following code makes and this would lead to
>>> unpredictable corruptions. Just count how many lock_extent_bits calls
>>> are there. And any caller of __set_extent_bit. There are so many that
>>> the BUG_ON is the measure of last resort to prevent worse problems.
>>>
>>>> I'll try to pre-allocate certain amount of extent_state as the last
>>>> chance of redemption.
>>>
>>> This only lowers the chances to hit the allocation error but there's
>>> always a case when certain amount + 1 would be needed.
>>
>> Lower chance is already good enough (TM) for low possibility (0.001)
>> error injection.
>>
>> And, for real world low memory case, lower chance in btrfs means higher
>> chance in other subsystem, less chance user will blame btrfs. :)
>>
>>>
>>>> Anyway, such BUG_ON() right after kmalloc() is really a blockage for
>>>> error injection test.
>>>
>>> Maybe, but the code is not yet in the state to inject memory allocatio=
n
>>> faiulres to that particular path (ie. the state changes).
>>
>> With last-chance reservation, we can make state related memory
>> allocation almost always to success even memory allocation failure
>> injected (if the possibility is low and low concurrency)
>> And the last-chance reservation can be configured at compile/module loa=
d
>> time, making it flex enough for most cases.
>
> Forgot to mention, for that method, I'll definitely keep the BUG_ON() on
> @prealloc.
>
> Just make the allocation part fall back to use fs_info->last_chance[] to
> grab a valid memory slot.

This makes no sense in fact, for bcc inject tool, modify the predicts
can filter out the NOFAIL case, so all of my previous last-chance method
just makes no sense anyway.

I'm re-testing using the refined predicates: '(!(gfpflags &
__GFP_NOFAIL)) =3D> submit_one_bio()'

And just now, I hit the same lock_extent_bits() hang with NOFAIL filter.
So this is definitely something wrong in the submit_one_bio() path.

Thanks,
Qu
>
> Thanks,
> Qu
>
>>
>> The main reason I'm doing such error injection test is to ensure write
>> time tree checker is not the cause of the lockup.
>>
>> Of course I can directly inject error into btrfs_check_leaf_full() and
>> btrfs_check_node(), and filter the stack to ensure it only happen in
>> write time, and that's already what I'm crafting, based on the bcc erro=
r
>> inject example and kprobe return value overriding.
>>
>> But it will never be a bad idea to explore what can go wrong.
>> And "always BUG_ON()" -> "good enough (TM)" already looks like a
>> improvement to me.
>>
>> Thanks,
>> Qu
>>
