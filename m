Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E3F8C7EE23
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 May 2023 08:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbjEWIPt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 May 2023 04:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236266AbjEWIPT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2023 04:15:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9570613E
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2023 01:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=FXCjfJGjXN69JQLggwuAv9/eGO03i4XKurqTvvf/ozQ=; b=x7FLi6wg7BOXACif044JFU8iSX
        d8x7QKPUYHZuAuzYFmb0vEJqHWASC3IgaeVLBjOVC2V6rzMPbKg18IRD32jiCRgNzmgtnZFouMb9n
        8akmKpS+tL5BgY7fwkppp6y211zMDbOHa3ac8RFy7V/c0oDDbIvvivEcmkwEz2C+raMFPFjhfoQIY
        ntQxugviGDkzbXPGUBWJkd89l5xAExYAKZln97Ex2yRJCPSWt1M/IIsrG8OGiZ1oP/GKLYdES62qz
        p60NZKdw7DRryajSugWEyzN/G+6ArNd/sOhLhVGi1HApyc3qaVB/BRDOVXZWpqRywbYPDBkTQdDp6
        5RYwctBg==;
Received: from [2001:4bb8:188:23b2:6ade:85c9:530f:6eb0] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q1N92-009OSP-1W;
        Tue, 23 May 2023 08:13:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: writeback fixlets and tidyups
Date:   Tue, 23 May 2023 10:13:06 +0200
Message-Id: <20230523081322.331337-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

this little series fixes a few minors bugs found by code inspection in the
writeback code, and then goes on to remove the use of PageError.

Note that the series is against the for-next branch, as it has some minor
conflicts with and builds on the PageError remove in the extent_buffer
series that hasn't made it to misc-next yet.

Subject:
 extent_io.c |  357 ++++++++++++++++++++----------------------------------------
 extent_io.h |    6 -
 inode.c     |  180 +++++++++++++-----------------
 subpage.c   |   34 -----
 subpage.h   |   10 -
 5 files changed, 209 insertions(+), 378 deletions(-)
