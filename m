Return-Path: <SRS0=HXCT=NO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6F3C0044C
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 09:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6890F2081F
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 09:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6890F2081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbeKCS3A (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 14:29:00 -0400
Received: from mout.gmx.net ([212.227.15.18]:36781 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbeKCS3A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Nov 2018 14:29:00 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MexaL-1fuLyA2YG1-00OXoo; Sat, 03
 Nov 2018 10:18:08 +0100
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MexaL-1fuLyA2YG1-00OXoo; Sat, 03
 Nov 2018 10:18:08 +0100
Subject: Re: [PATCH] Change the total_dirty from SZ_256M to SZ_64M.
To:     Nikolay Borisov <nborisov@suse.com>, hmsjwzb <weizhefix@gmail.com>
Cc:     clm@fb.com, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181103083654.655-1-weizhefix@gmail.com>
 <8965ea1d-c29f-7bdf-44cb-874511899567@suse.com>
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
Message-ID: <52fc83c0-4455-0d1b-0fee-42cfdec2580b@gmx.com>
Date:   Sat, 3 Nov 2018 17:17:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <8965ea1d-c29f-7bdf-44cb-874511899567@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:if2LHHLbr5BCDitmjkbaFbYraasI78D6H+uQIp/QsY2FwiZ8uyC
 VMh8Rw0zhnWdf2omoMBUhSozMCG+Fv9Xy46BoLAVCwGyh9XrpEzdrysPj8Jhqx93HorP5sn
 flPuDgRbZ/2oTdIX2OMRc9v0RTaWMpFoVQri1BOM1Z9L7dXH4QcIZ8twLFKkY5Jt1Pr8DT6
 03td4M+zyTWzSwyqwoOUQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:FiAn/elg5XI=:ocpmZaic4N1RkH5X8oDJJA
 KQMSNNCf0PTPv0ZBLhd5X10j4OY3cG2W9L7kY8RoaM6tiZ2DC/tE5yz2JObTPAmEhJ/40XLoE
 gv0GJYGWcQoGKFxWwMxSAqyaJE2f+Ao38+IQ1RgFcWF+g/u7kArzE34i9fYztOPur7Ko7vqYw
 TvVVXh3Ufk6A5+TBsKmqYU9xIByYN2ZkEObq6xxUKpTWvF4K+GQuTbM0XZpmCBJaYlrwNdAm+
 yOHS6MZqfAHM165V7SkFSaNu5EnPnUrXfIl3Re2KAMVgct0WDV2ZcaB/awJy8XPkj+CGQ2M1+
 P8zMhYTLmPbbmdtuXIe8zbhP5Bhv0AfoNd7kAJy30dLz160j933CMvWHWVYZvMMPxE19XT/cg
 3lzwY+J+FnhVW6L2UOlqwoTyIdYwsNgG3O1MkqbsXUKmYJp9oeyr8ONEpun6YW3bg0airMv1Y
 xX92pBWaS70ZSG93YEymTvOCuWonB/7aITqD4wqRQW5q03ZbF++o7j/p+n11atQnAx3b9pODq
 3TT8IdVxP7+LwWLtgW5DQ9I5lgM0o7EN9gI35O5sKNPXPwce7tngbhoL2BkEYDPCrAr+StFbM
 bj4F/dUCH9j+CoRTnUNu5A3x9coSQw2PFtAtDhgnUzmLpHyd4S2sqtvMQmNAzAZomgCbXwUpv
 BADuH0Tqkx12/saJ6OZWh3qg0PzcWiTuhPlOwj9rZQFwk4po9nj9MiKsvDES23N6qWimDNv6l
 ZKTgZ8yFnQKTx7ffkRjcTlnFipPqaz4mjB/We+KS6hFfiJt6S+5gUIkSAwFQEHeOJXT8LrUfo
 Eps85UGaQiaYNZsXL9Ydp1r7MVroHmsPj3VX1L+k16go5Q/dE3AaL44YtM7p3o1YgDwheqtKc
 8a+UsxEC2RfKTiq2WhmFGtnF2tsYXUd/EPHpERG1kv8PJ99uW5G6tRB/7Is5y3+TUh5kwxkGA
 v5fZCw5SKfQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/3 下午5:01, Nikolay Borisov wrote:
> 
> 
> On 3.11.18 г. 10:36 ч., hmsjwzb wrote:
>> The SZ_256M will cause trouble in platform with less than 256M memory.
>> For example, a qemu virtual machine.
>>
>> Signed-off-by: hmsjwzb <weizhefix@gmail.com>
> 
> If you have actually taken the care to understand the code in
> test_find_delalloc you would have seen that total_dirty and max_bytes
> are actually inter-dependent so you cannot really change total_bytes
> without adjusting max_bytes as well. Otherwise tests will start breaking.

Nowadays even for VM, the memory size should start from 2G.
If this 256M is causing problem, one should really re-consider the
memory size of the VM.

Not to mention the magic number is two ensure we have at least 2 file
extents.

> 
> NACK on this (and likely any future postings of this) since the tests
> are sized in a such a way so as to test design limits (such as the max
> extent size which is 128MB)

And we should add some comment about this.

Personally I prefer some comment with this and also use (2 *
BTRFS_MAX_EXTENT_SIZE) other than this intermediate number.

Thanks,
Qu

> 
> 
>> ---
>>  fs/btrfs/tests/extent-io-tests.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
>> index 9e0f4a01be14..cb23dce96a2d 100644
>> --- a/fs/btrfs/tests/extent-io-tests.c
>> +++ b/fs/btrfs/tests/extent-io-tests.c
>> @@ -62,7 +62,7 @@ static int test_find_delalloc(u32 sectorsize)
>>  	struct page *page;
>>  	struct page *locked_page = NULL;
>>  	unsigned long index = 0;
>> -	u64 total_dirty = SZ_256M;
>> +	u64 total_dirty = SZ_64M;
>>  	u64 max_bytes = SZ_128M;
>>  	u64 start, end, test_start;
>>  	u64 found;
>>
