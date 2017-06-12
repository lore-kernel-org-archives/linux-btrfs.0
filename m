Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33069 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753414AbdFLPaj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 11:30:39 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, bo.li.liu@oracle.com
Subject: [PATCH 0/3] More bio fixes and cleanups
Date: Mon, 12 Jun 2017 17:29:34 +0200
Message-Id: <cover.1497281195.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Main part is the initialization of btrfs_io_bio, the rest is doc & cleanup.

David Sterba (3):
  btrfs: document mandatory order of bio in btrfs_io_bio
  btrfs: add helper to initialize the non-bio part of btrfs_io_bio
  btrfs: sink gfp parameter to btrfs_io_bio_alloc

 fs/btrfs/check-integrity.c |  2 +-
 fs/btrfs/disk-io.c         |  2 +-
 fs/btrfs/extent_io.c       | 38 ++++++++++++++++++--------------------
 fs/btrfs/extent_io.h       |  2 +-
 fs/btrfs/raid56.c          |  2 +-
 fs/btrfs/scrub.c           | 16 +++++++---------
 fs/btrfs/volumes.h         |  4 ++++
 7 files changed, 33 insertions(+), 33 deletions(-)

-- 
2.13.0

