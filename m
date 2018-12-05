Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568AFC04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18E60206B7
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:52:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SjYaW5db"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18E60206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbeLEOw2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:52:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbeLEOw2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2018 09:52:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xVCwFHI6HvKxY0zmrsGlmeP093nzMUJ0MF1dyYdupng=; b=SjYaW5dbXiieUPLMJUvVm/vKd
        6DEqWhUXvMS4pgia+lxdiDdlcN20pBdeOWEWQ4tvp5Z3Jr59RHIMWIafZH1DC1VMi/gnJuiINNuaR
        qJRWQKC8ZczTr/rSxFPZnXjwXHABV5KQOZ5JY1Xya5UUpBXonjq84qyaLMdaVaeQTkbyKRwSxdMcn
        Q3xrin7yFUjFigCoEWc88wXug/V7YFD5tKdC/6473oYFYufjLpn5AQ3rO8CDu6QhFFmjZ6OuoAI0y
        FTawTz+psBbPghLrSTL9b34P7RalQ0Ks14yds8A6kXlLuVbIHCOnHF33yLa6/xkWZqxOvrJaCKzTg
        DebGEKX5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUYXL-0003dG-Dg; Wed, 05 Dec 2018 14:52:27 +0000
Date:   Wed, 5 Dec 2018 06:52:27 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 07/10] dax: export functions for use with btrfs
Message-ID: <20181205145227.GA12361@infradead.org>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
 <20181205122835.19290-8-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205122835.19290-8-rgoldwyn@suse.de>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If you want to export these at all they have to be EXPORT_SYMBOL_GPL.

But I'd really like to avoid seeing another duplicate DAX I/O path.
Please try to adopt the existing iomap-based infrastructure for your
needs first.
