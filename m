Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455A6C46475
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 10:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1C7D20652
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 10:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1C7D20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbeJWS05 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 14:26:57 -0400
Received: from mout.gmx.net ([212.227.15.15]:35589 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727542AbeJWS05 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 14:26:57 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LZiLk-1fl2Ri2Ixg-00lS84; Tue, 23
 Oct 2018 12:04:11 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LZiLk-1fl2Ri2Ixg-00lS84; Tue, 23
 Oct 2018 12:04:11 +0200
Subject: Re: [PATCH 01/13] btrfs-progs: lowmem: add argument path to
 punch_extent_hole()
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-2-suy.fnst@cn.fujitsu.com>
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
Message-ID: <79d1c476-4df2-e422-8aa4-74815a5a53e2@gmx.com>
Date:   Tue, 23 Oct 2018 18:04:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181023094147.7906-2-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:oo5yqJF2HhDRQazEAdFgROUBiSyYwWgzKktgpggBq1hm0MP+/ro
 a2XbZ5tkJ13dQoJD2+QZl3CUxaAu1WNaxzfZjT52u2kIHYOjNuOQVWHHoCQiP3LC7q98WBg
 8o1Pj1ZqHIW1wZBHoEGXOtRtmH9104lxoMme9t29CdrbioMiuIs55lLp9/98XplRQMqG1iE
 auO5OZi1sc6h5OLVdAgPA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:dSyb1v2xkBw=:scluKngnWhWFPGpEZXvrpF
 rXdvaNxSz3UJ6UXJvOnbrjnM3pkmwRLbzHrZidZx7CUEKs6UO+SSQE17MB4/M1amml4Q5Laek
 PW6cOOmP7KxwKR+0E9x+vfkCnNUV60CQJ0+t2M5gjCjyzOftxn68QOCsbAGDtO4O/uKGEUIR5
 NzJYIXPzN2eXLCAzvoNREX0SAmrRWj5SVHgSmvooy1sbxutP+Ft6AAQltRPOMLmEo5gEfHGHu
 n5+OjDJ2ScAGrQqEruDGukx8ninwQSPeNly7I/kghrI0e+aqEKIpy5S+PbQpGUvVglz3kYchi
 tTzur6YStZBcd+kYqvVm+AS7aUfMyKGkmSG4ys18ESAwBkZXqyROmO4+w9oW06uCaZqx17hgm
 Ykn6u1K0sze+i4UMCQdc6WoXkNe+foCamt2qqhUNaW3Ln8NENdBjusjHFA/62vWr8Hvy1kvfq
 8g9Gs05i28e5PZEH/JpPZeWXqpN9P/BYGBO1Xks4sBX4Z2rHXFkRVFIId2WBRiO1rwUQDubtZ
 geAh4ZIzo/keCUYS+0rMr5z8rbdlt2LnFIwd5AzV/d5NYotGjeltGlPReRIC8Xge/xzPybWl8
 gt6mzG7x9yR8qItU4ORN2uX8r6esvL7Iw9694EMAd+nAeT6GgQJBhUZCWTRIonwXS9gRL3+iw
 dgoajJi6vguhsDO1mmg+qIT4UJh0hhIWZsh3NMjFZbRnti2q6Yvmrp4pnQw1thZ1VMbOOue9c
 9NGtr/2Nuz5Kgfh2jpR052gQczmg6cmIeZE3uz1OeP9yJXpoRYotSNnYmuZ0C3av9zXnvfp7Y
 DwWhpiQnSJO6zv/OyVA9H9jNP7O0tCl6CDTCgUcdEI28tizYA8=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/23 下午5:41, Su Yue wrote:
> Since repair will do CoW, the outer path may be invalid,
> add an argument path to punch_extent_hole().
> When punch_extent_hole() returns, path will still point to the item
> before calling punch_extent_hole();
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Overall it looks OK, however still some nitpicks with a new bug exposed
inlined below.

> ---
>  check/mode-lowmem.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 1bce44f5658a..c8e4f13d816f 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1710,15 +1710,20 @@ out:
>  /*
>   * Wrapper function of btrfs_punch_hole.
>   *
> + * @path:	will point to the item while calling the function.
> + *
>   * Returns 0 means success.
>   * Returns not 0 means error.
>   */
> -static int punch_extent_hole(struct btrfs_root *root, u64 ino, u64 start,
> -			     u64 len)
> +static int punch_extent_hole(struct btrfs_root *root, struct btrfs_path *path,
> +			     u64 ino, u64 start, u64 len)
>  {
>  	struct btrfs_trans_handle *trans;
> -	int ret = 0;
> +	struct btrfs_key key;
> +	int ret;
> +	int ret2;

I didn't see the need to introduce another ret.

@ret is used to record the error from btrfs_punch_hole(), which should
only return <0 or 0.

We should only continue for ret == 0, so we can overwrite @ret.

>  
> +	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>  	trans = btrfs_start_transaction(root, 1);
>  	if (IS_ERR(trans))
>  		return PTR_ERR(trans);
> @@ -1732,6 +1737,12 @@ static int punch_extent_hole(struct btrfs_root *root, u64 ino, u64 start,
>  		       ino);
>  
>  	btrfs_commit_transaction(trans, root);

Here since the wrapper is a little old and at that time we don't have
btrfs_abort_transaction() (well, not really have one even now).

The correct behavior is to abort trans and return error if we get error
from btrfs_punch_hole().

And if we get no error from btrfs_punch_hole(), we can reuse @ret for
btrfs_search_slot(), no need to introduce @ret2.

> +
> +	btrfs_release_path(path);
> +	ret2 = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret2 > 0)
> +		ret2 = -ENOENT;
> +	ret |= ret2;
>  	return ret;
>  }
>  
> @@ -1963,7 +1974,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
>  	/* Check EXTENT_DATA hole */
>  	if (!no_holes && *end != fkey.offset) {
>  		if (repair)
> -			ret = punch_extent_hole(root, fkey.objectid,
> +			ret = punch_extent_hole(root, path, fkey.objectid,
>  						*end, fkey.offset - *end);
>  		if (!repair || ret) {
>  			err |= FILE_EXTENT_ERROR;
> @@ -2534,7 +2545,7 @@ out:
>  
>  		if (!nbytes && !no_holes && extent_end < isize) {
>  			if (repair)
> -				ret = punch_extent_hole(root, inode_id,
> +				ret = punch_extent_hole(root, path, inode_id,
>  						extent_end, isize - extent_end);

In this case, it's check_inode_item() and it's repair case for missing
tailing hole.

However isize can be unaligned, but hole extent should always be aligned.
So there is another bug that repair could create invalid hole extents.

Thanks,
Qu

>  			if (!repair || ret) {
>  				err |= NBYTES_ERROR;
> 
