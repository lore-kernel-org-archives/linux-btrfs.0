Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728021AbeIJWRq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 18:17:46 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5A14FAF4A
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 17:22:39 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Self-test cleanups
Date: Mon, 10 Sep 2018 19:22:22 +0200
Message-Id: <cover.1536599879.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've noticed a new use of the STATIC macro in Nikolay's patches cleaning
up delayed refs. My series removes the macro and does a other minor
reorganization to reduce ifdefs used in the test code.

David Sterba (4):
  btrfs: tests: add separate stub for find_lock_delalloc_range
  btrfs: tests: move testing members of struct btrfs_root to the end
  btrfs: tests: group declarations of self-test helpers
  btrfs: tests: polish ifdefs around testing helper

 fs/btrfs/ctree.h                 | 28 +++++++++++-----------------
 fs/btrfs/extent_io.c             | 13 ++++++++++++-
 fs/btrfs/extent_io.h             |  2 +-
 fs/btrfs/tests/extent-io-tests.c | 10 +++++-----
 4 files changed, 29 insertions(+), 24 deletions(-)

-- 
2.18.0
