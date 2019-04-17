Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACD3C282DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 15:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3034B20656
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 15:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TGoPbWsY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732679AbfDQPqO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 11:46:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37054 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732105AbfDQPqN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 11:46:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HFcd0O007282;
        Wed, 17 Apr 2019 15:45:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Rh6gKnWB0sVLqPz0Lq3eTBSyXWNWMtz7I/blLNb7xcI=;
 b=TGoPbWsY3TIdUAgod7mZsSUIsMs431bePJIALIHHHfQcYsYONW5DPfIpVWdftR519+hg
 Xg1evo79xO/MnbROpPeOpzMtO4NzB+0k37OYaGD045fhaDxzM7KSluJiVhjjpyFSa42t
 uFgO0l7ojhvaEc5Tw+ik1nC6sY/fMd0o3qZFHWrn84UP15kHkEf000Q9pTVandu0SYuT
 qnKi5pKwsxrNo0p9HmVL1zpJywGpIDKNOKSe603K5++feitaIZk4xzz0w6VHLwwhOSPT
 XtKXU/MU6lrMfvwDHlt3REXYrCjcVXbABbN/lBKFup+F84796NNo94ZGEni6LSEOvl3a Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2rusnf1sq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 15:45:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HFiB1r064194;
        Wed, 17 Apr 2019 15:45:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2rv2tveudp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 15:45:49 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3HFj6CX008105;
        Wed, 17 Apr 2019 15:45:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 08:45:06 -0700
Date:   Wed, 17 Apr 2019 08:45:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, david@fromorbit.com, willy@infradead.org, hch@lst.de,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 14/18] dax: memcpy before zeroing range
Message-ID: <20190417154504.GC4740@magnolia>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
 <20190416164154.30390-15-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416164154.30390-15-rgoldwyn@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170105
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170105
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 11:41:50AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> However, this needed more iomap fields, so it was easier
> to pass iomap and compute inside the function rather
> than passing a log of arguments.
> 
> Note, there is subtle difference between iomap_sector and
> dax_iomap_sector(). Can we replace dax_iomap_sector with
> iomap_sector()? It would need pos & PAGE_MASK though or else
> bdev_dax_pgoff() return -EINVAL.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/dax.c              | 14 ++++++++++----
>  fs/iomap.c            |  9 +--------
>  include/linux/dax.h   | 11 +++++------
>  include/linux/iomap.h |  6 ++++++
>  4 files changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index abbe4a79f219..af94909640ea 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1055,11 +1055,15 @@ static bool dax_range_is_aligned(struct block_device *bdev,
>  	return true;
>  }
>  
> -int __dax_zero_page_range(struct block_device *bdev,
> -		struct dax_device *dax_dev, sector_t sector,
> -		unsigned int offset, unsigned int size)
> +int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
> +			  unsigned int offset, unsigned int size)
>  {
> -	if (dax_range_is_aligned(bdev, offset, size)) {
> +	sector_t sector = dax_iomap_sector(iomap, pos & PAGE_MASK);
> +	struct block_device *bdev = iomap->bdev;
> +	struct dax_device *dax_dev = iomap->dax_dev;
> +
> +	if (!(iomap->type == IOMAP_DAX_COW) &&
> +	    dax_range_is_aligned(bdev, offset, size)) {
>  		sector_t start_sector = sector + (offset >> 9);
>  
>  		return blkdev_issue_zeroout(bdev, start_sector,
> @@ -1079,6 +1083,8 @@ int __dax_zero_page_range(struct block_device *bdev,
>  			dax_read_unlock(id);
>  			return rc;
>  		}
> +		if (iomap->type == IOMAP_DAX_COW)
> +			memcpy(iomap->inline_data, kaddr, offset);

I'm confused, why are we copying into the source page before zeroing
some part of the dax device?

>  		memset(kaddr + offset, 0, size);
>  		dax_flush(dax_dev, kaddr + offset, size);
>  		dax_read_unlock(id);
> diff --git a/fs/iomap.c b/fs/iomap.c
> index abdd18e404f8..90698c854883 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -98,12 +98,6 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
>  	return written ? written : ret;
>  }
>  
> -static sector_t
> -iomap_sector(struct iomap *iomap, loff_t pos)
> -{
> -	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
> -}
> -
>  static struct iomap_page *
>  iomap_page_create(struct inode *inode, struct page *page)
>  {
> @@ -990,8 +984,7 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
>  static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
>  		struct iomap *iomap)
>  {
> -	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev,
> -			iomap_sector(iomap, pos & PAGE_MASK), offset, bytes);
> +	return __dax_zero_page_range(iomap, pos, offset, bytes);
>  }
>  
>  static loff_t
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index a11bc7b1f526..892c478d7073 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -9,6 +9,7 @@
>  
>  typedef unsigned long dax_entry_t;
>  
> +struct iomap;
>  struct iomap_ops;
>  struct dax_device;
>  struct dax_operations {
> @@ -161,13 +162,11 @@ int dax_file_range_compare(struct inode *src, loff_t srcoff, struct inode *dest,
>                  loff_t destoff, loff_t len, bool *is_same, const struct iomap_ops *ops);
>  
>  #ifdef CONFIG_FS_DAX
> -int __dax_zero_page_range(struct block_device *bdev,
> -		struct dax_device *dax_dev, sector_t sector,
> -		unsigned int offset, unsigned int length);
> +int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
> +		unsigned int offset, unsigned int size);
>  #else
> -static inline int __dax_zero_page_range(struct block_device *bdev,
> -		struct dax_device *dax_dev, sector_t sector,
> -		unsigned int offset, unsigned int length)
> +static inline int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
> +		unsigned int offset, unsigned int size)
>  {
>  	return -ENXIO;
>  }
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 6e885c5a38a3..3a803566dea1 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -7,6 +7,7 @@
>  #include <linux/mm.h>
>  #include <linux/types.h>
>  #include <linux/mm_types.h>
> +#include <linux/blkdev.h>
>  
>  struct address_space;
>  struct fiemap_extent_info;
> @@ -120,6 +121,11 @@ static inline struct iomap_page *to_iomap_page(struct page *page)
>  	return NULL;
>  }
>  
> +static inline sector_t iomap_sector(struct iomap *iomap, loff_t pos)
> +{
> +	        return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;

Why the double indent?

--D

> +}
> +
>  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
>  		const struct iomap_ops *ops);
>  int iomap_readpage(struct page *page, const struct iomap_ops *ops);
> -- 
> 2.16.4
> 
