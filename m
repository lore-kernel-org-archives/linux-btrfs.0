Return-Path: <SRS0=txhb=62=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB13CA90AF
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 May 2020 17:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D01205ED
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 May 2020 17:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgELRTb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 May 2020 13:19:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:57136 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgELRTb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 May 2020 13:19:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 237C6AC4D;
        Tue, 12 May 2020 17:19:33 +0000 (UTC)
Date:   Tue, 12 May 2020 12:19:27 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/9] btrfs: Switch to iomap_dio_rw() for dio
Message-ID: <20200512171927.tk46sbriqvhasvsq@fiona>
References: <20200326210254.17647-5-rgoldwyn@suse.de>
 <20200327081024.GA24827@infradead.org>
 <20200327161348.to4upflzczkbbpfo@fiona>
 <20200507061430.GA8939@infradead.org>
 <20200507113741.GJ18421@twin.jikos.cz>
 <20200507121037.GA25363@infradead.org>
 <20200508031405.br4dcibcyuoluxum@fiona>
 <20200509135914.GA4962@infradead.org>
 <20200510040601.bub3du7g5kepeakw@fiona>
 <20200512145807.GA23409@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512145807.GA23409@infradead.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On  7:58 12/05, Christoph Hellwig wrote:
> On Sat, May 09, 2020 at 11:06:01PM -0500, Goldwyn Rodrigues wrote:
> > > > We cannot perform data reservations and release in iomap_begin() and
> > > > iomap_end() for performance and accounting issues.
> > > 
> > > So just drop "btrfs: Use ->iomap_end() instead of btrfs_dio_data"
> > > from the series and be done with it?
> > 
> > We are using current->journal_info for fdatawrite sequence hence using
> > that as a temporary pointer does not work since iomap_dio_rw() performs
> > the fdatawrite sequence.
> 
> Ok. but in that case they never really should have been separate patches.
> 

Yes, I realized it when I was dealing with this problem.

> Can someone help me to understand who consumes the reservation create by
> btrfs_delalloc_reserve_space?  Most importantly if this is done by
> something called from btrfs_dio_iomap_begin or from btrfs_submit_direct.

It is consumed in
btrfs_finish_ordered_io()->..btrfs_cow_block()->..btrfs_use_block_rsv().
So, it is a queued work from __end_write_update_ordered().

I am also understanding the way this reservation system works so I may
not be 100% correct.

More details are in the starting comments of fs/btrfs/block-rsv.c

-- 
Goldwyn
