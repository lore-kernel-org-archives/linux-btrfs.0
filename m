Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB58CC282DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 15:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99FF720652
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 15:27:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="loJynm65"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732741AbfDQP1v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 11:27:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57380 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732736AbfDQP1v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 11:27:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HFJ8oj167842;
        Wed, 17 Apr 2019 15:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=nlq8yIfjLOXxziWjU7ZRWZ5V5Wk9mZ0HLZBlU6kpdUM=;
 b=loJynm65X0NyBOqMxaepCrOqllHBahAbE8eZ/JSsz4TiIviJnuXGJJ2tENFzxfwCnT6T
 xe6FAGmSUIqitDH2M07Q5GIVKu0R9Ej7TDqX4N2oHZ0LT8p13ulgp3MeXv6wL0B0vTDj
 rKeKvl0eGH+ousInwXqM/Zg9is7Z9aifo6KUzQtx7RQ7W2WXhh0tjXxpUCqxiSnDpPp+
 ygwqMxlVL+GkO2CzhNGUsppap2qiOdyuaruSi/7aQPedJqvwD0/H60rF8BMEUowy/seo
 fSURBXDIWagwnYcREqYMn6BTAh+mHzQpwKUT+CVxdF6XkZXY5/yzlsQqh/ITFSxt34fw Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2rvwk3usxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 15:26:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HFO8Mn167134;
        Wed, 17 Apr 2019 15:24:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2rwe7afdqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 15:24:58 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3HFOtTX009582;
        Wed, 17 Apr 2019 15:24:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 08:24:54 -0700
Date:   Wed, 17 Apr 2019 08:24:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, david@fromorbit.com, willy@infradead.org, hch@lst.de,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 10/18] dax: replace mmap entry in case of CoW
Message-ID: <20190417152453.GA4740@magnolia>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
 <20190416164154.30390-11-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416164154.30390-11-rgoldwyn@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170104
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170104
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 11:41:46AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> We replace the existing entry to the newly allocated one
> in case of CoW. Also, we mark the entry as PAGECACHE_TAG_TOWRITE
> so writeback marks this entry as writeprotected. This
> helps us snapshots so new write pagefaults after snapshots
> trigger a CoW.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/dax.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 45fc2e18969a..d5100cbe8bd2 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -708,14 +708,15 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
>   */
>  static void *dax_insert_entry(struct xa_state *xas,
>  		struct address_space *mapping, struct vm_fault *vmf,
> -		void *entry, pfn_t pfn, unsigned long flags, bool dirty)
> +		void *entry, pfn_t pfn, unsigned long flags, bool dirty,
> +		bool cow)

I still wish these were flags instead of double booleans that will be
easy to mix up, especially since this is a static function and nobody
else has to see the flags...

#define IE_DIRTY	(1 << 0) /* mark entry and inode dirty */
#define IE_REPLACE	(1 << 1) /* replacing one page with another */

...otoh maybe I'll just defer to the maintainer. :)

>  {
>  	void *new_entry = dax_make_entry(pfn, flags);
>  
>  	if (dirty)
>  		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>  
> -	if (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE)) {
> +	if (cow || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
>  		unsigned long index = xas->xa_index;
>  		/* we are replacing a zero page with block mapping */

These comments need updating.

Otherwise looks good to me...

--D

>  		if (dax_is_pmd_entry(entry))
> @@ -727,12 +728,12 @@ static void *dax_insert_entry(struct xa_state *xas,
>  
>  	xas_reset(xas);
>  	xas_lock_irq(xas);
> -	if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
> +	if (cow || (dax_entry_size(entry) != dax_entry_size(new_entry))) {
>  		dax_disassociate_entry(entry, mapping, false);
>  		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
>  	}
>  
> -	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
> +	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
>  		/*
>  		 * Only swap our new entry into the page cache if the current
>  		 * entry is a zero page or an empty entry.  If a normal PTE or
> @@ -752,6 +753,9 @@ static void *dax_insert_entry(struct xa_state *xas,
>  	if (dirty)
>  		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
>  
> +	if (cow)
> +		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
> +
>  	xas_unlock_irq(xas);
>  	return entry;
>  }
> @@ -1031,7 +1035,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
>  	vm_fault_t ret;
>  
>  	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
> -			DAX_ZERO_PAGE, false);
> +			DAX_ZERO_PAGE, false, false);
>  
>  	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
>  	trace_dax_load_hole(inode, vmf, ret);
> @@ -1388,7 +1392,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  				memset(addr, 0, PAGE_SIZE);
>  		}
>  		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
> -						 0, write && !sync);
> +						 0, write && !sync,
> +						 iomap.type == IOMAP_DAX_COW);
>  
>  		/*
>  		 * If we are doing synchronous page fault and inode needs fsync,
> @@ -1467,7 +1472,8 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
>  
>  	pfn = page_to_pfn_t(zero_page);
>  	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
> -			DAX_PMD | DAX_ZERO_PAGE, false);
> +			DAX_PMD | DAX_ZERO_PAGE, false,
> +			iomap->type == IOMAP_DAX_COW);
>  
>  	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
>  	if (!pmd_none(*(vmf->pmd))) {
> @@ -1590,7 +1596,8 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  			goto finish_iomap;
>  
>  		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
> -						DAX_PMD, write && !sync);
> +						DAX_PMD, write && !sync,
> +						false);
>  
>  		/*
>  		 * If we are doing synchronous page fault and inode needs fsync,
> -- 
> 2.16.4
> 
