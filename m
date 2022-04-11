Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78244C433F5
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Apr 2022 07:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238468AbiDKHVJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 03:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbiDKHVI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Apr 2022 03:21:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC3324BE6
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2022 00:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hTettUkcog6xnkzOT4+CwC3cSovqg5TzlJoJ5gFBkb0=; b=gMtohyI9JVIuj8RudjZF3K/7eM
        nAtdlqA0G8e7uUbriq2TnvNAoPP8Hc0JfMgooNkTiCQuFe3uKRALhZHuWEmLDotAeJwZrepejpc6H
        Cfilv43qprD8VQaq8Sms3yyRvmq+a0Z79nNKrvrG0skybINSNYFpc1g5ZLtV7wkopjNEF9RZyc1yD
        t/d00gIOCuJu4+avVrNEv6Ds20nCNfkp4WIslXkk+qLD33KDDHx2p7jhjQEqdGSrsO2IelhovTQ/9
        HHqxczioF3TMPJmocY3w1ikAPIIj4NR7BTpYiR+rTNECaSsEFisrcW82tZoLyFncMLLJHRfFeyBoS
        Keqj3FFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ndoK7-0079XR-Uf; Mon, 11 Apr 2022 07:18:55 +0000
Date:   Mon, 11 Apr 2022 00:18:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs: make submit_one_bio() to return void
Message-ID: <YlPWXw+cWtMG0kE8@infradead.org>
References: <cover.1649657016.git.wqu@suse.com>
 <e4bb98b5884a77114ef0334dee6677e6e6260ea7.1649657016.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4bb98b5884a77114ef0334dee6677e6e6260ea7.1649657016.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 11, 2022 at 02:12:52PM +0800, Qu Wenruo wrote:
> Since commit "btrfs: avoid double clean up when submit_one_bio()
> failed", submit_one_bio() will never return any error, as if we hit any
> error, endio function will be responsible to cleanup the mess.
> 
> So here we're completely fine to make submit_one_bio() to return void.
> 
> NOTE: not all bio submission hooks should return void.
> 
> Hooks for async submission, like btrfs_submit_bio_start_direct_io() or
> btrfs_submit_bio_start(), they should still return error, so
> run_one_async_done() can detect the error properly.

This really should go into patch 1.
