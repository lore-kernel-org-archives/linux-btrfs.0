Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55374C6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11E1220868
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:44:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11E1220868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbeJZVVb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 17:21:31 -0400
Received: from mout.gmx.net ([212.227.15.15]:58093 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727582AbeJZVVb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 17:21:31 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lvl0u-1fXAgR0140-017TO5; Fri, 26
 Oct 2018 14:44:28 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lvl0u-1fXAgR0140-017TO5; Fri, 26
 Oct 2018 14:44:28 +0200
Subject: Re: [PATCH 5/5] btrfs: Replace BUG_ON with ASSERT in
 find_lock_delalloc_range
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-6-git-send-email-nborisov@suse.com>
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
Message-ID: <6eaef69c-48ab-d43c-ac82-c1d72c78bf00@gmx.com>
Date:   Fri, 26 Oct 2018 20:44:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1540554201-11305-6-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:HXDAAK5eDrsNTORxluxi9D4X6dnmGV0Fm7FsW4xB9qZxcr5nTd+
 3IwbNQNhaThe9iwnTE3IW8Ho608kxnpw/fepEB7LrLsxRQj1kR56gWDcX1WO8Dxy/zKenCC
 F8e50t9f47j824YgVLTA6wRY5YMd44LCY1rRZR3bD4K/GqBQviOP18cMLaI0uKWO75EQgo3
 +s8xC87q7avgvMX/R7t5w==
X-UI-Out-Filterresults: notjunk:1;V01:K0:OnrK720AtZw=:9uCDIF2kEHt6RGenY8rThD
 yo5gXKfUodostCwrfrdCcs+5t/+h6278dCIspIQEh+lSKDZ2QhjJ2E5X/aXitqpBHtj2oWY/d
 oMyfBqG/AuLOjvVYRknGija8duBj/1Q+HNXWNAdksCMq824wv6cl7uBhEPqZMFUUlsGJ/fjm1
 ntP2RUrcwjdNnhSSBz3oUVzvMQ8KGuNsjfHCJGMDmIwV/aIL6Hvw57jwOJBUU1X9TfbXrHauX
 eX0V928rMvR9y4YlPVg5U8hp2ZUl3nB6yA4aewXkihCSyAAtjeE3rWKQACdBuCqSzPrik6TVz
 MVwiwttQZyEuc0MeZeuyV38oOEyXyUg7za15+A8hNyYPuF65dVJGV5GJoBJQYDPsGLfrhuq/2
 T9owWo6d6YKe/jvy92xGeECC2YGgou0FqTqmCBgy7Ptj0p7tdl9e2xaC551i9KKoY7QmWvCgs
 OXcXWkAfNsBWIE7FwF0VpTA3seoUt6JTCHZ/pAOykr/SgYfkkzutRaOtiQGVvK712defFNmW/
 FHBCudUVQniSH8n3YFHDjpfi8Io/j8J3EokytPyqZ9g8hhEFuHE5ZDFRYqSd6qWGxDVPs2f+5
 3m9yHEupttlvrqhYAE+I54zN7OMGrtbRO2gg0MUyfJ/fLR+KqUzVGGsVDwSuOUgDStPKXqSY2
 l3kNUhcoZi9S3sJu0q7eAcNKufobS6ykb9r/D750QOsjNHv5KA23FiHn6xaAHDTxJhok/zKW3
 rBDGMSv+ekDWuyxK8CInkthe/yxHkD1SX6pQLb2bEGnMYGp5R+NVFmmDulVjej7xlrj1cB4o7
 Dny47Yx+MOzNeY5tuW++aTTEtRUeUjwLylrMtA/DP7YKyydGrY=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/26 下午7:43, Nikolay Borisov wrote:
> lock_delalloc_pages should only return 2 values - 0 in case of success
> and -EAGAIN if the range of pages to be locked should be shrunk due to
> some of gone. Manual inspections confirms that this is
> indeed the case since __process_pages_contig is where lock_delalloc_pages
> gets its return value. The latter always returns 0  or -EAGAIN so the
> invariant holds. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/extent_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 1a9a521aefe5..94bc53472031 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1606,6 +1606,7 @@ static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>  	/* step two, lock all the pages after the page that has start */
>  	ret = lock_delalloc_pages(inode, locked_page,
>  				  delalloc_start, delalloc_end);
> +	ASSERT(!ret || ret == -EAGAIN);
>  	if (ret == -EAGAIN) {
>  		/* some of the pages are gone, lets avoid looping by
>  		 * shortening the size of the delalloc range we're searching
> @@ -1621,7 +1622,6 @@ static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>  			goto out_failed;
>  		}
>  	}
> -	BUG_ON(ret); /* Only valid values are 0 and -EAGAIN */
>  
>  	/* step three, lock the state bits for the whole range */
>  	lock_extent_bits(tree, delalloc_start, delalloc_end, &cached_state);
> 
