Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E80AEC65BA7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 09:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACDB320875
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 09:18:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACDB320875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbeJEQQA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 12:16:00 -0400
Received: from mout.gmx.net ([212.227.17.22]:35901 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbeJEQQA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 12:16:00 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MEFqW-1fxKhV0Zdw-00FPG2; Fri, 05
 Oct 2018 11:18:02 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MEFqW-1fxKhV0Zdw-00FPG2; Fri, 05
 Oct 2018 11:18:02 +0200
Subject: Re: [PATCH 2/2] btrfs: volumes: Make sure no dev extent is beyond
 device boundary
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181005082525.22441-1-wqu@suse.com>
 <20181005082525.22441-3-wqu@suse.com>
 <2b2c24d4-9682-039b-b2f0-1fb0aa87f2ab@suse.com>
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
Message-ID: <152772c2-fb02-7840-d091-59710173ff82@gmx.com>
Date:   Fri, 5 Oct 2018 17:17:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <2b2c24d4-9682-039b-b2f0-1fb0aa87f2ab@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:b/n9QB/gzoEjkE6/JD212xMeiJu1EEhiSBESEJH1RyAY7kjTRxk
 +s0kjlkIwRZdpYFiwBQRKbPtnthwODM9MiOHr91HghYvk/hRko7saFvGyCr9nYwRWDDG8XA
 ZV5VRu1DXHTfRfYOiFR9kRH0LwlHS7kdSW0f94XtzVka5V5PIgOaolh5psNcDGj7ZL1JBSB
 L0pjJYJkW7Gv1Zv6tCuaA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:rYiqFA6PCG0=:nT2t2SqxUbwZr34/XcNL6W
 SdxbIPe8x4sZxEZ1veCihIeNebCUM3N7fI1roOB3bq6hgQl2Gp8mnhyDMTvahAPJvxoAPGGVT
 1JZF7SVHEGOeuwuvul9mo92NihMzxBNGLjJ5J9DMb58cLkSufzcXjY6h/8I3xkzEvvtP+mWH8
 mCpiKkGYcVz5D4cnPYG9007gapJv2ZHvACzFhrMxeCnyA3RBSnWopeHoshWK/gMfLwA/7Hqkz
 HVU3z4UCJATmLjgS1hkUWPJVn3hGizDMaT2JiBTNqU9egmM4soc1cEXOVVyqzgNRS+L3HMWWh
 8Jcdi1oOt3Mrxab1agqsyHmsaiv3ymzuZhQGQaDDusBwtElk4aSqRgahEHMNmEE0QO3fWe/Yd
 536GOw+1PM/MZR+wk6J5Op9p7FCR6DAMZcSS3U7hQGMa7kG8OM9EWhjgKly4twIcb4/LSkTrs
 amRkkwBhrSYpwHKldgg0QTl0IbcZIrPJA1spFL/v9hBCb6ZYdT/yamJh+70i20bkEMboUCXUt
 tAWlyLBofmdErLzROaJhDA/QJ/VSw7c/TqxFABn/RyOe1uWuweNw9YCewUoWMir65ZvZd9ogs
 LvrqEIJeSFu9xDXXxqqbcw9kLO6Ev0kH1xgbm++T3Tr/pMs7mgdKj8VoZoK7Jfxoi0n77wMqV
 Zd81CLAOo5OrXADUfjEYc4Ln+3V8B9Rry0BGdHBzWiGgUJ1w3RbgLNXu2XDSXLd8942wIsQKW
 hqeE+aVvFgQA1Apl5Uq3pSKWL40eUCvzinNaqfQdJFNP8drZMKF5dJo0RAjU/eE3CPd8b2zYz
 fRjQSqLlMQDcO1ieGzsol2EwuC3rlFPKZqXd4YlufYsejfMoVw=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/5 下午4:55, Nikolay Borisov wrote:
> 
> 
> On  5.10.2018 11:25, Qu Wenruo wrote:
>> Add extra dev extent end check against device boundary.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/volumes.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index bf0b2c16847a..9fb40e30be6a 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -7492,6 +7492,7 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
>>  	while (1) {
>>  		struct extent_buffer *leaf = path->nodes[0];
>>  		struct btrfs_dev_extent *dext;
>> +		struct btrfs_device *dev;
>>  		int slot = path->slots[0];
>>  		u64 chunk_offset;
>>  		u64 physical_offset;
>> @@ -7517,6 +7518,22 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
>>  			goto out;
>>  		}
>>  
>> +		/* Make sure no dev extent is beyond device bondary */
>> +		dev = btrfs_find_device(fs_info, devid, NULL, NULL);
>> +		if (!dev) {
>> +			btrfs_err(fs_info, "failed to find devid %llu", devid);
>> +			ret = -EUCLEAN;
>> +			goto out;
>> +		}
>> +		if (physical_offset + physical_len > dev->disk_total_bytes) {
>> +			btrfs_err(fs_info,
>> +"dev extent devid %llu physical offset %llu len %llu is beyond device boundary %llu",
>> +				  devid, physical_offset, physical_len,
>> +				  dev->disk_total_bytes);
>> +			ret = -EUCLEAN;
>> +			goto out;
>> +		}
> 
> Why not move this code in verify_one_dev_extent, you already have all
> the necessary context in there - devid and physical_len/physical_offset,
> let's avoid scattering logically related code in different places. ?

Right, this part could be moved into verify_one_dev_extent().

It will go that way in next update.

Thanks,
Qu

> 
>> +
>>  		ret = verify_one_dev_extent(fs_info, chunk_offset, devid,
>>  					    physical_offset, physical_len);
>>  		if (ret < 0)
>>
