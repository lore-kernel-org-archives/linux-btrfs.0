Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E74C282DE
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 06:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 785FC2084F
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 06:32:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ArDCGbBn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfDHGcg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:32:36 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53564 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfDHGcf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2019 02:32:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+d7sEEPpohC1GBFngRFeGjJqaKn7dWmpZgp8RSmS5EI=; b=ArDCGbBn1YuaX2lZp3pipFmF0
        xTukaj/dHZOJRKmRghOIu+l1AF+WKwhOqcwLyeJGCnfKU/kTBiMyQFjrurIe1NhPlFej7E7AKqs95
        k7PURLSIKlmLHrJKTY4tHLpQ3T3U8KLk7+pek88EPCBe5iEaW5x+uvjJbiW1aNEgNycY305nKatCT
        8FE+fucum9NoCx9sLo04R/nRQcJ6cmtYjI1R1HXkt8XEUTQI70+GIyjyH7p51EWJD7LRUBO4ccIi8
        UV43CWuLJMyfl5veyZroanOfcwsDRiEfgFNejRbSyybuYtwLOjKNHsXf0CqKWfBr/Qn349wVQSwJC
        Yjbhl2v/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hDNpb-0001DV-6r; Mon, 08 Apr 2019 06:32:35 +0000
Date:   Sun, 7 Apr 2019 23:32:35 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.de>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] block: Add new BLK_STS_SELFTEST status
Message-ID: <20190408063235.GA1298@infradead.org>
References: <20190406103759.6330-1-wqu@suse.com>
 <20190407070451.GA32498@infradead.org>
 <41acfcc7-1971-88a0-e34d-00fc34a5c190@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41acfcc7-1971-88a0-e34d-00fc34a5c190@suse.de>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Apr 07, 2019 at 03:08:42PM +0800, Qu Wenruo wrote:
> > But then again I really wonder why you need to pass this information
> > through a blk_status_t to start with.  In general these kinds of error
> > should be passed through file system specific errno fields.
> > 
> 
> For functions called in endio hook, we return blk_status_t.
> Or for case like hook before submitting bio, we set bio->bi_status to
> record it.

Ok.  Good enough explanation, please add it to the changelog.
