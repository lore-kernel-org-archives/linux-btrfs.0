Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C1AC00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 14:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99CCB206B2
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 14:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99CCB206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbeJEVlv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 17:41:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:56410 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728624AbeJEVlv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 17:41:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D6226AEC1;
        Fri,  5 Oct 2018 14:42:46 +0000 (UTC)
Subject: Re: [PATCH 5/6] btrfs: introduce nparity raid_attr
To:     Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <20181004212443.26519-6-hans.van.kranenburg@mendix.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f3602299-4904-9a59-0a38-ab4525be1239@suse.com>
Date:   Fri, 5 Oct 2018 17:42:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181004212443.26519-6-hans.van.kranenburg@mendix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On  5.10.2018 00:24, Hans van Kranenburg wrote:
> Instead of hardcoding exceptions for RAID5 and RAID6 in the code, use an
> nparity field in raid_attr.
> 
> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> ---
>  fs/btrfs/volumes.c | 18 +++++++++++-------
>  fs/btrfs/volumes.h |  2 ++
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index d82b3d735ebe..453046497ac8 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -37,6 +37,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 1,
>  		.devs_increment	= 2,
>  		.ncopies	= 2,
> +		.nparity        = 0,
>  		.raid_name	= "raid10",
>  		.bg_flag	= BTRFS_BLOCK_GROUP_RAID10,
>  		.mindev_error	= BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET,
> @@ -49,6 +50,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 1,
>  		.devs_increment	= 2,
>  		.ncopies	= 2,
> +		.nparity        = 0,
>  		.raid_name	= "raid1",
>  		.bg_flag	= BTRFS_BLOCK_GROUP_RAID1,
>  		.mindev_error	= BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET,
> @@ -61,6 +63,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 0,
>  		.devs_increment	= 1,
>  		.ncopies	= 2,
> +		.nparity        = 0,
>  		.raid_name	= "dup",
>  		.bg_flag	= BTRFS_BLOCK_GROUP_DUP,
>  		.mindev_error	= 0,
> @@ -73,6 +76,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 0,
>  		.devs_increment	= 1,
>  		.ncopies	= 1,
> +		.nparity        = 0,
>  		.raid_name	= "raid0",
>  		.bg_flag	= BTRFS_BLOCK_GROUP_RAID0,
>  		.mindev_error	= 0,
> @@ -85,6 +89,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 0,
>  		.devs_increment	= 1,
>  		.ncopies	= 1,
> +		.nparity        = 0,
>  		.raid_name	= "single",
>  		.bg_flag	= 0,
>  		.mindev_error	= 0,
> @@ -97,6 +102,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 1,
>  		.devs_increment	= 1,
>  		.ncopies	= 1,
> +		.nparity        = 2,
>  		.raid_name	= "raid5",
>  		.bg_flag	= BTRFS_BLOCK_GROUP_RAID5,
>  		.mindev_error	= BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET,
> @@ -109,6 +115,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 2,
>  		.devs_increment	= 1,
>  		.ncopies	= 1,
> +		.nparity        = 2,
>  		.raid_name	= "raid6",
>  		.bg_flag	= BTRFS_BLOCK_GROUP_RAID6,
>  		.mindev_error	= BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
> @@ -4597,6 +4604,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	int devs_min;		/* min devs needed */
>  	int devs_increment;	/* ndevs has to be a multiple of this */
>  	int ncopies;		/* how many copies to data has */
> +	int nparity;		/* number of stripes worth of bytes to
> +				   store parity information */
>  	int ret;
>  	u64 max_stripe_size;
>  	u64 max_chunk_size;
> @@ -4623,6 +4632,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	devs_min = btrfs_raid_array[index].devs_min;
>  	devs_increment = btrfs_raid_array[index].devs_increment;
>  	ncopies = btrfs_raid_array[index].ncopies;
> +	nparity = btrfs_raid_array[index].nparity;
>  
>  	if (type & BTRFS_BLOCK_GROUP_DATA) {
>  		max_stripe_size = SZ_1G;
> @@ -4752,13 +4762,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	 * this will have to be fixed for RAID1 and RAID10 over
>  	 * more drives
>  	 */
> -	data_stripes = num_stripes / ncopies;
> -
> -	if (type & BTRFS_BLOCK_GROUP_RAID5)
> -		data_stripes = num_stripes - 1;
> -
> -	if (type & BTRFS_BLOCK_GROUP_RAID6)
> -		data_stripes = num_stripes - 2;
> +	data_stripes = (num_stripes - nparity) / ncopies;
>  
>  	/*
>  	 * Use the number of data stripes to figure out how big this chunk
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 23e9285d88de..0fe005b4295a 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -331,6 +331,8 @@ struct btrfs_raid_attr {
>  	int tolerated_failures; /* max tolerated fail devs */
>  	int devs_increment;	/* ndevs has to be a multiple of this */
>  	int ncopies;		/* how many copies to data has */
> +	int nparity;		/* number of stripes worth of bytes to
> +				   store parity information */

The description can be simplified to: number of parity stripes

>  	int mindev_error;	/* error code if min devs requisite is unmet */
>  	const char raid_name[8]; /* name of the raid */
>  	u64 bg_flag;		/* block group flag of the raid */
> 
