Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29032C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 12:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB96C218B0
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 12:55:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="FbMvDsdx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbfDXMzq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 08:55:46 -0400
Received: from mout.gmx.net ([212.227.15.19]:48665 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729032AbfDXMzp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 08:55:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556110538;
        bh=JXu4p1u+3Lc59Sy82FGPspKZMn5qCEMD48nYJQplIFg=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=FbMvDsdxXRnld3n0BYWUd2LsMPiZdVBcAGpOIP8TseBduUPYIhp4DG7UqFBQoTvbu
         WFVu5tq8QhvdsqjhBQJFO/ZB0N304XR84XNdzKUlV8zIzud1fWGl9mCZpauHYL7BnL
         jCXU13YyKLby/WiwEZb+hG9whCo38gsCnrRafL0g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MQMyZ-1h6GrW3JGz-00MMk7; Wed, 24
 Apr 2019 14:55:38 +0200
Subject: Re: [PATCH] btrfs: ctree: Dump the leaf before BUG_ON()
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190424124829.14277-1-wqu@suse.com>
 <05b5b4bc-4849-61c9-79d9-72af22cfaf1e@suse.com>
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
Message-ID: <9dd0ff19-97fe-1f43-f884-4d539fc34343@gmx.com>
Date:   Wed, 24 Apr 2019 20:55:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <05b5b4bc-4849-61c9-79d9-72af22cfaf1e@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ta0Y7sZ/34j5dlMzkDewcexuk7LKCk/g/huwArYpy6hdSX0rzKs
 CGULNI48WuFyNpDiGhB4Wgg/uTJv7UTPxKxamEZpbxuvx+edgG2DLuG/AFVyIPrbmfznHZQ
 W1iXQavdtKihN0ivzWbW/Kf/8NoIGZ+bKZe8xFk0pT8BgXuGEfJAOlHEVRLPQFGT3xAEwsh
 kgQiXWhjNp8Tisty8m52w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:X4fP7memqFY=:dmynwoAGObhzmJF9NEFa4U
 aJIDajaO+segHlXG0zdX/7+91jWniClqqf/i+bu+H9tbPUcA0sctM7x+BvkNssFj8YmxSkcDd
 Tivjzzdc5Gy8YO8xX0JIF1CpnM7vpXsbv6ZYrKxjPflDebWKS61GSn6VDU5MZjudeFhUltC+I
 Nd+Cw1hjfMsqVjoYz6iCah3FhEFSJusrYXE5d5s8G1Z3h0uxP4jYThhrdk1cdEanavtXkuFJ6
 2eooVnNSC82vMk1g1Dhyun4z/gfi2+JhfmRgwfu3ZHUneEkUzfMjxcorTWBUyuNIJ5O2STNNp
 RUzYVI8t8WfeuX0djrwFOKuU0Fa0TRMLDTgZEveFnZ2nEfFNDZU10hHmPwVT33wAhcmHf1zMF
 LVYiterx3QjZIiSQ4l+lH5wTKE355oGm/+FswMC4USdlgpFOoulsGHud79njp+uaO0Pb2Q6Fe
 ZL5oNFAKbg+6MmL94cZoWcqY0JzVYs8Ry3fUirXFsTFb6dELBo3Tj5z0/yp5I72DM8F22ndzJ
 RtF4MxeWqcjm5Bfoa8+vndDkOKLMw+uA+iKwiBuRBYZEnWlqE2QFLbW62J83trX+RlPTYHD5n
 sEuS3IcJwDJZ7fcr5Ngyiji0E7ouUawbZvTWCGB1/+8p+NpAglzVmIHfZIFJ4P4i1Ld1c46xo
 6QYJxVk/fsH3YGGNpKnoQJXqJuBcMY/rLoy0qHFsG7bLQwtvJptY5Q0oQuCjppr3Mfp2yIgx8
 vt9U6iGFAh5iHSjpf+rnPusH6yI/v4tlvnaLZlmvEtHNPKjy6BSGJ3A01iPaSZltvSnGYzfMG
 25vWQzO+YHrv1QMHUWs28lGFs5jlRHUkidXMl+Qy+EJO4c0zw2in3PLzEIuFIoqA51MFWV56O
 m8+htyzUiDEH/1ZIGSTQiNf0oy8NDHgLORYiDgxiTAKz62Xqi9UURnC44Kn1Ek/K4Q8/+jxpF
 yzEKp8B+lTA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/24 =E4=B8=8B=E5=8D=888:52, Nikolay Borisov wrote:
>
>
> On 24.04.19 =D0=B3. 15:48 =D1=87., Qu Wenruo wrote:
>> Let's dump the leaf content before triggering BUG_ON() so that we can
>> have some clue on what's going wrong.
>> The output of tree locks should help us to debug such problem.
>>
>
> The reason is some sort of in-memory corruption/confusion of the extent
> maps, causing overlapping extents. However so far it hasn't been
> possible to reproduce that on-demand to actually debug it. Filipe
> suspected it has to do with extent mapping merging logic. This only
> occurs when working with the log tree which takes its data from the
> in-memory extent mapping tree.

Anyway, this won't hurt. right?

If it gives us some clue, that's the best case.
If not, it won't make the current situation worse, right?

Thanks,
Qu
