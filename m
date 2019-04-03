Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03C3C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 09:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB8052082C
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 09:29:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="i8sWleXV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfDCJ3n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 05:29:43 -0400
Received: from mout.gmx.net ([212.227.15.19]:52243 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfDCJ3n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 05:29:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554283756;
        bh=+DU2oRVGVNm0O6HB6TTAAXSvfUpsKYnzd4WZxs6OXgE=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=i8sWleXVQKfcONBjIr9pvovOMqjw9yl6NSVuIYSpAA8gd670X2ikdTgJEZlrDUlWF
         dbFXye44/4r4wsG5mwyF7daO7fKDGqqcay3JwA26eVWMdVHtKkH4NOGzPMbVNv/5uM
         nV5fNb189E6bgxeyZOEvGrsys+d5LKgK08EUytxA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LsUDg-1gnRRL1atE-011y1E; Wed, 03
 Apr 2019 11:29:16 +0200
Subject: Re: Interesting btrfs csum and tree-checker performance penalty
 analyse
To:     Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <b1640ba7-b42b-8b60-6626-ab215c8e0b8e@gmx.com>
 <03733bc5-8247-efff-4228-6442a943047e@suse.com>
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
Message-ID: <3ff3082d-86ef-9cf7-7a9f-4e78daae2451@gmx.com>
Date:   Wed, 3 Apr 2019 17:29:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <03733bc5-8247-efff-4228-6442a943047e@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hmXi4jSf4UZv75MjrX4NGXAmWQBdmP5ukIF/U9UY082Nd/nOKW3
 7EYLQmyWmc6na3QKWtCvQ5/0Pqgt1kzVi6esMNQqqQu3i6Ijd2bEzn/Pz/DjD14pMrsKclH
 JV+rov5Xo1dy6X9W6NUHRQKpgN5lrLuJb8C4WwNAp18OAU1VJQlUjP6RzEKdeU87YMntmnD
 85Kq1qeYPXD2cKxFlE9sg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:NHfqR1f9ipM=:lwE/T+BfiEsk+lL5Z7fM1j
 cjYGor3xmAt6inVr3J5JYRCU0aex28/dMmBZdt1CABZSKmC8jmz6DrVViJPCMtdu0wjCqq/FT
 D8BwpMzwsYXBWVyhijjh8p2dZvVsK6pmx/N4WkiU9+s2BZePwkPaOUfndLoGCKx57mKn+GfQq
 Yhb4nFPwqo3JsVp/o04aNLNIw5bKn4xlTL3FxQUyI7Els96fs2CHsDU9+KqIW3zS/7+TJh4+v
 QoAk5acZC4aab8QGN161U4pM86mAUvZwmoZVnRIBwnu+/NQeNAAGpoRBgt5xUKK08o+3xfoHl
 hBqMjN9mIXuPKEQmqPxRakmAfADw+ztYG4oPktYoX5NMmkSUJmFYXj/NgDB7kE/Ctr0MVLCm4
 KxJyoYdXHfWY9mk730fQoOqNxx+QECRjUbDnj2VdMUgFO2MZE+lo1q3R6tgZs/5ONrMdGKiTD
 ETXhJ5KtgMs+c27Jm9AnWPk+FAjqH34/C7kVyOTFTAgRX+LgRl3d3AXnoKfJ6ZFes58KJ628A
 3eQPPaQD7GNX8q1YRKZXV3d15axiKamPeBsWcriEahwYaw5NH7Chn/+rWFIJMDeXH6daGcKLg
 b3dF9hpWzO52ZGMq03Yq6fVXXiu6GoFddBQqn89Pjh/hBcAFIwFSz1PTj0nRfhAQ8Hy7krtDb
 XbSX8v222Cg/J8hG0JFjiNiYhGAxnEUlnkfkLFh+StIjsTW2wMvSVO/DEAr9q8XnvyOjhnzwF
 1NZNpkD4VgJUs63/DyXWa4Vf24LqSrSn90oSgYs+RFUJ5crXXVe3iCeArnEw5aAk5gjp7I3Vg
 j4O3u18hkAXWRTGayD3ngrHyQV5L6guHzJWMwcHYrcpBLHX50Rigbj8EFI/I5NbHuTnVHgS7c
 FNkh8SaZ2Rtzibx7ZSnEAAEVkAim7IKNjncR3xuA7KDkXXcc/8kibLUQ4k8dBxwBduu2ojaes
 tnmONQMk9xQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/3 =E4=B8=8B=E5=8D=885:09, Nikolay Borisov wrote:
>
>
> On 3.04.19 =D0=B3. 11:54 =D1=87., Qu Wenruo wrote:
>> Hi,
>>
>> Recently Intel LKP performance test is reporting regression of btrfs
>> performance.
>>
>> It points to tree-checker code, and since I'm poking around the
>> bcc/ebpf, I spend some time to do an interesting look into the
>> performance penalty about both btrfs csum and tree-checker.
>>
>> The code base is David's misc-next, which contains both write-time tree
>> checker and enhanced code to handle fuzzed image.
>>
>> The tool can be find in my gist:
>> https://gist.github.com/adam900710/b5542f2e52ed4687986cf41f64b85253
>
> So you are essentially trying to figure out the average run time of 3
> functions, this could have been made simpler by using the funclatency
> bcc tool from iovisor repo:
>
> https://github.com/iovisor/bcc/blob/master/tools/funclatency.py
>
>
> Actually running this tool will show you a latency histogram making it
> easier to spot any latency outliers. An average value doesn't mean
> anything without having more context i.e stddev.

That can be done easily in python part, although the histogram has a
better way to present it.

>
>
>>
>> To use the tool, one needs bcc-python binding and kernel config for
>> eBPF, but at least Arch default kernel has all needed config, so any on=
e
>> can try it on Arch.
>>
>> The work load is:
>>  mkfs.btrfs -n 4K $DEV
>>  mount $DEV $MNT
>>  fsstress -n 10000 -w -d $MNT
>>  umount $MNT
>>
>>  ## start my script ##
>>  mount $DEV $MNT
>>  ls -R $MNT > /dev/null # To read all fs tree blocks
>>  fsstress -n 1000 -w -d $MNT # Trigger enough write
>>  umount $MNT
>>  ## stop my script ##
>>
>>
>> The result is very interesting:
>> Basic result is:
>> CSUM_TREE_BLOCK: nr=3D2311 total=3D10000612 avg=3D4327
>> TREE_CHECKER_READ: nr=3D461 total=3D41911553 avg=3D90914
>> TREE_CHECKER_WRITE: nr=3D1575 total=3D5783330 avg=3D3671
>
> Definitely something worth looking at.

And it already exposes a bug.

The write time tree checker doesn't check the content of leaf, which is
why it's so fast.

For the slow read part, it's the empty root owner check, which I'll
definitely remove it.

Thanks,
Qu
>
>>
>> So if just looking at the average number of csum calculate, it only
>> brings 3~5=CE=BCs. And surprisingly, write time tree checker even slowe=
r than
>> checksum!
>>
>> Also surprisingly, read time tree checker takes near 100=CE=BCs. nearly=
 20
>> times slower than csum/write time tree checker.
>>
>> So we have a new direction to enhance tree-checker performance.
>> BTW, bcc/ebpf is really awesome!
>>
>> Thanks,
>> Qu
>>
