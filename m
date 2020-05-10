Return-Path: <SRS0=0CDI=6Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F7BC35280
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 May 2020 04:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62A4F20722
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 May 2020 04:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgEJEGG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 May 2020 00:06:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:41710 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbgEJEGG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 May 2020 00:06:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CE4B3AEA3;
        Sun, 10 May 2020 04:06:07 +0000 (UTC)
Date:   Sat, 9 May 2020 23:06:01 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/9] btrfs: Switch to iomap_dio_rw() for dio
Message-ID: <20200510040601.bub3du7g5kepeakw@fiona>
References: <20200326210254.17647-1-rgoldwyn@suse.de>
 <20200326210254.17647-5-rgoldwyn@suse.de>
 <20200327081024.GA24827@infradead.org>
 <20200327161348.to4upflzczkbbpfo@fiona>
 <20200507061430.GA8939@infradead.org>
 <20200507113741.GJ18421@twin.jikos.cz>
 <20200507121037.GA25363@infradead.org>
 <20200508031405.br4dcibcyuoluxum@fiona>
 <20200509135914.GA4962@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509135914.GA4962@infradead.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On  6:59 09/05, Christoph Hellwig wrote:
> On Thu, May 07, 2020 at 10:14:05PM -0500, Goldwyn Rodrigues wrote:
> > geenric/475 fails because there are reservations left in the inode's
> > block reservations system which are not cleared out. So the system
> > triggers WARN_ON() while performing destroy_inode.
> > 
> > The problem is similar to described in:
> > 50745b0a7f46 ("Btrfs: Direct I/O: Fix space accounting")
> > 
> > To test the theory, I framed an ugly patch of using an extra field
> > in current-> task_struct to store a number which carries the reservation
> > currently remaining like the patch does and it works. So what we need is
> > a way to carry reservation information from btrfs_direct_write() to
> > iomap's direct ops ->submit_io() where the reservations are consumed.
> > 
> > We cannot use a similar solution of using current->journal_info
> > because fdatawrite sequence in iomap_dio_rw() uses
> > current->journal_info.
> > 
> > We cannot perform data reservations and release in iomap_begin() and
> > iomap_end() for performance and accounting issues.
> 
> So just drop "btrfs: Use ->iomap_end() instead of btrfs_dio_data"
> from the series and be done with it?

We are using current->journal_info for fdatawrite sequence hence using
that as a temporary pointer does not work since iomap_dio_rw() performs
the fdatawrite sequence.

-- 
Goldwyn
