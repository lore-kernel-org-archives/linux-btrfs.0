Return-Path: <SRS0=UUkT=6P=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC1FEC47256
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 May 2020 06:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92278208DB
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 May 2020 06:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgEAGwY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 May 2020 02:52:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:44300 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728204AbgEAGwY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 May 2020 02:52:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 22D18AD11
        for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2020 06:52:23 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/4] btrfs-progs: Sync code for btrfs_block_group
Date:   Fri,  1 May 2020 14:52:15 +0800
Message-Id: <20200501065219.484868-1-wqu@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset mostly make btrfs_block_group structure to sync with
kernel, providing the basis for later modification. (Hint: skinny bg
tree)

Changelog:
v2:
- Add a patch to sync the block group item accessors

Qu Wenruo (4):
  btrfs-progs: Sync block group item accessors from kernel
  btrfs-progs: Kill block_group_cache::key
  btrfs-progs: Remove the unused btrfs_block_group_cache::cache
  btrfs-progs: Rename btrfs_block_group_cache to btrfs_block_group

 check/main.c                    |  51 +++----
 check/mode-common.c             |   4 +-
 check/mode-lowmem.c             |  22 +--
 cmds/rescue-chunk-recover.c     |  16 +--
 convert/common.c                |   6 +-
 convert/main.c                  |   8 +-
 convert/source-fs.c             |   4 +-
 ctree.h                         |  33 +++--
 extent-tree.c                   | 234 ++++++++++++++++----------------
 free-space-cache.c              |  32 ++---
 free-space-cache.h              |  12 +-
 image/main.c                    |   2 +-
 kernel-shared/free-space-tree.c | 117 ++++++++--------
 kernel-shared/free-space-tree.h |   6 +-
 mkfs/main.c                     |  19 ++-
 print-tree.c                    |   6 +-
 transaction.h                   |   2 +-
 volumes.h                       |   4 +-
 18 files changed, 290 insertions(+), 288 deletions(-)

-- 
2.26.2

