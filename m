Return-Path: <SRS0=lzwu=CZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6233C2D0F6
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Sep 2020 08:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76980208E4
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Sep 2020 08:50:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hUxTXtIw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgIPIuJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 04:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgIPIuB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Sep 2020 04:50:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA0CC06174A;
        Wed, 16 Sep 2020 01:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HY5sSDf+1gYa2b3NXHBac5E/PqpXZ7sU5Qg7bTCCCV4=; b=hUxTXtIwup8HwXzRn4HnMIRdA5
        FPpltTYYiaSUM8IwPHrwFgbd1a9DADpv9bhUGqJLTh2LIDgW3qQoydHUySggdhzxU97zPROKeanBn
        2UGUonQzrkanDUmkWGawx1Kz3VDSPGdQOGCFC5/QmRQH/zLYeCQpTnchFIqk0K7Mj0WSP5YrWzQIG
        qQqg+11Uzy9xSKl9cSXBhYTJkQEMppsELiB9kas2wXnbt8/4LschRanwncC6AhwXNXZnpiBkPt5mJ
        F4UVmELqbY187ZKI+XMx7ALpwqvZfYhNMTim956FO9UZVhQYTuVHW4+YzCH41xaTf2tOfUoN8gp5Z
        hW2p2S9w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIT8Z-0008Nz-0U; Wed, 16 Sep 2020 08:49:59 +0000
Date:   Wed, 16 Sep 2020 09:49:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Nick Terrell <nickrterrell@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
        squashfs-devel@lists.sourceforge.net,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Kernel Team <Kernel-team@fb.com>,
        Nick Terrell <terrelln@fb.com>, Chris Mason <clm@fb.com>,
        Petr Malat <oss@malat.biz>, Johannes Weiner <jweiner@fb.com>,
        Niket Agarwal <niketa@fb.com>, Yann Collet <cyan@fb.com>
Subject: Re: [PATCH 5/9] btrfs: zstd: Switch to the zstd-1.4.6 API
Message-ID: <20200916084958.GC31608@infradead.org>
References: <20200916034307.2092020-1-nickrterrell@gmail.com>
 <20200916034307.2092020-7-nickrterrell@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916034307.2092020-7-nickrterrell@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 15, 2020 at 08:42:59PM -0700, Nick Terrell wrote:
> From: Nick Terrell <terrelln@fb.com>
> 
> Move away from the compatibility wrapper to the zstd-1.4.6 API. This
> code is functionally equivalent.

Again, please use sensible names  And no one gives a fuck if this bad
API is "zstd-1.4.6" as the Linux kernel uses its own APIs, not some
random mess from a badly written userspace package.
