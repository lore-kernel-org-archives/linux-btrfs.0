Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC93C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 10:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA944206BB
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 10:08:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA944206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbeKMUF3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 15:05:29 -0500
Received: from mout.gmx.net ([212.227.15.18]:49567 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731448AbeKMUF3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 15:05:29 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MX1dc-1g1fKN2l7M-00VxfZ; Tue, 13
 Nov 2018 11:08:00 +0100
Subject: Re: [PATCH] btrfs: qgroups: Prepare to deprecate
 BTRFS_QGROUP_LIMIT_RSV_RFER/EXCL flags
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181113060909.27605-1-wqu@suse.com>
 <5123074e-c78d-5324-c6be-91a5a25d4426@suse.com>
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
Message-ID: <db7371db-a893-1ab7-8b97-359aa78da715@gmx.com>
Date:   Tue, 13 Nov 2018 18:07:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <5123074e-c78d-5324-c6be-91a5a25d4426@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:gm4qTVmLRZYqkOunFNcVeEomrL/xO37NtuZwRPvuc2IeR+MmKu4
 N/SMRvQ6fioue+1pbprp1L5iIEMInRNxsGkJvBpugG+iENFgOVs6w8gAi28OSj5FtmnrYh+
 Qluywd2xX8gVxzdoBsTGAIXTB15cSdj07Sgx6XXlNFaADGTTLdjsSKUZxqQsqo3ATOypcHP
 kqSUl7to5zQstMUlzEwaw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:sMpv53j9Vco=:4Lbw703ni+atWDf6DWYnGm
 1k/UiQooJVpl0cIpD+Chmt2f7TGLhTfElIOxDurdPusz8WFfJT7QGj6d63So/0dl8wEeLD/DY
 2VXf1nyKhLHuEGFlLQ9T8dObW+wMDQXNkTl7s4E/IH02yTM4Rdwikqc5s7URpgP+V4+kW/8XI
 2R6AYB4qe1Q4YcGAUpMrErGWuHlb5AjQglNM2gP8V32qbH3y9IFnbRsYhTfhH/MTFDLic5xrr
 4z8xbdcvN4E/kXJCeX827NJj+Ajcqs+Eb+WyVSmqOJY9Wj59nxxgckeWh7mCfI+BQCM3QRuJK
 LySudOyZRc0scpPicUU48aCLdrMMtYoOqJiiIVlO1BPk8goXqwr3tg/O4jSgjc45B6UNf77gT
 wsfAvOxDHMRLoW4Ylq3AQfFTj/VOJdrxz1J15L1hhlqH9UTuDIkM19GMHg/B1Zhkwzf6j9Ps9
 grtGSFo+jbg5KYHibg1dktu7kehDWI9XQDjmKm02MAzNSe34i2lyyy6SkwT86/JyqrD48wK/4
 P8AiSyFKrUehfFYuNglj6yMlzffEAvRtYGqCsqvdcUw3ADfmsYNDzaabHTh81clxxkDZ8pUfz
 ja6RiytOuey1CSwEuXbfMa5/bl0YT4Y3xWxgV32yJyRX2XipWpNd0Y88tR3A29DIGxKK1APHd
 Qz+snUnl92ZWaoX7K3EVXZJtuAz+xcSv8dq03C62aZxeGlBL+YZslsTKx0zO78sTlbhSSjoW6
 n+v0sVqhNRahbfhlbKWSIiDttHZ14+y+dwEMOFNim8QIdKlSZI3C1MMeMNNLhUdF8PfXoN5CW
 3BKUEq8itEt5gpk2+kzHZ7gm9+PimtCMeewLFnZtk+l3n7m10mC9kJINu+J91xFEszgCc0Cas
 O1Nd8xbhHuKVEZpPG2f2HBG3obNy/wJxIPw270YFglQhmwc7E1z1d3nmREXr5z9ttNuNkPE/q
 gQVctjf/XQQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/13 下午5:48, Nikolay Borisov wrote:
> 
> 
> On 13.11.18 г. 8:09 ч., Qu Wenruo wrote:
>> These two flags are only used to set btrfs_qgroup::rsv_rfer/excl number,
>> but then are never used.
>>
>> Nor these flags are really used by btrfs-progs, so it's pretty safe just
>> to deprecate them in next kernel release.
>>
>> This patch will mark these two flags deprecated and output warning
>> messages, but still handle them.
>>
>> These two flags will be completely removed in next kernel release.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/qgroup.c          | 16 ++++++++++------
>>  include/uapi/linux/btrfs.h | 12 ++++++------
>>  2 files changed, 16 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 9afad8c14220..d4a52dbad044 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1385,21 +1385,25 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
>>  			qgroup->max_excl = limit->max_excl;
>>  		}
>>  	}
>> -	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_RFER) {
>> +	if (limit->flags & __BTRFS_QGROUP_LIMIT_RSV_RFER) {
>>  		if (limit->rsv_rfer == CLEAR_VALUE) {
>> -			qgroup->lim_flags &= ~BTRFS_QGROUP_LIMIT_RSV_RFER;
>> -			limit->flags &= ~BTRFS_QGROUP_LIMIT_RSV_RFER;
>> +			qgroup->lim_flags &= ~__BTRFS_QGROUP_LIMIT_RSV_RFER;
>> +			limit->flags &= ~__BTRFS_QGROUP_LIMIT_RSV_RFER;
>>  			qgroup->rsv_rfer = 0;
>>  		} else {
>> +			btrfs_warn_rl(fs_info,
>> +"BTRFS_QGROUP_LIMIT_RSV_RFER flag is deprecated, will not be supported in v5.1");
>>  			qgroup->rsv_rfer = limit->rsv_rfer;
>>  		}
>>  	}
>> -	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_EXCL) {
>> +	if (limit->flags & __BTRFS_QGROUP_LIMIT_RSV_EXCL) {
>>  		if (limit->rsv_excl == CLEAR_VALUE) {
>> -			qgroup->lim_flags &= ~BTRFS_QGROUP_LIMIT_RSV_EXCL;
>> -			limit->flags &= ~BTRFS_QGROUP_LIMIT_RSV_EXCL;
>> +			qgroup->lim_flags &= ~__BTRFS_QGROUP_LIMIT_RSV_EXCL;
>> +			limit->flags &= ~__BTRFS_QGROUP_LIMIT_RSV_EXCL;
>>  			qgroup->rsv_excl = 0;
>>  		} else {
>> +			btrfs_warn_rl(fs_info,
>> +"BTRFS_QGROUP_LIMIT_RSV_EXCL flag is deprecated, will not be supported in v5.1");
>>  			qgroup->rsv_excl = limit->rsv_excl;
>>  		}
>>  	}
>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>> index db4c253f8011..ec79ab781ee0 100644
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -53,12 +53,12 @@ struct btrfs_ioctl_vol_args {
>>   * struct btrfs_qgroup_limit.flags
>>   * struct btrfs_qgroup_limit_item.flags
>>   */
>> -#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0)
>> -#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1)
>> -#define BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2)
>> -#define BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3)
>> -#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4)
>> -#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5)
>> +#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0) /* reference (rfer) limit */
>> +#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1) /* exclusive (excl) limit */
>> +#define __BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2) /* deprecated */
>> +#define __BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3) /* deprecated */
> 
> We gain absolutely nothing by prepending the __, drop it. What's
> sufficient for this patch is to introduce only the warnings, nothing else.

IMHO, there are 2 problems if we don't rename it:

1) Later user can still use it without checking the header.
   This is particularly common for anyone using completion tool, like
   ctags or clang completion.
   For these case, without checking the header careless user won't
   really know these flags are deprecated.

2) To show that there are really no existing users of these 2 flags
   It's much more clearly shown in the patch, than without modifying it.

3) To let us know whether there is any real user of these flags
   After such renaming, if we really have some users of these flags,
   they will mostly come and complain to the mail list.
   Such noise would help us to know the usage (if there is any).

So, I still prefer to rename them.
This also applies to user space counter part.

Thanks,
Qu

> 
>> +#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4) /* compressed rfer limit */
>> +#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5) /* compressed excl limit */
>>  
>>  struct btrfs_qgroup_limit {
>>  	__u64	flags;
>>
