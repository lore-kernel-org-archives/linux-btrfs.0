Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8449FC282DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 16:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 562F120835
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 16:52:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F0LK9nWo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732858AbfDQQwu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 12:52:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55024 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729512AbfDQQwu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 12:52:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HGnGYH071600;
        Wed, 17 Apr 2019 16:52:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=yr51umyzSuE5Pl3UAUeEE3ur81CDNe+yzcXuNlIeyXg=;
 b=F0LK9nWoIRoueg/7dxPxqKxxViUS1v6/fbIPLUwf+wY2GAPnkgLAtLI9bc82bdXhDKyN
 wj2eQY7buaVO44gkSj7ZPOz1Xs8E2yyAgIZY1itfeWaUsJdG8yv6S0lMgElMgELM5kk9
 bFkJDSCljSjQDQCu4+YdU59wr9x0GduyF7f9m7E50zl0/EH7RI4nOU+9tZIspmnjT0Zw
 X3YfmM/FeJiO9Kp7eAp4pZmHr/+KCstZJa3J+7MrtoX69jWJhVK6AShrwiKRrGA+q2n8
 JTZH7VooDE+b5rZkbwY2D3oWQMsmqOL+0d6Gg6ScCz+BeAnbdnL/eLI080st1bMV4s8J yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2rusnf25sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 16:52:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HGqQOw181699;
        Wed, 17 Apr 2019 16:52:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2rubq723w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 16:52:30 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3HGqSmR019970;
        Wed, 17 Apr 2019 16:52:29 GMT
Received: from localhost (/10.159.130.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 09:52:28 -0700
Date:   Wed, 17 Apr 2019 09:52:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, david@fromorbit.com, willy@infradead.org, hch@lst.de,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 08/18] dax: memcpy page in case of IOMAP_DAX_COW for mmap
 faults
Message-ID: <20190417165227.GE4740@magnolia>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
 <20190416164154.30390-9-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416164154.30390-9-rgoldwyn@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170113
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170113
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 11:41:44AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Change dax_iomap_pfn to return the address as well in order to
> use it for performing a memcpy in case the type is IOMAP_DAX_COW.
> 
> Question:
> The sequence of bdev_dax_pgoff() and dax_direct_access() is
> used multiple times to calculate address and pfn's. Would it make
> sense to call it while calculating address as well to reduce code?
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/dax.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 4b4ac51fbd16..45fc2e18969a 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -983,7 +983,7 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
>  }
>  
>  static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
> -			 pfn_t *pfnp)
> +			 pfn_t *pfnp, void **addr)
>  {
>  	const sector_t sector = dax_iomap_sector(iomap, pos);
>  	pgoff_t pgoff;
> @@ -995,7 +995,7 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
>  		return rc;
>  	id = dax_read_lock();
>  	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
> -				   NULL, pfnp);
> +				   addr, pfnp);
>  	if (length < 0) {
>  		rc = length;
>  		goto out;
> @@ -1280,6 +1280,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
>  	struct inode *inode = mapping->host;
>  	unsigned long vaddr = vmf->address;
> +	void *addr;
>  	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
>  	struct iomap iomap = { 0 };
>  	unsigned flags = IOMAP_FAULT;
> @@ -1369,16 +1370,23 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	sync = dax_fault_is_synchronous(flags, vma, &iomap);
>  
>  	switch (iomap.type) {
> +	case IOMAP_DAX_COW:
>  	case IOMAP_MAPPED:
>  		if (iomap.flags & IOMAP_F_NEW) {
>  			count_vm_event(PGMAJFAULT);
>  			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
>  			major = VM_FAULT_MAJOR;
>  		}
> -		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
> +		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn, &addr);
>  		if (error < 0)
>  			goto error_finish_iomap;
>  
> +		if (iomap.type == IOMAP_DAX_COW) {
> +			if (iomap.inline_data)
> +				memcpy(addr, iomap.inline_data, PAGE_SIZE);

Same memcpy_mcsafe question from my reply to patch 4 applies here.

> +			else
> +				memset(addr, 0, PAGE_SIZE);
> +		}
>  		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
>  						 0, write && !sync);
>  
> @@ -1577,7 +1585,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  
>  	switch (iomap.type) {
>  	case IOMAP_MAPPED:
> -		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn);
> +		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn, NULL);

Same (unanswered) question from the v2 series -- doesn't a PMD fault
also require handling IOMAP_DAX_COW?

--D

>  		if (error < 0)
>  			goto finish_iomap;
>  
> -- 
> 2.16.4
> 
