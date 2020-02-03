Return-Path: <SRS0=25Zt=3X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50994C35247
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Feb 2020 15:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 320F321744
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Feb 2020 15:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgBCPjX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 10:39:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:57616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgBCPjX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Feb 2020 10:39:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AFFA0ADE2;
        Mon,  3 Feb 2020 15:39:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C9BD0DA81B; Mon,  3 Feb 2020 16:39:00 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 5.6, part 2
Date:   Mon,  3 Feb 2020 16:38:55 +0100
Message-Id: <cover.1580742376.git.dsterba@suse.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

second batch containing fixes that arrived after the merge window
freeze, mostly stable material. The top patch is fresh but addressing
space reporing bug that's been bothering users and we've tested it
meanwhile.

Please pull thanks.

* fix race in tree-mod-log element tracking

* fix bio flushing inside extent writepages

* fix assertion when in-memory tracking of discarded extents finds an
  empty tree (eg. after adding a new device)

* update logic of temporary read-only block groups to take into account
  overcommit

* fix some fixup worker corner cases:
  - page could not go through proper COW cycle and the dirty status is
    lost due to page migration
  - deadlock if delayed allocation is performed under page lock

* fix send emitting invalid clones within the same file

* fix statfs reporting 0 free space when global block reserve size is
  larger than remaining free space but there is still space for new
  chunks

----------------------------------------------------------------
The following changes since commit 4e19443da1941050b346f8fc4c368aa68413bc88:

  btrfs: free block groups after free'ing fs trees (2020-01-23 17:24:39 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.6-tag

for you to fetch changes up to d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6:

  btrfs: do not zero f_bavail if we have available space (2020-02-02 18:49:32 +0100)

----------------------------------------------------------------
Chris Mason (1):
      Btrfs: keep pages dirty when using btrfs_writepage_fixup_worker

Filipe Manana (2):
      Btrfs: fix race between adding and putting tree mod seq elements and nodes
      Btrfs: send, fix emission of invalid clone operations within the same file

Josef Bacik (6):
      btrfs: flush write bio if we loop in extent_write_cache_pages
      btrfs: fix force usage in inc_block_group_ro
      btrfs: take overcommit into account in inc_block_group_ro
      btrfs: drop the -EBUSY case in __extent_writepage_io
      btrfs: do not do delalloc reservation under page lock
      btrfs: do not zero f_bavail if we have available space

Nikolay Borisov (1):
      btrfs: Correctly handle empty trees in find_first_clear_extent_bit

 fs/btrfs/block-group.c           |  39 +++++++++----
 fs/btrfs/ctree.c                 |   8 +--
 fs/btrfs/ctree.h                 |   6 +-
 fs/btrfs/delayed-ref.c           |   8 +--
 fs/btrfs/disk-io.c               |   1 -
 fs/btrfs/extent_io.c             |  49 +++++++++-------
 fs/btrfs/inode.c                 | 121 +++++++++++++++++++++++++++++++--------
 fs/btrfs/send.c                  |   3 +-
 fs/btrfs/space-info.c            |  18 +++---
 fs/btrfs/space-info.h            |   3 +
 fs/btrfs/super.c                 |  10 +++-
 fs/btrfs/tests/btrfs-tests.c     |   1 -
 fs/btrfs/tests/extent-io-tests.c |   9 +++
 13 files changed, 193 insertions(+), 83 deletions(-)
