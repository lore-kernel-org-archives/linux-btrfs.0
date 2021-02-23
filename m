Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD1EC433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Feb 2021 12:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D00264E21
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Feb 2021 12:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhBWMLp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 07:11:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232685AbhBWMJc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Feb 2021 07:09:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC7A164E21
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2021 12:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614082132;
        bh=OrFXc0DCi1CRQ8jui8shbWd58unAZ1vdn/84MuWwbro=;
        h=From:To:Subject:Date:From;
        b=MDA/0JfOhArOpKH/2JYp1H8Uq07Gbj9FT/pGoNdAbYGLKFdwnjXK97qlNiPZQZ5wy
         co6QxcrnIbE89LScNLY9vlVSwN2TRe8FQcZTh800lPu5li2d2Bo55xT8k7wO10cmzV
         mklKKHHMKXfEaUPipqlZni+0b33fQnZ0/PhQli91BVuqQt0hPdqkNCQo24D8Yqz0kL
         OYQY3a0Ojt7EWL6LkWT7yDfZKlOMvYWoLMop0xW+MqD4r5XoTeucDqp5j8KpVjOaRY
         hyg6tuz79ENTerHEOkKjCkIGEa1OTucipvd91FCUPviviNYB2I4G0+QwEaGbS18E8H
         03tIiYmCY7D+w==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: fix a couple races between fsync and other code
Date:   Tue, 23 Feb 2021 12:08:46 +0000
Message-Id: <cover.1614081281.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The first patch fixes a race between fsync and memory mapped writes, which
can result in corruptions. The second one fixes a different race that in
practice should be "impossible" to happen, but in case it's triggered
somehow, results in not logging an inode when it has new extents. The last
patch just removes some no longer needed code.

The first patch, as mentioned in its changelog, depends on Josef's patchset
which has the subject:

   "Introduce a mmap sem to deal with some mmap issues"

The others are independent of it.

Filipe Manana (3):
  btrfs: fix race between memory mapped writes and fsync
  btrfs: fix race between marking inode needs to be logged and log
    syncing
  btrfs: remove stale comment and logic from btrfs_inode_in_log()

 fs/btrfs/btrfs_inode.h | 32 +++++++++++++++++++-------------
 fs/btrfs/file.c        | 28 +++++++++++-----------------
 fs/btrfs/inode.c       |  4 +---
 fs/btrfs/transaction.h |  2 +-
 4 files changed, 32 insertions(+), 34 deletions(-)

-- 
2.28.0

