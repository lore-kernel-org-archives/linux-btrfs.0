Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE5BC282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EDD420870
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfAWRid (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 12:38:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:37940 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725896AbfAWRid (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 12:38:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ACEC7B080
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 17:38:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 09C6EDA6F5; Wed, 23 Jan 2019 18:37:58 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/6] Extent buffer locking cleanups, part 1
Date:   Wed, 23 Jan 2019 18:37:56 +0100
Message-Id: <cover.1548264220.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This series cleans up a few locking helpers, removes conditional
switches by read/write type where not necessary and updates the callers.
No changes expected, other than tiny speedups resulting from smaller
code.

David Sterba (6):
  btrfs: split btrfs_set_lock_blocking_rw to read and write helpers
  btrfs: split btrfs_clear_lock_blocking_rw to read and write helpers
  btrfs: replace btrfs_set_lock_blocking_rw with appropriate helpers
  btrfs: open code now trivial btrfs_set_lock_blocking
  btrfs: simplify waiting loop in btrfs_tree_lock
  btrfs: merge btrfs_set_lock_blocking_rw with it's caller

 fs/btrfs/backref.c     |   4 +-
 fs/btrfs/ctree.c       |  39 +++++++++------
 fs/btrfs/disk-io.c     |   4 +-
 fs/btrfs/extent-tree.c |  14 +++---
 fs/btrfs/locking.c     | 108 ++++++++++++++++++++---------------------
 fs/btrfs/locking.h     |  15 ++----
 fs/btrfs/qgroup.c      |   6 +--
 fs/btrfs/ref-verify.c  |   4 +-
 fs/btrfs/relocation.c  |   8 +--
 fs/btrfs/transaction.c |   2 +-
 fs/btrfs/tree-defrag.c |   2 +-
 fs/btrfs/tree-log.c    |   6 +--
 12 files changed, 105 insertions(+), 107 deletions(-)

-- 
2.20.1

