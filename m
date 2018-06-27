Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60215 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932333AbeF0Nid (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 09:38:33 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 83B90AB9B
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 13:38:32 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/4] Misc cleanups
Date: Wed, 27 Jun 2018 16:38:21 +0300
Message-Id: <1530106705-27186-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here are a couples of cleanups of things I observed while looking at the 
extent_buffer management code. 

Patch 1 rewrites a do {} while into a simple for() construct. This survived 
xfstest + selftests 

Patch 2 substitutes and outdated comment for a lockdep_assert_held call

Patch 3 rename the idiotic EXTENT_BUFFER_DUMMY to something more meaningful

Patch 4 removes some cargo-cult copied code when performing qgroup leaf scan 

Nikolay Borisov (4):
  btrfs: Refactor loop in btrfs_release_extent_buffer_page
  btrfs: Document locking require via lockdep_assert_held
  btrfs: Rename EXTENT_BUFFER_DUMMY to EXTENT_BUFFER_PRIVATE
  btrfs: Remove unnecessary locking code in qgroup_rescan_leaf

 fs/btrfs/disk-io.c   |  2 +-
 fs/btrfs/extent_io.c | 26 +++++++++++---------------
 fs/btrfs/extent_io.h |  2 +-
 fs/btrfs/qgroup.c    |  7 +------
 4 files changed, 14 insertions(+), 23 deletions(-)

-- 
2.7.4

