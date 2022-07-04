Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD20C43334
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Jul 2022 12:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbiGDMhM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbiGDMhL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2022 08:37:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC89311A29
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Jul 2022 05:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=R4rAchYsC97fvnwVsCnjdwCsqHBSdQ84dgVOXptzgJI=; b=3dWggubT7juaPLh1NpG0mw5oTI
        iesVr5AdHa2haoHYZDTbXWNWYAlRSZZF61eXpjjcVB4mmt1p+aJCwpIftdut1dRvWGmAhtAO0mq3B
        91YtzHr+sMEWWnM/XVYnLXbVtd044Wjb0DCzkA8Ve4UBad9wVW/uMWvuKD3CYlQjy9ZLhK4LQ3Bru
        KCHQHzpGZGJKguppNDPTiUtotvOJwXdXh1CeQB7Qosqr367dibGx6K1JV5HFGfFWn34YvniJCnCEt
        Gbm10k5YBte3baHy1f3Mutx/ZNVgiHpB6WnkW2WnaAqSb8ihFqOQWQlMCLno8+poOWK8/+s73jLA9
        6OWZJKjg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LKA-008pBT-DG; Mon, 04 Jul 2022 12:37:10 +0000
Date:   Mon, 4 Jul 2022 05:37:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: don't fallback to buffered IO for NOWAIT
 direct IO writes
Message-ID: <YsLe9uzaeqchot6h@infradead.org>
References: <cover.1656934419.git.fdmanana@suse.com>
 <1a7080444b73f8ca1481a7786e52bdf405193be9.1656934419.git.fdmanana@suse.com>
 <YsLWTuUF0nq+sFKw@infradead.org>
 <20220704121114.GA655122@falcondesktop>
 <YsLZLBPM4KkvpN5v@infradead.org>
 <20220704121936.GA656399@falcondesktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704121936.GA656399@falcondesktop>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jul 04, 2022 at 01:19:36PM +0100, Filipe Manana wrote:
> First time I'm hearing it, and never had complaints before.

Take a look at Documentation/process/coding-style.rst.

> Why is it wrong? The purpose it to never fallback directly to buffered IO if
> it's a NOWAIT write. Moving the check to above the label, would make the
> non-aligned case fallback directly to buffered IO under NOWAIT.

Oh, indeed. I keep forgetting that btrfs is unusual in that it does not
fail unaligned direct I/O like all other file systems but just falls
back to buffered I/O instead.

