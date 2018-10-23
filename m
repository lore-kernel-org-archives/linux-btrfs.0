Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8C5ECDE46
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 10:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88D782080A
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 10:07:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88D782080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbeJWSae (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 14:30:34 -0400
Received: from mout.gmx.net ([212.227.15.18]:43527 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729006AbeJWSad (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 14:30:33 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LuPYt-1fVHks2uGt-011iwi; Tue, 23
 Oct 2018 12:07:46 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LuPYt-1fVHks2uGt-011iwi; Tue, 23
 Oct 2018 12:07:46 +0200
Subject: Re: [PATCH 02/13] btrfs-progs: lowmem: move nbytes check before isize
 check
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-3-suy.fnst@cn.fujitsu.com>
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
Message-ID: <4e76d260-0496-3bfc-f9b8-3b6ab68bd25b@gmx.com>
Date:   Tue, 23 Oct 2018 18:07:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181023094147.7906-3-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ZVUOu+dCcfMbsU1Pe0ZwVnUe9//wG/bgVfvG7/vMTsFxAZw+J8p
 fdSBTcGZCaa6xftjN63QOjSxmerZxybuYQapDNQV4HWYCiRgEzZVhHeZt7wvbAKAQ24/BYR
 8G4zD5h0XGq/0YXJDGN/d9bJ4I6utpiahr2aoy4pILNWYGgtZiWt+063+MgHTd9VAjLennJ
 me2Ld1wC9CHFL0qiVtDeg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:Z9jSIROrnxA=:ebjRpSTGp19I6IGX1T4sGT
 kwUEzJMHkSjplK183PP25YCFyHUhlLN6tKaeF/FtjIn4DcweFKTRh0lHMWhBrxl71oO508Lm2
 0cK5/sNHPpMeRsHYdA/ud/KjX9PmwAO5WDTZun5imzxp6z/nHBERpV5zQ3Gdyqxnp1UEk7Km0
 9EugCDGHxovdpp+0zgwrMBVHaxORYXconbKOTjkAwZaprNYbMTDC/mt05icegiQMpqGxmBv2h
 UWf4Uvm/0EZUB49yft3DHbsJcEGnBWbxfy1zQK8uoHAMPbKm/6cF+C4/qpe1xUTPq1gpzGu1k
 Jz3SBND+J1P2f97tJ6C3GXNm8CpuX6rj1rWmhidtFRpWs/zdNWTqEPBYksDqVM0x8mhXARf9C
 Kg57Rs32GDWM8uYxXhgykSfYHaRhWQLfYncCJ/fdCTAEy45+H3pjokXTdSRTi3AJ3E3WwGtZZ
 7/SB6s4q9Rf+4AkWfjWc/bh27eYGci73LmFca+KHGpX+w9/DbgIYEzT3DTjkmgt/MiuU4o5hg
 bGpe+1ldCDwTu7cEzK4U+l6ALGcXkR9HAKlgbtnXGoUrk/UbAG7X/2csjnn2mQHpj3mTXaMI3
 ZjjdfPeOsKx7dttMC+jTeYaG+IxxDNtI2xV4y+eOuyd7/2NcE13hk+PNTOrisulDgwwEHslhN
 ttSgApn8tGilUs3/9JHNHK+i8AgWkHbNW26r2Vq+dVuyAlKPJwqozx+o0qyARtYVJ7jOwslgQ
 syojGxe6+KCv4Im6oO7zlq7lPOcx0Z1F9/EbHVFwSNN5NRiNbiivzDKgHTNg2roWkd0CQm55J
 RSl5iP9cMUilEuBcb+G4xAJQeThNXz5KgODG2Zw/c4iQ9jJIF0=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/23 下午5:41, Su Yue wrote:
> For files, lowmem repair will try to check nbytes and isize,
> but isize check depends nbytes.
> 
> Once bytes has been repaired, then isize should be checked and
> repaired.
> So move nbytes check before isize check. Also set nbytes to
> extent_size once repaired successfully.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Overall looks good.

Just a small nitpick.

> ---
>  check/mode-lowmem.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index c8e4f13d816f..76e7be81ceb1 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -2125,7 +2125,7 @@ out:
>  		error("failed to set nbytes in inode %llu root %llu",
>  		      ino, root->root_key.objectid);
>  	else
> -		printf("Set nbytes in inode item %llu root %llu\n to %llu", ino,
> +		printf("Set nbytes in inode item %llu root %llu to %llu\n", ino,

It's better to fix it in another patch.

Thanks,
Qu

>  		       root->root_key.objectid, nbytes);
>  
>  	/* research path */
> @@ -2543,28 +2543,31 @@ out:
>  			}
>  		}
>  
> -		if (!nbytes && !no_holes && extent_end < isize) {
> -			if (repair)
> -				ret = punch_extent_hole(root, path, inode_id,
> -						extent_end, isize - extent_end);
> +		if (nbytes != extent_size) {
> +			if (repair) {
> +				ret = repair_inode_nbytes_lowmem(root, path,
> +							 inode_id, extent_size);
> +				if (!ret)
> +					nbytes = extent_size;
> +			}
>  			if (!repair || ret) {
>  				err |= NBYTES_ERROR;
>  				error(
> -	"root %llu INODE[%llu] size %llu should have a file extent hole",
> -				      root->objectid, inode_id, isize);
> +	"root %llu INODE[%llu] nbytes %llu not equal to extent_size %llu",
> +				      root->objectid, inode_id, nbytes,
> +				      extent_size);
>  			}
>  		}
>  
> -		if (nbytes != extent_size) {
> +		if (!nbytes && !no_holes && extent_end < isize) {
>  			if (repair)
> -				ret = repair_inode_nbytes_lowmem(root, path,
> -							 inode_id, extent_size);
> +				ret = punch_extent_hole(root, path, inode_id,
> +						extent_end, isize - extent_end);
>  			if (!repair || ret) {
>  				err |= NBYTES_ERROR;
>  				error(
> -	"root %llu INODE[%llu] nbytes %llu not equal to extent_size %llu",
> -				      root->objectid, inode_id, nbytes,
> -				      extent_size);
> +	"root %llu INODE[%llu] size %llu should have a file extent hole",
> +				      root->objectid, inode_id, isize);
>  			}
>  		}
>  	}
> 
