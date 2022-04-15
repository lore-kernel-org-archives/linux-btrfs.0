Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3381CC433FE
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Apr 2022 07:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350900AbiDOHOl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Apr 2022 03:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241498AbiDOHOk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Apr 2022 03:14:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0523A774D;
        Fri, 15 Apr 2022 00:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Xuk7BnB/ke6UWk21aG4E+CA4gBxPd6W/inTX9awzAFc=; b=f68OSstf9nB+2FOSgE5XOaNnNn
        qeSlMXNcbz4n1HnLSL6WB37CM5up/r6jOaoRjMcf1RM0Jr6Y0CZMky7SwyRJhryW3FsALgiITQkIP
        y98Orvb2fYlrVAKPXdfsYdF242sGvfVK+nhoPhjVRKrcWuzz2r+0knnbInGQ3/VqqJzex+NsIT86w
        QAzr0I0GR7ha5m8185R2haLM9cszzBnLEzqwiCJAvbhxgUNK+L8xHvTdrPxZF9VhIgPfbaAniHW0U
        4/EpHAZ52vWT6dGvjeGu3723+DI4Y+cDGKJiXpQJRR5JLExPdNI0bx/zDYfofN0cqoNqs1V9/aV1S
        yddgnb/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nfG7m-0099JN-Sy; Fri, 15 Apr 2022 07:12:10 +0000
Date:   Fri, 15 Apr 2022 00:12:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs: avoid double clean up when
 submit_one_bio() failed
Message-ID: <YlkayiTPf93aBpSD@infradead.org>
References: <cover.1649766550.git.wqu@suse.com>
 <0b13dccbc4d6e066530587d6c00c54b10c3d00d7.1649766550.git.wqu@suse.com>
 <YlkQgTCv+Iw2QzPz@infradead.org>
 <37226b35-7d5a-dd86-7b20-7a0dfd3b96fc@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37226b35-7d5a-dd86-7b20-7a0dfd3b96fc@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 15, 2022 at 03:02:41PM +0800, Qu Wenruo wrote:
> But this can not be said to btrfs_submit_compressed_read(), which has
> the same problem and can be triggered by EIO error easily.
> 
> Do you want to give it a try? Or mind to me fix it?

I don't really know the btrfs writeback and compression code very well,
so if you can tackle it that would be great.  I'll review it and will
ask lots of stupid question in exchange :)
