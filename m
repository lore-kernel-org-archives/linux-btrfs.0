Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B39B9C433EF
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 May 2022 15:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbiECPLE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 May 2022 11:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237852AbiECPKy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2022 11:10:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BC13969F
        for <linux-btrfs@vger.kernel.org>; Tue,  3 May 2022 08:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5FcyXeefoHiSY2r3J/KNvg3elKyzvMaEiMBbd1JzTu4=; b=hn+aTUxB495jSrcKWvoCfwjoBl
        7RmVhFEtGu2/qUu/igJF9016RJffuYBvq8QUFKMILF3nt6W0nKmE669R8repK73Vxvpbji/KZ9VHM
        JNxzTrcCp8McXpauCqrx877Uid7VN1qU/H6WfNR5Jma7XDfjQVVGioiSwK3cnNSJf/HYSatJ6TLEo
        4tQGn3zAC/YiLDsazR18SOwn8dfYqtBmI+qxZFeMZTbIcgnto+n3THJEap0sgc0dPKaK+XA9cV41f
        vnnYNQ34AMMVfwVMIwMEsBHN8iGk21P6c9cBL2clmA7eCMGhCOh/4k+E7DhIQoduui4HqFj/kxdfu
        +NFpV7nA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nlu7Q-006PVA-9Q; Tue, 03 May 2022 15:07:16 +0000
Date:   Tue, 3 May 2022 08:07:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/13] btrfs: add a helper to queue a corrupted sector
 for read repair
Message-ID: <YnFFJGbbs4+MgKY1@infradead.org>
References: <cover.1651559986.git.wqu@suse.com>
 <2cfd9d2766824ddce727b06068de24d7a4be9637.1651559986.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cfd9d2766824ddce727b06068de24d7a4be9637.1651559986.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This adds an ununused static function and thus doesn't even compile.
