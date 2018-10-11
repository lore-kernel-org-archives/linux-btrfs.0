Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E79C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 13:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEB3820841
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 13:13:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEB3820841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbeJKUk2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 16:40:28 -0400
Received: from mout.gmx.net ([212.227.17.21]:37191 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbeJKUk1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 16:40:27 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MM0bQ-1g2tfx42DE-007ja0; Thu, 11
 Oct 2018 15:13:15 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MM0bQ-1g2tfx42DE-007ja0; Thu, 11
 Oct 2018 15:13:15 +0200
Subject: Re: [PATCH 1/2] btrfs: Populate btrfs_super_block::log_root_transid
To:     Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181004054950.11651-1-wqu@suse.com>
 <20181004054950.11651-2-wqu@suse.com> <20181011123151.GP29418@twin.jikos.cz>
 <ba395b06-ff1a-1926-5339-3a2927e3af0f@gmx.com>
 <2971327e-aa24-534c-cbfb-3ba9f399c6f2@suse.com>
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
Message-ID: <5edcb70a-a9c7-dc06-7a09-fd287e315612@gmx.com>
Date:   Thu, 11 Oct 2018 21:13:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <2971327e-aa24-534c-cbfb-3ba9f399c6f2@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:FYRjQrccSA92+lhz0YU/SwCcaYMT7BRdpVVlDaLeRCxeVGR2Yo5
 Wt5YIprHcPsXS3MOn12oZIoudCelkcVt2xdG9ZFJyBrI6FUDafuT2zHrxRy52G3AaPd2PeI
 enOXUl6Q2IaVyJwVhT9QhgaGnq1Lksc4LDqfUyobL9iszZvT+xu24giW0OjySjqDCVujkaP
 2DAXnIPrwREaq/GNAjt7g==
X-UI-Out-Filterresults: notjunk:1;V01:K0:hBxQZmwRlrA=:xZdH9VbpL82H32xAHslhbr
 ME/UOPRIeVGxyGKfE+1kpiRHQMhsTitAt5EXlgkft5dUjeBgi1cIxwMbj/MX2tKXnE+tV1enI
 /P8huUJh9ZZOhT2ucqpwYd3TA+UV4gssadA6D91G8kHzhYI9qQhytjKDd3ZdvBe3GLenQETqH
 M2GebIIC0Zmvrbyf418JFrwY2cSeqjMK11dFoZnzgPJRJW+IDtAfBphvFKP8W6Z1ue3RV5+E+
 v3I4Uj7LPt16wCk01EWHEqFuOZAZl81V9DBSaj70ODELB4NooSV7ZCNK1r5vZhH8ufnZUgzLx
 miJcjvR3IdKbSpuM+HWCqbnQE4v5KwzwYPayus13XB0DZhpDW7wQOlCmRTrhVr8vaLE06iGFd
 trfrgeg7Pt9TBe12o46t6TAJKhwauzxE4+GTqncJGTFa2tk3Ex7euY8gkC+35ZohlI70XtA92
 z/9xWs3xF9MfKdKhLQszOFO9duMVQZckTf2HGPJsrjL2yyuxEETnapu00ex2GF25GXuX3Lwcz
 64agjakqhPKxlZ9Uz7DHi9tG+/U7R5I0pZqRlfqm7pOYqAx/LpqF6fsHBAOjl/DjzuXSCeOp8
 EFP6FX2wQc+Q3zRU5LHmshE3oafU44j2GGE4TF99Ke3TnXCw0DUbcb8d6NwWn0JMpRZ2ej/F/
 BnOHa2PY9Bln6MMEtOCgUuwxaBXbls78mtY9JPHgj3+IC7J9/BlkuY+dRaiCtXZM/T6yc19Kw
 dvXSxxg6tf9Kle5g9IQ66mgjkpwH+bs3p/9cA4nO7FF2LgHOJ2eT7EXaawCGRa/hO5Y75ByLw
 ZXuFJ5AAQVx1nsTySog6ebqP9fUBWquy92I97zyXCObKIIcAQE=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/11 下午9:11, Nikolay Borisov wrote:
> 
> 
> On 11.10.2018 15:45, Qu Wenruo wrote:
>>
>>
>> On 2018/10/11 下午8:31, David Sterba wrote:
>>> On Thu, Oct 04, 2018 at 01:49:49PM +0800, Qu Wenruo wrote:
>>>> We have btrfs_super_block::log_root_transid to record the transid of log
>>>> tree root.
>>>>
>>>> However it's never populated and it's always 0, just as the following
>>>> dump-super:
>>>>  log_root                30572544
>>>>  log_root_transid        0
>>>>  log_root_level          0
>>>>
>>>> This patch will populate it with log tree root correctly, so the result
>>>> will be:
>>>>  log_root                30572544
>>>>  log_root_transid        6
>>>>  log_root_level          0
>>>>
>>>> This won't affect current kernel behavior or btrfs check result as we
>>>> already expect log tree root generation always to be super block
>>>> genration + 1.
>>>>
>>>> But it could be later used to detect log tree corruption early.
>>>
>>> The backward compatibility seems to be ok in general, I found one
>>> scenario where the check will fail:
>>>
>>> * mount with unpatched kernel, log_root_transid = 0
>>> * mount with patched kernel, log_root_transid 100, generation 101
>>> * mount with unpatched kernel, log_root_transid 100 (unchanged), generation 201
>>> * mount with patched kernel -> check fails
>>
>> Indeed, this is a problem I missed.
>>
>> It provides the old principle, if we're going to change how kernel
>> use/interprete a on-disk memeber, we have to introduce a new
>> incompatible flag.
>>
>> Please just drop the series of patch.
> 
> Since this member really doesn't have any purpose now I think the
> prudent thing to do is to rename it to "reserved1" or "padding" or
> whatever but basically signal that it's no longer in used. In the future
> when a new incompaat bit will be required for some feature it can be
> re-used.

Makes sense.

I'll craft a patch for that.

Thanks,
Qu

> 
>>
>> Thanks,
>> Qu
>>>
>>> So the problem is when log_root_transid is not 0 and changes out of sync
>>> with the generation. The above sequence of kernels can simply happen
>>> when switching between old stable and current releases.
>>>
>>
