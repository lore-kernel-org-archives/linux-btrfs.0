Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0611EC10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 08:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A50EE20989
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 08:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="iN3BSmIL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfDFIAV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 04:00:21 -0400
Received: from mout.gmx.net ([212.227.17.21]:60625 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbfDFIAV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 04:00:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554537609;
        bh=9b9g9YeNxIECexcii19VRfnumr8BWH7w86qCe26SBjQ=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=iN3BSmILWyFGATG9lRpFl8iOMPyzznTZQKp6mHjLUgsSR8n/eAzslj622rdZytrIB
         MdbIJxVOMqMberB9fQqrFnvbSOxyNaPs6+KI0zVO+q5irjqHXYeCOqBPzmlayMUj5y
         eDer7x+1C4jWs4N4LGqqnX0bIbkP5bUcsruyhp1Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MZ8fw-1hT68R405s-00KyTa; Sat, 06
 Apr 2019 10:00:09 +0200
Subject: Re: Possible bio merging breakage in mp bio rework
To:     Nikolay Borisov <nborisov@suse.com>, Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@osandov.com>,
        linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <59c19acf-999f-1911-b0b8-1a5cec8116c5@suse.com>
 <20190406001653.GA4805@ming.t460p>
 <9ac6f2eb-069a-a02c-7863-e33cb00ad312@suse.com>
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
Message-ID: <07d4d129-6d50-2d2e-746f-c7316670a749@gmx.com>
Date:   Sat, 6 Apr 2019 16:00:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <9ac6f2eb-069a-a02c-7863-e33cb00ad312@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BiuoJTQZCtOA7meZPfocY3UjwuZEoJ3XFwQFRZBkAlAAzHiK36n
 oZqufhb2fWmoIJcQ40gpK8mipPuuMRkV6FOJHupPGereaGJJ3oyX7J/85Q2vtd6XJDeE2nd
 7yID5aHx6yLau/opu9x+fjiRvX2Z9+8/0mC0FE4kWTgtpwxxnGvBxAkyUdbylwe9MLQFwxx
 HDuT6TtBAmFiq1WiQqicQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:D2MEFyagfmM=:8HQgtRxLJjN5FCiSVFHDyM
 rxjabK34M+W4VGrZli4cSFSai4dnEL3OjVuZxXLW+hnOOJtsABZH1RrT7zMb2oaOWDFM61FU7
 1BKpKUo2qK7/CQIhUK5NOmVnrc0Q3Jf5polilfknNGPhXenziUsyRxToUKKSkW8yNxsGc2Lsf
 eP3KLfgpmJVGjd3vq1iyk7wA+EHelM08it0W9T5XQc7O2SOV1jIX7O3Ux0zl7eyJdqqP5lXOZ
 lRCk5RjBznx3jfM3CtRTmV+hXpJl4xkSZUzgoGRz3hkl8QdH+yNtA209FjZF28MI2WfZUCLaD
 zGlVN3eyGxAYaM2sf7r1NstDheAB9LOew8JcbGlDNJ74z188rIbahBYhD2UCc2m9MB6c3lbWN
 /eMyDUlzni7+BVl7i5bCqPxoSaByXisWBnZnUrnN4buv7ednd658L1eiFRGQpXHIhZ3klOlat
 HopjMsDhzp05FphYS1fsPm7UlLSNatJd0SMNm+M/m0Eh4fiqmppqbnUWcMPrzdQR+T7jLjERf
 ReL0PRZOx/wqwHck06ZzHsA3XLUakpiMpLVa92ojvIauBCpVAj0tX/5IGJ+xp4exCo+uIfXXy
 b/MTUWyX+ChUF7iuDw+AytHurDGns6DcZs19KE2blHQAyuHRhh5VZkMLfYZMUfubpHToA5XoJ
 5QoATtDGDANzzzGSdVfK73P0ZxN45A6ID7XVcIrX72IG2uFUy8fix2aw8BmYyNK78yG4+yMJC
 DQj85O7jWp3ewcdShEwGblQBYgpXdyHHUDpWjBFanROoX8NyjHY7Vf38EIaQJl9qC30lktE4E
 hzlAT7w0XAcAXxFEWt3b52qUtXsNveHkj8Twlalj5MPLOM1o0n5e625KExeMTK0Z+uCrM4irQ
 01yVzi4+eRX2YzfMpkNZjmBiFd1HYW/vUDR8HIwHD/bWZMObyhNbNPiL5OfaPzeCvBfbkxH+G
 1HbesY2HM/A==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/6 =E4=B8=8B=E5=8D=882:09, Nikolay Borisov wrote:
>
>
> On 6.04.19 =D0=B3. 3:16 =D1=87., Ming Lei wrote:
>> Hi Nikolay,
>>
>> On Fri, Apr 05, 2019 at 07:04:18PM +0300, Nikolay Borisov wrote:
>>> Hello Ming,
>>>
>>> Following the mp biovec rework what is the maximum
>>> data that a bio could contain? Should it be PAGE_SIZE * bio_vec
>>
>> There isn't any maximum data limit on the bio submitted from fs,
>> and block layer will make the final bio sent to driver correct
>> by applying all kinds of queue limit, such as max segment size,
>> max segment number, max sectors, ...
>>
>>> or something else? Currently I can see bios as large as 127 megs
>>> on sequential workloads, I got prompted to this since btrfs has a
>>> memory allocation that is dependent on the data in the bio and this
>>> particular memory allocation started failing with order 6 allocs.
>>
>> Could you share us the code? I don't see why order 6 allocs is a must.
>
> When a bio is submitted btrfs has to calculate the checksum for it, this
> happens in btrfs_csum_one_bio. Said checksums are stored in an
> kmalloc'ed array, whose size is calculated as:
>
> 32 + bio_size / btrfs' block size (usually 4k). So for a 127mb bio that
> would be: 32 * ((134184960=C3=B74096) * 4) =3D 127k. We'd make an order =
3
> allocation. Admittedly the code in btrfs should know better rather than
> make unbounded allocations without a fallback, but bio suddenly becoming
> rather unbounded in their size caught us offhand.

Can we switch between kmalloc() for small csum while using pages for
larger csum?

Thanks,
Qu

>
>
>>
>>> Further debugging showed that with the following xfs_io command line:
>>>
>>>
>>> xfs_io -f -c "pwrite -S 0x61 -b 4m 0 10g" /media/scratch/file1
>>>
>>> I can easily see very large bios:
>>>
>>> [  188.366540] kworker/-7       3.... 34847519us : btrfs_submit_bio_ho=
ok: bio: ffff8dffe9940bb0 bi_iter.bi_size =3D 134184960 bi_vcn: 28 bi_vcnt=
_max: 256
>>> [  188.367129] kworker/-658     2.... 34946536us : btrfs_submit_bio_ho=
ok: bio: ffff8dffe9940370 bi_iter.bi_size =3D 134246400 bi_vcn: 28 bi_vcnt=
_max: 256
>>> [  188.367714] kworker/-7       3.... 35107967us : btrfs_submit_bio_ho=
ok: bio: ffff8dffe9940bb0 bi_iter.bi_size =3D 134184960 bi_vcn: 30 bi_vcnt=
_max: 256
>>> [  188.368319] kworker/-658     2.... 35229894us : btrfs_submit_bio_ho=
ok: bio: ffff8dffe9940370 bi_iter.bi_size =3D 134246400 bi_vcn: 32 bi_vcnt=
_max: 256
>>> [  188.368909] kworker/-7       3.... 35374809us : btrfs_submit_bio_ho=
ok: bio: ffff8dffe9940bb0 bi_iter.bi_size =3D 134184960 bi_vcn: 25 bi_vcnt=
_max: 256
>>> [  188.369498] kworker/-658     2.... 35516194us : btrfs_submit_bio_ho=
ok: bio: ffff8dffe9940370 bi_iter.bi_size =3D 134246400 bi_vcn: 31 bi_vcnt=
_max: 256
>>> [  188.370086] kworker/-7       3.... 35663669us : btrfs_submit_bio_ho=
ok: bio: ffff8dffe9940bb0 bi_iter.bi_size =3D 134184960 bi_vcn: 32 bi_vcnt=
_max: 256
>>> [  188.370696] kworker/-658     2.... 35791006us : btrfs_submit_bio_ho=
ok: bio: ffff8dffe9940370 bi_iter.bi_size =3D 100655104 bi_vcn: 24 bi_vcnt=
_max: 256
>>> [  188.371335] kworker/-658     2.... 35816114us : btrfs_submit_bio_ho=
ok: bio: ffff8dffe99434f0 bi_iter.bi_size =3D 33591296 bi_vcn: 5 bi_vcnt_m=
ax: 256
>>>
>>>
>>> So that's 127 megs in a single bio? This stems from the new merging lo=
gic.
>>> 07173c3ec276 ("block: enable multipage bvecs") made it so that physica=
lly
>>> contiguous pages added to the bio would just modify bi_iter.bi_size an=
d the
>>> initial page's bio_vec's bv_len. There's no longer the
>>> page =3D=3D bv->bv_page portion of the check.
>>
>> bio_add_page() tries best to put physically contiguous pages into one b=
vec, and
>> I don't see anything is wrong in the log.
>>
>> Could you show us what the real problem is?
>>
>> Thanks,
>> Ming
>>
