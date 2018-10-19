Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603DAECDE43
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 03:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC5A2145D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 03:34:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FC5A2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbeJSLiP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 07:38:15 -0400
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:20058
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbeJSLiP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 07:38:15 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail02.adl6.internode.on.net with ESMTP; 19 Oct 2018 14:04:03 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gDLY3-0006ar-00; Fri, 19 Oct 2018 14:34:03 +1100
Date:   Fri, 19 Oct 2018 14:34:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, tj@kernel.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, riel@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH 5/7] mm: add a flag to indicate we used a cached page
Message-ID: <20181019033402.GK18822@dastard>
References: <20181018202318.9131-1-josef@toxicpanda.com>
 <20181018202318.9131-6-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018202318.9131-6-josef@toxicpanda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 18, 2018 at 04:23:16PM -0400, Josef Bacik wrote:
> This is preparation for dropping the mmap_sem in page_mkwrite.  We need
> to know if we used our cached page so we can be sure it is the page we
> already did the page_mkwrite stuff on so we don't have to redo all of
> that work.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  include/linux/mm.h | 6 +++++-
>  mm/filemap.c       | 5 ++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 4a84ec976dfc..a7305d193c71 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -318,6 +318,9 @@ extern pgprot_t protection_map[16];
>  #define FAULT_FLAG_USER		0x40	/* The fault originated in userspace */
>  #define FAULT_FLAG_REMOTE	0x80	/* faulting for non current tsk/mm */
>  #define FAULT_FLAG_INSTRUCTION  0x100	/* The fault was during an instruction fetch */
> +#define FAULT_FLAG_USED_CACHED	0x200	/* Our vmf->page was from a previous
> +					 * loop through the fault handler.
> +					 */
>  
>  #define FAULT_FLAG_TRACE \
>  	{ FAULT_FLAG_WRITE,		"WRITE" }, \
> @@ -328,7 +331,8 @@ extern pgprot_t protection_map[16];
>  	{ FAULT_FLAG_TRIED,		"TRIED" }, \
>  	{ FAULT_FLAG_USER,		"USER" }, \
>  	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
> -	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }
> +	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
> +	{ FAULT_FLAG_USED_CACHED,	"USED_CACHED" }
>  
>  /*
>   * vm_fault is filled by the the pagefault handler and passed to the vma's
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 5212ab637832..e9cb44bd35aa 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2556,6 +2556,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
>  		if (cached_page->mapping == mapping &&
>  		    cached_page->index == offset) {
>  			page = cached_page;
> +			vmf->flags |= FAULT_FLAG_USED_CACHED;

This is really saying the page has been initialised by a prior
fault attempt, not that "we used a cached page". "cached page" is a
horribly overloaded term - I suspect we should not overload it more,
especially as the flag get cleared if the cached page is not up to
date (i.e. the data on it hasn't been fully initialised).

FAULT_FLAG_PAGE_INITIALISED?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
