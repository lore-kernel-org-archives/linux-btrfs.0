Return-Path: <SRS0=HFAs=UZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49FEC48BD5
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Jun 2019 03:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 801AF20883
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Jun 2019 03:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfFZDDH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Jun 2019 23:03:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:45960 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726077AbfFZDDH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jun 2019 23:03:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 341CEAEAA;
        Wed, 26 Jun 2019 03:03:06 +0000 (UTC)
Date:   Tue, 25 Jun 2019 22:03:03 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] iomap: Check iblocksize before transforming
 page->private
Message-ID: <20190626030303.2suclansmshwufqv@fiona>
References: <20190621192828.28900-1-rgoldwyn@suse.de>
 <20190621192828.28900-4-rgoldwyn@suse.de>
 <20190624070536.GA3675@lst.de>
 <20190625185659.tqaikm27onz6g3jt@fiona>
 <CAL3q7H5eS9_KHwxDrkCGV1aVXvBdmJ-1UaGUnEcwRARr6pGzKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H5eS9_KHwxDrkCGV1aVXvBdmJ-1UaGUnEcwRARr6pGzKw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 21:04 25/06, Filipe Manana wrote:
> On Tue, Jun 25, 2019 at 8:58 PM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> >
> > On  9:05 24/06, Christoph Hellwig wrote:
> > > On Fri, Jun 21, 2019 at 02:28:25PM -0500, Goldwyn Rodrigues wrote:
> > > > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > > >
> > > > btrfs uses page->private as well to store extent_buffer. Make
> > > > the check stricter to make sure we are using page->private for iop by
> > > > comparing iblocksize < PAGE_SIZE.
> > > >
> > > > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > >
> > > If btrfs uses page->private itself and also uses functions that call
> > > to_iomap_page we have a major problem, as we now have a usage conflict.
> > >
> > > How do you end up here?
> > >
> >
> > Btrfs uses page->private to identify which extent_buffer it belongs to.
> > So, if you read, it fills the page->private. Then you try to write to
> > it, iomap will assume it to be iomap_page pointer.
> >
> > I don't think we can move extent_buffer out of page->private for btrfs.
> > Any other ideas?
> 
> The extent buffer is only for pages belonging to the btree inode (i.e.
> pages that correspond to a btree node/lead).
> Haven't looked in detail to this patchset, but you can't do buffered
> writes or direct IO against the btree inode, can you?
> So for file inodes, this problem doesn't exist.

Why do we call set_page_extent_mapped(page) in lock_and_cleanup_extent_if_needed() or __do_readpage()?

I must admit, the backtrace crashes that I saw had the page->private set to
EXTENT_PAGE_PRIVATE rather than the extent_buffer pointer. Does that mean
calling this function is not necessary in these codepaths?

-- 
Goldwyn
