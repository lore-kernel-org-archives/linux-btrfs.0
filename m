Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA16C636CC
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 Feb 2023 06:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjBMGmR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 13 Feb 2023 01:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBMGmQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2023 01:42:16 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EC0EB7B;
        Sun, 12 Feb 2023 22:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=5EYhWU7/wflEH4cWk12WbohpUi
        YqPKjdnBQP1OeuWrJD4mEUoWBrmpOA4zjM3YnOu431tOBUa6/Jxkccn30lAKM7lajR1AqCcYY6uve
        BuAR1f9a7uNtgTMihSBvNzHXHil+I2Cv8h9Yd95GVCJHUM96RJBGvxeseWsuelf1wBNv6vW+aruQf
        yK2XIUjNl7A14+LfcgVQXqm6o5b5HQ2Udc0LgyJFGT0LrLoOZYPM3g71nkhTMb878xVdKVD/XOnpE
        /S54eq5odao6kTe1Z4bUaN1CnqZH1D3yj6Pwuh+CBs9FNA8cjAPer5GTedQJk7SEPPTKd+NR3X5Es
        2OW8vnsg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pRSXX-00DN4v-Am; Mon, 13 Feb 2023 06:42:15 +0000
Date:   Sun, 12 Feb 2023 22:42:15 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix unnecessary increment of read error stat on
 write error
Message-ID: <Y+nbx7omeZSL5lvS@infradead.org>
References: <29145a990313cb8759b8131b07f29694cc183ab3.1676265001.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29145a990313cb8759b8131b07f29694cc183ab3.1676265001.git.naohiro.aota@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
