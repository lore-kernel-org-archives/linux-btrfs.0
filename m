Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C316C636C9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Jul 2021 15:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5642E61003
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Jul 2021 15:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239937AbhGUOzH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Jul 2021 10:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239911AbhGUOzH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jul 2021 10:55:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFD8C061575;
        Wed, 21 Jul 2021 08:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=8KuDQrnsKE/QJXd3wnSZP3njuWpZS7069MdcHs16fac=; b=SnaVlgWLCnPxZe6MSPeCgA5WF3
        mfFjWRLbdDbxoofBaGlKbANz2EK6vsGUzaSCchM2CLd7Vtg4JCkUv53eXT4auTL9zqMKT9jue92ee
        GET65Cnrg/R3Of4K+HgVAvP2B/moykywEkb0l1rJdJm/7RgaiF/M2rFSw0TvKkqvsK1M7CwffMNDf
        GQG21ROSjiIYHqQzjTmS8dpuyAazsvticIRsBHdIapWiOxAiD8qgepLIc1nPFoN9bAjheWpkyowUe
        c4lVFKc3NW7vQCVvqKOLl+xBDBNmrMsUWSnM5g92VdL+3W6fEItCaC+oCTuBG2U/IK7pU9FunVgOC
        tjmmk9Sw==;
Received: from [2001:4bb8:193:7660:d6d5:72f4:23f7:1898] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6EFo-009L7P-Fs; Wed, 21 Jul 2021 15:35:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: fixes and cleanups for block_device refcounting
Date:   Wed, 21 Jul 2021 17:35:15 +0200
Message-Id: <20210721153523.103818-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Jens,

this series fixes up a possible race with the block_device lookup
changes, and the finishes off the conversion to stop using the inode
refcount for block devices.

Diffstat:
 block/genhd.c           |    5 +--
 block/partitions/core.c |   14 ++++-----
 drivers/block/loop.c    |    5 ---
 fs/block_dev.c          |   71 +++++++++++++++---------------------------------
 fs/btrfs/zoned.c        |   11 ++-----
 include/linux/blkdev.h  |    2 -
 6 files changed, 34 insertions(+), 74 deletions(-)
