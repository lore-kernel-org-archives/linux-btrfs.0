Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677AbcASKz3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 05:55:29 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL] Btrfs: misc fixes for 4.5, part 2
Date: Tue, 19 Jan 2016 11:55:16 +0100
Message-Id: <cover.1453200293.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fixes that had pending review or updated version since the last pull request.
Please pull to 4.5.

----------------------------------------------------------------
The following changes since commit ee592d07716139ef7c3ea8049936cbc3aafbc533:

  Btrfs: Check metadata redundancy on balance (2016-01-07 15:20:56 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git misc-for-4.5

for you to fetch changes up to 546bed631203344611f42b2af1d224d2eedb4e6b:

  btrfs: initialize the seq counter in struct btrfs_device (2016-01-15 19:28:43 +0100)

----------------------------------------------------------------
Chandan Rajendra (1):
  Btrfs: Initialize btrfs_root->highest_objectid when loading tree root
    and subvolume roots

Sebastian Andrzej Siewior (1):
  btrfs: initialize the seq counter in struct btrfs_device

Tsutomu Itoh (1):
  Btrfs: fix output of compression message in btrfs_parse_options()

 fs/btrfs/disk-io.c   | 27 +++++++++++++++++++++++++++
 fs/btrfs/inode-map.c |  9 +--------
 fs/btrfs/inode-map.h |  1 +
 fs/btrfs/ioctl.c     |  4 ++++
 fs/btrfs/super.c     | 29 ++++++++++++++++++++++-------
 fs/btrfs/volumes.c   |  1 +
 6 files changed, 56 insertions(+), 15 deletions(-)

-- 
2.6.3

