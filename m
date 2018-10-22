Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DCBC004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 17:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4857020663
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 17:57:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="0AiVyJMl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4857020663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbeJWCQ2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 22:16:28 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39949 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728878AbeJWCQ2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 22:16:28 -0400
Received: by mail-qt1-f194.google.com with SMTP id z9-v6so7116062qto.7
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 10:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=my5wh6X5Z2sj/VWBRX7uC0ClqBKdVPmhq2qlgotFP0U=;
        b=0AiVyJMlWD2ykObNuH0HBjsZhep/bkFPv9/FWWz8mtuDFhtkqPOWAdpZD5pjUnyQ1I
         /zLuH2UQS2KSMAH6YTbZaNtQnV0ffkEAGsLFnjfQSVk6KGrIOfbSnKsw31mXbxuhdh+2
         A+lMVxVjANuTYyF2Jo1TBwzCovT64sYO/WXSOB/sxCRc60t8Hak5vCdLrSmq1yo8IlZ2
         hybMy+NwIQXXYHcQKPyZy4CJkxQdRqbQ7DOfd4PWNU4hRnCo28V4lftCmupIq5ok/lzP
         I18ApYV/U8HaFyYx3Srq4KJ9et7x50O9bxYJwdO2EmIFhSOUWSAr2JB0RYiylhpGEhvU
         +ICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=my5wh6X5Z2sj/VWBRX7uC0ClqBKdVPmhq2qlgotFP0U=;
        b=RPYhOgBWmz7FKPZ/49BuAFX27Xsf6qIt3gNe9gb+C9XY+5GiL0zyjTOU4HQRGw0nUW
         NioDXf/QwrTqeAMU+4pQ342JT7Hom63odvkXUngVamnBK5ykbcqPINlsz+M1yK6n9bqm
         FxQknGpbhWDERLMo5DreEXSZ6Hz80RhgAsuSJwIGy2E4AtAvVOfu34M5VDPsuf1x3FGv
         SEMmmRJhPmeDGiwnUwJVj9sPUGAzY6UNACXWHA/IosBgyW96RqwXAow/YOBUWOYLxRG2
         9GjKJ4uznKs7yRKJCOE39p4GeE3Mc8xXBnfUV2ppes8eIq5NSt9ei3YUgj+EVc0VUr6G
         MHSQ==
X-Gm-Message-State: AGRZ1gJJ/kk4983oiH0hi6N9pSaAuc/3k7RVfYbN/wXbd+KxNNcR6Z4Y
        NRkURPq71t8KpfT2OiBEJvq1T5SiPKXqWQ==
X-Google-Smtp-Source: AJdET5c5EJ+ZK6wu5+7Swvfd47mtgSadeYdDzEHUwmbsoz6W86X7IspSq6Nl3AS2Ts/Csx0GjwmJjw==
X-Received: by 2002:a0c:f7c8:: with SMTP id f8mr6000977qvo.154.1540231016322;
        Mon, 22 Oct 2018 10:56:56 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 70-v6sm7352212qkf.35.2018.10.22.10.56.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Oct 2018 10:56:55 -0700 (PDT)
Date:   Mon, 22 Oct 2018 13:56:54 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, riel@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH 7/7] btrfs: drop mmap_sem in mkwrite for btrfs
Message-ID: <20181022175652.ase7u23uzizqtlao@destiny>
References: <20181018202318.9131-1-josef@toxicpanda.com>
 <20181018202318.9131-8-josef@toxicpanda.com>
 <20181019034847.GM18822@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181019034847.GM18822@dastard>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 19, 2018 at 02:48:47PM +1100, Dave Chinner wrote:
> On Thu, Oct 18, 2018 at 04:23:18PM -0400, Josef Bacik wrote:
> > ->page_mkwrite is extremely expensive in btrfs.  We have to reserve
> > space, which can take 6 lifetimes, and we could possibly have to wait on
> > writeback on the page, another several lifetimes.  To avoid this simply
> > drop the mmap_sem if we didn't have the cached page and do all of our
> > work and return the appropriate retry error.  If we have the cached page
> > we know we did all the right things to set this page up and we can just
> > carry on.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/inode.c   | 41 +++++++++++++++++++++++++++++++++++++++--
> >  include/linux/mm.h | 14 ++++++++++++++
> >  mm/filemap.c       |  3 ++-
> >  3 files changed, 55 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 3ea5339603cf..6b723d29bc0c 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -8809,7 +8809,9 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
> >  vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
> >  {
> >  	struct page *page = vmf->page;
> > -	struct inode *inode = file_inode(vmf->vma->vm_file);
> > +	struct file *file = vmf->vma->vm_file, *fpin;
> > +	struct mm_struct *mm = vmf->vma->vm_mm;
> > +	struct inode *inode = file_inode(file);
> >  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> >  	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
> >  	struct btrfs_ordered_extent *ordered;
> > @@ -8828,6 +8830,29 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
> >  
> >  	reserved_space = PAGE_SIZE;
> >  
> > +	/*
> > +	 * We have our cached page from a previous mkwrite, check it to make
> > +	 * sure it's still dirty and our file size matches when we ran mkwrite
> > +	 * the last time.  If everything is OK then return VM_FAULT_LOCKED,
> > +	 * otherwise do the mkwrite again.
> > +	 */
> > +	if (vmf->flags & FAULT_FLAG_USED_CACHED) {
> > +		lock_page(page);
> > +		if (vmf->cached_size == i_size_read(inode) &&
> > +		    PageDirty(page))
> > +			return VM_FAULT_LOCKED;
> > +		unlock_page(page);
> > +	}
> 
> What does the file size have to do with whether we can use the
> initialised page or not? The file can be extended by other
> data operations (like write()) while a page fault is in progress,
> so I'm not sure how or why this check makes any sense.
> 
> I also don't see anything btrfs specific here, so....
> 

First thanks for the review, I've gone through and addressed everything you
mentioned, however this one is subtle.

The problem is the vmf->vma->vm_file access.  Once we drop the mmap_sem we can
no longer safely go into vmf->vma, so I'd have to fix all the page_mkwrite()'s
to not touch vma, and add a vmf->fpin instead to mess with. Plus I didn't want
to miss some subtlety in other fs's page_mkwrite()'s and inavertedly break them.
If I break btrfs I can fix it, I'm not as good with xfs.

If you want this in the generic layer and not in the fs I can go back and add a
vmf->fpin and vmf->mm, and then fix up all the mkwrite()'s to use that instead
of vmf->vma.  I think that's the only things we care about so it wouldn't be
hard.  Does that sound reasonable to you?

Also the size thing was just a paranoid way to make sure everything had stayed
exactly the same, but you're right, I'll just keep it consistent with all of our
other "is this page ok" checks.  Thanks,

Josef
