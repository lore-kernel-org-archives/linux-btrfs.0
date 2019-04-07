Return-Path: <SRS0=Yn0v=SJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03197C282DD
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB134218D0
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:04:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G3bmTl/A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfDGHEw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 03:04:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59388 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfDGHEw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2019 03:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OUZcnsm2VNcZFZpPfIENrLH3COZ+/fwo3nctRyToEr4=; b=G3bmTl/Azn2rn+Btx/YM4rMmi
        70p/3HWiRSbL9qf8CTTpcOd07g+zDDtIrG9qbSyMspGOMfMpDMDiBlohGmoBfrwbhqbK5xEegCq2x
        qzEWInjIN0SXwxQjw6GUHj24No24Au+ArDXUVyL9selcZjSRAw1dibwqVBi/2CETns4GW4vgU/iY6
        6XQg9LEqVd1f7CvsFZaSHFSZnXzkfb8s1zmhP0O/hAYW/VJWfsfNxpk9XaJPQDdCjCIUpfG12gHTq
        1UOAP5Exgj1EQgFlxaE/OrX6kTkTgRhYjzzz/9Pb9EQ0QPi4bZqcLw1ifO6bKPEh5MOSuHa01iEyu
        XyWM36pAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hD1rI-0008WP-1D; Sun, 07 Apr 2019 07:04:52 +0000
Date:   Sun, 7 Apr 2019 00:04:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] block: Add new BLK_STS_SELFTEST status
Message-ID: <20190407070451.GA32498@infradead.org>
References: <20190406103759.6330-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190406103759.6330-1-wqu@suse.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> +	[BLK_STS_UCLEAN]	= { -EUCLEAN,	"structure needs cleaning" },

The subject line doesn't mention this new error code.  That being said
while this sounds slightly less bad than the original name it still
sounds weird..

The various filesystems really use EFSCORRUPTED which is just mapped
to EUCLEAN, so maybe this really should be

	[BLK_STS_FSCORRUPTED]	=
		{ -EUCLEAN, "file system corruption detected" },

But then again I really wonder why you need to pass this information
through a blk_status_t to start with.  In general these kinds of error
should be passed through file system specific errno fields.
