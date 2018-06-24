Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35766 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751482AbeFXPWv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Jun 2018 11:22:51 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.18-rc1
Date: Sun, 24 Jun 2018 17:19:58 +0200
Message-Id: <cover.1529853141.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

there are 2 regression fixes and an incorrect error value propagation
fix from 'rename exchange'. Please pull, thanks.

----------------------------------------------------------------
The following changes since commit ac0b4145d662a3b9e34085dea460fb06ede9b69b:

  btrfs: scrub: Don't use inode pages for device replace (2018-06-11 15:59:14 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.18-rc1

for you to fetch changes up to c5b4a50b74018b3677098151ec5f4fce07d5e6a0:

  Btrfs: fix return value on rename exchange failure (2018-06-22 12:59:08 +0200)

----------------------------------------------------------------
Filipe Manana (2):
      Btrfs: fix physical offset reported by fiemap for inline extents
      Btrfs: fix return value on rename exchange failure

Lu Fengqi (1):
      btrfs: fix invalid-free in btrfs_extent_same

 fs/btrfs/extent_io.c |  5 ++++-
 fs/btrfs/inode.c     |  4 +++-
 fs/btrfs/ioctl.c     | 10 +++++-----
 3 files changed, 12 insertions(+), 7 deletions(-)
