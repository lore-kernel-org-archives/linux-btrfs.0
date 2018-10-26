Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4C8C6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B0AB2064A
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:05:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B0AB2064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbeJZTmX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 15:42:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:49402 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbeJZTmX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 15:42:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DB5BBAF63;
        Fri, 26 Oct 2018 11:05:42 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id ABA851E06DB; Fri, 26 Oct 2018 11:47:33 +0200 (CEST)
Date:   Fri, 26 Oct 2018 11:47:33 +0200
From:   Jan Kara <jack@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Jan Kara <jack@suse.cz>, kernel-team@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, david@fromorbit.com,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, riel@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH 7/7] btrfs: drop mmap_sem in mkwrite for btrfs
Message-ID: <20181026094733.GB25227@quack2.suse.cz>
References: <20181018202318.9131-1-josef@toxicpanda.com>
 <20181018202318.9131-8-josef@toxicpanda.com>
 <20181025132230.GD7711@quack2.suse.cz>
 <20181025135849.bu3cmjnrvz5yysye@macbook-pro-91.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181025135849.bu3cmjnrvz5yysye@macbook-pro-91.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu 25-10-18 09:58:51, Josef Bacik wrote:
> On Thu, Oct 25, 2018 at 03:22:30PM +0200, Jan Kara wrote:
> > On Thu 18-10-18 16:23:18, Josef Bacik wrote:
> > > ->page_mkwrite is extremely expensive in btrfs.  We have to reserve
> > > space, which can take 6 lifetimes, and we could possibly have to wait on
> > > writeback on the page, another several lifetimes.  To avoid this simply
> > > drop the mmap_sem if we didn't have the cached page and do all of our
> > > work and return the appropriate retry error.  If we have the cached page
> > > we know we did all the right things to set this page up and we can just
> > > carry on.
> > > 
> > > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ...
> > > @@ -8828,6 +8830,29 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
> > >  
> > >  	reserved_space = PAGE_SIZE;
> > >  
> > > +	/*
> > > +	 * We have our cached page from a previous mkwrite, check it to make
> > > +	 * sure it's still dirty and our file size matches when we ran mkwrite
> > > +	 * the last time.  If everything is OK then return VM_FAULT_LOCKED,
> > > +	 * otherwise do the mkwrite again.
> > > +	 */
> > > +	if (vmf->flags & FAULT_FLAG_USED_CACHED) {
> > > +		lock_page(page);
> > > +		if (vmf->cached_size == i_size_read(inode) &&
> > > +		    PageDirty(page))
> > > +			return VM_FAULT_LOCKED;
> > > +		unlock_page(page);
> > > +	}
> > 
> > I guess this is similar to Dave's comment: Why is i_size so special? What
> > makes sure that file didn't get modified between time you've prepared
> > cached_page and now such that you need to do the preparation again?
> > And if indeed metadata prepared for a page cannot change, what's so special
> > about it being that particular cached_page?
> > 
> > Maybe to phrase my objections differently: Your preparations in
> > btrfs_page_mkwrite() are obviously related to your filesystem metadata. So
> > why cannot you infer from that metadata (extent tree, whatever - I'd use
> > extent status tree in ext4) whether that particular file+offset is already
> > prepared for writing and just bail out with success in that case?
> > 
> 
> I was just being overly paranoid, I was afraid of the case where we would
> truncate and then extend in between, but now that I actually think about it that
> would end up with the page not being on the mapping anymore so we would catch
> that case.  I've dropped this part from my current version.  I'm getting some
> testing on these patches in production and I'll post them sometime next week
> once I'm happy with them.  Thanks,

OK, but do you still need the vmf->cached_page stuff? Because I don't see
why even that is necessary...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
