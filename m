Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37786C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F033D2086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:42:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F033D2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbeK0Tji (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 14:39:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:39024 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729297AbeK0Tji (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 14:39:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ABE6FAC15
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 08:42:27 +0000 (UTC)
Subject: Re: [PATCH v2 3/5] btrfs-progs: volumes: Refactor
 btrfs_alloc_dev_extent() into two functions
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181127083828.23861-1-wqu@suse.com>
 <20181127083828.23861-4-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 xsFNBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABzSJOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuZGU+wsF4BBMBAgAiBQJYijkSAhsDBgsJCAcDAgYVCAIJ
 CgsEFgIDAQIeAQIXgAAKCRBxvoJG5T8oV/B6D/9a8EcRPdHg8uLEPywuJR8URwXzkofT5bZE
 IfGF0Z+Lt2ADe+nLOXrwKsamhweUFAvwEUxxnndovRLPOpWerTOAl47lxad08080jXnGfYFS
 Dc+ew7C3SFI4tFFHln8Y22Q9075saZ2yQS1ywJy+TFPADIprAZXnPbbbNbGtJLoq0LTiESnD
 w/SUC6sfikYwGRS94Dc9qO4nWyEvBK3Ql8NkoY0Sjky3B0vL572Gq0ytILDDGYuZVo4alUs8
 LeXS5ukoZIw1QYXVstDJQnYjFxYgoQ5uGVi4t7FsFM/6ykYDzbIPNOx49Rbh9W4uKsLVhTzG
 BDTzdvX4ARl9La2kCQIjjWRg+XGuBM5rxT/NaTS78PXjhqWNYlGc5OhO0l8e5DIS2tXwYMDY
 LuHYNkkpMFksBslldvNttSNei7xr5VwjVqW4vASk2Aak5AleXZS+xIq2FADPS/XSgIaepyTV
 tkfnyreep1pk09cjfXY4A7qpEFwazCRZg9LLvYVc2M2eFQHDMtXsH59nOMstXx2OtNMcx5p8
 0a5FHXE/HoXz3p9bD0uIUq6p04VYOHsMasHqHPbsMAq9V2OCytJQPWwe46bBjYZCOwG0+x58
 fBFreP/NiJNeTQPOa6FoxLOLXMuVtpbcXIqKQDoEte9aMpoj9L24f60G4q+pL/54ql2VRscK
 d87BTQRYigc+ARAAyJSq9EFk28++SLfg791xOh28tLI6Yr8wwEOvM3wKeTfTZd+caVb9gBBy
 wxYhIopKlK1zq2YP7ZjTP1aPJGoWvcQZ8fVFdK/1nW+Z8/NTjaOx1mfrrtTGtFxVBdSCgqBB
 jHTnlDYV1R5plJqK+ggEP1a0mr/rpQ9dFGvgf/5jkVpRnH6BY0aYFPprRL8ZCcdv2DeeicOO
 YMobD5g7g/poQzHLLeT0+y1qiLIFefNABLN06Lf0GBZC5l8hCM3Rpb4ObyQ4B9PmL/KTn2FV
 Xq/c0scGMdXD2QeWLePC+yLMhf1fZby1vVJ59pXGq+o7XXfYA7xX0JsTUNxVPx/MgK8aLjYW
 hX+TRA4bCr4uYt/S3ThDRywSX6Hr1lyp4FJBwgyb8iv42it8KvoeOsHqVbuCIGRCXqGGiaeX
 Wa0M/oxN1vJjMSIEVzBAPi16tztL/wQtFHJtZAdCnuzFAz8ue6GzvsyBj97pzkBVacwp3/Mw
 qbiu7sDz7yB0d7J2tFBJYNpVt/Lce6nQhrvon0VqiWeMHxgtQ4k92Eja9u80JDaKnHDdjdwq
 FUikZirB28UiLPQV6PvCckgIiukmz/5ctAfKpyYRGfez+JbAGl6iCvHYt/wAZ7Oqe/3Cirs5
 KhaXBcMmJR1qo8QH8eYZ+qhFE3bSPH446+5oEw8A9v5oonKV7zMAEQEAAcLBXwQYAQIACQUC
 WIoHPgIbDAAKCRBxvoJG5T8oV1pyD/4zdXdOL0lhkSIjJWGqz7Idvo0wjVHSSQCbOwZDWNTN
 JBTP0BUxHpPu/Z8gRNNP9/k6i63T4eL1xjy4umTwJaej1X15H8Hsh+zakADyWHadbjcUXCkg
 OJK4NsfqhMuaIYIHbToi9K5pAKnV953xTrK6oYVyd/Rmkmb+wgsbYQJ0Ur1Ficwhp6qU1CaJ
 mJwFjaWaVgUERoxcejL4ruds66LM9Z1Qqgoer62ZneID6ovmzpCWbi2sfbz98+kW46aA/w8r
 7sulgs1KXWhBSv5aWqKU8C4twKjlV2XsztUUsyrjHFj91j31pnHRklBgXHTD/pSRsN0UvM26
 lPs0g3ryVlG5wiZ9+JbI3sKMfbdfdOeLxtL25ujs443rw1s/PVghphoeadVAKMPINeRCgoJH
 zZV/2Z/myWPRWWl/79amy/9MfxffZqO9rfugRBORY0ywPHLDdo9Kmzoxoxp9w3uTrTLZaT9M
 KIuxEcV8wcVjr+Wr9zRl06waOCkgrQbTPp631hToxo+4rA1jiQF2M80HAet65ytBVR2pFGZF
 zGYYLqiG+mpUZ+FPjxk9kpkRYz61mTLSY7tuFljExfJWMGfgSg1OxfLV631jV1TcdUnx+h3l
 Sqs2vMhAVt14zT8mpIuu2VNxcontxgVr1kzYA/tQg32fVRbGr449j1gw57BV9i0vww==
Message-ID: <1c742d68-660c-0ccc-3cbc-baf5f208502b@suse.com>
Date:   Tue, 27 Nov 2018 10:42:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181127083828.23861-4-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 27.11.18 г. 10:38 ч., Qu Wenruo wrote:
> We have btrfs_alloc_dev_extent() accepting @convert flag to toggle
> special handling for convert.
> 
> However that @convert flag only determine whether we call
> find_free_dev_extent(), and we may later need to insert dev extents
> without searching dev tree.
> 
> So refactor btrfs_alloc_dev_extent() into 2 functions,
> btrfs_alloc_dev_extent(), which will try to find free dev extent, and
> btrfs_insert_dev_extent(), which will just insert a dev extent.
> 
> For implementation, btrfs_alloc_dev_extent() will call
> btrfs_insert_dev_extent() anyway, so no duplicated code.
> 
> This removes the need of @convert parameter, and make
> btrfs_insert_dev_extent() public for later usage.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

This looks much better:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  volumes.c | 48 ++++++++++++++++++++++++++++++------------------
>  volumes.h |  3 +++
>  2 files changed, 33 insertions(+), 18 deletions(-)
> 
> diff --git a/volumes.c b/volumes.c
> index 30090ce5f8e8..0dd082cd1718 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -530,10 +530,12 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
>  	return find_free_dev_extent_start(device, num_bytes, 0, start, len);
>  }
>  
> -static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
> -				  struct btrfs_device *device,
> -				  u64 chunk_offset, u64 num_bytes, u64 *start,
> -				  int convert)
> +/*
> + * Insert one device extent into the fs.
> + */
> +int btrfs_insert_dev_extent(struct btrfs_trans_handle *trans,
> +			    struct btrfs_device *device,
> +			    u64 chunk_offset, u64 num_bytes, u64 start)
>  {
>  	int ret;
>  	struct btrfs_path *path;
> @@ -546,18 +548,8 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>  	if (!path)
>  		return -ENOMEM;
>  
> -	/*
> -	 * For convert case, just skip search free dev_extent, as caller
> -	 * is responsible to make sure it's free.
> -	 */
> -	if (!convert) {
> -		ret = find_free_dev_extent(device, num_bytes, start, NULL);
> -		if (ret)
> -			goto err;
> -	}
> -
>  	key.objectid = device->devid;
> -	key.offset = *start;
> +	key.offset = start;
>  	key.type = BTRFS_DEV_EXTENT_KEY;
>  	ret = btrfs_insert_empty_item(trans, root, path, &key,
>  				      sizeof(*extent));
> @@ -583,6 +575,22 @@ err:
>  	return ret;
>  }
>  
> +/*
> + * Allocate one free dev extent and insert it into the fs.
> + */
> +static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
> +				  struct btrfs_device *device,
> +				  u64 chunk_offset, u64 num_bytes, u64 *start)
> +{
> +	int ret;
> +
> +	ret = find_free_dev_extent(device, num_bytes, start, NULL);
> +	if (ret)
> +		return ret;
> +	return btrfs_insert_dev_extent(trans, device, chunk_offset, num_bytes,
> +					*start);
> +}
> +
>  static int find_next_chunk(struct btrfs_fs_info *fs_info, u64 *offset)
>  {
>  	struct btrfs_root *root = fs_info->chunk_root;
> @@ -1107,7 +1115,7 @@ again:
>  			list_move_tail(&device->dev_list, dev_list);
>  
>  		ret = btrfs_alloc_dev_extent(trans, device, key.offset,
> -			     calc_size, &dev_offset, 0);
> +			     calc_size, &dev_offset);
>  		if (ret < 0)
>  			goto out_chunk_map;
>  
> @@ -1241,8 +1249,12 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
>  	while (index < num_stripes) {
>  		struct btrfs_stripe *stripe;
>  
> -		ret = btrfs_alloc_dev_extent(trans, device, key.offset,
> -			     calc_size, &dev_offset, convert);
> +		if (convert)
> +			ret = btrfs_insert_dev_extent(trans, device, key.offset,
> +					calc_size, dev_offset);
> +		else
> +			ret = btrfs_alloc_dev_extent(trans, device, key.offset,
> +					calc_size, &dev_offset);
>  		BUG_ON(ret);
>  
>  		device->bytes_used += calc_size;
> diff --git a/volumes.h b/volumes.h
> index b4ea93f0bec3..44284ee75adb 100644
> --- a/volumes.h
> +++ b/volumes.h
> @@ -268,6 +268,9 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  		       int flags);
>  int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>  void btrfs_close_all_devices(void);
> +int btrfs_insert_dev_extent(struct btrfs_trans_handle *trans,
> +			    struct btrfs_device *device,
> +			    u64 chunk_offset, u64 num_bytes, u64 start);
>  int btrfs_add_device(struct btrfs_trans_handle *trans,
>  		     struct btrfs_fs_info *fs_info,
>  		     struct btrfs_device *device);
> 
