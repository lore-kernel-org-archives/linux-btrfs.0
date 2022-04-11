Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B97C433EF
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Apr 2022 17:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344369AbiDKRCs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 13:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348783AbiDKRCd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Apr 2022 13:02:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F95B5F5F
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2022 10:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CKOfGGHdUsrvcGUkN3l+u1i76VC+mj6K5qxExCGc/Gs=; b=ECFqzZlFD/vpHABSRsVmbA+fQz
        wcjPwccQrv7eUi2pHXh7zcT0HKB7j7mJr1C54XBJL8yGHzl0td2XpENFEDB2AHH4/xICFfbOvgEVS
        b9OINwN9n4hudW/py+2bB4b5xH5doA9SglHhvX9u7zNd9BYFspvATIgbl6Lqarg5LlU+uGehItJka
        bbVOrmzQv4IfOlHOVZhif+MU0Lkr3O27x34LzReD0ZJilEBlaoN7WbrGvkoX+3GViSFJCPhOqQtIo
        +fGNsuRRmQGq9zDNjlMIuaDkObx/ogc19/Vik0GunqsjdqJtYHBZCGL/Dg2IdETmXG1Artw+bMer+
        faFCxHxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ndxOg-009p3d-V0; Mon, 11 Apr 2022 17:00:14 +0000
Date:   Mon, 11 Apr 2022 10:00:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/16] btrfs: make finish_rmw() subpage compatible
Message-ID: <YlRentZd9vVt1Ff2@infradead.org>
References: <cover.1648807440.git.wqu@suse.com>
 <911628d0221328e4e5c0bdff58313c0c64485315.1648807440.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <911628d0221328e4e5c0bdff58313c0c64485315.1648807440.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 01, 2022 at 07:23:24PM +0800, Qu Wenruo wrote:
> The trick involved is how we call kunmap_local(), as now the pointers[]
> only store the address with @pgoff added, thus they can not be directly
> used for kunmap_local().

Yes, they can. kumap_local only needs a pointer somewhere into the
mapped page, not the return value from kmap_local_page:

 * @__addr can be any address within the mapped page.  Commonly it is the
 * address return from kmap_local_page(), but it can also include offsets.

> For the cleanup, we have to re-grab all the sectors and reduce the
> @pgoff from pointers[], then call kunmap_local().

No need for that.
