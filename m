Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87958C433F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Mar 2022 10:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358850AbiCYK2s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 06:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245022AbiCYK2r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Mar 2022 06:28:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF99ABF50
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2022 03:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=btq2xRV00pqWy3H4ReRAoH6g4yz6qvvOis02uy19ECs=; b=Mwcue5D2iIC0QAHFQQRbu1eNVf
        JitBu5TIrMP26yJoMruKEN4Y5ALnKN0R0CbfzadCLPxg97tqoMv4+5EXP+sprIwJtllM6vbdO3Idy
        OYPTEHSXORoIfCTyIrCS5igOl011ROU7rTzuS92Yeprk4WSKxrbC+eAXTUwfnvIiDrngc+XH9KPMZ
        xPxJyB6B2ccsiKcFgEwCxsjVXFKhbLNHe3z6dj5kzv94A4a33BR3lKh+0ShQJU/1N8vFjip0+haD7
        3G39r1PH3ZIJDBtJgq4Zc5E/PrRKJj4GyUT7oc79lQbQkR3cIBB54jG1P3rUGeomZiamoiA0lrHO6
        KMIGBLng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nXhA0-001iZq-F8; Fri, 25 Mar 2022 10:27:12 +0000
Date:   Fri, 25 Mar 2022 03:27:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] btrfs: do data read repair in synchronous mode
Message-ID: <Yj2ZALUKtblRSaxP@infradead.org>
References: <cover.1648201268.git.wqu@suse.com>
 <1b796a483efa008ba5e2090621161684b3c4109b.1648201268.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b796a483efa008ba5e2090621161684b3c4109b.1648201268.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I'd suggest to at least submit all I/O in parallel.  Just put
a structure with an atomic_t and completion on the stack.  Start with
a recount of one, inc for each submit, and then dec after all
submissions and for each completion and only wake on the final dec.
That will make sure there is only one wait instead of one per copy.

Extra benefits for also doing this for all sectors, but that might be
a little more work.
