Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50114ECDE47
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 13:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 146D72075D
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 13:58:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="CMWZbZcU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 146D72075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbeJYWbr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 18:31:47 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:44991 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbeJYWbq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 18:31:46 -0400
Received: by mail-yb1-f193.google.com with SMTP id p144-v6so3697434yba.11
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 06:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F5Br1vFFX8kn4xvNIYzxt6g31sDP9kyeqhPTuCAWwfE=;
        b=CMWZbZcUk26TWxuvlEVVEnWf/u+ZmEzy51bIT2e+ufjWLux/wi3X4ip78tUOjrxqkR
         LJ9RAHfY3Mb9f6A20FZ7p0DCVC5j83fuNU6Gj5Is/EgA4ageQy7XplwryVzzjKHitIPh
         FHDUcmQQ2YwSpuMVMROlMuqhsprJ3hO7p0/MMTj8DYDAmqSwX573JqdT/rW3tgPpsIpZ
         G9OA49wUsptxkeRhopoiR26uPmd62dcaoDxCKVkQsK3wV8iMvYav1yAHavVLMYvJvlNV
         vkx2XMjov2dWaz+SkSkQlx3JKwRMamy1UZRQ6WvJshKnhxOF+SzPK+dfsIBBGK5SxaIG
         Xj0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F5Br1vFFX8kn4xvNIYzxt6g31sDP9kyeqhPTuCAWwfE=;
        b=tjHVekQdLOtaxyjnyS65lj8HDvoUneDR2v7hdo5iKLp1KBDDSTVTSCWqNt8kYliM/F
         Y5Lw7LzYIg4AI9ZvXNPDolt/kk8le3xzVPN60gZtqQ2VQcwmFM6xEnr+78G7yRHtAepg
         2KbjnRibKbf3PNxsRhSZOjHKIjxihUdi68AzPsSqE9CTrIKzdZNL4UyU5m56NONznixQ
         LOSYc4CUGFX4vCBw1T6GtdmpwK/Q2kIOZoRWa/A7k93rsZjTqpAW41i7HLKRl7Ku9p/L
         AC5T166yxE06DTp+hlDOdY+6JvY5HqQVNZPCkXEbjWbWFMlbSQasCQH5O9NVKGpd53y/
         NvWQ==
X-Gm-Message-State: AGRZ1gKsBWnKQ3+b4sf91uo4xfw7YzoWGiHdS4v8F3dEOknzLoIwJqnp
        iRIIMXi7uXTPmp14CGyYytEJFw==
X-Google-Smtp-Source: AJdET5dz63rgaQHVqbjRS9jGywKITkZYMc5KkmJQushTy5QwSbnMGU7jG2ymaYr6EUibqPRJJHL7wg==
X-Received: by 2002:a25:c1c5:: with SMTP id r188-v6mr1518174ybf.260.1540475933459;
        Thu, 25 Oct 2018 06:58:53 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:600d])
        by smtp.gmail.com with ESMTPSA id 123-v6sm1994695ywx.15.2018.10.25.06.58.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Oct 2018 06:58:52 -0700 (PDT)
Date:   Thu, 25 Oct 2018 09:58:51 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        david@fromorbit.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        riel@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH 7/7] btrfs: drop mmap_sem in mkwrite for btrfs
Message-ID: <20181025135849.bu3cmjnrvz5yysye@macbook-pro-91.dhcp.thefacebook.com>
References: <20181018202318.9131-1-josef@toxicpanda.com>
 <20181018202318.9131-8-josef@toxicpanda.com>
 <20181025132230.GD7711@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181025132230.GD7711@quack2.suse.cz>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 25, 2018 at 03:22:30PM +0200, Jan Kara wrote:
> On Thu 18-10-18 16:23:18, Josef Bacik wrote:
> > ->page_mkwrite is extremely expensive in btrfs.  We have to reserve
> > space, which can take 6 lifetimes, and we could possibly have to wait on
> > writeback on the page, another several lifetimes.  To avoid this simply
> > drop the mmap_sem if we didn't have the cached page and do all of our
> > work and return the appropriate retry error.  If we have the cached page
> > we know we did all the right things to set this page up and we can just
> > carry on.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ...
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
> I guess this is similar to Dave's comment: Why is i_size so special? What
> makes sure that file didn't get modified between time you've prepared
> cached_page and now such that you need to do the preparation again?
> And if indeed metadata prepared for a page cannot change, what's so special
> about it being that particular cached_page?
> 
> Maybe to phrase my objections differently: Your preparations in
> btrfs_page_mkwrite() are obviously related to your filesystem metadata. So
> why cannot you infer from that metadata (extent tree, whatever - I'd use
> extent status tree in ext4) whether that particular file+offset is already
> prepared for writing and just bail out with success in that case?
> 

I was just being overly paranoid, I was afraid of the case where we would
truncate and then extend in between, but now that I actually think about it that
would end up with the page not being on the mapping anymore so we would catch
that case.  I've dropped this part from my current version.  I'm getting some
testing on these patches in production and I'll post them sometime next week
once I'm happy with them.  Thanks,

Josef
