Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42040C46475
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 02:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 159B32082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 02:55:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 159B32082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbeJXLVp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 07:21:45 -0400
Received: from mout.gmx.net ([212.227.17.20]:51971 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbeJXLVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 07:21:45 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Me5Q2-1fy6pT0H8g-00PxFg; Wed, 24
 Oct 2018 02:13:54 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Me5Q2-1fy6pT0H8g-00PxFg; Wed, 24
 Oct 2018 02:13:54 +0200
Subject: Re: [PATCH 05/13] btrfs-progs: lowmem: check unaligned disk_bytenr
 for extent_data
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-6-suy.fnst@cn.fujitsu.com>
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
Message-ID: <bd2b2004-0396-50e1-4b74-2e3a910907d5@gmx.com>
Date:   Wed, 24 Oct 2018 08:13:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181023094147.7906-6-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:K2IMIMFyepGzXF/7YLrGWGGeP/UoiwS3XCl4j8b/0wrZOeTafe7
 Z356yNmLJ8Xer1PxQk4GeJIol8Idfg2n/3DfU4UxLSCf6PtMOSoges5ifsEEgMkGkxZRPUy
 IVxFxVyrwBva6/+CHRfVwLqdQIDbk25OJNPcGJAyFtFSg6EQ5L7zjRAL1x/+Z1mHgoy4+Lk
 ZBM14/RfNnwBrHliDRleA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:NgdP/mqy5Mc=:CQXvy+WcwCPaD0lNMZupYp
 o9a/XWzbr8+lRz4beKVmgyg90VgLGZgiK5SnV4WbzF69MpmQfY7aUgsK5TaNCDIjbTIlv3+it
 WzjxXWf2gl2EIao04b7MCVBvYQzV7a8NMMB13oC0MwPq8ToqW4AgxsAjOoM/r4vS5zEi57PEE
 Spi1q7d88S4+9bNxuKyEsoYvVK3ghUJP3xKCvD/p6XtD7w7OyUo4xFr1lQjrM2O5D/FaMTv4s
 GrxeCIweAdcO+e7Qt1PFMqHgMbg7E4Kn5iH4dU7BntMO5bykc/CaxiuV1Nvra3culn+mc/nLj
 OlvIuXSUaZsyqKV7eKYm/V5wyZxgtL24MLhurnRFrkQXzPVTDrLIL/8XANcoGmStUfaqkOg6H
 AMrgeovopH5ZK6UFo3yLPIDejDieL+gHh0cuVhOyH3zkgm9mfxDYsvoclgFby/TwOdHYdzYE9
 lMl1kMiYLjHFBY+XkNnnd5RuYNnxBzArOzs1hLrAK8FLriLFTzzmSRhUgJLBu3esBPk8yAm88
 2Sg0GPrD+wyKEF7HUK4/MfPrwOHXhYc3AuK/LnXAgUyA0nq9iMQbdOi4AKcDF02sbS62tSwhS
 v6FYiK8snZYro7qh0sYqyKLfxRcivM0NK+oFWvmWZbZKhPeY70J2ci6kK4xFdgTfdBtlb6M2D
 BKsrMnPuJP0gxt1CSQBK/3JAKBgZfRTYABW9jUL4bgczj91yejL4NHtwaOPDrfJRW6fTKU+Ev
 IxVWC7av8wQnTnWktZsFldDys9E8eq3ozDh1+pi0DnL+VF996denZRb9ObmO19rxhHZW34aAT
 e2TkpugMcYBmJb38K8Umx16wtjeUXYGxjCPTbFUfdIpRk6d70g=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/23 下午5:41, Su Yue wrote:
> Add support to check unaligned disk_bytenr for extent_data.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  check/mode-lowmem.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 35fe1adf58e6..e8a2e825c0f3 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -3103,7 +3103,14 @@ static int check_extent_data_item(struct btrfs_root *root,
>  	extent_num_bytes = btrfs_file_extent_num_bytes(eb, fi);
>  	offset = btrfs_file_extent_offset(eb, fi);
>  
> -	/* Check unaligned disk_num_bytes and num_bytes */
> +	/* Check unaligned disk_bytenr, disk_num_bytes and num_bytes */
> +	if (!IS_ALIGNED(disk_bytenr, root->fs_info->sectorsize)) {
> +		error(
> +"file extent [%llu, %llu] has unaligned disk bytenr: %llu, should be aligned to %u",
> +			fi_key.objectid, fi_key.offset, disk_bytenr,
> +			root->fs_info->sectorsize);
> +		err |= BYTES_UNALIGNED;
> +	}
>  	if (!IS_ALIGNED(disk_num_bytes, root->fs_info->sectorsize)) {
>  		error(
>  "file extent [%llu, %llu] has unaligned disk num bytes: %llu, should be aligned to %u",
> 
