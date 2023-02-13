Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB16CC636D4
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 Feb 2023 06:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjBMGg3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 13 Feb 2023 01:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjBMGg2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2023 01:36:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27BE6580
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Feb 2023 22:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uFbNeBXa9a71E9+96vmISkaHYQ
        FlaMUEhe2bgjI+N/t+kQbiE6NkkTy+9Gc+dOqNU3QfPbK0iI+yRGgRPSwrRrDeL+Wr14VHMS35WO5
        mY99GC53PbyYG/Yc4afXw6ewdetjXy2t8DTYxW+H+7aPgaW9NneUmMhc0N0yQ8zeVU3MQN3RbfI0N
        21QJjTKNaAxM30Mkp14vr7weMSvkvKnE4LXY62Jc4SgsvV8fmY0V8mTk18pqhrEzzM2KNV7pnCfaM
        Tw/+CedMl1i1ZwCxFOElOqZ8ndEEMZMLfaUFiZg5XJOovk/BpS7QDggy/o1HtOTRtBK4/oW62MaQX
        CYWVvUow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pRSRr-00DMJp-V4; Mon, 13 Feb 2023 06:36:23 +0000
Date:   Sun, 12 Feb 2023 22:36:23 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: avoid reusing variable names in nested blocks
Message-ID: <Y+naZz12hUbq+17l@infradead.org>
References: <cover.1676041962.git.anand.jain@oracle.com>
 <8c49c7599f9ab47d93ccc1635bc68e541997d766.1676041962.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c49c7599f9ab47d93ccc1635bc68e541997d766.1676041962.git.anand.jain@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
