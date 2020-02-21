Return-Path: <SRS0=i4Ze=4J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB10EC35646
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 16:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD17820578
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 16:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgBUQbT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 11:31:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:43652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgBUQbT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Feb 2020 11:31:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D730DAF5C;
        Fri, 21 Feb 2020 16:31:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 87E82DA70E; Fri, 21 Feb 2020 17:30:59 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 00/11] Minor cleanups
Date:   Fri, 21 Feb 2020 17:30:58 +0100
Message-Id: <cover.1582302545.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Minor and safe cleanups.

David Sterba (11):
  btrfs: use struct_size to calculate size of raid hash table
  btrfs: move mapping of block for discard to its caller
  btrfs: open code trivial helper btrfs_header_fsid
  btrfs: open code trivial helper btrfs_header_chunk_tree_uuid
  btrfs: simplify parameters of btrfs_set_disk_extent_flags
  btrfs: adjust message level for unrecognized mount option
  btrfs: raid56: simplify sort_parity_stripes
  btrfs: replace u_long type cast with unsigned long
  btrfs: adjust delayed refs message level
  btrfs: merge unlocking to common exit block in
    btrfs_commit_transaction
  btrfs: reduce pointer intdirections in btree_readpage_end_io_hook

 fs/btrfs/ctree.c       |  4 +--
 fs/btrfs/ctree.h       | 12 +--------
 fs/btrfs/disk-io.c     | 18 +++++++------
 fs/btrfs/extent-tree.c |  7 +++---
 fs/btrfs/raid56.c      |  4 +--
 fs/btrfs/super.c       |  2 +-
 fs/btrfs/transaction.c | 57 +++++++++++++++---------------------------
 fs/btrfs/volumes.c     | 33 ++++++++----------------
 8 files changed, 49 insertions(+), 88 deletions(-)

-- 
2.25.0

