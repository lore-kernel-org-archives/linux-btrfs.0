Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34804 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751140AbdFBQ73 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 12:59:29 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 56188ABB1
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Jun 2017 16:59:28 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/8] Bio allocation and error handling cleanups
Date: Fri,  2 Jun 2017 18:58:27 +0200
Message-Id: <cover.1496422340.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The error handling can be simplified as we do bio allocations using a bioset as
was pointed out by Christoph in https://lkml.kernel.org/r/20170516143737.GA24541@infradead.org

David Sterba (8):
  btrfs: bioset allocations will never fail, adapt our helpers
  btrfs: btrfs_bio_alloc never fails, skip error handling
  btrfs: btrfs_bio_clone never fails, skip error handling
  btrfs: btrfs_io_bio_alloc never fails, skip error handling
  btrfs: sink gfp parameter to btrfs_bio_clone
  btrfs: remove redundant parameters from btrfs_bio_alloc
  btrfs: opencode trivial compressed_bio_alloc, simplify error handling
  btrfs: pass bytes to btrfs_bio_alloc

 fs/btrfs/check-integrity.c |  5 ----
 fs/btrfs/compression.c     | 23 +++------------
 fs/btrfs/disk-io.c         |  3 --
 fs/btrfs/extent_io.c       | 71 ++++++++++++++++------------------------------
 fs/btrfs/extent_io.h       |  6 ++--
 fs/btrfs/inode.c           |  6 +---
 fs/btrfs/raid56.c          |  3 --
 fs/btrfs/scrub.c           | 25 ----------------
 fs/btrfs/volumes.c         |  3 +-
 9 files changed, 32 insertions(+), 113 deletions(-)

-- 
2.12.0

