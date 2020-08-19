Return-Path: <SRS0=vkwB=B5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2095C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Aug 2020 11:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86EB4206DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Aug 2020 11:23:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MhyJYE5k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgHSLXD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 07:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbgHSLW4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Aug 2020 07:22:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8265BC061757;
        Wed, 19 Aug 2020 04:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vm/n+cq2+QZEBwpYmocpy9sE7SxCxGiFYNzTqy/WpRw=; b=MhyJYE5kDP6jGVCT9D1aHQ+tOx
        xR2RKmfgtowqZGyHUz6qNchzvWrsM09Sn/E68pAk84Zk5JM4RFGhMbgsklDvO9AqpF3nDdnqg1w6a
        LHtqoP1Ds7rIKVNz5/3BZSt/kAksFiLt+tgo1CI/sPAMQvoaVmh5ai84ChIzZQYg61NdaisntfW3y
        hn9cG/tFD92Mz7u3JmdLpV2VpYrC95ITnPoAjlL2zdSTeGvIQGp5oL5cMy6wc3cBL6FPjv6skIlvB
        pTmto1Z8XZnygjEtsQ7RWLJ9GJElIgW6wqf6Iz+udeH46tTqEO7GeNPciFCSLcmnfN7CiLwwQa5tD
        cc3HNgpg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8MBB-0001Kc-09; Wed, 19 Aug 2020 11:22:53 +0000
Date:   Wed, 19 Aug 2020 12:22:52 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Is there anyway to ensure iov iter won't break a page copy?
Message-ID: <20200819112252.GZ17456@casper.infradead.org>
References: <5a2d6a48-9407-7c81-f12a-9e66abdf927f@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a2d6a48-9407-7c81-f12a-9e66abdf927f@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 19, 2020 at 06:59:48PM +0800, Qu Wenruo wrote:
> There are tons of short copy check for iov_iter_copy_from_user_atomic(),
> from the generic_performan_write() which checks the copied in the
> write_end().
> 
> To iomap, which checks the copied in its iomap_write_end().
> 
> But I'm wondering, all these call sites have called
> iov_iter_falut_in_read() to ensure the range we're copying from are
> accessible, and we prepared the pages by ourselves, how could a short
> copy happen?

Here's how it happens.  The system is low on memory.  We fault in the
range that we're interested in, which (for the sake of argument is a
file mapping; similar things can happen for anonymous memory) allocates
page cache pages and fills them with data.  Now another task runs and
also allocates memory.  The pages we want get reclaimed (we don't have
a refcount on them, so this can happen).  Now when we go to access
them again, they're not there.

> Is there any possible race that user space can invalidate some of its
> memory of the iov?
> 
> If so, can we find a way to lock the iov to ensure all its content can
> be accessed without problem until the iov_iter_copy_from_user_atomic()
> finishes?

Probably a bad idea.  The I/O might be larger than all of physical memory,
so we might not be able to pin all of the pages for the duration of
the I/O.

