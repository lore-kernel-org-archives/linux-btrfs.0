Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55426 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727541AbeGSLry (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 07:47:54 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5564BACAA
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 11:05:14 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/7] Structure and callback cleanups
Date: Thu, 19 Jul 2018 13:05:06 +0200
Message-Id: <cover.1531996240.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A handful of removed structure members that are not used,
async_submit_bio is down by 16 bytes and async_cow by 8.

Some of the extent_io_ops callbacks are unnecessarily called indirectly.
The rest of extent_io_ops is going to be transformed in following
series.

David Sterba (7):
  btrfs: remove unused member async_submit_bio::fs_info
  btrfs: remove unused member async_submit_bio::bio_flags
  btrfs: remove redundant member async_cow::root
  btrfs: unify end_io callbacks of async_submit_bio
  btrfs: drop extent_io_ops::tree_fs_info callback
  btrfs: drop extent_io_ops::merge_bio_hook callback
  btrfs: drop extent_io_ops::set_range_writeback callback

 fs/btrfs/compression.c | 10 +++-------
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/disk-io.c     | 42 +++---------------------------------------
 fs/btrfs/disk-io.h     |  5 +++--
 fs/btrfs/extent_io.c   | 28 +++++++---------------------
 fs/btrfs/extent_io.h   |  8 --------
 fs/btrfs/inode.c       | 32 ++++++++------------------------
 7 files changed, 25 insertions(+), 102 deletions(-)

-- 
2.18.0

