Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91655C43218
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 06:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 500F42067C
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 06:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="a3PuUhXC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfDZGcc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 02:32:32 -0400
Received: from mout.gmx.net ([212.227.15.19]:53291 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfDZGcc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 02:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556260334;
        bh=3OKnfGd3dPtdqVBSCFCWh6cPjDJjWEW76UWLrwKFi1s=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=a3PuUhXCpVMcK1n1z5jqmW0TC7gFsidLNdt8h18wG6iWVFhqZiAZ3oEwODwo5IkQU
         wkHsW5y3LpXreomcT0eQz9CF4JVj68H7QGRAfZ/p+4q06PM42mEM62YvAZ9L3fT2hE
         8tvAkXFXHTkbiBS5bM4KvBzOZEfetAm+JZcCCeLw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MaJ3n-1hGvhw3fvR-00WDwp; Fri, 26
 Apr 2019 08:32:14 +0200
Subject: Re: [PATCH] Btrfs: fix unexpected failure of nocow buffered writes
 after snapshotting when low on space
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
Message-ID: <cc92c057-915a-b83e-f308-2f0fcbd5107d@gmx.com>
Date:   Fri, 26 Apr 2019 14:32:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <50d35084420d7fed439d74fd29b12d7d@synology.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:r/rLOyYHEnM/jOX/dzi/DDx+xalu6hQVtJ3356Ept7GPylHPDV3
 p09KtXXzsv8kmTgG3/FaFsTEzm88HZFtIKmCgfqFoAwTLy+dHoGKWDG1SabRNOIOBi7NmgO
 rz6G3IXthV27/3Hv/U+1txCbEgTwAtQw27QNWXPBbMIpb+uFz++oYqj1eElpQtXRVq9G6rc
 saalbOCEXUSl9L5c79c9g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xcdX1DFhAq0=:6V5FJqcw588HjyjZVG+hLt
 vpQ1dC/Hisaq8p+AzdFFLFLlDHFSDV/zKWBhOfwHv2bBeT2IPwStNJ4thDR6kRqO8k2fECUSD
 ersvpJfn6jXCXouXuEijP4fF2p+Tl9kRddPBivHEfKVyCBhkUnhchmlDnTd9LrOpR33ocAf+5
 DrgX6GZwuBBC0shcVU1C0PbKOjwuxnN88AEsBqlT6DO25Ni+SmYZfrQefm1zSEV6XlrBNMKRc
 6bfBtHAUbFS9pwhecxkqeODBIgt/PpEhSBMnL49OkjNhn9WIABf+wM7WllMMjk1CEqjeG1yd5
 sBmbGugssrxkG219pDz5QmY09dPDRzrJAuxS9AOfSPYsoB9d1QNP8JtpuyKUmmXDV/qwkLnG8
 SKOSpnu//NK+dTZlDPF0EQA2lpcM/+STnu1YmTrXI4qPNQTJXXenFY2zX1Y+rT/CJbtCQEHlt
 BJFXdVO7q4KBNd3HcgqFaWz25qJA9eY1WQpW9J7O8cDhlV/q7BbZY3ZLmmpt67rB9u3wzx/m/
 EY/ext8iPaXdE/re9xWyD17dkY798VNB0LDhej4M95eHz+pgaENFGBxK44gOXig+iaRhJCJks
 7MzniOOi/npOJ3MyqNvGYha3auKuUDvviW7ypRk//5wryBww4seY1PBVySEjrS74yV0mvjpB2
 fJy0viTMbTwRUGrHumMCtJqgnr/PyJgtZbThqXHua4GUcQDGiI2njaLLwLgomDYtpnUPKV8sU
 96/AFmQup0PGbrdcGwyV3a7CDUF6kvMJnaUCI+LBhyWGHcYhSY/++Eai80ywVmof+/yvTRVro
 dR0pwQlLQ/mAhbSvkTg6eDUVNopUj0aAgp3jkq5McshncUdXzBF8NYta3PmG2Czl5vKS6OL3f
 oWsKucF6djTdbtg7wY5FEAftK0ksDhAU+RT3gN9tmfTEMsJ5hmCnPICzCyF3GXYbfUIcvs6TT
 sCV0+KRixmw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/26 =E4=B8=8A=E5=8D=8811:32, robbieko wrote:
[snipped]
>>
>> But now, before creating new snapshot, we will flush all data.
>>
>> This means at this time, the data will be written back *NOCOW*, just as
>> expected.
>>
>>> will_be_snapshotted will be set, and then flush
>>
>> will_be_snapshotted will also be gone.
>>
>> Thanks,
>> Qu
>>
>
> Why will will_be_snapshotted disappear?
>
> If will_be_snapshotted is removed, when volume is full,
> how do we ensure that snapshot and write are both
> simultaneous data not loss ?
>
> How do you avoid the write data between btrfs_start_delalloc_snapshot
> and create_pending_snapshot during this time ?

Oh, I forgot that buffered write doesn't rely on transaction, thus it
has the race window between above 2 functions.


So will_be_snapshotted is to ensure buffered write at above race window
always reserve space for COW.

So your patch changes the behavior from:
                   /------------------------ inc(will_be_snapshotted)
                   |
=2D------------------|-------------------------------------
reserve: NOCOW     | reserve: COW
delalloc: NOCOW    | delalloc: COW

That reserve NOCOW->delalloc COW is causing ENOSPC.

To new the behavior:

                   /------------------------ inc(will_be_snapshotted)
                   |                     /-- inc(snapshot_force_cow)
=2D------------------|---------------------|---------------
reserve: NOCOW     | reserve: COW        | reserve: COW
delalloc: NOCOW    | delalloc: NOCOW     | delalloc: COW

And now reserve->delalloc is either NOCOW->NOCOW or COW->COW, avoiding
the possible ENOSPC.

Then it makes sense now. (although way more complex)

Although I still have some questions about all these
will_be_snapshotted/snapshot_force_cow code.

1) Does that btrfs_start_delalloc_snapshot() in create_snapshot() call
   still make sense?
   We now have btrfs_start_delalloc_snapshot() in
   btrfs_start_delalloc_flush().
   Can we remove that call in create_snapshot() and:

2) Can't we make the race window smaller? (If we can remove the call in
   mentioned in above quiestion)
   E.g. move the inc(will_be_snapshotted) before
   btrfs_start_delalloc_snapshot() in btrfs_start_delalloc_flush(),
   and move inc(snapshot_force_cow) after that
   btrfs_start_delalloc_snapshot() call?

   As you also mentioned, the real race window is between
   btrfs_start_delalloc_snapshot() and create_pending_snapshot().

Thanks,
Qu

>
> E.g. chattr +C /mnt
> Fallocate -l 4096 /mnt/small_file
> Fallocate -l $((64*1024*1024)) /mnt/large_file
>
> First process:
> While true; do
> dd if=3D/dev/urandom of=3D/mnt/small_file bs=3D4k count=3D1 conv=3Dnotru=
nc
> Done
>
> Second process:
> While true; do
> dd if=3D/dev/urandom of=3D/mnt/large_file bs=3D64k count=3D1024 conv=3Dn=
otrunc
> Done
>
> Third process: create snapshot.

