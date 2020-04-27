Return-Path: <SRS0=C73g=6L=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F89C55199
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Apr 2020 05:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 537D22075B
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Apr 2020 05:54:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VNo0SLzA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgD0Fy3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 01:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726221AbgD0Fy3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Apr 2020 01:54:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E6BC061A0F;
        Sun, 26 Apr 2020 22:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VIbo6voS8su7pBgW6QNQX9T1AnhQ/gr6+hSotvAjdrw=; b=VNo0SLzA18Ne9P9sHHtq9QWzV/
        caSidokmLnLyClnfmsnhtgIJ3o3r94Cw7yjxpQsHG0zgqqyoXWY0ew2Zn7vOtJYxKbNGRTeBgvTbn
        CgmwUIHiZy/D0rBviqHyNz5EW9BFpFAgfY5sB61+1xTN4KSIKmdyjkSIbHrDRbmbg0Ni95cNaWTCx
        3uDFhtflbYzYcQNAfwjCa6xWCozXDEdvOamkrQg26/M/WNWOxh1/5wy8c63YA1dAAMbNy4vQA+40g
        cIOiVIElQnx/Oj1On16HRtNgcgQccVybdfcdccPDZmxjsrdMvpsNyVEMcVu3cRKH73BVRr+gzKdru
        ix92/ZvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSwiq-0005BE-Af; Mon, 27 Apr 2020 05:54:28 +0000
Date:   Sun, 26 Apr 2020 22:54:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, willy@infradead.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 3/9] btrfs: use set/clear_fs_page_private
Message-ID: <20200427055428.GB16709@infradead.org>
References: <20200426214925.10970-1-guoqing.jiang@cloud.ionos.com>
 <20200426214925.10970-4-guoqing.jiang@cloud.ionos.com>
 <20200426222054.GA2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426222054.GA2005@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 27, 2020 at 08:20:54AM +1000, Dave Chinner wrote:
> >  void set_page_extent_mapped(struct page *page)
> >  {
> > -	if (!PagePrivate(page)) {
> > -		SetPagePrivate(page);
> > -		get_page(page);
> > -		set_page_private(page, EXTENT_PAGE_PRIVATE);
> > -	}
> > +	if (!PagePrivate(page))
> > +		set_fs_page_private(page, (void *)EXTENT_PAGE_PRIVATE);
> 
> Change the definition of EXTENT_PAGE_PRIVATE so the cast is not
> needed? Nothing ever reads EXTENT_PAGE_PRIVATE; it's only there to
> set the private flag for other code to check and release the extent
> mapping reference to the page...

IIRC there as a patch on the btrfs list to remove EXTENT_PAGE_PRIVATE,
it might be better to not bother changing it.  Maybe the btrfs
maintainers remember this better.
