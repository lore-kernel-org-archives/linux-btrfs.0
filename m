Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4231C7EE23
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Jun 2023 07:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbjFLHmp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 03:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbjFLHmj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2023 03:42:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E96C0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jun 2023 00:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oZPjI3e67L3RI3zaeoUNq70jfe
        i9kBl1tmv07UOqAeVgR+si930AQrVM3086GfHxekW51OSu9LYucGHoF/lAFF1rzVnl4j3ALJJP9yp
        olqE/8qMV9REY1MvnbC0pkFra3x2uluWCCfPqZgyR1ofnPCL58pQxhV7sJmwcd/Ttz0CVrdHxXAVs
        E1XyTiXOzvlbDOvmcn+yFnUzKHqFGRxV8Ygq7AZ+1ru1vtSqQuSCDYPsFCQjZ5ZlMMJLOPNqSZ+2Q
        9oP2SvbYAAjK8AeB9bQle6aUTHr1XzUgikh5RwXShSMXNW2kju9fwSytF1+GVeaobVpxmzT+wb205
        P9QA0FlQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q8cAQ-002wVU-1z;
        Mon, 12 Jun 2023 07:40:46 +0000
Date:   Mon, 12 Jun 2023 00:40:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: scrub: remove
 btrfs_fs_info::scrub_wr_completion_workers
Message-ID: <ZIbL/mvnKwhw4BcW@infradead.org>
References: <6e0ace5a15c44d7264a2261597c66a975f214a21.1686554551.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e0ace5a15c44d7264a2261597c66a975f214a21.1686554551.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
