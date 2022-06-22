Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21DFEC43334
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Jun 2022 04:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356958AbiFVE7B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 00:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356953AbiFVE6u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Jun 2022 00:58:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F8E289B8;
        Tue, 21 Jun 2022 21:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=hbcsZ3KmX2p5px7oDw5aVsEemx6Tgn/iQES3hJTX31g=; b=dwXYJ9M4gXlhLEkE/O/IuudFH1
        5Zr5vLcT1jafg/Xq+13N0ZEj6gEjRv8gmUOnVkd5IyJo7E1cMyxNGYddRLfuCoj74OPCXaXNCPLYQ
        QnU0jUIL/O3hxpF0gFwKbUC/P4A5jQYwf8PG8uv4Bd9r3Q5B++7S335rJuPZKp8+dC/VA7Stvcdhl
        oXyqM7tkEwl11NRRvdwpWz9g5eppU2PgVnSsFbk/sr+BC2jL20497Kw/fXeEZLhC2rdjfNToLc5xH
        MA+4LAFzKFv0a/XQxRipCaV4wk2EDkJkK7z7M6k6Tx+F1FNxDzD8aELm6+bLnOW9ONOTkBwWHkxug
        dW932wCg==;
Received: from 213-225-1-25.nat.highway.a1.net ([213.225.1.25] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o3sRz-008Wh9-D5; Wed, 22 Jun 2022 04:58:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: btrfs read repair: more tests
Date:   Wed, 22 Jun 2022 06:58:40 +0200
Message-Id: <20220622045844.3219390-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

this series adds a few more btrfs read repair tests.  Still all for user
data as I haven't managed to successfully inject corruption into metadata
yet.
