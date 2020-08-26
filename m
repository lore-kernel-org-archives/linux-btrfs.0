Return-Path: <SRS0=f55l=CE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EAAC433E4
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Aug 2020 01:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D178F2078D
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Aug 2020 01:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHZBDq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 21:03:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:47804 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbgHZBDm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Aug 2020 21:03:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4B06CAFFD;
        Wed, 26 Aug 2020 00:53:10 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Tyler Richmond <t.d.richmond@gmail.com>
Subject: [PATCH 0/3] btrfs-progs: check: add inode invalid transid detect and repair support
Date:   Wed, 26 Aug 2020 08:52:30 +0800
Message-Id: <20200826005233.90063-1-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Really nothing interesting here for btrfs-progs, just reusing existing
inode generation detect and repair code.

The interesting part is, how a wrongly copied error message delayed us
so long to locate a bug.

Reported-by: Tyler Richmond <t.d.richmond@gmail.com>

Qu Wenruo (3):
  btrfs-progs: check/lowmem: add inode transid detect and repair support
  btrfs-progs: check/original: add inode transid detect and repair
    support
  btrfs-progs: tests/fsck: add test image for inode transid repair

 check/main.c                                     |   8 +++++---
 check/mode-lowmem.c                              |  11 +++++++----
 .../bad_inode_transid.img.xz                     | Bin 0 -> 1888 bytes
 3 files changed, 12 insertions(+), 7 deletions(-)
 create mode 100644 tests/fsck-tests/043-bad-inode-generation/bad_inode_transid.img.xz

-- 
2.28.0

