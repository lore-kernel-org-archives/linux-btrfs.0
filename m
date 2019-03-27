Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8EEC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 17:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7302E2075C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 17:54:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FklUO/rN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbfC0Ryb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 13:54:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43906 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727695AbfC0Ryb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 13:54:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2RHrprg074789;
        Wed, 27 Mar 2019 17:54:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=vw//IQeYnYLQIo5JWn3HtytOeZHORkr5RWBAi0SrpHs=;
 b=FklUO/rN9dnppJlaCfkVDflNOuzwna/QpPgtFgpVhA3xhoTYRorGFtJxp2tL/naBweuO
 WPCRnUiPqif0Nn2PJBMNfpRGViKCucw5V1dU1r+I67FXAKpW5/XD0u5N8HzTRRoCQpfk
 +mDIUCws+8z9+GCWIJdHsJrnvTzZBxqlz/aU+iN3BpVKI58nn5W31TzX9bHA5oZkLmsL
 4lu86QhhiEYmaWZCSh0f+MoIjrDMG4yK5N1dfSXVC+Sw6MDeV2U0j9h0jkE5s+rY62u/
 F/krXpcK6YJtLpxTDGB9d/3zbld78MjV4p+MCc99eN7gIeWdm9phKsNGZYtVuk9vJBMX 9g== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2re6djj848-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Mar 2019 17:54:23 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2RHsHl2001153
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Mar 2019 17:54:17 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2RHsGCg024017;
        Wed, 27 Mar 2019 17:54:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 Mar 2019 10:54:16 -0700
Date:   Wed, 27 Mar 2019 10:54:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 04/15] dax: Introduce IOMAP_F_COW for copy-on-write
Message-ID: <20190327175414.GB1172@magnolia>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-5-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326190301.32365-5-rgoldwyn@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9207 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903270126
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 02:02:50PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> The IOMAP_F_COW is a flag to notify dax that it needs to copy
> the data from iomap->cow_addr to iomap->addr, if the start/end
> of I/O are not page aligned.
> 
> This also introduces dax_to_dax_copy() which performs a copy
> from one part of the device to another, to a maximum of one page.
> 
> Question: Using iomap.cow_addr == 0 means the CoW is to be copied
> (or memset) from a hole. Would this be better handled through a flag?
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/dax.c              | 36 ++++++++++++++++++++++++++++++++++++
>  include/linux/iomap.h |  3 +++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index ca0671d55aa6..e254535dd830 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1051,6 +1051,28 @@ static bool dax_range_is_aligned(struct block_device *bdev,
>  	return true;
>  }
>  
> +static void dax_to_dax_copy(struct iomap *iomap, loff_t pos, void *daddr,
> +			    size_t len)
> +{
> +	loff_t blk_start, blk_pg;
> +	void *saddr;
> +	ssize_t map_len;
> +
> +	/* A zero address is a hole. */
> +	if (iomap->cow_addr == 0) {
> +		memset(daddr, 0, len);
> +		return;
> +	}
> +
> +	blk_start = iomap->cow_addr + pos - iomap->cow_pos;
> +	blk_pg = round_down(blk_start, PAGE_SIZE);
> +
> +	map_len = dax_direct_access(iomap->dax_dev, PHYS_PFN(blk_pg), PAGE_SIZE,
> +			&saddr, NULL);
> +	saddr += blk_start - blk_pg;
> +	memcpy(daddr, saddr, len);
> +}
> +
>  int __dax_zero_page_range(struct block_device *bdev,
>  		struct dax_device *dax_dev, sector_t sector,
>  		unsigned int offset, unsigned int size)
> @@ -1143,6 +1165,20 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  			break;
>  		}
>  
> +		if (iomap->flags & IOMAP_F_COW) {
> +			loff_t pg_end = round_up(end, PAGE_SIZE);
> +			/*
> +			 * Copy the first part of the page
> +			 * Note: we pass offset as length
> +			 */
> +			if (offset)
> +				dax_to_dax_copy(iomap, pos - offset, kaddr, offset);
> +
> +			/* Copy the last part of the range */
> +			if (end < pg_end)
> +				dax_to_dax_copy(iomap, end, kaddr + offset + length, pg_end - end);
> +		}
> +
>  		map_len = PFN_PHYS(map_len);
>  		kaddr += offset;
>  		map_len -= offset;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 0fefb5455bda..391785de1428 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h

Probably a good idea to cc the iomap maintainers on this (entire
patchset)... <cough>

--D

> @@ -35,6 +35,7 @@ struct vm_fault;
>  #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
>  #define IOMAP_F_DIRTY		0x02	/* uncommitted metadata */
>  #define IOMAP_F_BUFFER_HEAD	0x04	/* file system requires buffer heads */
> +#define IOMAP_F_COW		0x08	/* cow before write */
>  
>  /*
>   * Flags that only need to be reported for IOMAP_REPORT requests:
> @@ -59,6 +60,8 @@ struct iomap {
>  	u64			length;	/* length of mapping, bytes */
>  	u16			type;	/* type of mapping */
>  	u16			flags;	/* flags for mapping */
> +	u64			cow_addr; /* read address to perform CoW */
> +	loff_t			cow_pos; /* file offset of cow_addr */
>  	struct block_device	*bdev;	/* block device for I/O */
>  	struct dax_device	*dax_dev; /* dax_dev for dax operations */
>  	void			*inline_data;
> -- 
> 2.16.4
> 
