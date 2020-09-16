Return-Path: <SRS0=lzwu=CZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21898C43461
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Sep 2020 18:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA1B420936
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Sep 2020 18:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qAhoj5A8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgIPSzQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 14:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727633AbgIPR6D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Sep 2020 13:58:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1FCC002177;
        Wed, 16 Sep 2020 07:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qRV1VR1lw4Pk3Btc/ldGIrFcQRYbXcvusp2+nqI5T2s=; b=qAhoj5A8/WBwt5HE5/TC3r1KPb
        FSpELKFytkPr5wmYs215KBD8P/G/e8uxMWtY+kR4NsdsomnEMZXVLoO3988eucRjiNLxPE491bB/i
        BjYlmMXn9pRIytA9jX5u7YFjP0P08jsI63mZIAkxVq/1rHGAVwDJDKNiEa/hcXpmnhzmr0H2vP6HP
        Yy6FHkkcLKlF5znZYRlonAVdhIptb+JADXalWjRiYPmX8YD3tRvnddqjjTwjGoHUq2gjnM/t0dMhV
        Km0ShtrXDt2odA5/6+vWzDEISdIKWkFQXQCBW/S9EcOzSXH4dCTzRfxWT3crfildhh5MNT5yTOJCX
        vmbNY1Yw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIYSM-0003cS-2f; Wed, 16 Sep 2020 14:30:46 +0000
Date:   Wed, 16 Sep 2020 15:30:46 +0100
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
        Niket Agarwal <niketa@fb.com>, Yann Collet <cyan@fb.com>
Subject: Re: [PATCH 5/9] btrfs: zstd: Switch to the zstd-1.4.6 API
Message-ID: <20200916143046.GA13543@infradead.org>
References: <20200916034307.2092020-1-nickrterrell@gmail.com>
 <20200916034307.2092020-7-nickrterrell@gmail.com>
 <20200916084958.GC31608@infradead.org>
 <CCDAB4AB-DE8D-4ADE-9221-02AE732CBAE2@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CCDAB4AB-DE8D-4ADE-9221-02AE732CBAE2@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 16, 2020 at 10:20:52AM -0400, Chris Mason wrote:
> It???s not completely clear what you???re asking for here.  If the API
> matches what???s in zstd-1.4.6, that seems like a reasonable way to label
> it.  That???s what the upstream is for this code.
> 
> I???m also not sure why we???re taking extra time to shit on the zstd
> userspace package.  Can we please be constructive or at least actionable?

Because it really doesn't matter that these crappy APIs he is
introducing match anything, especially not something done as horribly
as the zstd API.  We'll need to do this properly, and claiming
compliance to some version of this lousy API is completely irrelevant
for the kernel.
