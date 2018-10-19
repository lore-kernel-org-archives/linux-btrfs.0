Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5B5ECDE44
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 03:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03C0C21476
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 03:44:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03C0C21476
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbeJSLsh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 07:48:37 -0400
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:14612 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbeJSLsh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 07:48:37 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl2.internode.on.net with ESMTP; 19 Oct 2018 13:51:55 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gDLMI-0006a3-Jn; Fri, 19 Oct 2018 14:21:54 +1100
Date:   Fri, 19 Oct 2018 14:21:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, tj@kernel.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, riel@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH 3/7] mm: drop the mmap_sem in all read fault cases
Message-ID: <20181019032154.GI18822@dastard>
References: <20181018202318.9131-1-josef@toxicpanda.com>
 <20181018202318.9131-4-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018202318.9131-4-josef@toxicpanda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 18, 2018 at 04:23:14PM -0400, Josef Bacik wrote:
> Johannes' patches didn't quite cover all of the IO cases that we need to
> drop the mmap_sem for, this patch covers the rest of them.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  mm/filemap.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 1ed35cd99b2c..65395ee132a0 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2523,6 +2523,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
>  	int error;
>  	struct mm_struct *mm = vmf->vma->vm_mm;
>  	struct file *file = vmf->vma->vm_file;
> +	struct file *fpin = NULL;
>  	struct address_space *mapping = file->f_mapping;
>  	struct file_ra_state *ra = &file->f_ra;
>  	struct inode *inode = mapping->host;
> @@ -2610,11 +2611,15 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
>  	return ret | VM_FAULT_LOCKED;
>  
>  no_cached_page:
> +	fpin = maybe_unlock_mmap_for_io(vmf->vma, vmf->flags);
> +
>  	/*
>  	 * We're only likely to ever get here if MADV_RANDOM is in
>  	 * effect.
>  	 */
>  	error = page_cache_read(file, offset, vmf->gfp_mask);
> +	if (fpin)
> +		goto out_retry;

Please put the unlock after the comment explaining the goto label
so it's clear that the pin is associated only with the read
operations like so:

no_cached_page:
	/*
	 * We're only likely to ever get here if MADV_RANDOM is in
	 * effect.
	 */
	fpin = maybe_unlock_mmap_for_io(vmf->vma, vmf->flags);
	error = page_cache_read(file, offset, vmf->gfp_mask);
	if (fpin)
		goto out_retry;
>  
>  	/*
>  	 * The page we want has now been added to the page cache.
> @@ -2634,6 +2639,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
>  	return VM_FAULT_SIGBUS;
>  
>  page_not_uptodate:
> +	fpin = maybe_unlock_mmap_for_io(vmf->vma, vmf->flags);
> +
>  	/*
>  	 * Umm, take care of errors if the page isn't up-to-date.
>  	 * Try to re-read it _once_. We do this synchronously,

Same here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
