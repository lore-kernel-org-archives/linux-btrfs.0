Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD4FC432BE
	for <linux-btrfs@archiver.kernel.org>; Sat, 24 Jul 2021 07:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F90560E9C
	for <linux-btrfs@archiver.kernel.org>; Sat, 24 Jul 2021 07:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhGXGcu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhGXGcu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Jul 2021 02:32:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC1EC061575;
        Sat, 24 Jul 2021 00:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=y05nn3QU3uPeS1ZgmMUbAAAgTGYtUzQDUxvCUfjqrEU=; b=mGAwZbnCO2qbWAtnmPH5mzrz/U
        vVEstPs2hk8uiikRrjpQGPBAbf3CiAg12uARs1yfS50U8qALuBV39IqKIMabziaPh19ysY2x1GDGx
        /z6ofmXNsXJORLgPx8oIktvYLIuPVRIJc55i0JCdKiSB3eL2KvKCdYGpnu8Xb5tSYDt3omogBujV2
        RGic7g/5wdt2U4KTj0M59mElg21U5IGwaiLD7DIt8b93FED0eh5qo8+tyYINjAIrdjzbMQl5RygVQ
        G/BiR2Wa1UK2t+9JYySux9xgNiHBygqRbrN+DIOG4JtEq5erPJCuOIRm29AcXW6KFeAp5Kk6+sgsk
        iIa7lYbA==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7Bq6-00C4Vg-RR; Sat, 24 Jul 2021 07:12:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: fixes and cleanups for block_device refcounting v3
Date:   Sat, 24 Jul 2021 09:12:39 +0200
Message-Id: <20210724071249.1284585-1-hch@lst.de>
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

Note that patch 1 is a 5.14 and -stable candidate.


Changes since v2:
 - fix a double put_disk in the add_partition error path
 - split a patch and better document the two new ones
 - also remove partition bdev inodes a little earlier

Changes since v1:
 - clean up btrfs even more by storing a bdev instead of the disk
 - keep a persistent disk reference in the bdev
 - a bunch of cleanups to make the above change easier

Diffstat:
 block/genhd.c           |   13 ++-----
 block/partitions/core.c |   37 +++++++++------------
 drivers/block/loop.c    |    5 --
 fs/block_dev.c          |   83 ++++++++++++++----------------------------------
 fs/btrfs/inode.c        |    2 -
 fs/btrfs/ordered-data.c |    2 -
 fs/btrfs/ordered-data.h |    3 -
 fs/btrfs/zoned.c        |   12 ++----
 include/linux/blkdev.h  |    2 -
 9 files changed, 51 insertions(+), 108 deletions(-)
