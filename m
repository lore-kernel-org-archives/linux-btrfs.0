Return-Path: <SRS0=VYXz=XT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5F5C432C2
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 17:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5101920872
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 17:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406972AbfIXRc6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 13:32:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:58046 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730714AbfIXRc6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Sep 2019 13:32:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 943EFAF57;
        Tue, 24 Sep 2019 17:32:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4CF48DA835; Tue, 24 Sep 2019 19:33:17 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Minor cleanups in locking helpers
Date:   Tue, 24 Sep 2019 19:33:16 +0200
Message-Id: <cover.1569345962.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Reorganizing code wrt locking helpers, minor text and stack savings.

Debugging build
~~~~~~~~~~~~~~~

   text    data     bss     dec     hex filename
1513898  146192   27496 1687586  19c022 pre/btrfs.ko
1514206  146768   27496 1688470  19c396 post/btrfs.ko
DELTA: +308
^^^^^^^^^^^ the increase is caused by inlining the
            btrfs_assert_tree_locked itself, IMO acceptable for debugging build

Stack report:

btrfs_clean_tree_block                                             -8 (24 -> 16)
btrfs_drop_subtree                                                 +8 (104 -> 112)
btrfs_mark_buffer_dirty                                            -8 (32 -> 24)
insert_ptr                                                         -8 (80 -> 72)

LOST (64):
        btrfs_assert_tree_read_locked                               8
        btrfs_assert_spinning_writers_get                          16
        btrfs_assert_spinning_readers_put                          16
        btrfs_assert_spinning_writers_put                          16
        btrfs_assert_tree_locked                                    8

NEW (0):
LOST/NEW DELTA:      -64
PRE/POST DELTA:      -80


Release build
~~~~~~~~~~~~~

   text    data     bss     dec     hex filename
1079643   17304   14912 1111859  10f733 pre/btrfs.ko
1079468   17316   14912 1111696  10f690 post/btrfs.ko
DELTA: -175
^^^^^^^^^^^ that's what counts

Stack report:

btrfs_drop_subtree                                                 -8 (80 -> 72)
btrfs_clean_tree_block                                             -8 (24 -> 16)
btrfs_mark_buffer_dirty                                            -8 (32 -> 24)
insert_ptr                                                         -8 (80 -> 72)

LOST (8):
        btrfs_assert_tree_locked                                    8

NEW (0):
LOST/NEW DELTA:       -8
PRE/POST DELTA:      -4

David Sterba (4):
  btrfs: make locking assertion helpers static inline
  btrfs: make btrfs_assert_tree_locked static inline
  btrfs: move btrfs_set_path_blocking to other locking functions
  btrfs: move btrfs_unlock_up_safe to other locking functions

 fs/btrfs/ctree.c         | 51 --------------------------
 fs/btrfs/ctree.h         |  1 -
 fs/btrfs/delayed-inode.c |  1 +
 fs/btrfs/locking.c       | 78 +++++++++++++++++++++++++++++++---------
 fs/btrfs/locking.h       | 13 ++++++-
 5 files changed, 75 insertions(+), 69 deletions(-)

-- 
2.23.0

