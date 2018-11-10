Return-Path: <SRS0=TwUB=NV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39F7C43441
	for <linux-btrfs@archiver.kernel.org>; Sat, 10 Nov 2018 23:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D0352089A
	for <linux-btrfs@archiver.kernel.org>; Sat, 10 Nov 2018 23:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uMW+77cH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D0352089A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbeKKJHz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 04:07:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51800 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbeKKJHz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 04:07:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAANKNig044546;
        Sat, 10 Nov 2018 23:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=JYbArTvG/wmexD+o7emcUBs6axhnI+cViWyiO+OjGQ8=;
 b=uMW+77cHVqGJHalW741SH3SFWdITOCEs3/7N0x3071ILEG00HZL5rHDK9U0YKFrBOyRu
 Sj5MCbP6aAC10WZJX5ZlpNjqYfG+3o0bVnWp1vAtMAHChCfPdbXwngN0O+PKkE1shU/F
 4qigA13gKmNTcItv+3YVkB3rjRJ9AK10hM7nvowvAhnZ1HEr70zlSdQTAThMw9yymKG2
 ffuXfUPgTAnosvoW0r8JntgZB+u2fcssEB2/ExmJxRuZx+5857jCTvJUrdvqIpGsg+BN
 fRGIvMDoc0SYNkgEuCyuTbx5bH/aycd8U2pTn2aKPjr9JR/aFK0uIHTDlOmZ2Rdjx9fk Fg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2nnw6e9098-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Nov 2018 23:21:12 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAANL6gL006567
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Nov 2018 23:21:06 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAANL5qK027075;
        Sat, 10 Nov 2018 23:21:06 GMT
Received: from [172.20.10.2] (/183.90.37.226)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 10 Nov 2018 15:21:05 -0800
Subject: Re: [PATCH] btrfs: Check for missing device before bio submission in
 btrfs_map_bio
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20181108141638.31681-1-nborisov@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <332f0c06-2bd8-1e2a-e073-2758f6d5a56f@oracle.com>
Date:   Sun, 11 Nov 2018 07:21:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181108141638.31681-1-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9073 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811100185
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/08/2018 10:16 PM, Nikolay Borisov wrote:
> Before btrfs_map_bio submits all stripe bio it does a number of checks
> to ensure the device for every stripe is present. However, it doesn't
> do a DEV_STATE_MISSING check, instead this is relegated to the lower
> level btrfs_schedule_bio (in the async submission case, sync submission
> doesn't check DEV_STATE_MISSING at all). Additionally
> btrfs_schedule_bios does the duplicate device->bdev check which has
> already been performed in btrfs_map_bio.
> 
> This patch moves the DEV_STATE_MISSING check in btrfs_map_bio and
> removes the duplicate device->bdev check. Doing so ensures that no bio
> cloning/submission happens for both async/sync requests in the face of
> missing device. This makes the async io submission path slightly shorter
> in terms of instruction count. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>   fs/btrfs/volumes.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 44c5e8ccb644..3312cad65209 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6106,12 +6106,6 @@ static noinline void btrfs_schedule_bio(struct btrfs_device *device,
>   	int should_queue = 1;
>   	struct btrfs_pending_bios *pending_bios;
>   
> -	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state) ||
> -	    !device->bdev) {
> -		bio_io_error(bio);
> -		return;
> -	}
> -
>   	/* don't bother with additional async steps for reads, right now */
>   	if (bio_op(bio) == REQ_OP_READ) {
>   		btrfsic_submit_bio(bio);
> @@ -6240,7 +6234,8 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
>   
>   	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
>   		dev = bbio->stripes[dev_nr].dev;
> -		if (!dev || !dev->bdev ||
> +		if (!dev || !dev->bdev || test_bit(BTRFS_DEV_STATE_MISSING,
> +						   &dev->dev_state) ||
>   		    (bio_op(first_bio) == REQ_OP_WRITE &&
>   		    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))) {
>   			bbio_error(bbio, first_bio, logical);
> 
