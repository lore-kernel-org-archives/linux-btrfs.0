Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59142 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752344AbeGANH5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Jul 2018 09:07:57 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.18-rc2
Date: Sun,  1 Jul 2018 15:07:45 +0200
Message-Id: <cover.1530449809.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we have a few regression fixes for qgroup rescan status tracking and the
vm_fault_t conversion that mixed up the error values.

Please pull, thanks.

----------------------------------------------------------------
The following changes since commit c5b4a50b74018b3677098151ec5f4fce07d5e6a0:

  Btrfs: fix return value on rename exchange failure (2018-06-22 12:59:08 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.18-rc2-tag

for you to fetch changes up to e4e7ede739f7fb468686dfffa2d1e35dca35bacd:

  Btrfs: fix mount failure when qgroup rescan is in progress (2018-06-28 11:30:57 +0200)

----------------------------------------------------------------
Chris Mason (1):
      Btrfs: fix regression in btrfs_page_mkwrite() from vm_fault_t conversion

Filipe Manana (1):
      Btrfs: fix mount failure when qgroup rescan is in progress

Qu Wenruo (1):
      btrfs: quota: Set rescan progress to (u64)-1 if we hit last leaf

 fs/btrfs/inode.c  |  3 ++-
 fs/btrfs/qgroup.c | 17 +++++++++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)
