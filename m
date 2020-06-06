Return-Path: <SRS0=rRh3=7T=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E790AC433E0
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Jun 2020 03:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1A1B20723
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Jun 2020 03:14:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kokRMdy9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgFFDOF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 23:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728506AbgFFDOF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jun 2020 23:14:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D143C08C5C2;
        Fri,  5 Jun 2020 20:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1BrkHY9S/k3MVQiB0H5PSL2SCm/KMOh5iXjQyg7vRA4=; b=kokRMdy9d9tCcLDjbKUnuPgFs9
        f84UqG95kS6fiykPUXnU4MK1TX0DI0t3Ljf8VirBwPwOhsW7LatC6TlCW0vBcCQE5jG1XmwS2NzPE
        +lmcUEq/gFxI8CvQQQg0lLERExA9mmdPAt2ZxLKrra2x503KxbHa9VVWaI1PZd4XErFy9IuT0N+qR
        A1LgIZ8Tsn3xNutC4AiwlwStT321O+wbN+BxZMa/+WDhAULF1CJnRVk/eMyA3l23h7b1ZrO48/PUG
        IbRwFiRgb2YxnPsGrHRJ0rFM1BZzCFUUMDJXOqj0vFMZOZmuuz2LiSuptFQc9oTnWMkaO+SSQf7qW
        qmlfPrbQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jhPHT-0004dr-Lv; Sat, 06 Jun 2020 03:13:59 +0000
Date:   Fri, 5 Jun 2020 20:13:59 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     darrick.wong@oracle.com, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, linux-fsdevel@vger.kernel.org, hch@lst.de,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 1/3] iomap: dio Return zero in case of unsuccessful
 pagecache invalidation
Message-ID: <20200606031359.GL19604@bombadil.infradead.org>
References: <20200605204838.10765-1-rgoldwyn@suse.de>
 <20200605204838.10765-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605204838.10765-2-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jun 05, 2020 at 03:48:36PM -0500, Goldwyn Rodrigues wrote:
> Return zero in case a page cache invalidation is unsuccessful so
> filesystems can fallback to buffered I/O.

I don't think it's acceptable to change common code to fix a btrfs bug
at this point in the release cycle.  This change needs to be agreed to
before the -rc5 stage, not during the pre-rc1 window.

If you can't fix this in btrfs alone, then back out the btrfs changes
for now.
