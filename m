Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9113EC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 23:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47BCA2075E
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 23:38:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="kEinTa9L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbfC1Xi4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 19:38:56 -0400
Received: from mout.gmx.net ([212.227.15.19]:37095 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728038AbfC1Xi4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 19:38:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553816325;
        bh=6sJ8IH10m5Q7QAXFsUCEA4cdt+wpwX47dLpHasDSDH4=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=kEinTa9LhssL8hO2oHuDqKHwespNrlAp7KMfwcD7KZk2NF59vEBuUwVSpsdRx41Hd
         AlmVWrrFTgWcM/gBGDA43CoQvqf3G5ytG5GwjQvFOwXw6FB8je1Ds3OZT/2BvsUSne
         Pl9/VD1SNEXfpJAs48pzse0OiyaJA7iJRCbFI7bk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MHoWj-1h64dd07C9-003eJA; Fri, 29
 Mar 2019 00:38:45 +0100
Subject: Re: [PATCH 1/3] btrfs: tree-checker: Verify chunk items
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190308072929.30863-1-wqu@suse.com>
 <20190308072929.30863-2-wqu@suse.com>
 <913bed07-e9a0-14ed-1602-e4a5f206e303@suse.com>
 <95e0667a-0004-bec0-03c3-1708ab013320@gmx.com>
 <20190328165843.GP29086@twin.jikos.cz>
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
Message-ID: <5b9860cc-608b-3133-013d-a723dee07f7e@gmx.com>
Date:   Fri, 29 Mar 2019 07:38:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190328165843.GP29086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6VY+VfUBJK76lGaYvXo9CQUT2Jyghww0JQS9ytGcjNjI/NVIwW0
 PhPJ0251N7issNWZC1HA3Gop6/8jn3dt4jkJgF/YPpsN7U07zwKNdnhaWa1Zbm3vJBgnxbu
 WVC2caG8TzGL9cAX0oSZ9bvApaxL6EfEM/QhQqXdN9fHlbTBh8gE2CXd8DXVbUoEooWL/Uo
 NyUfc0vueEsXcbkEIhKFw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:997V4LYXMt8=:dDVfW2p6TmpDEbQVrVfz/f
 3ud98IWw3N8D2TSXI3KXid+z4917Mng7zTkET0fwSY83B6qjQdnSMc1OTNd5MtZ0Cn4gm9sKn
 7IK+JP9gOZqk/hzI1q22Ss013aMbEUpoCBpKoUA1um9MI3fnrO6co2efZJhLry/cSs+XZMKZC
 X1gcSD2f50OsRSxcP0251AzpNa5zgtz/DPtDKQDnZloP0YafKn0byD53f0gDj4hatQ/o9Dw2v
 Ua5ndRqNoMlOi28+lhjHeufDXdmcoRhWVDBBOx4Te1GNcODe8UitliXxBuIbYO9Rnsc47zDhW
 G/mH70PgmOIccwaHfnuDQmyTr9p+YqVoGiXkmrJ3ImTCUYHgynKaIEkDTsq+Mk0fHdoQx6sAJ
 8feImTihexvZQsdDOP6TlGkIG1JlBYM4vlk0GvOhfUluLPDIsTAZflaHCgeiTkve8G9tbGEho
 UKdi7+bUjSyq7SnqJbJ+Crw7WyEeAsKcsfh73P/ZHB3VBZIaNa8Z9E/WzPhWdFTl582ncTjxC
 yMSvbXwkmZmC3koE7DXOg3M6fKiX5dSyP4290V0sJXH4+fd9Hd66msVkXxYXXO1Rjc8q58TXb
 8wHp8bKvf3K55gQrFzccjMe/1mTbNlz+bTUDWDFKHyUUzU89Mfgiehg4fHdCDMpk8ZoiYlvMz
 WsPEh7icPPCISka4mQ3vldBdclWA+JhDpAtKI0ZLaBv+eg7+d2EsV7fL3PB/aB37bWP1dJG/N
 IJfWw1eh43TL7twjFzxA0233i6mNakkVLZOn+j0syRtANAjIN6D5ON/F4VWOxu1doktfA1QWq
 8Nh9xvocgm11rU8WrZIG2PPgv2fY4mEqXHeSl99OZDmk05oZUTjHmvphQz6RzR1jRXFOOGzDV
 5q7SpvF7bLp5cx8tgF12rSn9U9lvYbfq3ozo4VXo8I60x3Z0iLFY1neChYJBVfWtbCaj8tWfX
 XYiTldZMvdQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/29 =E4=B8=8A=E5=8D=8812:58, David Sterba wrote:
> On Tue, Mar 19, 2019 at 03:58:24PM +0800, Qu Wenruo wrote:
>> Should we put kernel test cases into btrfs-progs?
>
> We collect all the images in btrfs-progs.
>
>> We have fuzzed test groups for btrfs-progs mainly, but we don't really
>> have kernel tests in btrfs-progs.
>> Is it proper to put kernel-crashing tests into btrfs-progs?
>
> Yes, but they should not be run by default. Currently there's not even a
> test script for mounting the images. But the testsuite can be run
> independently in a VM so the kernel tests make sense too.
>
>> If not, where should we put such tests?
>>
>> And BTW, I originally wanted to craft the minimal image for those tests=
,
>> but quite a lot of the image needs several corruption combined to hit
>> the pitfall. I'm not sure if it's worthy to create the minimal image.
>
> That probably depends how much other work does the minimal image save.

Just tens of kilo bytes for the image.
The original crafted image is around 100 kilo after compression.

The minimal image is about 20 kilo, but I can't reproduce the same bug
due to less corruption.

> The plan is to use python-btrfs to craft the images on-the-fly. We could
> do that by specific tools written in C or enhance btrfs-corroupt-block,
> but I'm strongly in favor of the python way due to simplicity.

Considering how many leaves and their copies needs to be corrupted, and
some tricky combination is needed.

I'm more or less tending to just use the fuzzed images provided by the
reporter.

Thanks,
Qu

>
> Another way is to use the script only to generate the image and then
> store it for tests to avoid the run-time dependency on python-btrfs.
>
