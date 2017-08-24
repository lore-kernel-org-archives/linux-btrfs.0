Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53671 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752748AbdHXPYX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 11:24:23 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fix for rc7
Date: Thu, 24 Aug 2017 17:22:54 +0200
Message-Id: <cover.1503588032.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we have one more fixup that stems from the blk_status_t conversion that did not
quite cover everything. The normal cases were not affected because the code is
0, but any error and retries could mix up new and old values. Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 14ccee78fc82f5512908f4424f541549a5705b89:

  Linux 4.13-rc6 (2017-08-20 14:13:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.13-rc7

for you to fetch changes up to 58efbc9f5463308c43d812fd0748a4dee44c8a16:

  Btrfs: fix blk_status_t/errno confusion (2017-08-24 17:19:02 +0200)

----------------------------------------------------------------
Omar Sandoval (1):
      Btrfs: fix blk_status_t/errno confusion

 fs/btrfs/disk-io.c |  4 ++--
 fs/btrfs/inode.c   | 70 +++++++++++++++++++++++++++++-------------------------
 fs/btrfs/raid56.c  | 34 +++++++++++++-------------
 fs/btrfs/volumes.c | 10 ++++----
 fs/btrfs/volumes.h |  6 ++---
 5 files changed, 64 insertions(+), 60 deletions(-)
