Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B318C10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 15:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D63E921773
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 15:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x5Hs+CwE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfC1PqM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 11:46:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46652 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfC1PqM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 11:46:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2SFhjuB134735;
        Thu, 28 Mar 2019 15:45:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Rhc9JSQb0hobzxB4+y+WeIHcz73uRvAtrLVsFpd5h1w=;
 b=x5Hs+CwEJjFRKGypZaToYPuC8i6FtFcOV0bc8o2ldX8hy22+M3IcWtEZtiMmHcHwnYfd
 Uz6yzNGT5Y+vRG1o/FSbrcjctcFnZxzV6xnr80RRKjeJABc5/r6s+vXMdcQfShN6/DqK
 Xh4CRXCF6hP5d3USBrk6VIXf/KL5/ujTozUj8aPYbO+n1aOtgbvv2TSVrXMClhyBWR6A
 ZLPMtLUcCIbmQnYAUejKkaf0EE2Udh+lO06VESr2s+Kcwil0UDl/sqKLvr6+TmFATgyT
 nsE6uQhLcRa2uYd/s9emT1KJZ0wV8egCCF311rx63DaFSgtuJTn8kGY5yYnXbHVOrKyf Wg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2re6djqhgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 15:45:47 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2SFjfee018953
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 15:45:42 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2SFjfYY002077;
        Thu, 28 Mar 2019 15:45:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 08:45:40 -0700
Date:   Thu, 28 Mar 2019 08:45:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 09/15] btrfs: add dax mmap support
Message-ID: <20190328154539.GF1172@magnolia>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-10-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326190301.32365-10-rgoldwyn@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9209 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903280106
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 02:02:55PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Add a new vm_operations struct btrfs_dax_vm_ops
> specifically for dax files.
> 
> Since we will be removing(nulling) readpages/writepages for dax
> return ENOEXEC only for non-dax files.
> 
> dax_insert_entry() looks ugly. Do you think we should break it
> into dax_insert_cow_entry() and dax_insert_entry()?

I would (or replace the two bools with flags), but people seem not to
like my stylistic choices. :)

> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/ctree.h |  1 +
>  fs/btrfs/dax.c   | 11 +++++++++++
>  fs/btrfs/file.c  | 18 ++++++++++++++++--
>  fs/dax.c         | 17 ++++++++++-------
>  4 files changed, 38 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 3bcd2a4959c1..0e5060933bde 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3802,6 +3802,7 @@ int btree_readahead_hook(struct extent_buffer *eb, int err);
>  /* dax.c */
>  ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to);
>  ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from);
> +vm_fault_t btrfs_dax_fault(struct vm_fault *vmf);
>  #else
>  static inline ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from)
>  {
> diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
> index 49619fe3f94f..927f962d1e88 100644
> --- a/fs/btrfs/dax.c
> +++ b/fs/btrfs/dax.c
> @@ -157,4 +157,15 @@ ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *iter)
>  	}
>  	return ret;
>  }
> +
> +vm_fault_t btrfs_dax_fault(struct vm_fault *vmf)
> +{
> +	vm_fault_t ret;
> +	pfn_t pfn;
> +	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &pfn, NULL, &btrfs_iomap_ops);
> +	if (ret & VM_FAULT_NEEDDSYNC)
> +		ret = dax_finish_sync_fault(vmf, PE_SIZE_PTE, pfn);
> +
> +	return ret;
> +}
>  #endif /* CONFIG_FS_DAX */
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 3b320d0ab495..196c8f37ff9d 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2214,15 +2214,29 @@ static const struct vm_operations_struct btrfs_file_vm_ops = {
>  	.page_mkwrite	= btrfs_page_mkwrite,
>  };
>  
> +#ifdef CONFIG_FS_DAX
> +static const struct vm_operations_struct btrfs_dax_vm_ops = {
> +	.fault          = btrfs_dax_fault,
> +	.page_mkwrite   = btrfs_dax_fault,
> +	.pfn_mkwrite    = btrfs_dax_fault,
> +};
> +#else
> +#define btrfs_dax_vm_ops btrfs_file_vm_ops
> +#endif
> +
>  static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
>  {
>  	struct address_space *mapping = filp->f_mapping;
> +	struct inode *inode = file_inode(filp);
>  
> -	if (!mapping->a_ops->readpage)
> +	if (!IS_DAX(inode) && !mapping->a_ops->readpage)
>  		return -ENOEXEC;
>  
>  	file_accessed(filp);
> -	vma->vm_ops = &btrfs_file_vm_ops;
> +	if (IS_DAX(inode))
> +		vma->vm_ops = &btrfs_dax_vm_ops;
> +	else
> +		vma->vm_ops = &btrfs_file_vm_ops;
>  
>  	return 0;
>  }
> diff --git a/fs/dax.c b/fs/dax.c
> index 21ee3df6f02c..41061da42771 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c

Whoah, waitaminute, I thought this was a "twiddle stuff inside btrfs
only" patch...

> @@ -708,14 +708,15 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
>   */
>  static void *dax_insert_entry(struct xa_state *xas,
>  		struct address_space *mapping, struct vm_fault *vmf,
> -		void *entry, pfn_t pfn, unsigned long flags, bool dirty)
> +		void *entry, pfn_t pfn, unsigned long flags, bool dirty,
> +		bool cow)
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
>  		if (dax_is_pmd_entry(entry))
> @@ -732,7 +733,7 @@ static void *dax_insert_entry(struct xa_state *xas,
>  		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
>  	}
>  
> -	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
> +	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
>  		/*
>  		 * Only swap our new entry into the page cache if the current
>  		 * entry is a zero page or an empty entry.  If a normal PTE or
> @@ -1031,7 +1032,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
>  	vm_fault_t ret;
>  
>  	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
> -			DAX_ZERO_PAGE, false);
> +			DAX_ZERO_PAGE, false, false);
>  
>  	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
>  	trace_dax_load_hole(inode, vmf, ret);
> @@ -1408,7 +1409,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  			goto error_finish_iomap;
>  
>  		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
> -						 0, write && !sync);
> +						 0, write && !sync,
> +						(iomap.flags & IOMAP_F_COW) != 0);

Assuming you stick with bool cow, you don't need the != 0 test.

>  
>  		/*
>  		 * If we are doing synchronous page fault and inode needs fsync,
> @@ -1487,7 +1489,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
>  
>  	pfn = page_to_pfn_t(zero_page);
>  	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
> -			DAX_PMD | DAX_ZERO_PAGE, false);
> +			DAX_PMD | DAX_ZERO_PAGE, false, false);
>  
>  	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
>  	if (!pmd_none(*(vmf->pmd))) {
> @@ -1610,7 +1612,8 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  			goto finish_iomap;
>  
>  		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
> -						DAX_PMD, write && !sync);
> +						DAX_PMD, write && !sync,
> +						false);

Why don't PMD faults support COW?

--D

>  
>  		/*
>  		 * If we are doing synchronous page fault and inode needs fsync,
> -- 
> 2.16.4
> 
