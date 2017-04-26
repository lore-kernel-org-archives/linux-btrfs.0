Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932295AbdDZRxE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Apr 2017 13:53:04 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs bug fixes for 4.12
Date: Wed, 26 Apr 2017 18:52:41 +0100
Message-Id: <20170426175241.32703-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following changes for the 4.12 merge window.
These are all bug fixes and nothing particularly outstanding compared to
changes for past merge windows.

Thanks.

The following changes since commit a967efb30b3afa3d858edd6a17f544f9e9e46eea:

  Btrfs: fix potential use-after-free for cloned bio (2017-04-11 18:49:56 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.12

for you to fetch changes up to a7e3b975a0f9296162b72ac6ab7fad9631a07630:

  Btrfs: fix reported number of inode blocks (2017-04-26 16:27:26 +0100)

----------------------------------------------------------------
Filipe Manana (5):
      Btrfs: fix invalid attempt to free reserved space on failure to cow range
      Btrfs: fix incorrect space accounting after failure to insert inline extent
      Btrfs: fix extent map leak during fallocate error path
      Btrfs: send, fix file hole not being preserved due to inline extent
      Btrfs: fix reported number of inode blocks

Qu Wenruo (2):
      btrfs: Fix metadata underflow caused by btrfs_reloc_clone_csum error
      btrfs: Handle delalloc error correctly to avoid ordered extent hang

 fs/btrfs/btrfs_inode.h |   7 ++++
 fs/btrfs/extent_io.h   |   5 ++-
 fs/btrfs/file.c        |  66 +++++++++++++++++++++++++++++++++----
 fs/btrfs/inode.c       | 242 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------
 fs/btrfs/send.c        |  23 +++++++++++--
 5 files changed, 277 insertions(+), 66 deletions(-)

-- 
2.11.0

