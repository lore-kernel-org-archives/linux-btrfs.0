Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F108CC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 18:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88BE421780
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 18:55:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="IunQUVYm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88BE421780
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbeKNEyx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 23:54:53 -0500
Received: from smtp-32-i6.italiaonline.it ([213.209.14.32]:45435 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726535AbeKNEyw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 23:54:52 -0500
Received: from venice.bhome ([84.223.217.49])
        by smtp-32.iol.local with ESMTPA
        id MdqNgO9gYfnYOMdqNgkDtk; Tue, 13 Nov 2018 19:55:24 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1542135324; bh=fBxaV0Qvv1XjSfJMstnJIQ9h2WCNVYiykai3IuUtfvA=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=IunQUVYmlEOd2g9BvLFKID7ZyKyQK29uvvYg8e4pUlj0ax2oK2vVWbHydu/MX/6g3
         9uNvBlkOvCvrg7LezxVYVZG8tLb6aByXAsEj01oRyvv+en8pcuncokm3DF4vD9Mrs9
         uC1qLRrE2euIrLOzV/yX9awO5mNsSjSPl2RJGiHBLowgC3lqtwrHNJC39FXF+NQK5w
         j7Nyitj8xTz6mSzj+tPXi4j+rLJPOD9WgXpAd4da9fNCC2Rv9c7emwIHHFHlKliZ6f
         qUXRcBslK74r0HtirREVM105v3YiuJEle84TXKymLMypfFLAyitJFxG6A6cySuevpY
         xO3Bimk53n7EQ==
X-CNFS-Analysis: v=2.3 cv=QKq5uTDL c=1 sm=1 tr=0
 a=fIDDTigewxANa3j7Vc0ApQ==:117 a=fIDDTigewxANa3j7Vc0ApQ==:17
 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=TD8gUqi8AAAA:8 a=YdJAqheK4nT_SQJDD6kA:9
 a=bV2QCdX8BW85wDs8:21 a=T-NslbJBs0Mp0yk9:21 a=QEXdDO2ut3YA:10
 a=ZAeakzZzxOc8cl0CLKiY:22
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH V7] Btrfs: enhance raid1/10 balance heuristic
To:     Timofey Titovets <timofey.titovets@synesis.ru>,
        linux-btrfs@vger.kernel.org
Cc:     nborisov@suse.com, Timofey Titovets <nefelim4ag@gmail.com>
References: <20181112115839.13969-1-timofey.titovets@synesis.ru>
From:   Goffredo Baroncelli <kreijack@libero.it>
Openpgp: preference=signencrypt
Autocrypt: addr=kreijack@libero.it; prefer-encrypt=mutual; keydata=
 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
Message-ID: <c2402d86-24ff-279a-8398-0f4379721dd4@libero.it>
Date:   Tue, 13 Nov 2018 19:55:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181112115839.13969-1-timofey.titovets@synesis.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfOJXSB4VB7pvlDITzc2jAfFkhXutXhhzJZABMO4UuRPFDIMYoj8SMw0gb0DdpTrIw5mehyrmZUtNheVzYOZeIrJa5SQv0R0PxiRpAWqrA2do6Zftx4dh
 R16oFKQ8lrRY2A3bnD7OZFhzvO+gNnCfB2zoZ5SjOAhMqgJpa4BijrdpFYVZ7LZ/vRKXWy774ZaszBsqCqCrZ0AKHQgUQGflbWms1IgAUfd/vMeG9HL2KJhH
 Dpp8pab6FjeKDWXl+k6lNBG9elPNOT6Z5fHS3NPzZqY=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/11/2018 12.58, Timofey Titovets wrote:
> From: Timofey Titovets <nefelim4ag@gmail.com>
> 
> Currently btrfs raid1/10 balancer bаlance requests to mirrors,
> based on pid % num of mirrors.
[...]
>   v6 -> v7:
>     - Fixes based on Nikolay Borisov review:
>       * Assume num == 2
>       * Remove "for" loop based on that assumption, where possible
>       * No functional changes
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
> Reviewed-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
> ---
[...]
> +/**
> + * guess_optimal - return guessed optimal mirror
> + *
> + * Optimal expected to be pid % num_stripes
> + *
> + * That's generaly ok for spread load
> + * Add some balancer based on queue length to device
> + *
> + * Basic ideas:
> + *  - Sequential read generate low amount of request
> + *    so if load of drives are equal, use pid % num_stripes balancing
> + *  - For mixed rotate/non-rotate mirrors, pick non-rotate as optimal
> + *    and repick if other dev have "significant" less queue length
> + *  - Repick optimal if queue length of other mirror are less
> + */
> +static int guess_optimal(struct map_lookup *map, int num, int optimal)
> +{
> +	int i;
> +	int round_down = 8;
> +	/* Init for missing bdevs */
> +	int qlen[2] = { INT_MAX, INT_MAX };
> +	bool is_nonrot[2] = { false, false };
> +	bool all_bdev_nonrot = true;
> +	bool all_bdev_rotate = true;
> +	struct block_device *bdev;
> +
> +	ASSERT(num == 2);
> +
> +	/* Check accessible bdevs */> +	for (i = 0; i < 2; i++) {

From your function comment, it is not clear why you are comparing "num" to "2". Pay attention that there are somewhere some patches which implement raid profile with higher redundancy (IIRC up to 4). I suggest to put your assumption also in the comment ("...this function works up to 2 mirrors...") and, better, add a define like 

#define BTRFS_MAX_RAID1_RAID10_MIRRORS 2

And replace "2" with BTRFS_MAX_RAID1_RAID10_MIRRORS



> +		bdev = map->stripes[i].dev->bdev;
> +		if (bdev) {
> +			qlen[i] = 0;
> +			is_nonrot[i] = blk_queue_nonrot(bdev_get_queue(bdev));
> +			if (is_nonrot[i])
> +				all_bdev_rotate = false;
> +			else
> +				all_bdev_nonrot = false;
> +		}
> +	}
> +
> +	/*
> +	 * Don't bother with computation
> +	 * if only one of two bdevs are accessible
> +	 */
> +	if (qlen[0] == INT_MAX)
> +		return 1;
> +	if (qlen[1] == INT_MAX)
> +		return 0;
> +
> +	if (all_bdev_nonrot)
> +		round_down = 2;
> +
> +	for (i = 0; i < 2; i++) {
> +		bdev = map->stripes[i].dev->bdev;
> +		qlen[i] = bdev_get_queue_len(bdev, round_down);
> +	}
> +
> +	/* For mixed case, pick non rotational dev as optimal */
> +	if (all_bdev_rotate == all_bdev_nonrot) {
> +		if (is_nonrot[0])
> +			optimal = 0;
> +		else
> +			optimal = 1;
> +	}
> +
> +	if (qlen[optimal] > qlen[(optimal + 1) % 2])
> +		optimal = i;
> +
> +	return optimal;
> +}
> +
>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  			    struct map_lookup *map, int first,
>  			    int dev_replace_is_ongoing)
> @@ -5177,7 +5274,8 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  	else
>  		num_stripes = map->num_stripes;
>  
> -	preferred_mirror = first + current->pid % num_stripes;
> +	preferred_mirror = first + guess_optimal(map, num_stripes,
> +						 current->pid % num_stripes);
>  
>  	if (dev_replace_is_ongoing &&
>  	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
