Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9EBC43218
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 07:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 665B6206DD
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 07:00:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="a7/uE3Vu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbfDZHAB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 03:00:01 -0400
Received: from mout.gmx.net ([212.227.17.20]:48531 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbfDZHAA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 03:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556261976;
        bh=QRWxnbmM1EulrzHPqRNbibayoA+Un5pFJHEJcKzpy2Y=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=a7/uE3VubeACQigwCSEIVCNAxTUdC9nCL8eDRlY31MySgtOv/DfRN2SPfouzymG6b
         NuuqbMluV9g57eGHSI4SzWrufdcxzw68McEgT89HTtip4B1ZPkKqSfi+ZwzRyCXwZy
         PzAi9UGUKvRV5vaW0+XCKhvEx4xWbtN8hoJnjz5k=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MEccf-1hZZ5q2uUb-00Flel; Fri, 26
 Apr 2019 08:59:36 +0200
Subject: Re: [PATCH] Btrfs: fix unexpected failure of nocow buffered writes
 after snapshotting when low on space
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
To:     robbieko <robbieko@synology.com>
Cc:     fdmanana@gmail.com, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        linux-btrfs-owner@vger.kernel.org
References: <1533522630-21758-1-git-send-email-robbieko@synology.com>
 <afb5d89f-e1f9-351e-c789-ac291649d17b@gmx.com>
 <06b5b693-8017-7ec0-b17a-c723291f00c7@suse.com>
 <950b2924-9edd-d9d7-ace0-bc3e2ab07a6a@gmx.com>
 <CAL3q7H6-9mxYyzi8Y0N8Vvgf4qRgrqURqHASE_4Du-jLmywuBQ@mail.gmail.com>
 <cfcaf75e-7e89-cf1f-9293-6a022762f22c@gmx.com>
 <20b22fc6cdc288ed9aaf0be1a6cdeb7b@synology.com>
 <1fcaaa0c-cf7b-38dc-0af9-c90773c9af07@gmx.com>
 <50d35084420d7fed439d74fd29b12d7d@synology.com>
 <cc92c057-915a-b83e-f308-2f0fcbd5107d@gmx.com>
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
Message-ID: <bc2fd2ad-1ca9-48d1-d8ff-13eec7eabd02@gmx.com>
Date:   Fri, 26 Apr 2019 14:59:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cc92c057-915a-b83e-f308-2f0fcbd5107d@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EKg82/XV7ugL2wd7HS4RIFoFzbCSszm8XUM1K9oy31ir1Nh5lfc
 j6iJiz4HdvW6gzZxDoERy5oiwvg+ILZGfxRYIY8WYejqIS+OTF4N65St9f+htbJ3fxCYNE5
 E0JTgiQJdKABAqmTdcFci7lzesPnjagGxNPRWW3QyLcDFGvMHO7o4lgv0X57tuGAwe39u83
 YqJ65W3rkwaZKcTDJaGzQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vy8ts3nVtKo=:fy0D4Z9e3Tfz9yEugAKuIB
 IuxbI/xTtWotFVhLogOLik+HJKzxPSXwQzltZXyepOSNnyd48WSRBtYWbMyQHTRss5aTsvuxO
 smt37BD5IOsdZh/qfGM0paz+liEFTyZ/BgGBSuXl+nnEV157S25G9eJo1ZjRQEhW6KC6L5bIo
 vaiTRCdn8lQPcVUvpLJ/qSashBfQlQ5fXbkFd21kOBF7mgOmSH7tLmnxTzSGfJ0yOmpKcnW3b
 7tCXCBk5T8d/49NhHLPd4hyCZFHcp6AQb2wN8myagze+zGKVo1L1O9KIJZtzftkWswOlo4xnU
 hxkKyktR3lzZ+UYFRZ2+DNTeyAWfyLbVvBOFo+Uo0UqqeJXHWnd9mz5F2BJTnvflD7RH7eQIk
 OHuTqbMwVJqjcpCrOCeEHy7hkA8Trz3FnNnasDLm4qLYozN50jxB58Il9XxRX80fJ+lkoqEYw
 Mr8wzTKkybN4YGzkpEpJruPW/uSMcetusGTp/uTSZsAcuQqCB55J7Cy0LzXVDpeKulvZwemgO
 w3cVTpVlxJZt2xP3zejfumg8tmV2wRyUTWcc/j/eXiZKRd3W4KbrWFA6+fKWTwDBHBG+xQJjf
 8BUHKWi+Lpn8anykIiwvF1Hp75jVSx5mlLZaPTDwDGqWPNIpRCeYJ7izJoy7Zpq2b6QlaIrh4
 cGdPsncS/aqknbVWfl9G6hDcHf2p0tR0GKwbg7XgD1p9QjzgQrQgVY62zSuayPbY5fejTpEo0
 6KMfe544tLtrnxG+gYC9qbfToCgM16zaMXm3dyjKlaUMflp2C7hWf2FMVUJUqOtjuk1aWMosp
 r3GkTXfOo09y8eoQd0us5IauiAv+ytS5x/PQDB6sSwD1PXt2weq4RY03g/mbaPM7mYsioigqD
 sTN600EFmUB1AcPNI9t3NRygHiLDZMrRPkIT0+3l/s72dUZO3w/pgQ7I6yqOqgcHrkdTnPR8c
 zMzYEZjvE1w==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/26 =E4=B8=8B=E5=8D=882:32, Qu Wenruo wrote:
>
>
> On 2019/4/26 =E4=B8=8A=E5=8D=8811:32, robbieko wrote:
> [snipped]
>>>
>>> But now, before creating new snapshot, we will flush all data.
>>>
>>> This means at this time, the data will be written back *NOCOW*, just a=
s
>>> expected.
>>>
>>>> will_be_snapshotted will be set, and then flush
>>>
>>> will_be_snapshotted will also be gone.
>>>
>>> Thanks,
>>> Qu
>>>
>>
>> Why will will_be_snapshotted disappear?
>>
>> If will_be_snapshotted is removed, when volume is full,
>> how do we ensure that snapshot and write are both
>> simultaneous data not loss ?
>>
>> How do you avoid the write data between btrfs_start_delalloc_snapshot
>> and create_pending_snapshot during this time ?
>
> Oh, I forgot that buffered write doesn't rely on transaction, thus it
> has the race window between above 2 functions.
>
>
> So will_be_snapshotted is to ensure buffered write at above race window
> always reserve space for COW.
>
> So your patch changes the behavior from:
>                    /------------------------ inc(will_be_snapshotted)
>                    |
> -------------------|-------------------------------------
> reserve: NOCOW     | reserve: COW
> delalloc: NOCOW    | delalloc: COW
>
> That reserve NOCOW->delalloc COW is causing ENOSPC.
>
> To new the behavior:
>
>                    /------------------------ inc(will_be_snapshotted)
>                    |                     /-- inc(snapshot_force_cow)
> -------------------|---------------------|---------------
> reserve: NOCOW     | reserve: COW        | reserve: COW
> delalloc: NOCOW    | delalloc: NOCOW     | delalloc: COW
>
> And now reserve->delalloc is either NOCOW->NOCOW or COW->COW, avoiding
> the possible ENOSPC.
>
> Then it makes sense now. (although way more complex)
>
> Although I still have some questions about all these
> will_be_snapshotted/snapshot_force_cow code.
>
> 1) Does that btrfs_start_delalloc_snapshot() in create_snapshot() call
>    still make sense?
>    We now have btrfs_start_delalloc_snapshot() in
>    btrfs_start_delalloc_flush().
>    Can we remove that call in create_snapshot() and:
>
> 2) Can't we make the race window smaller? (If we can remove the call in
>    mentioned in above quiestion)
>    E.g. move the inc(will_be_snapshotted) before
>    btrfs_start_delalloc_snapshot() in btrfs_start_delalloc_flush(),
>    and move inc(snapshot_force_cow) after that
>    btrfs_start_delalloc_snapshot() call?
>
>    As you also mentioned, the real race window is between
>    btrfs_start_delalloc_snapshot() and create_pending_snapshot().

And another (unrelated) question:

3) Why we use such complex way to prevent race? Why not just go per-
   subvolume freeze like various volume manager?

   Current way keeps buffered write still going, but does it worth?

   If we freeze/block write when creating snapshot, it just falls back
   to traditional volume manager behavior, shouldn't cause much problem,
   and we can get rid of all these snapshot specific fixes.

Thanks,
Qu

>
> Thanks,
> Qu
>
>>
>> E.g. chattr +C /mnt
>> Fallocate -l 4096 /mnt/small_file
>> Fallocate -l $((64*1024*1024)) /mnt/large_file
>>
>> First process:
>> While true; do
>> dd if=3D/dev/urandom of=3D/mnt/small_file bs=3D4k count=3D1 conv=3Dnotr=
unc
>> Done
>>
>> Second process:
>> While true; do
>> dd if=3D/dev/urandom of=3D/mnt/large_file bs=3D64k count=3D1024 conv=3D=
notrunc
>> Done
>>
>> Third process: create snapshot.
>
