Return-Path: <SRS0=0DI8=CJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFB1C433E7
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 23:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 954C62078B
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 23:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgHaXWI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 19:22:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:53738 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgHaXWD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Aug 2020 19:22:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7F6F7ABF4;
        Mon, 31 Aug 2020 23:22:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3E14FDA7CF; Tue,  1 Sep 2020 01:20:50 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 5.9-rc4
Date:   Tue,  1 Sep 2020 01:20:49 +0200
Message-Id: <cover.1598905089.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

two small fixes and a bunch of lockdep fixes for warnings that show up
with an upcoming tree locking update but are valid with current locks as
well.  Please pull, thanks.

* fix bug in free space bitmap/extent switch logic

* several lockdep warning fixes

* clarify tree-checker error message

----------------------------------------------------------------
The following changes since commit a84d5d429f9eb56f81b388609841ed993f0ddfca:

  btrfs: detect nocow for swap after snapshot delete (2020-08-21 12:21:23 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.9-rc3-tag

for you to fetch changes up to f96d6960abbc52e26ad124e69e6815283d3e1674:

  btrfs: tree-checker: fix the error message for transid error (2020-08-27 14:16:05 +0200)

----------------------------------------------------------------
Josef Bacik (5):
      btrfs: drop path before adding new uuid tree entry
      btrfs: fix potential deadlock in the search ioctl
      btrfs: allocate scrub workqueues outside of locks
      btrfs: set the correct lockdep class for new nodes
      btrfs: set the lockdep class for log tree extent buffers

Marcos Paulo de Souza (1):
      btrfs: block-group: fix free-space bitmap threshold

Qu Wenruo (1):
      btrfs: tree-checker: fix the error message for transid error

 fs/btrfs/block-group.c     |   4 +-
 fs/btrfs/ctree.c           |   6 ++-
 fs/btrfs/extent-tree.c     |   2 +-
 fs/btrfs/extent_io.c       |   8 +--
 fs/btrfs/extent_io.h       |   6 +--
 fs/btrfs/free-space-tree.c |   4 ++
 fs/btrfs/ioctl.c           |  27 +++++++---
 fs/btrfs/scrub.c           | 122 ++++++++++++++++++++++++++-------------------
 fs/btrfs/tree-checker.c    |   2 +-
 fs/btrfs/volumes.c         |   3 +-
 10 files changed, 113 insertions(+), 71 deletions(-)
