Return-Path: <SRS0=SmLw=EK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C51EC2D0A3
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Nov 2020 11:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 056A1223BD
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Nov 2020 11:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604488059;
	bh=zTh0DS6Qo8YhgB2qBglJcgHeGhYucMyBjtNYt9HmMgg=;
	h=From:To:Subject:Date:List-ID:From;
	b=LCYyS6IZqSdl4x6I9JuTXPPlo7LRQORVtiYHLNKor13ak0T4dPVEvSJEYwJGCNM9z
	 q9cGGqjtqHd5tvgoTREFR/E0abAH6n6HNi+1F/joBj+8QClirinhS4tzH6XvoyG/7C
	 slBtABhwnhL2RWMKN2lXppW7isPa6m7RsBerWQVo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgKDLHi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 4 Nov 2020 06:07:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbgKDLHh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Nov 2020 06:07:37 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAAB821556
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2020 11:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604488057;
        bh=zTh0DS6Qo8YhgB2qBglJcgHeGhYucMyBjtNYt9HmMgg=;
        h=From:To:Subject:Date:From;
        b=u+6wqWfp9QgdjurFxo3lsyA/2ZXhmVDvLgBvKu6B1Cj78FnG2O7yVWAQHmWmcADnj
         oEp/rj87dLRLIqUE2SSjPKAE3IqrhnNLNVJ+g97RRc88D68YB/EXDk6bf/VW6m/GQ7
         Ti8tLUSDbWoWyQtXvhlF/XIeqLZM9U39gVyJtIb0=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs: fix cases of stat(2) reporting incorrect number of used blocks
Date:   Wed,  4 Nov 2020 11:07:30 +0000
Message-Id: <cover.1604486892.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

There are several cases where a stat(2) call can report an incorrect number
of used blocks. In some cases can even result in reporting 0 used blocks,
which is a specially bad value to report when a file is not empty, and we
had user bug reports in the past for such cases (the changelogs in the
patches point to one such report).

This patchset addresses all those cases. The third patch fixes a race in
defrag that while it does not result in a functional problem (data loss
or some corruption), it leads to unnecessary IO and space allocation,
and it's necessary for the 4th and final patch to work as it is.

A couple test cases for fstests will follow.

Filipe Manana (4):
  btrfs: fix missing delalloc new bit for new delalloc ranges
  btrfs: refactor btrfs_drop_extents() to make it easier to extend
  btrfs: fix race when defragging that leads to unnecessary IO
  btrfs: update the number of bytes used by an inode atomically

 fs/btrfs/btrfs_inode.h       |   3 +-
 fs/btrfs/ctree.h             |  71 ++++++++--
 fs/btrfs/extent-io-tree.h    |  16 ++-
 fs/btrfs/extent_io.c         |  10 +-
 fs/btrfs/file.c              | 246 +++++++++++++++--------------------
 fs/btrfs/inode.c             | 233 +++++++++++++++++++++++++++------
 fs/btrfs/ioctl.c             |  39 ++++++
 fs/btrfs/reflink.c           |   9 +-
 fs/btrfs/tests/inode-tests.c |  12 +-
 fs/btrfs/tree-log.c          |  32 +++--
 10 files changed, 458 insertions(+), 213 deletions(-)

-- 
2.28.0

