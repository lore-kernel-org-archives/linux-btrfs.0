Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538CBC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 08:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 103FD20857
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 08:03:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="MvOBAdhJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfCSIDm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 04:03:42 -0400
Received: from mout.gmx.net ([212.227.15.18]:47693 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbfCSIDm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 04:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1552982311;
        bh=ZFb9u4/+1MuBvKta0n6l1Z3xizYhQTIzgnKnSTmUdiA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=MvOBAdhJ1xuioWTcxbbf6OVDuVwoJwtoMU1nIqVaLvbxFLYkcvSpgHSbNN7j7p7Tg
         gfiSSE6la3oIewzTGe0u1sZC+vw3L5HW21mLzUKDBxXR5x1O3B6QOs/Crz+9fBhxVV
         DwAzeEdv43kMWOr5LqKFlP8Nhgi7h3FYir1CzmiY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M4nt7-1gngxH1LR7-00yzLr; Tue, 19
 Mar 2019 08:58:31 +0100
Subject: Re: [PATCH 1/3] btrfs: tree-checker: Verify chunk items
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190308072929.30863-1-wqu@suse.com>
 <20190308072929.30863-2-wqu@suse.com>
 <913bed07-e9a0-14ed-1602-e4a5f206e303@suse.com>
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
Message-ID: <95e0667a-0004-bec0-03c3-1708ab013320@gmx.com>
Date:   Tue, 19 Mar 2019 15:58:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <913bed07-e9a0-14ed-1602-e4a5f206e303@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0NEOIbwmwQjXUeBpaNT+oDxgIphx48Bv3cJP5N1q5OKawO1OWPf
 kEuDSxCHVsV3LIbT1OyQEiOIHbIvUv0HtE+jafupr2yamgg2Y47SoPUnapl7A34eiKnUYjO
 JYRbXe1bEhsnFPe8Ia+ADVdi3tGowJnKGd3OkIgNUWUMSB4IEKUG2HKvD5q7oW20VeZcW7W
 y+gMquSzlNfmXhHZQbxLw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9/sEXdRar1Y=:A3q4NWDBbRrAAAtkLY4FjI
 i6RzpYFRrkNBIiNGPxlxXQi6UeXNqryKSwVZ0d3DODyH/SBXuB4A1hnw4HmEMTiCg5mqyWj3v
 lwswTemDsP/zNaQrFER4QvctF+cOSAXNiHmUN9p8quE9KJ0054wHHrV0xiG3FfWxF00rcndPp
 HHy6VTAT7OpcMcd4QR4t9tlZsYl5fB4bqCsG8PkXbJKU/+y34t2dZJC5N+yEbeqk5LHTe/DDd
 +13kQ+Dnn6RJoz8wLh4nycTuntnuiv553hKakiZXFHLLdbx663WjQbY/zXgUw9hvRpC0PNV/r
 nzDpgVPAvaGbGkk/ikx7wAnKAx55rdfXaWcb/oV6nEFnRYqABZorDT1LHcm2hoAhTRw9R0oWW
 61ebhBwXipslsHyALntmMPRFQ+i7KK4kcy5PmAYa/sJqhcBfsLKqz+0K/sUPHj7h1EoVgMomt
 QyKGvyZFHgttbDH6Odo+gEvAM1t+eVJ85l5icynjSbxjNTWG4kpPw6HK5zFRR1UxFv08Y1Wbb
 DkXPRJyjKPy85zS5mzsqTzMWq0U+ZM4YlOING8gihf62bupLkq36Xpuadc533pajOHShkMiHB
 /lPpHdi6CtEFMzWgt55464fqA7Y8aaa2xtxzanSUe1TZJYYiyGQqyihp8xY4BPYEWGdlTl9fP
 rylEeN0TJ/FfCC0tpjWauIcJ1LTJv77DtyXxEeKY0xuwSt80i1FKtJR1XW6waBtoyVKBvDs2d
 JgGpS2RWGS6Rq1tuRoQY6pVHwYI5K1rtTnxPvh8wqQL/5nNQx1y1gh3foc9vFzYaUahH0GQSr
 6/ofnxEuhCU48Qjcb9WWonI/LwI/vJCsw0ZxYLEVt9D4iocbwQIxtguxq/S+9LFrDz6Yl1OBb
 N+61LExXBPk6TLykYYRIxEm2CuCZeUsUc15FOfkz7HLlwWmhbuosj5xqRwTyyIbSNBcBFoxgh
 QiHgqdJ4tQg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/11 =E4=B8=8B=E5=8D=8811:25, Nikolay Borisov wrote:
>
>
> On 8.03.19 =D0=B3. 9:29 =D1=87., Qu Wenruo wrote:
>> We already have btrfs_check_chunk_valid() to verify each chunk before
>> tree-checker.
>>
>> Merge that function into tree-checker, and update its error message to
>> be more readable.
>>
>> Old error message would be something like:
>>   BTRFS error (device dm-3): invalid chunk num_stipres: 0
>>
>> New error message would be:
>>   Btrfs critical (device dm-3): corrupt superblock syschunk array: chun=
k_start=3D2097152, invalid chunk num_stripes: 0
>> Or
>>   Btrfs critical (device dm-3): corrupt leaf: root=3D3 block=3D8388608 =
slot=3D3 chunk_start=3D2097152, invalid chunk num_stripes: 0
>>
>> Btrfs_check_chunk_valid() is exported for super block syschunk array
>> verification.
>>
>> Also make tree-checker to verify chunk items, this makes chunk item
>> checker covers all chunks and avoid fuzzed image.
>>
>> Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D202751
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>
> Actually since the reporter made images available I would like to have
> those integrated into the fsck group so that those changes can be
> validated and ensure further regressions do not creep up.
>

Add David into this discussion.
This topic seems to be mentioned before.

Should we put kernel test cases into btrfs-progs?

We have fuzzed test groups for btrfs-progs mainly, but we don't really
have kernel tests in btrfs-progs.
Is it proper to put kernel-crashing tests into btrfs-progs?

If not, where should we put such tests?


And BTW, I originally wanted to craft the minimal image for those tests,
but quite a lot of the image needs several corruption combined to hit
the pitfall. I'm not sure if it's worthy to create the minimal image.

Thanks,
Qu
