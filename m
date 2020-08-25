Return-Path: <SRS0=8sAC=CD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD3FC433E1
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 13:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1577C2075F
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 13:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgHYNco (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 09:32:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:56570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbgHYNcg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Aug 2020 09:32:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 56377AC98;
        Tue, 25 Aug 2020 13:33:03 +0000 (UTC)
Date:   Tue, 25 Aug 2020 08:32:29 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/4] btrfs: basic refactor of btrfs_buffered_write()
Message-ID: <20200825133229.fenl7ybtlfsrh4mu@fiona>
References: <20200825054808.16241-1-wqu@suse.com>
 <20200825114432.GA2873@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825114432.GA2873@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12:44 25/08, Christoph Hellwig wrote:
> Does much refactoring of this code make sense?  Goldwyn has initial
> patches to convert the buffered I/O path to iomap, and I hope that would
> pick up speed now that the direct I/O conversion landed.
> 

Yes. Btrfs needs to handle pages on it's own and needs to lock them
because of extent locking. Page locks need to be performed before extent
locking. If we proceed with converting to iomap, we may have to change
iomap->page_ops->page_prepare to (say) iomap->page_ops->get_page, which
would return the locked page. Not sure if it still makes sense to
convert to iomap for "just" copy_from/to_user().. I will need to perform
tests for that.

Btrfs does want sub-page I/O feature iomap offers. For
that, I still need to figure out a way to for releasepage callback
without using page->private since iomap uses it for iomap_page_private.

-- 
Goldwyn
