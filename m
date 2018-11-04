Return-Path: <SRS0=b0aI=NP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2903FC0044C
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 00:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F09AB2081F
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 00:39:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F09AB2081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbeKDJvb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 4 Nov 2018 04:51:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:44974 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728545AbeKDJva (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 4 Nov 2018 04:51:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 822CCAF71;
        Sun,  4 Nov 2018 00:38:31 +0000 (UTC)
Subject: Re: [PATCH] btrfs: avoid link error with CONFIG_NO_AUTO_INLINE
To:     Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        David Sterba <DSterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>
Cc:     Gu Jinxiang <gujx@cn.fujitsu.com>,
        Changbin Du <changbin.du@gmail.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181103153941.1881966-1-arnd@arndb.de>
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
Message-ID: <87d4e8ce-2142-9d6e-498a-c7e5b83964eb@suse.de>
Date:   Sun, 4 Nov 2018 08:38:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181103153941.1881966-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/3 下午11:39, Arnd Bergmann wrote:
> On 32-bit ARM with gcc-8, I see a link error with the addition of the
> CONFIG_NO_AUTO_INLINE option:
> 
> fs/btrfs/super.o: In function `btrfs_statfs':
> super.c:(.text+0x67b8): undefined reference to `__aeabi_uldivmod'
> super.c:(.text+0x67fc): undefined reference to `__aeabi_uldivmod'
> super.c:(.text+0x6858): undefined reference to `__aeabi_uldivmod'
> super.c:(.text+0x6920): undefined reference to `__aeabi_uldivmod'
> super.c:(.text+0x693c): undefined reference to `__aeabi_uldivmod'
> fs/btrfs/super.o:super.c:(.text+0x6958): more undefined references to `__aeabi_uldivmod' follow
> 
> So far this is the only file that shows the behavior, so I'd propose
> to just work around it by marking the functions as 'static inline'
> that normally get inlined here.

As a workaround it looks OK, but it's definitely not the root cause.

> 
> The reference to __aeabi_uldivmod comes from a div_u64() which has an
> optimization for a constant division that uses a straight '/' operator
> when the result should be known to the compiler. My interpretation is
> that as we turn off inlining, gcc still expects the result to be constant
> but fails to use that constant value.

It looks more like a bug in div_u64() optimization.

Despite this file in btrfs, did you hit the same problem for any other file?

> 
> Cc: Changbin Du <changbin.du@gmail.com>
> Fixes: 943b8435c3bd ("kernel hacking: add a config option to disable compiler auto-inlining")

I can't find it in the mainline kernel, is the commit hash correct?
If not merged, we should still has a chance to further polish that patch.

Thanks,
Qu

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/btrfs/super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index c3c1e7bee49d..b7af0b8936ad 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1922,7 +1922,7 @@ static int btrfs_remount(struct super_block *sb, int *flags,
>  }
>  
>  /* Used to sort the devices by max_avail(descending sort) */
> -static int btrfs_cmp_device_free_bytes(const void *dev_info1,
> +static inline int btrfs_cmp_device_free_bytes(const void *dev_info1,
>  				       const void *dev_info2)
>  {
>  	if (((struct btrfs_device_info *)dev_info1)->max_avail >
> @@ -1951,8 +1951,8 @@ static inline void btrfs_descending_sort_devices(
>   * The helper to calc the free space on the devices that can be used to store
>   * file data.
>   */
> -static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
> -				       u64 *free_bytes)
> +static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
> +					      u64 *free_bytes)
>  {
>  	struct btrfs_device_info *devices_info;
>  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> 
