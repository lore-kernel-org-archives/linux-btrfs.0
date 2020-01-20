Return-Path: <SRS0=RPoL=3J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A66C33CA1
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Jan 2020 14:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0796222314
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Jan 2020 14:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgATOJX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 09:09:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:49018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgATOJW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Jan 2020 09:09:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 606F0B147;
        Mon, 20 Jan 2020 14:09:20 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 00/11] Make pinned extents tracking per-transaction
Date:   Mon, 20 Jan 2020 16:09:07 +0200
Message-Id: <20200120140918.15647-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I've finally managed to finish and test the pinned extents rework. So here it is.

The idea is to move pinnex extents tracking from the global fs_info->pinned_extents,
which is just a pointer to fs_info->freed_extents[] array members to a per
transaction structure. This will allow to cleanup pinned extents information
during transaction abort.

The bulk of the changes are necessary to ensure a valid transaction handle
is passed to every function that utilizes fs_info->pinned_extents. Also it
was necessary to account for the peculiarities of excluded extents which are
also tracked in ->freed_extents array but with a different flag (yuck).

First 9 patches propagate btrfs_trans_handle where it's necessary. Patch 10
factors out pinned extent clean up to make Patch 11 more readable , alternatively
the changes in patch 10 had to be in patch 11 which would have made it messier
for review.

I believe this series doesn't bring any user facing changes it (hopefully)
streamlines the code and makes it apparent what the lifetime of pinned extents
is and paves the way for further cleanups of BUG_ON.

Nikolay Borisov (11):
  btrfs: Perform pinned cleanup directly in btrfs_destroy_delayed_refs
  btrfs: Make btrfs_pin_extent take trans handle
  btrfs: Introduce unaccount_log_buffer
  btrfs: Call btrfs_pin_reserved_extent only during active transaction
  btrfs: Make btrfs_pin_reserved_extent take transaction
  btrfs: Make btrfs_pin_extent_for_log_replay take transaction handle
  btrfs: Make pin_down_extent take btrfs_trans_handle
  btrfs: Pass trans handle to write_pinned_extent_entries
  btrfs: Mark pinned log extents as excluded
  btrfs: Factor out pinned extent clean up in btrfs_delete_unused_bgs
  btrfs: Use btrfs_transaction::pinned_extents

 fs/btrfs/block-group.c       | 85 +++++++++++++++++++++++-------------
 fs/btrfs/ctree.h             | 12 ++---
 fs/btrfs/disk-io.c           | 56 ++++++++++++------------
 fs/btrfs/extent-io-tree.h    |  3 +-
 fs/btrfs/extent-tree.c       | 70 +++++++++++++----------------
 fs/btrfs/free-space-cache.c  |  5 ++-
 fs/btrfs/tests/btrfs-tests.c |  7 +--
 fs/btrfs/transaction.c       |  1 +
 fs/btrfs/transaction.h       |  1 +
 fs/btrfs/tree-log.c          | 70 +++++++++++++++++++----------
 include/trace/events/btrfs.h |  3 +-
 11 files changed, 174 insertions(+), 139 deletions(-)

--
2.17.1

