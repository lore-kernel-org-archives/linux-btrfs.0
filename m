Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1D3C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 00:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C6562080C
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 00:30:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C6562080C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732067AbeKTK4m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 05:56:42 -0500
Received: from mout.gmx.net ([212.227.17.21]:50097 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728979AbeKTK4m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 05:56:42 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lh7M3-1fcvjP3hwN-00oYmh; Tue, 20
 Nov 2018 01:30:13 +0100
Subject: Re: [PATCH v2] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
To:     Nikolay Borisov <nborisov@suse.com>, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181119094823.27346-1-fdmanana@kernel.org>
 <20181119141536.20748-1-fdmanana@kernel.org>
 <19a37acc-9b6f-7606-7ddd-2119b9bda207@gmx.com>
 <4a3e14e3-4d1a-866a-46fb-857ef9e700cc@suse.com>
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
Message-ID: <b09a3b1c-151e-3c8d-4936-7199907c7713@gmx.com>
Date:   Tue, 20 Nov 2018 08:30:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <4a3e14e3-4d1a-866a-46fb-857ef9e700cc@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:43cS6vLQJyF6yUIOT8PmlM69UKPDnzuQPY3g2MGhLq6a+Rg1U9h
 sScnCZ75qeqbUgDnmiLsWf//YJRUJStujwS65Mv8HYQuD7TkPBB/cO+lSTkwnUYoOHihQmB
 4gajWrxZqUmWBNIgRvnoD/6KyGLa1SP9J7cQZ84IKIp2hJnVipX2x95XLAz8+SX4KkbZqZ/
 afShSC+UQfcnxw3V8oYyw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:MjYwlg8kuuw=:zJtCnNNLtgWPPxzrgLrXxW
 hv41gEjIyA/rqyfcOIrq8xKf6kXSN+wLBWQBDdnVSV+R6NyqZ5fMiA81r4VCTZ4qORtn9kC1X
 tC4LXf1rpof5i4PWSH3LVwKfOxI73UC9RaxpqXznw6RoVsAe/NEaFb2bHVxsBgtFFOQ+Yiqgi
 AdZnhJQ9sARB2KFGFZPRnJB3yo0DFOxQEZ5QEgEdLxVpZcMOLfrTrNd4fr1f6vPRK+29xX+zf
 bjHCAGRadW92y3yLz6cdmXe84DQSIRF8KxQW0JDHLsLVBy1pThyV+FHnMzVrYPbgdMsrL7RoV
 yWRdcwQvEpNybKTl58wzABeP4g3K73mHxXxKzxBNUiNvt9Vfl416rB/PfwpY9oeM5hugUWFrJ
 wQznTSdUOrk0e2p8pfVk5S7z5Pm94uvnnHVV9qxGKXKKsBDh60OUkcBH+MUa6huWMHCb6CMZq
 hq06hzxyR2NZU+4O2wXK35waZtfxn77b9+hMjlTe9UOM+HpiVQrFFPbDiyROPH/EmftCD8sfX
 zsbZoTl0L1CkmRmN25GhFVIa6Tc9LluaRks1e1Ag/wvxOU7SyAkgHeCmkN7cPq+LX3GFjZmu6
 k49Uf8q1SHOt27bxqMU/aaELEs5zQh6T2phgmXF0FJ1UC9yjKgAwVXm0qAUIQ3wafV2JfmHiQ
 KK2CLaFen9wYnPymvN3bqjpFvwg7XAdFjkKWTxaOi+6Jh8LBx0tif6LI8BMcouBtinxzg4jfI
 dIgDb2RlPqviQJIzWNLriNNBekC0YWV7aAVwvlZqzU8jZ5lqqcl9F97dgEsLXb0MFpNoe+oRr
 veaUak6SF94bUqjR4V2UxZ9muUdgN2N+k+1zy4QW88TSGAr85th04h9Qgzo2smyWiJPaC0RDJ
 OH8S8dV/5K1g13xthKIc4vHWalBsbhQvvPc2qHnm+cqkGQwqImp9RDPirkkDTSDhNC1s5MAg9
 J/IALObpW2g==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/19 下午11:36, Nikolay Borisov wrote:
> 
> 
> On 19.11.18 г. 16:48 ч., Qu Wenruo wrote:
>> There may be some qgroup reserved space related problem in such case,
>> but I'm not 100% sure to foresee such problem.
> 
> But why is this a problem - we always queue quota rescan following QUOTA
> enable, that should take care of proper accounting, no?

For reserved data/metadata space, not qgroup numbers.

But it turns out we have already handle such case for data.

So I'm overreacting to this problem.

> 
>>
>>
>> The best way to do this is, commit trans first, and before any other one
>> trying to start transaction, we set the bit.
>> However I can't find such infrastructure now (I still remember we used
>> to have a pending bit to change quota enabled flag, but removed later)
