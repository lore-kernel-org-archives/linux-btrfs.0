Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97567C56201
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F903206F1
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:40:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C7gMd9SP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbgKJSj7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgKJSj7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Nov 2020 13:39:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C0EC0613D1;
        Tue, 10 Nov 2020 10:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=79SE+AKjlqgBbqilhiLeZ8j33rMROxnpjj18eGnMGAA=; b=C7gMd9SPM+bIdOdwPgkWo9RDoB
        6ZF3yngMrEjxVNvOcaTcQyUm3aCrbUU9x+EALS8F1IjHfoa+o4Bq6uMxBjbSaZtgfSl0pY/4hjbvY
        2/IxXVA3IqblqosgM8IlDlPBBI3Yzh//Tjg6dzXGk5pS2OSp5/9t9rHSy9ZsoSEn9F31iQbfHZ750
        lb5ioAP6tStztsmGYbr6Rf07Bhs4I3P30WpcJPT6h/sdUNxb2hNnkvJ5cUUhds4gP+tyHx0f0e1Kl
        xu2XqNFcm/G2iD0odGhWtuXGTmb+yn+FIxXQMQD/73xyXkYo3AebaX70Iqfvaxm1ZpZh3yQgQXxfk
        x24Igmxw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcYYb-0002os-Hv; Tue, 10 Nov 2020 18:39:53 +0000
Date:   Tue, 10 Nov 2020 18:39:53 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Chris Mason <clm@fb.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Nick Terrell <nickrterrell@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
        squashfs-devel@lists.sourceforge.net,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Kernel Team <Kernel-team@fb.com>,
        Nick Terrell <terrelln@fb.com>, Petr Malat <oss@malat.biz>,
        Johannes Weiner <jweiner@fb.com>,
        Niket Agarwal <niketa@fb.com>, Yann Collet <cyan@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v5 1/9] lib: zstd: Add zstd compatibility wrapper
Message-ID: <20201110183953.GA10656@infradead.org>
References: <20201103060535.8460-1-nickrterrell@gmail.com>
 <20201103060535.8460-2-nickrterrell@gmail.com>
 <20201106183846.GA28005@infradead.org>
 <D9338FE4-1518-4C7B-8C23-DBDC542DAC35@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D9338FE4-1518-4C7B-8C23-DBDC542DAC35@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 09, 2020 at 02:01:41PM -0500, Chris Mason wrote:
> You do consistently ask for a shim layer, but you haven???t explained what
> we gain by diverging from the documented and tested API of the upstream zstd
> project.  It???s an important discussion given that we hope to regularly
> update the kernel side as they make improvements in zstd.

An API that looks like every other kernel API, and doesn't cause endless
amount of churn because someone decided they need a new API flavor of
the day.  Btw, I'm not asking for a shim layer - that was the compromise
we ended up with.

If zstd folks can't maintain a sane code base maybe we should just drop
this childish churning code base from the tree.
