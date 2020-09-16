Return-Path: <SRS0=lzwu=CZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8BDC43461
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C61E21D1B
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:11:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vuzIdI2m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgIPUKJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgIPRdm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Sep 2020 13:33:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BD4C00217F;
        Wed, 16 Sep 2020 07:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I+Wrsf2OsM4H/FvG28XmzjWSyq2hOoPWFZhAVEE3RCk=; b=vuzIdI2myzrcSR8N8YUZIxJs7P
        Sx91GDqxw7SKvTK3Q/nRp4WnHClkpkK/1OSKRygFhe90fZaV9fh+k7GQDAKnGLqU52NU1R7o24SfD
        seMr7Y2+IlmkwzW5l1W2SFiJm7EC1UQvsJqgorQoJrd0mihZ0kd7Vp8ebhVZCF0Q0ELXjj/VrFWna
        ctPysIiI3CtHiEShBsJMczKgdXTh3NyyyLxs+T7ZmyrJaIQAuUEi+E+Z480NRxWRE3n4HU0iyYgbT
        oc26VCkL3wOc32lThfhoy8TDA7vL4lHIHRx7dN1lyrOOFn10v1O1A0ycsq6YvIr+h+Hpjh/++0yzE
        tDUCoKHA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIYhO-0004Yh-Kj; Wed, 16 Sep 2020 14:46:18 +0000
Date:   Wed, 16 Sep 2020 15:46:18 +0100
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
Message-ID: <20200916144618.GB16392@infradead.org>
References: <20200916034307.2092020-1-nickrterrell@gmail.com>
 <20200916034307.2092020-7-nickrterrell@gmail.com>
 <20200916084958.GC31608@infradead.org>
 <CCDAB4AB-DE8D-4ADE-9221-02AE732CBAE2@fb.com>
 <20200916143046.GA13543@infradead.org>
 <1CAB33F1-95DB-4BC5-9023-35DD2E4E0C20@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1CAB33F1-95DB-4BC5-9023-35DD2E4E0C20@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 16, 2020 at 10:43:04AM -0400, Chris Mason wrote:
> Otherwise we just end up with drift and kernel-specific bugs that are harder
> to debug.  To the extent those APIs make us contort the kernel code, I???m
> sure Nick is interested in improving things in both places.

Seriously, we do not care elsewhere.  Why would zlib be any different?

> There are probably 1000 constructive ways to have that conversation.  Please
> choose one of those instead of being an asshole.

I think you are the asshole here by ignoring the practices we are using
elsewhere and think your employers pet project is somehow special.  It
is not, and claiming so is everything but constructive.
