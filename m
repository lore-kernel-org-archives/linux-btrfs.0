Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83DE6C001DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Jul 2023 16:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbjGLQl7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 12:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjGLQly (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2023 12:41:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891E91BFB
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jul 2023 09:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qMjLtN97CpPQihCKkooj6X0tsC0C3gNZqihZTbdTojU=; b=TS3rYevpm1lpK/spHP7a2UIUNj
        PLjbOd9gWyYkDF3ZPetRFrACijdV1wTiHsVbLc9oPgO65QiLdCkl0hfk/4JUu3R8n+14XbVWI9bHR
        I/T2d9C8Ifa7gO4zDUiFy4ZHrgNJfHNrPeGJvQLxrDbtL3LLr2LcCxI07YP7N4bQh6hDUZQJZojBC
        4ga5OyXA1Q8C+fWcXZJH9QqZ/RTSYY12YzTHICraM8Ca/zssGKDdwwnDuYLAhSuKNjWViK8UBgv1s
        zw1l1s+WKoXFdfODkbD6+dGr5QMF3bPtDy7NvRnT5Id4+exhbKjoU9yF1+OxwbAjqrehQnsImqPVz
        zTm2vyLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qJcuI-000dFA-26;
        Wed, 12 Jul 2023 16:41:38 +0000
Date:   Wed, 12 Jul 2023 09:41:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, willy@infradead.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 0/6] btrfs: preparation patches for the incoming
 metadata folio conversion
Message-ID: <ZK7XwgBJZDpWFuz6@infradead.org>
References: <cover.1689143654.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1689143654.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 12, 2023 at 02:37:40PM +0800, Qu Wenruo wrote:
> One of the biggest problem for metadata folio conversion is, we still
> need the current page based solution (or folios with order 0) as a
> fallback solution when we can not get a high order folio.

Do we?  btrfs by default uses a 16k nodesize (order 2 on x86), with
a maximum of 64k (order 4).  IIRC we should be able to get them pretty
reliably.

If not the best thning is to just a virtually contigous allocation as
fallback, i.e. use vm_map_ram.  That's what XFS uses in it's buffer
cache, and it already did so before it stopped to use page cache to
back it's buffer cache, something I plan to do for the btrfs buffer
cache as well, as the page cache algorithms tend to not work very
well for buffer based metadata, never mind that there is an incredible
amount of complex code just working around the interactions.

