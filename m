Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B930C04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 13:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B7C82084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 13:26:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B7C82084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbeLLN02 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 08:26:28 -0500
Received: from mout.gmx.net ([212.227.17.22]:42279 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbeLLN02 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 08:26:28 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Luajs-1hWuPU0fLc-00zq1u; Wed, 12
 Dec 2018 14:26:21 +0100
Subject: Re: name hash mismatch
To:     Nikolay Borisov <nborisov@suse.com>,
        =?UTF-8?B?0J7Qu9C10LMg0JLQu9Cw0YE=?= =?UTF-8?B?0L7Qsg==?= 
        <allsys01@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAKKX_zOEE=N5FrTyfg6JzJ7FfrBix0dnoKK2tYvmTD2kwvEXrg@mail.gmail.com>
 <7793059d-fca6-9465-6276-de7b764c7f89@suse.com>
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
Message-ID: <c7b5775c-9f3d-8793-1c05-66abc486d05e@gmx.com>
Date:   Wed, 12 Dec 2018 21:26:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <7793059d-fca6-9465-6276-de7b764c7f89@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:GaHjk2++B5NpUynuNIOFoBwV/KpPepT43zcoBS88F4DvKC57d6K
 ijP2OiL0sC8i41zaq3oSL3OoYsKasTCIjRiYR9LEi+misT/uuXxys6d9bbw//wOyq9m0fw2
 amq5ILehU1bSiYf5rCPqF8zsbqy/ST2W364Qp/NKXlLQ/IjMG8SECTrYsIhB9vvWZjsRrFJ
 cH270O44c2gRfGUtdnDIQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:UjPK7QmzBkE=:XIHRS6gFqAXVyTmnIjQES4
 F8hzDqutjFCbsOOVXbGRS0X1G4m9uF6G66yqtGqaFehezwqF5Kfh45Jn4cI/zPywHc2jyv333
 9TxHOoSHMzrGQjtgvkXiu3pTfCkVJVu9mJWim4V2ZsunKbo3R7xlkbSuKfdG60RhOHt4ZGWou
 +xMwvWtuV4MD2FD+K6CiHD7EU9zn1Ft7CteIxbweT3PY8bxJOKiwsU6j/NCvZoPCRAAAwaQvT
 A3tMaawSWsB6ZZGuWd0HIifR6jqrfNp4/rt7eXUrR6fHwQxxW70BkkDwlcBC0/AWPSZ+E/qan
 TWt9ZNiRRolwDTrDlatjmcslPF2UMBkfnpWOeItiU2WnEN05bpru3BmZkayySI26/pdUgJsZv
 go3CthjFs0tM0gIKfmqSCqe9g+o6lVyi1v5K5A2Vh9Q2TY9Y3oDHPbrN3j9+Mxp/At0PZeDiK
 /h9yv3Po8gAN8GpCWaUU19jxqFPE2HxsQag5K8nYGp81ZdtskCFQQXAYWSU4uxNR3u50ywIH7
 y0wGVdaHiWlYq2VCVLClE9wTIPO5jtJx6ojqqUMM2OyW4kEtnYXqCFyr3ppBqRBltZjc2GGc2
 W/nTJcIuNjmEPMDea8klp+auwTPS/H50UglNG+sXrf2Dx8rb8nADR5dgNpE3jiCDpakW+q3K3
 S8I/REECtZGdgiECr004Wslg6NfBcK/H4kzEPKk0NkOouzLCGqJ+9e3zsLFu12pr6GW8dsFQn
 hbZM9Rn9bGvv007ewj4r91T3OrygilZ0XojjtkS30/5DG+JcvDmAFr12uUM9UT7scPicv8wSn
 wA5HUk/T6+edOqmMqtcFCoCqQk6GXAaZV3zgiqrahrX1gC+YjkjiVUlk1K0CXQxlKLzTAc7z2
 LHoDAEab/M3sjNGFKKB5Ga0rxmB9kbguEVUij/RiYbbuxilcw0T6JP+1/xauQ9ledTQzTk9wT
 JZb9IUIds7g==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/12 下午9:00, Nikolay Borisov wrote:
> 
> 
> On 12.12.18 г. 14:44 ч., Олег Власов wrote:
>> Hello
>> If anyone could help with with "name hash mismatch" error at btrfs.
>> full error is
>> "BTRFS critical (device sda5): corrupt leaf: root=2234
>> block=244700761008 slot 136 ino=2531, name hash mismatch with key,
>> have 0x000000000026cd84d"
>> so i could not access one file neither to remove it.
>>
>> uname -a
>> Linux linux-wwqj 4.12.14-lp150.12.16-default #1 SMP Tue Aug 14
>> 17:51:27 UTC 2018 (28574e6) x86_64 x86_64 x86_64 GNU/Linux
>> btrfs --version
>> btrfs-progs v4.15
> 
> First I'd suggest to update to the latest btrfs progs. Then just run
> btrfs check --readonly --mode lowmem /path/to/device  and paste the
> output. This won't do any changes to your filesystem but will give a
> better idea of what the corruption might be.

Yep, that's pretty much recommended.

On the other hand this kernel warning message just means exactly what it
says.
One of your DIR_ITEM has incorrect hash.

IIRC this is an old bug in kernel, not sure when it get fixed but it
should definitely get fixed now.

If btrfs check --readonly shows *NO OTHER* bug, I have the check-next
branch which could fix it.

But please keep in mind, don't run btrfs check --repair right now.

Thanks,
Qu

> 
>>
>> tnx in advance
>>
