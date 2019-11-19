Return-Path: <SRS0=Px4L=ZL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96914C432C0
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Nov 2019 12:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72F4420637
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Nov 2019 12:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfKSMGA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 07:06:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:49272 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725280AbfKSMGA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Nov 2019 07:06:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D1151B389;
        Tue, 19 Nov 2019 12:05:58 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/6] Cleanup super block stripe exclusion code
Date:   Tue, 19 Nov 2019 14:05:49 +0200
Message-Id: <20191119120555.6465-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This series aims to cleanup the code necessary to exclude io stripes within a
chunk that can contain a superblock. To achieve this following actions are taken
(in order of appearance) :

1. Make btrfs_rmap_block private to block-group.c since it's only used by
exclude_super_stripes.

2. Extend btrfs selftest framework to accommodate testing of btrfs_rmap_block's
functionality

3. Add tests for btrfs_rmap_block

4. With tests in place perform surgery on btrfs_rmap_block to make it more readable,
this is achieved by renamring variables, making code more linear, getting rid
of a BUG_ON.

5. After btrfs_rmap_block is sane it's easier to reason about some of its
invariants, allowing me to simplify exclude_super_stripes.

This series survived full xfstest with no visible regressions.

Nikolay Borisov (6):
  btrfs: Move and unexport btrfs_rmap_block
  btrfs: selftests: Add support for dummy devices
  btrfs: Add self-tests for btrfs_rmap_block
  btrfs: Refactor btrfs_rmap_block to improve readability
  btrfs: Read stripe len directly in btrfs_rmap_block
  btrfs: Remove dead code exclude_super_stripes

 fs/btrfs/block-group.c            | 107 +++++++++++++++++++++----
 fs/btrfs/tests/btrfs-tests.c      |  28 +++++++
 fs/btrfs/tests/btrfs-tests.h      |   1 +
 fs/btrfs/tests/extent-map-tests.c | 128 +++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c                |  69 ----------------
 fs/btrfs/volumes.h                |   2 -
 6 files changed, 246 insertions(+), 89 deletions(-)

--
2.17.1

