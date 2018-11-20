Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D69C43610
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 09:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54FCC206BB
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 09:17:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54FCC206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbeKTTpM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 14:45:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:33684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726479AbeKTTpM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 14:45:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 221FDAF13
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 09:17:05 +0000 (UTC)
Subject: Re: [PATCH] btrfs: qgroup: Skip delayed data ref for reloc trees
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20181120084636.31346-1-wqu@suse.com>
 <970d0031-00ec-eb37-7245-f682f4f10569@suse.com>
 <f8bf0702-973c-eec5-ccfc-f68e2cd7aa05@suse.de>
 <d14476a9-723c-8420-8973-e33978c80191@suse.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
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
Message-ID: <9b4de2a9-77a0-7425-e6b5-3486d6c68b36@suse.de>
Date:   Tue, 20 Nov 2018 17:17:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <d14476a9-723c-8420-8973-e33978c80191@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/20 下午5:11, Nikolay Borisov wrote:
> 
> 
> On 20.11.18 г. 11:07 ч., Qu Wenruo wrote:
>>
>>
>> On 2018/11/20 下午4:51, Nikolay Borisov wrote:
> <snip>
>>> I'm beginning to wonder, should we document
>>> btrfs_add_delayed_data_ref/btrfs_add_tree_ref arguments separate for
>>> each function, or should only the differences be documented - in this
>>> case the newly added root parameter. The rest of the arguments are being
>>> documented at init_delayed_ref_common.
>>
>> You won't be happy with my later plan, it will add new parameter for
>> btrfs_add_delayed_tree_ref(), and it may not be @root, but some bool.
> 
> You are right, but I'm starting to think that the interface of adding
> those references is wrong because we shouldn't really need adding more
> and more arguments. All of this feels like piling hack on top of hack
> for some legacy infrastructure which no one bothers fixing from a
> high-level.

Can't agree any more!

But the problem is, such big change on the low level delayed-ref
infrastructure could easily cause new bugs, thus there isn't much
driving force to change it.

I'm considering to change the longer and longer parameter list into a
structure as the first step to do cleanup.
(By the nature of structure and union, some parameters can easily be
merged into an union, makes the parameter structure easier to read)

Feel free if you have any better suggestion.
(I also hate the current btrfs_inc_extent_ref() and btrfs_inc_ref()
interfaces, but I don't have enough confidence to change them right now)

Thanks,
Qu

> 
> 
>>
>> So I think we may need to document at least the difference.
>>
>> Thanks,
>> Qu
>>
>>>
> <snip>
> 
