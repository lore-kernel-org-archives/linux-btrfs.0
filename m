Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48CBECDE3D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 03:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8611B21470
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 03:50:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8611B21470
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbeJSLyi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 07:54:38 -0400
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:45215 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726478AbeJSLyi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 07:54:38 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl2.internode.on.net with ESMTP; 19 Oct 2018 13:57:23 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gDLRa-0006aP-Eq; Fri, 19 Oct 2018 14:27:22 +1100
Date:   Fri, 19 Oct 2018 14:27:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, tj@kernel.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, riel@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH 4/7] mm: use the cached page for filemap_fault
Message-ID: <20181019032722.GJ18822@dastard>
References: <20181018202318.9131-1-josef@toxicpanda.com>
 <20181018202318.9131-5-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018202318.9131-5-josef@toxicpanda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 18, 2018 at 04:23:15PM -0400, Josef Bacik wrote:
> If we drop the mmap_sem we have to redo the vma lookup which requires
> redoing the fault handler.  Chances are we will just come back to the
> same page, so save this page in our vmf->cached_page and reuse it in the
> next loop through the fault handler.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  mm/filemap.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 65395ee132a0..5212ab637832 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2530,13 +2530,38 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
>  	pgoff_t offset = vmf->pgoff;
>  	int flags = vmf->flags;
>  	pgoff_t max_off;
> -	struct page *page;
> +	struct page *page = NULL;
> +	struct page *cached_page = vmf->cached_page;
>  	vm_fault_t ret = 0;
>  
>  	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
>  	if (unlikely(offset >= max_off))
>  		return VM_FAULT_SIGBUS;
>  
> +	/*
> +	 * We may have read in the page already and have a page from an earlier
> +	 * loop.  If so we need to see if this page is still valid, and if not
> +	 * do the whole dance over again.
> +	 */
> +	if (cached_page) {
> +		if (flags & FAULT_FLAG_KILLABLE) {
> +			error = lock_page_killable(cached_page);
> +			if (error) {
> +				up_read(&mm->mmap_sem);
> +				goto out_retry;
> +			}
> +		} else
> +			lock_page(cached_page);
> +		vmf->cached_page = NULL;
> +		if (cached_page->mapping == mapping &&
> +		    cached_page->index == offset) {
> +			page = cached_page;
> +			goto have_cached_page;
> +		}
> +		unlock_page(cached_page);
> +		put_page(cached_page);
> +	}
> +

Can you factor this out so the main code path doesn't get any more
complex than it already is? i.e. something like:

	error = vmf_has_cached_page(vmf, &page);
	if (error)
		goto out_retry;
	if (page)
		goto have_cached_page;

-dave.

-- 
Dave Chinner
david@fromorbit.com
