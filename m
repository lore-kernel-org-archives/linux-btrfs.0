Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C18C433EF
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Apr 2022 13:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347239AbiD1NgH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 09:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347235AbiD1NgG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Apr 2022 09:36:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEC021266
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2022 06:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2bWVqSRJgqAwKeiIyZo3N/fdVt
        agCwYu8GXQh2BJCKTTG0M4RVmbKf4f1aFZh4B4CqJw2OW8mfoao5o7Jfycv/AZb7bPrEaEGkg/5CD
        oy9NaEp8a74ctdG1ZID3pJZfsuNejrc1DVapVVeOJEg8Qq76w1+ebKDseKjJ9DI1W5olany+bD7xW
        ZcmkMRRynrfDyjN/UtjvpOBuexem7/JVkhDsDr/3dyeDWH2111d7BmAeGM4VyVNrULXQocFz9Ec4C
        PkPJwJhUugU1B+FJRyBshiufn/3mxnTV4JUC85PKFKTSOcVC4d/M4KULfYXeskxxvnPDF0bnRk5HD
        xhseKqlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk4GJ-0074uJ-UG; Thu, 28 Apr 2022 13:32:51 +0000
Date:   Thu, 28 Apr 2022 06:32:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC v2 03/12] btrfs: remove duplicated parameters from
 submit_data_read_repair()
Message-ID: <YmqXg6QsG6EPmrgn@infradead.org>
References: <cover.1651043617.git.wqu@suse.com>
 <5e2703629692c60feef18ff551c453c4ce1cf5f0.1651043617.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e2703629692c60feef18ff551c453c4ce1cf5f0.1651043617.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
