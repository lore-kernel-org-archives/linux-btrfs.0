Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25367C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 08:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2BF020868
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 08:46:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2BF020868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbeJLQRX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:17:23 -0400
Received: from mout.gmx.net ([212.227.15.19]:47867 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727524AbeJLQRX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 12:17:23 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MMShK-1gJ6YZ0I3S-008Lok; Fri, 12
 Oct 2018 10:45:54 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MMShK-1gJ6YZ0I3S-008Lok; Fri, 12
 Oct 2018 10:45:54 +0200
Subject: Re: [PATCH v2] btrfs: Deprecate unused super block member,
 log_root_transid
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181012063720.25659-1-wqu@suse.com>
 <9584982b-ac47-1b99-cb6f-7c0c68804b94@suse.com>
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
Message-ID: <1ceba3fb-f84a-7b5d-0fed-f06997806b74@gmx.com>
Date:   Fri, 12 Oct 2018 16:45:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <9584982b-ac47-1b99-cb6f-7c0c68804b94@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:91wcFtaTYAdNp4Bau0Vi8UqMWObvCbreakxntSE3OHtNC/du/Cd
 YFYAjTiVox1lfsNbyyRxTHdLmxt2xAgsdvpHS0NBSycAngSHf5Va+uh/KxOS4T2FenNb8vq
 KdHMTIoAh/XZVhMd9HnPfNXtL7jGceWmrQxjEi3KybKC4+tczzRrCnCrDPlVf3fzoOOKBQA
 Bu+qVgp6naN6MiBhd40Ew==
X-UI-Out-Filterresults: notjunk:1;V01:K0:scd2VTfoesk=:yJiiFauypGmt/UBNCKtzGA
 c9+VSnw+z3PKAiEAjsSNALx1uRGj4zUVBWAa2WRlHCQ7UECw3ELiaHP8/NhPg9oCwyc8li7RL
 Zk8VIHAnFl4xUz/jAkb4GMrZt8Oym4UBKQastIEkC5TMHNZ2yafZ+HCqyHW4KOuA04l81p/ZI
 WL9SO9l8w42GknRyZllWA7dZlfikoUWEpMEpx7gzWbWQo+kEw8btq0Y0y+x4KklczyF4XiVtg
 TFFlprQUwDRb6V4UbIAzlk/h+Tjfm1pN2PUK09xkv773k7IVoulTiskqIv/pG20xeqSEMiiKt
 X+zExQBWy1svZ4as15Nghah0U0O7WQ73HDFu6pYI1I/UDRHRY6VEBabd2rCgaeWmme2oxF8rm
 Ls7zJgFcXdPDQUNVdHHyS0PsLGBeIeMoYxk03FgmAXJQT3YunEItimywy1TSH3+XvLmGQfxlR
 EcNiHtOSuXdpxVDWxYIa5CQcUPqLTJe+CoLdx7jt+6MAnBeAN45BF54rYjdcFiDXmpp0dGJq3
 EfkaSvt+U3RDGnlh9anUbmZdSwmjLZqXFkOWwbKKfDUczMEKvOpkln87OXy/QW4sCDUysQcDz
 dWhBx4YeHqn3qKLKo++Uafx8Y6L+dJTiJNjXBZVAbQswa07hapDCMV7V2EfmVh5tfFFRLge/O
 gG26OfXdccHn06bWsEDUrAnuOul4J0bBIRhjTtHfqjBoKtPVdkdRfWWZS4bqs5clUGwlgIa53
 5fArpyApi7Hd0bqqWMMpPjEDX8+ko2+JtO4GqSyEaGLFFz8JKM7hUGwCyMi5j+UmwVnroEm2D
 Xhag8L4+PLBEHHdtILMyotyudJPKkj6hfz8QMwWFB+rkPu+qRg=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/12 下午2:52, Nikolay Borisov wrote:
> 
> 
> On 12.10.2018 09:37, Qu Wenruo wrote:
>> The member log_root_transid is never used.
>> It's always kept untouched even when updating log tree root.
>>
>> And populating it without introducing new incompat flags could easily
>> cause back-compatibility problems.
>> So just mark it unused.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> changelog:
>> v2:
>>   Remove the redundant comment.
>> ---
>>  fs/btrfs/ctree.h | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 53af9f5253f4..7adf5f4dcda4 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -214,8 +214,7 @@ struct btrfs_super_block {
>>  	__le64 chunk_root;
>>  	__le64 log_root;
>>  
>> -	/* this will help find the new super based on the log root */
>> -	__le64 log_root_transid;
>> +	__le64 __unused_log_root_transid;
> 
> why do you keep insisting on having "log_root_transid" in the name of
> this member? It was never used on-disk so for all intents and purposes
> log_root_transid doesn't mean anything? No need to resend, I'm sure
> David will change it on commit, nut I'm just curious.

We have a similar case, leaf_size.
Although it differs from this case and it's still used, I prefer to have
something showing that we at least planned to use this member.

Just in case one day we tries to use it again.

Thanks,
Qu

> 
> 
>>  	__le64 total_bytes;
>>  	__le64 bytes_used;
>>  	__le64 root_dir_objectid;
>> @@ -2317,8 +2316,6 @@ BTRFS_SETGET_STACK_FUNCS(super_chunk_root_level, struct btrfs_super_block,
>>  			 chunk_root_level, 8);
>>  BTRFS_SETGET_STACK_FUNCS(super_log_root, struct btrfs_super_block,
>>  			 log_root, 64);
>> -BTRFS_SETGET_STACK_FUNCS(super_log_root_transid, struct btrfs_super_block,
>> -			 log_root_transid, 64);
>>  BTRFS_SETGET_STACK_FUNCS(super_log_root_level, struct btrfs_super_block,
>>  			 log_root_level, 8);
>>  BTRFS_SETGET_STACK_FUNCS(super_total_bytes, struct btrfs_super_block,
>>
