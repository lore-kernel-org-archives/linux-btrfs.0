Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbbLCQgg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 11:36:36 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL][PATCH 0/4] A few cleanups around extent bit setting helpers
Date: Thu,  3 Dec 2015 17:34:44 +0100
Message-Id: <cover.1449159704.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The extent helpers conveniently wrap __set_extent_bit but needlessly do an
extra call. We can get rid of it by making them static inline. Series separated
by the common underlying set/clear bit function. Aiming for 4.5, please pull.

----------------------------------------------------------------

The following changes since commit 1ec218373b8ebda821aec00bb156a9c94fad9cd4:

  Linux 4.4-rc2 (2015-11-22 16:45:59 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/simplify-set-bit

for you to fetch changes up to cd716d8fea125e5531003e66aaf7ca7323277f83:

  btrfs: make lock_extent static inline (2015-12-03 14:44:59 +0100)

----------------------------------------------------------------
David Sterba (4):
      btrfs: make set_extent_bit helpers static inline
      btrfs: make clear_extent_bit helpers static inline
      btrfs: drop unused parameter from lock_extent_bits
      btrfs: make lock_extent static inline

 fs/btrfs/disk-io.c          |   2 +-
 fs/btrfs/extent_io.c        |  98 ++-----------------------------------
 fs/btrfs/extent_io.h        | 114 +++++++++++++++++++++++++++++++++++---------
 fs/btrfs/file.c             |   8 ++--
 fs/btrfs/free-space-cache.c |   2 +-
 fs/btrfs/inode.c            |  20 ++++----
 fs/btrfs/ioctl.c            |   6 +--
 fs/btrfs/scrub.c            |   2 +-
 8 files changed, 116 insertions(+), 136 deletions(-)
