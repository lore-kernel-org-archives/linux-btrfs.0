Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014F3C282DA
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 09:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3EB1218FE
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 09:18:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="gshJiRa4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfDFJSx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 05:18:53 -0400
Received: from mout.gmx.net ([212.227.17.21]:55941 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbfDFJSx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 05:18:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554542302;
        bh=T5W+IpQoCcEBJvovdY3hOw6ES3pM42Xbk7Nigv5F4ro=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=gshJiRa42mRWWq4j0OJ0TIvWE8WIPVJjoJMXFcxKAiO2cP0QufoWURcbFiIApVJqb
         uHMoWWHXyN0O+bMk1JCmLbqdJqUle2Ez0d6GhpOZFJRbSLmEraCzVVVnbQUjBTICTE
         Q9WeYwvC3Afx1Sc5cMQGLqEKW451Ea+ZLZ4x0M1Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MJXEd-1hBJcU338d-0031Xt; Sat, 06
 Apr 2019 11:18:22 +0200
Subject: Re: [PATCH 1/2] block: Add new BLK_STS_SELFTEST status
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20190406031426.22436-1-wqu@suse.com>
 <8b35c2d5-6707-0898-b978-ab09b748f2cb@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <d959f6d7-ee8b-1441-1484-7d6ba276c122@gmx.com>
Date:   Sat, 6 Apr 2019 17:18:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <8b35c2d5-6707-0898-b978-ab09b748f2cb@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:oyRG6Mzq8LK+rpcvILKzNKHBZ8T76M8rEi7FU1v9dh7klm53OKF
 2l9StMNtlBke44hxfLlLTJ0c0LL7RxJ3R1INuPcoejYEkAZA/w9fgEpTLtffEvXrs6oB5nf
 /AJe0idTqKdIDrNeRUCuAS202rci3kkXTbeGn5zbGhDV9FDmVs+G32D0lslQQC3GWa7S/O9
 GR8KUC4X0RVlDm0PIZ08w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Dv7rqTzstQo=:ZY5aUkayE99oNk7GOVXwbt
 mRtV4i+L+V6KnU0J7DL13kUBCJRD8x1UhCErkrGbcOpkOxdVrJVO9CXZyKG9EL0BHTvRSiT/G
 vNsdqvR8q/Kmlr+l3xUn1w2XkfqkxQOdAgmbHKDYxDhW9gbxXe0kbEL1RSN4eDOk48YJrVxa0
 rwvWZXCC67U2+Quvx71W8DvzAfxxVUiuiaapx9ahtqd02Pq8AYEitXOTQCxwhbRm3FyZm0nfB
 EDWwRi/Qn3Khd6gv9ySIPLoqjN3fiLZMSv7+ORd1UJyxzyGdJYdKBh/ONLpYSYVH7P54azb8f
 QJyuymSGrcIBpegvupAduP/OCMaOL8cw2lDd89ubuvSqumTqTxQ/lW1deQGKmmyRlwys6SEfz
 blhuW6B6Jw1QVy8xWIGaFrI+5nw1WWgJoVr7VLw4j+8m2jWklmIKjk2T+8yghFCkmAJqEq8Ig
 THadbpoP3lmj7OI5KMHMnG+wcsbghUJDvVBjgxiCjF92coQTktrzKQFJEAvcdAN+bAh4lJrNf
 y+ysZB0A5Hge1ThHwh2Kmdn0nsgnmaUFSjuXygUSZTO/+peFUTwSN/Z+3lwq4J8xxb55XfoVY
 F34/birEw6FvKSYW0Pnsn0Pte9unYoEX4llXMTyvDs5/264AmPs1xngLng2GYyLqxetGS3J61
 G9x9pXjPXAGudHXtavfT+fsasOVuN0D2TFHTmXq5tnUwSOhNHWgMwDLSuAA+IMoQPfH1EHOiI
 sJB8RZxNRxoYmSr2A7XqXJYPdO/PDi2KnX9Y7sYbcW7Y3ftUwGAQRFVbeG6VbpufENFoMTNLW
 fRplh4W5dni/zFG7kVKXEws1Ch5WH0mBHfMq1W95qq17UoZnl02cVKKy2HYRalHEy1X1h9fg4
 PQX4DhkFb5U0eDiujzjAhZsumqVcPjsjzPZcD0E5pbtx34CwyqKQw3tPiLKRahY3u8WPfN2VF
 sUnat13hKuQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/6 =E4=B8=8B=E5=8D=884:41, Nikolay Borisov wrote:
>
>
> On 6.04.19 =D0=B3. 6:14 =D1=87., Qu Wenruo wrote:
>> There are a lot of end_io hooks which can do some self test at
>> read/write time.
>>
>> Normally such selftest should return -EUCLEAN to indicate something
>> unexpected.
>>
>> However there is no BLK_STS_* bit for that, this makes every selftest
>> error to be interpreted to EIO, which lowers the severity.
>>
>> This patch will add a new BLK_STS_SELFTEST, to allow the error from
>> endio to be passed to filesystem.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  block/blk-core.c          | 1 +
>>  include/linux/blk_types.h | 3 +++
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 4673ebe42255..66967642a5ef 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -135,6 +135,7 @@ static const struct {
>>  	[BLK_STS_RESOURCE]	=3D { -ENOMEM,	"kernel resource" },
>>  	[BLK_STS_DEV_RESOURCE]	=3D { -EBUSY,	"device resource" },
>>  	[BLK_STS_AGAIN]		=3D { -EAGAIN,	"nonblocking retry" },
>> +	[BLK_STS_SELFTEST]	=3D { -EUCLEAN,	"filesystem selftest" },
>
> SELFTEST is ambiguous, I personally relate it to the selftests that some
> subsystems have. This should be changed to STS_CLEANUP or STS_CORRUPT or
> some such.

Considering my poor naming schemes, what about sticking to EUCLEAN
across all of these?
BLK_STS_UCLEAN	-ECULEAN "Structure needs clean up"

Thanks,
Qu

>
>>
>>  	/* device mapper special case, should not leak out: */
>>  	[BLK_STS_DM_REQUEUE]	=3D { -EREMCHG, "dm internal retry" },
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 791fee35df88..5bba24c3753c 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -63,6 +63,9 @@ typedef u8 __bitwise blk_status_t;
>>   */
>>  #define BLK_STS_DEV_RESOURCE	((__force blk_status_t)13)
>>
>> +/* Filesystem selftest error */
>> +#define BLK_STS_SELFTEST	((__force blk_status_t)14)
>> +
>>  /**
>>   * blk_path_error - returns true if error may be path related
>>   * @error: status the request was completed with
>>
