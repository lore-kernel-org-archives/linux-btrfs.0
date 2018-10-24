Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1CCC46475
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 02:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 096B52082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 02:55:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 096B52082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbeJXLVh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 07:21:37 -0400
Received: from mout.gmx.net ([212.227.17.22]:37883 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbeJXLVh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 07:21:37 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M0cs6-1fKONc0yvG-00uq3v; Wed, 24
 Oct 2018 02:13:27 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M0cs6-1fKONc0yvG-00uq3v; Wed, 24
 Oct 2018 02:13:27 +0200
Subject: Re: [PATCH 04/13] btrfs-progs: lowmem: fix false alert about the
 existence of gaps in the check_file_extent
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-5-suy.fnst@cn.fujitsu.com>
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
Message-ID: <665a8b5f-c463-6dde-a5cc-959d84c44378@gmx.com>
Date:   Wed, 24 Oct 2018 08:13:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181023094147.7906-5-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:klQyPemhNw6OSMP/o7PjWp3Lwo+HxhHO9A2RVeWFe6h86xpgy60
 WovlMvFHlLFsG4mr9bfFNPajro6naR05HKzsMJoDxSTRXJ46XCggnP9NvoBbDXuo1DcQFOx
 uBD/a1eXLIDOuBRFLmK0EB05e7MRCGJgurUR/TRTC4kwnFPl/cixJ2U6B8yI9yozF9tzoYU
 6F3DeiwlAm037HF8oGwJg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:11r/BBj5lZ8=:yGzc3t2Pth8SGbI/3KUpPT
 3d8tQjr2Fw7U66RxlO5eh145FpHpv7JGoctjMn9PryNTA6CN0oGVnYbJdjUbAQgvKoFjqgr24
 hLqVQoMHKhac6qFxarBGT+IAhgEi7VLL3cwKMWA/+1h5ppe0V5Z/bnM7dobIwodxSOovTmIMG
 SE8op2sBEDKrC60yQKPADz0FA/kf7OqBZewyJjgmfJxnvalwMbrNEgx8qPjpynaO8JKCqU8H4
 06KJknBuSYX2YC6VaG5P0ZKT1azWXlS7ygewPVfyUSEvb6/34El5lJgsurzsVkW6KMiJzVjlz
 /6iYJz/wEvX57AkD3WzCXRadbclBRo3H73lmCKM/AySu5azNLioyAEEHhkZL9Fos4g0pebSDP
 moqHh1RTQ0nCF/L0o7M/K2x5B9ea7wVRQqbiS3HdHsOoeMus3Yx8GhJP+xU7aBwK2lbDr3Cz+
 R3FRY2iIJz7e3/q3ytxi9U27VKCaEOhL/Q+LJYekSLAzZ+AZXuy++8FmqZNIk698W7Zd7o0rj
 6UeP2q3GMsnFk2yiWqXAFURkqy+83Tt0ZGtI6wiacCDyxNIqkNgpW7EcHNsZy8GYjXeIBiouP
 9Xrs0KUDtAwmxVPRaVDdeaU/QlgWK0PeYFgpLHxGTt9sq8wtEyl+eCeEypzXMOqqEb+fmGe92
 ft9Ia/l3XDyt/KGu24jcd74k+hrfcakA3bFwg6rLC5mHofNuRFxQYXtGZQtX0snbmYDRdOK8i
 voO9CvPq9x/8VUwAuT29crUIpkOWc/jP0i8NGLad+dA284TwoOojvV8HRMW93A5twwWKktLMU
 VAZBHmZbQycm7aBIsxi+s31iroOPRwTAwRw6MPTZahjRjT+YOk=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/23 下午5:41, Su Yue wrote:
> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> 
> The 'end' parameter of check_file_extent tracks the ending offset of the
> last checked extent. This is used to detect gaps between adjacent extents.
> 
> Currently such gaps are wrongly detected since for regular extents only
> the size of the extent is added to the 'end' parameter. This results in
> wrongly considering all extents of a file as having gaps between them
> when only 2 of them really have a gap as seen in the example below.
> 
> Solution:
> The extent_end variable should set to the sum of the offset and the
> extent_num_bytes of the file extent.
> 
> Example:
> Suppose that lowmem check the following file extent of inode 257.
> 
>         item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
>                 generation 6 type 1 (regular)
>                 extent data disk byte 13631488 nr 4096
>                 extent data offset 0 nr 4096 ram 4096
>                 extent compression 0 (none)
>         item 7 key (257 EXTENT_DATA 8192) itemoff 15760 itemsize 53
>                 generation 6 type 1 (regular)
>                 extent data disk byte 13631488 nr 4096
>                 extent data offset 0 nr 4096 ram 4096
>                 extent compression 0 (none)
>         item 8 key (257 EXTENT_DATA 12288) itemoff 15707 itemsize 53
>                 generation 6 type 1 (regular)
>                 extent data disk byte 13631488 nr 4096
>                 extent data offset 0 nr 4096 ram 4096
>                 extent compression 0 (none)
> 
> For inode 257, check_inode_item set extent_end to 0, then call
> check_file_extent to check item {6,7,8}.
> item 6)
> 	offset(0) == extent_end(0)
> 	extent_end = extent_end(0) + extent_num_bytes(4096)
> item 7)
> 	offset(8192) != extent_end(4096)
> 	extent_end = extent_end(4096) + extent_num_bytes(4096)
> 			^^^

The problem is all about a gap screwing up all later accounting.

So it's indeed a problem.

> 	The old extent_end should replace by offset(8192).
> item 8)
> 	offset(12288) != extent_end(8192)
> 		^^^
> 	But there is no gap between item {7,8}.
> 
> Fixes: d88da10ddd42 ("btrfs-progs: check: introduce function to check file extent")
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  check/mode-lowmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 769b3141de8b..35fe1adf58e6 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1985,7 +1985,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
>  		}
>  	}
>  
> -	*end += extent_num_bytes;
> +	*end = fkey.offset + extent_num_bytes;
>  	if (!is_hole)
>  		*size += extent_num_bytes;
>  
> 
