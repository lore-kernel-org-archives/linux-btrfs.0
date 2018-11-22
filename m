Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D405C43610
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 14:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1962A206B2
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 14:13:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1962A206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387905AbeKWAx2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 19:53:28 -0500
Received: from mout.gmx.net ([212.227.15.19]:42319 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732939AbeKWAx2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 19:53:28 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MEnX8-1gEE5l0T7K-00FzrL; Thu, 22
 Nov 2018 15:13:43 +0100
Subject: Re: btrfs-cleaner 100% busy on an idle filesystem with 4.19.3
To:     Roman Mamedov <rm@romanrm.net>,
        Tomasz Chmielewski <tch@virtall.com>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <ca2de2a36290496ccf41b6ed23c799d8@virtall.com>
 <f9e07d50-be2e-36fb-8953-2419200522f0@suse.com>
 <0df02574bdf0fb676cee7b5a3d1890e3@virtall.com>
 <20181122190307.45b10248@natsu>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <bc6a5f96-c971-b1a2-30a4-956deea9aae0@gmx.com>
Date:   Thu, 22 Nov 2018 22:13:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181122190307.45b10248@natsu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:F5cPGPmKiwX/aMEwxyD48NRxfV/DqW5+2FT213wPm/TgG1gyY76
 cS9LCwFjpDTouGTwypOb6zpPvkaBX45XfN8ZJV02E2L1mKaHMFdDLFDFsPqiMk8mjkDcPgv
 GGAnUeKOGAjJKrCWYwTB7KQDJVHaSUhS8PzIXaouoYqAFvY4UebehH9elUzsFYuGTrFQtcz
 /3XHEC/lJWtkqgPdMur/A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:m7pcxhc7dfY=:tH69nK+J5tbnhaqP4QnM37
 7+WxLvW8UD8P0NRbc0W5fn/oyPByjDV6Su6Xt7+5Ut+3TVjYSvtH3MRLnFi9yhxj+oXrmnPs1
 kKVomJd9MuD7bIYbRFZkax3VJ5mzHyTvFgwDQ+Gcx+i92sTnuqrXRWGLWIN/VDhRhFP0oQSRY
 dg7DJVF20nmyzUKmkP37/CxKsaqABT9W4dJQRmw6XBq2MmEO2qeEf2lDNv+TqQfjbt1RJkaFQ
 wP5lMrFTYkFFEyZKneikdbPfbcRF+JOjdeBlJdVx2VkJGpczWYAW++7Zjmr+qWXhRyosZw2A2
 NY2MWq/M0MP/9t6Xe59V6y5q3Gi71DdK8Dh289GoTq7/w/K/n37vNTYFDEfHsfm0kZgDuzG+o
 3FRf5iMko2jmhoUJkfdFtS53xFPHj5MzRrq+MQX/+1GqIpj7oLp2AoxP+RLex4yl73mSv+3LR
 cWQOAZl48so2tGB13cAYV/S/uhy8KlTz8WaU8vJVfrtfkKT4eVyr6dSoENry0ZcvLgHUiXTdO
 29sqdPkG0M7Xr8mSXH46eODDJ/y/gQsOtJ/S7SXLTsUGpYjWLLxSbZzymdxin0yyoc+E4w40L
 NOexwfafWowCg/omq9romcxoCWAmIYBw9IWW03pT6QQ+3egm4WvHnq7X+2gcJ1AYv+0Z7Gvq5
 YVXs4mE/gabGUYqYpGFHVmBuSO9K600qccKcwFLwY+eOo8bKzeJvpe7oRSq+F6H4EW3dBvnZk
 fGRJ3SP6iHJhCxga3cbRjgCmOFycuwIWOpkrVtNohE/1SyIYZCm6EjiILelvjc8vQQXMAClpx
 3dp0TEraNVTsd6471rdEKo4XzoCr5JKGEyY9l2L4ElcnBMoadSGiEp2kzOni2klwe+ZlrJJfq
 vOoewOpiOL48ZAOD0ELLZVvq04lB+O+50+5oYUaxvHBQaDhximdTFJMEOTzoEU
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/22 下午10:03, Roman Mamedov wrote:
> On Thu, 22 Nov 2018 22:07:25 +0900
> Tomasz Chmielewski <tch@virtall.com> wrote:
> 
>> Spot on!
>>
>> Removed "discard" from fstab and added "ssd", rebooted - no more 
>> btrfs-cleaner running.
> 
> Recently there has been a bugfix for TRIM in Btrfs:
>   
>   btrfs: Ensure btrfs_trim_fs can trim the whole fs
>   https://patchwork.kernel.org/patch/10579539/
> 
> Perhaps your upgraded kernel is the first one to contain it, and for the first
> time you're seeing TRIM to actually *work*, with the actual performance impact
> of it on a large fragmented FS, instead of a few contiguous unallocated areas.
> 
That only affects btrfs_trim_fs(), and you can see it's only called from
ioctl interface, so it's definitely not the case.

Thanks,
Qu
