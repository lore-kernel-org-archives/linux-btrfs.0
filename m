Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E69C64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 07:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ACCF2098A
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 07:30:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9ACCF2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbeJDOWW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 10:22:22 -0400
Received: from mout.gmx.net ([212.227.17.21]:46311 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727204AbeJDOWW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Oct 2018 10:22:22 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MbbWD-1gO7vU3HwD-00J3Om; Thu, 04
 Oct 2018 09:30:22 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MbbWD-1gO7vU3HwD-00J3Om; Thu, 04
 Oct 2018 09:30:22 +0200
Subject: Re: [PATCH 2/2] btrfs: Validate btrfs_super_block::log_root_transid
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181004054950.11651-1-wqu@suse.com>
 <20181004054950.11651-3-wqu@suse.com>
 <29849d48-501f-fd2c-3225-eba07fc0915e@suse.com>
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
Message-ID: <d395776e-3a2f-22bb-b8cf-d7422e3a8c98@gmx.com>
Date:   Thu, 4 Oct 2018 15:30:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <29849d48-501f-fd2c-3225-eba07fc0915e@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:6k1RH8HzpnOXpJzCYIGKfAqmtCNCB6UUuPKBn++T3jLCJLHb83+
 FWVFYCGxTXou2rOm0YQidwlBHepCTFtM9YxXadfubesSJo38WUZc6r0LoS8apRYr29ZryrT
 FZ+gRkVr+Jxqof/xfCnd4Tvogo4/vbVDPvvmd8SahdO9bDepetiVkE4uzmIQS0n2foww3cy
 /IEkmjhdWrGM4O4HHlz+Q==
X-UI-Out-Filterresults: notjunk:1;V01:K0:3+0MKpxB38M=:leEPVJqiHMmHed6PzY9jVb
 sL23VN31wChDhR4jkBVdJioWwJBSre6RO8IQYavGfpT3g3zbKciQRLdcvqmP+9J6e/axgny+x
 pAIFCe2F60mx00AxorCvy4XA8Pc4M+TfTYSSoaBZvqsaxNXEpxSmWP0C03oOTkeiXaPRTAwlt
 wyHaa3h7Qv6BO2RmON2STR2Ing53iXtlzQJ/w/E9LlAoo+qjsX0l8GtjE22NYu+FTDpOWVmdf
 2mXxzohL6fxBJxHtsf0wfganjvgW3VYH803laQbiOwq4GvXQODOWB85DU5vPsRYTw9yPBALxr
 Hd8nlrPx/T1Psa87gMkD7k2TEM8uz3GBInb4VRJ7ctGSIsmUP46CIng8H9OBP7dQ/oFlJwD4Q
 GoILbKrK3TM1TmkJ28+md13WpYxtRiQSgGJB2UBwJdpjdoZoidQq3XMfPOdq8wEzA9zVcmZy5
 QcsjUFQw9qra6oMq6Y2k3odcnlEz/KCWAeC7lZsBVjSrQB5bIyTgLhu8UWOdsYPNPJ9Tqa+9D
 5smwywZUW7GOcMF0izeDSOnDL07Idpue6qSKPpZZmbH5yF8XXT3Yt3D9B0gdc2FeWibVL1Ait
 6OUl9Rwet4AN5Wh08oT62VpHv8da4T5UvJ+vVXzRr0qH8wsDH3aS1PY1tUgnupDZBIn3e7TM9
 /EOdJX6nTgr+ksZEoVQnwLrVnd6EMSR4SGnmJMUAnK1UkOsdTlFA34th8TOQcm2eHZ3CAOjZ6
 h9D9HHaWgd2HWkh06z9f5hi1G0W75sTFkQv13bZ5Vhz8svYhnAJMdhy8mRk/bFUz/TPrEI4dt
 XY6cW3426HALdxZXEgMCoUtDT+7TU77VqjrO4xmJoc4Fn8jmyU=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/4 下午2:57, Nikolay Borisov wrote:
> 
> 
> On  4.10.2018 08:49, Qu Wenruo wrote:
>> So we can detect log root related problem early and report the error
>> more meaningfully other than hitting it log root read time.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/disk-io.c | 28 ++++++++++++++++++++++------
>>  1 file changed, 22 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 5124c15705ce..34c68401c6bc 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2408,6 +2408,7 @@ static int validate_super(struct btrfs_fs_info *fs_info,
>>  {
>>  	u64 nodesize = btrfs_super_nodesize(sb);
>>  	u64 sectorsize = btrfs_super_sectorsize(sb);
>> +	u64 generation;
>>  	int ret = 0;
>>  
>>  	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
>> @@ -2534,21 +2535,36 @@ static int validate_super(struct btrfs_fs_info *fs_info,
>>  		ret = -EINVAL;
>>  	}
>>  
>> +	generation = btrfs_super_generation(sb);
>>  	/*
>>  	 * The generation is a global counter, we'll trust it more than the others
>>  	 * but it's still possible that it's the one that's wrong.
>>  	 */
>> -	if (btrfs_super_generation(sb) < btrfs_super_chunk_root_generation(sb))
>> +	if (generation < btrfs_super_chunk_root_generation(sb))
>>  		btrfs_warn(fs_info,
>>  			"suspicious: generation < chunk_root_generation: %llu < %llu",
>> -			btrfs_super_generation(sb),
>> -			btrfs_super_chunk_root_generation(sb));
>> -	if (btrfs_super_generation(sb) < btrfs_super_cache_generation(sb)
>> +			generation, btrfs_super_chunk_root_generation(sb));
>> +	if (generation < btrfs_super_cache_generation(sb)
>>  	    && btrfs_super_cache_generation(sb) != (u64)-1)
>>  		btrfs_warn(fs_info,
>>  			"suspicious: generation < cache_generation: %llu < %llu",
>> -			btrfs_super_generation(sb),
>> -			btrfs_super_cache_generation(sb));
>> +			generation, btrfs_super_cache_generation(sb));
>> +
>> +	/*
>> +	 * Check log root transid against super block generation.
>> +	 *
>> +	 * Older kernel doesn't populate log_root_transid, only need to check
>> +	 * it when it's not zero.
>> +	 * Since replaying suspicious log tree can cause serious problem, refuse
>> +	 * to mount if it doesn't match.
>> +	 */
>> +	if (btrfs_super_log_root_transid(sb) &&
>> +	    btrfs_super_log_root_transid(sb) != generation + 1) {
> 
> nit: in the same vein as you do for btrfs_super_generation just assign
> super_log_root_Transid to a local var and use that. IMO it's more
> consistent with what's happening in this function.

@generation is used for more than one location (chunk generation and
cache generation), while log root transid (along with chunk generation
and cache generation) isn't used more than twice.

Thus I only assign generation to @generation.

Thanks,
Qu

> 
>> +		btrfs_err(fs_info,
>> +	"bad log tree, log_root_transid != generation + 1: %llu != %llu + 1",
>> +			  btrfs_super_log_root_transid(sb), generation);
>> +		ret = -EINVAL;
>> +	}
>>  
>>  	return ret;
>>  }
>>
