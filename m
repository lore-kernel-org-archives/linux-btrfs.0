Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F2EECDE3D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 03:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDBC92145D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 03:36:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDBC92145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbeJSLk0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 07:40:26 -0400
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:55887
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726478AbeJSLk0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 07:40:26 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail02.adl6.internode.on.net with ESMTP; 19 Oct 2018 14:06:12 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gDLa8-0006bD-Ep; Fri, 19 Oct 2018 14:36:12 +1100
Date:   Fri, 19 Oct 2018 14:36:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, tj@kernel.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, riel@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH 6/7] mm: allow ->page_mkwrite to do retries
Message-ID: <20181019033612.GL18822@dastard>
References: <20181018202318.9131-1-josef@toxicpanda.com>
 <20181018202318.9131-7-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018202318.9131-7-josef@toxicpanda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 18, 2018 at 04:23:17PM -0400, Josef Bacik wrote:
> Before we didn't set the retry flag on our vm_fault.  We want to allow
> file systems to drop the mmap_sem if they so choose, so set this flag
> and deal with VM_FAULT_RETRY appropriately.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  mm/memory.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 433075f722ea..c5e81edd94f9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2384,11 +2384,13 @@ static vm_fault_t do_page_mkwrite(struct vm_fault *vmf)
>  	unsigned int old_flags = vmf->flags;
>  
>  	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
> +	vmf->flags |= old_flags & FAULT_FLAG_ALLOW_RETRY;
>  
>  	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
>  	/* Restore original flags so that caller is not surprised */
>  	vmf->flags = old_flags;


> -	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
> +	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
> +			    VM_FAULT_RETRY)))

Mess.

#define __FAIL_FLAGS	(VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)
	if (ret & __FAIL_FLAGS)

Should kill the unlikely() at the same time.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
