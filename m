Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35735 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751543AbeDIMBO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 08:01:14 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EEA41AD39
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 12:01:12 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/7] Tracepoint updates
Date: Mon,  9 Apr 2018 13:58:43 +0200
Message-Id: <cover.1523275048.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Switch the inode number type to u64, plus other cleanups and fixups.

David Sterba (7):
  btrfs: tracepoints, use correct type for inode number
  btrfs: tracepoints, use %llu instead of %Lu
  btrfs: tracepoints, drop unnecessary ULL casts
  btrfs: tracepoints, fix whitespace in strings
  btrfs: tracepoints, use extended format with UUID where possible
  btrfs: tests: pass fs_info to extent_map tests
  btrfs: use fs_info for btrfs_handle_em_exist tracepoint

 fs/btrfs/extent_map.c             |   6 +-
 fs/btrfs/extent_map.h             |   3 +-
 fs/btrfs/inode.c                  |   2 +-
 fs/btrfs/tests/extent-map-tests.c |  60 ++++++----
 include/trace/events/btrfs.h      | 225 +++++++++++++++++++-------------------
 5 files changed, 158 insertions(+), 138 deletions(-)

-- 
2.16.2

