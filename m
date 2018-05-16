Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55108 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751028AbeEPWDW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 18:03:22 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DECE8AF5C
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 22:03:20 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Update selfstes strings
Date: Thu, 17 May 2018 00:00:40 +0200
Message-Id: <cover.1526507933.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update test messages so that error reports are visible in the log, few
more tweaks of the strings as they're updated.

David Sterba (2):
  btrfs: tests: add helper for error messages and update them
  btrfs: tests: drop newline from test_msg strings

 fs/btrfs/tests/btrfs-tests.h           |   3 +-
 fs/btrfs/tests/extent-buffer-tests.c   |  56 +++---
 fs/btrfs/tests/extent-io-tests.c       |  75 ++++----
 fs/btrfs/tests/extent-map-tests.c      |  32 ++--
 fs/btrfs/tests/free-space-tests.c      | 177 ++++++++++---------
 fs/btrfs/tests/free-space-tree-tests.c |  74 ++++----
 fs/btrfs/tests/inode-tests.c           | 312 +++++++++++++++++----------------
 fs/btrfs/tests/qgroup-tests.c          |  88 +++++-----
 8 files changed, 414 insertions(+), 403 deletions(-)

-- 
2.16.2

