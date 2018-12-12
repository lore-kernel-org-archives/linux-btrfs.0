Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB17BC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 08:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E1B72084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 08:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jHYx+HDd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E1B72084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbeLLIHf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 03:07:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51308 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbeLLIHe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 03:07:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QDp2lOTtdqtGNp8NmlApdHnk+rMQU2i/spgT6VCbZ8o=; b=jHYx+HDdL9AXP+EiZ80HnLYQg
        d6XCybCU/FydcTInCtkEIGwV410bPWWuKw0gDX3Z4YZg/HpjVclLqLf8g0nAi/L4DWdUIHxea2/Le
        UsuHU0HJzxwMCTf3BYU6lULH+/3EMlmj6X1CLPUGgkfkZ5sVuxToLFAJnQQx7KcoxBoVKTRFJDH2G
        Dd3m/CFu5eW9XkX/Gz21jC4HxGSiOhRhUBbqUAghpLGDo4HglaiDyZGalbo4vBBYouY8BF6L4m4J1
        QRhKHFDjCPZawsrRE5gnpc9B67nXyfJRpezqUp+ux+Y49xsYbRXw16n95sdRHiD09Jhze1jnYtTld
        RfTmxy2qg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gWzYM-0005ng-J2; Wed, 12 Dec 2018 08:07:34 +0000
Date:   Wed, 12 Dec 2018 00:07:34 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/10] dax: export functions for use with btrfs
Message-ID: <20181212080734.GB14877@infradead.org>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
 <20181205122835.19290-8-rgoldwyn@suse.de>
 <20181205145227.GA12361@infradead.org>
 <20181206114601.bzh3356jtyvhxc6m@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206114601.bzh3356jtyvhxc6m@merlin>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 06, 2018 at 05:46:01AM -0600, Goldwyn Rodrigues wrote:
> This is not worth with btrfs. With non-page aligned I/O on btrfs, we
> need to copy the first/last page of the extents for CoW.

We'll need to do the same for XFS with reflink support anyway.  So
I'd rather handle it in common code if we can.

> So, we
> would end up using the exported functions anyways. Believe me, I have
> spent some time getting btrfs iomap compatible before giving up. The
> problems are btrfs needs to carry a lot of information across
> iomap_begin and iomap_end. While the added private variable helps in
> this, it also needs hooks in bio_submit() functions for crc calculations
> during direct writes.

Although we'd need to find a smarter way to handle this vs adding
more indirect calls everywhere.

