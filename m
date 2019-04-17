Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558E0C282DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 16:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 264F620835
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 16:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jdu7R5tm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732737AbfDQQrZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 12:47:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49140 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbfDQQrY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 12:47:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HGd84P062934;
        Wed, 17 Apr 2019 16:47:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=dAzZzlzW4BqSVsUKnl3rcAJNjKkzS9NrXYNg0NNxDfE=;
 b=jdu7R5tmOy8WIA7xbveD2+UI3FsXsef2uP9SS6iw1hVLAMuMVaD7IEv+kN0hYBNk5lGM
 HxVgTe8bOjNg9Ytmpt3pxuuPhPizF597x3j1VsvmTITk5X/VMPxuRfrQ+ztdowY68kvo
 EUjIzmV/ALQoD+VazTDesjc4ZW9Y/QwybjAew1vTzUkKE75DgA5QkrQXEjPQ+zrqIaH+
 vzhJtHesyH06AgzjRe/S37ZPD8sm2LuFJ0H1lLkqphpAoVfLXrKD+xtXrESwHWUph8QC
 uCVZ25oaPcKSS/1Umu/KvdgmRjSS6VRYGwETS/u3pYfQrLqznjkde+ZV0a52fQoHqiTk Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2rusnf24w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 16:47:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HGkR3f167890;
        Wed, 17 Apr 2019 16:47:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2rubq721e0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 16:47:02 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3HGl07i016790;
        Wed, 17 Apr 2019 16:47:01 GMT
Received: from localhost (/10.159.130.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 09:47:00 -0700
Date:   Wed, 17 Apr 2019 09:46:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, david@fromorbit.com, willy@infradead.org, hch@lst.de,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 04/18] dax: Introduce IOMAP_DAX_COW to CoW edges during
 writes
Message-ID: <20190417164659.GD4740@magnolia>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
 <20190416164154.30390-5-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416164154.30390-5-rgoldwyn@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170112
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170112
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 11:41:40AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> The IOMAP_DAX_COW is a iomap type which performs copy of
> edges of data while performing a write if start/end are
> not page aligned. The source address is expected in
> iomap->inline_data.
> 
> dax_copy_edges() is a helper functions performs a copy from
> one part of the device to another for data not page aligned.
> If iomap->inline_data is NULL, it memset's the area to zero.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/dax.c              | 41 ++++++++++++++++++++++++++++++++++++++++-
>  include/linux/iomap.h |  1 +
>  2 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index ca0671d55aa6..4b4ac51fbd16 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1083,6 +1083,40 @@ int __dax_zero_page_range(struct block_device *bdev,
>  }
>  EXPORT_SYMBOL_GPL(__dax_zero_page_range);
>  
> +/*
> + * dax_copy_edges - Copies the part of the pages not included in
> + * 		    the write, but required for CoW because
> + * 		    offset/offset+length are not page aligned.
> + */
> +static void dax_copy_edges(struct inode *inode, loff_t pos, loff_t length,
> +			   struct iomap *iomap, void *daddr)
> +{
> +	unsigned offset = pos & (PAGE_SIZE - 1);
> +	loff_t end = pos + length;
> +	loff_t pg_end = round_up(end, PAGE_SIZE);
> +	void *saddr = iomap->inline_data;
> +	/*
> +	 * Copy the first part of the page
> +	 * Note: we pass offset as length
> +	 */
> +	if (offset) {
> +		if (saddr)
> +			memcpy(daddr, saddr, offset);

I've been wondering, do we need memcpy_mcsafe here?

> +		else
> +			memset(daddr, 0, offset);

Or here?

(Or any of the other places we call memcpy/memset in this series...)

Because I think we'd prefer to return EIO on bad pmem over a machine
check.

--D

> +	}
> +
> +	/* Copy the last part of the range */
> +	if (end < pg_end) {
> +		if (saddr)
> +			memcpy(daddr + offset + length,
> +			       saddr + offset + length,	pg_end - end);
> +		else
> +			memset(daddr + offset + length, 0,
> +					pg_end - end);
> +	}
> +}
> +
>  static loff_t
>  dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		struct iomap *iomap)
> @@ -1104,9 +1138,11 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  			return iov_iter_zero(min(length, end - pos), iter);
>  	}
>  
> -	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
> +	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED
> +			 && iomap->type != IOMAP_DAX_COW))

Usually the '&&' goes on the first line, right?

>  		return -EIO;
>  
> +
>  	/*
>  	 * Write can allocate block for an area which has a hole page mapped
>  	 * into page tables. We have to tear down these mappings so that data
> @@ -1143,6 +1179,9 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  			break;
>  		}
>  
> +		if (iomap->type == IOMAP_DAX_COW)
> +			dax_copy_edges(inode, pos, length, iomap, kaddr);

No return value?  So the pmem copy never fails?

--D

> +
>  		map_len = PFN_PHYS(map_len);
>  		kaddr += offset;
>  		map_len -= offset;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 0fefb5455bda..6e885c5a38a3 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -25,6 +25,7 @@ struct vm_fault;
>  #define IOMAP_MAPPED	0x03	/* blocks allocated at @addr */
>  #define IOMAP_UNWRITTEN	0x04	/* blocks allocated at @addr in unwritten state */
>  #define IOMAP_INLINE	0x05	/* data inline in the inode */
> +#define IOMAP_DAX_COW	0x06	/* Copy data pointed by inline_data before write*/
>  
>  /*
>   * Flags for all iomap mappings:
> -- 
> 2.16.4
> 
