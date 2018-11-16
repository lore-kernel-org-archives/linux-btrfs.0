Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA80C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 08:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 737B7208A3
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 08:10:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 737B7208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388978AbeKPSVp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:21:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:48152 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbeKPSVo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 13:21:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BFC9FAD56
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 08:10:25 +0000 (UTC)
Subject: Re: [PATCH 5/9] btrfs-progs: Fix Wimplicit-fallthrough warning
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20181116075426.4142-1-wqu@suse.com>
 <20181116075426.4142-6-wqu@suse.com>
 <f95d5ad5-9be6-ef37-bbbf-189a7059c86b@suse.com>
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
Message-ID: <1320e00e-7e1d-17fc-965f-03da221ab215@suse.de>
Date:   Fri, 16 Nov 2018 16:10:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <f95d5ad5-9be6-ef37-bbbf-189a7059c86b@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/16 下午4:04, Nikolay Borisov wrote:
> 
> 
> On 16.11.18 г. 9:54 ч., Qu Wenruo wrote:
>> Although most fallthrough case is pretty obvious, we still need to teach
>> the dumb compiler that it's an explicit fallthrough.
>>
>> Also reformat the code to use common indent.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
> Is this attribute dependent on a particular compiler version? Does
> gcc4.4 for example support it?

IIRC unsupported attribute should just be ignored by the compiler, so it
shouldn't cause any problem.

However I'm not 100% perfect sure, as my distribution doesn't provide
older gcc.

Thanks,
Qu

> 
>> ---
>>  utils.c | 30 ++++++++++++++++++++++--------
>>  1 file changed, 22 insertions(+), 8 deletions(-)
>>
>> diff --git a/utils.c b/utils.c
>> index a310300829eb..b274f46fdd9d 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -1134,15 +1134,25 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_size, unsigned unit_mod
>>  	num_divs = 0;
>>  	last_size = size;
>>  	switch (unit_mode & UNITS_MODE_MASK) {
>> -	case UNITS_TBYTES: base *= mult; num_divs++;
>> -	case UNITS_GBYTES: base *= mult; num_divs++;
>> -	case UNITS_MBYTES: base *= mult; num_divs++;
>> -	case UNITS_KBYTES: num_divs++;
>> -			   break;
>> +	case UNITS_TBYTES:
>> +		base *= mult;
>> +		num_divs++;
>> +		__attribute__ ((fallthrough));
>> +	case UNITS_GBYTES:
>> +		base *= mult;
>> +		num_divs++;
>> +		__attribute__ ((fallthrough));
>> +	case UNITS_MBYTES:
>> +		base *= mult;
>> +		num_divs++;
>> +		__attribute__ ((fallthrough));
>> +	case UNITS_KBYTES:
>> +		num_divs++;
>> +		break;
>>  	case UNITS_BYTES:
>> -			   base = 1;
>> -			   num_divs = 0;
>> -			   break;
>> +		base = 1;
>> +		num_divs = 0;
>> +		break;
>>  	default:
>>  		if (negative) {
>>  			s64 ssize = (s64)size;
>> @@ -1907,13 +1917,17 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
>>  	default:
>>  	case 4:
>>  		allowed |= BTRFS_BLOCK_GROUP_RAID10;
>> +		__attribute__ ((fallthrough));
>>  	case 3:
>>  		allowed |= BTRFS_BLOCK_GROUP_RAID6;
>> +		__attribute__ ((fallthrough));
>>  	case 2:
>>  		allowed |= BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
>>  			BTRFS_BLOCK_GROUP_RAID5;
>> +		__attribute__ ((fallthrough));
>>  	case 1:
>>  		allowed |= BTRFS_BLOCK_GROUP_DUP;
>> +		__attribute__ ((fallthrough));
>>  	}
>>  
>>  	if (dev_cnt > 1 && profile & BTRFS_BLOCK_GROUP_DUP) {
>>
