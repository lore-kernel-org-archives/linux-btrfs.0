Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36932 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753541AbaKZP3T (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 26 Nov 2014 10:29:19 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 0/6] Btrfs: fixes for block group remove/allocation and trim/discard
Date: Wed, 26 Nov 2014 15:28:49 +0000
Message-Id: <1417015735-8581-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fixes several issues exposed by block group removal/allocation and
trim/discard running in parallel.

The first 3 patches and the last one (6) are independent and don't depend on each
other. Patches 3 and 6 are not really related to trim/discard at all.

I bundled all these patches into the same patchset because all these issues were
triggered by the same test for xfstests that I prepared and will send out soon.
The issues were triggered on a qemu/kvm guest using scsi-hd drives with discard
support enabled (which makes the host do hole punching on the virtual disks'
image files), 4 virtual CPUs and 4Gb of ram. Some of these issues were hard to
trigger and happened like once for every 10+ runs of the test (each test run
takes nearly 30 minutes with my hardware and a debug kernel).

Filipe Manana (6):
  Btrfs: fix invalid block group rbtree access after bg is removed
  Btrfs: fix crash caused by block group removal
  Btrfs: fix freeing used extents after removing empty block group
  Btrfs: fix race between fs trimming and block group remove/allocation
  Btrfs: fix race between writing free space cache and trimming
  Btrfs: make btrfs_abort_transaction consider existence of new block
    groups

 fs/btrfs/ctree.h            | 14 ++++++-
 fs/btrfs/disk-io.c          | 14 +++++++
 fs/btrfs/extent-tree.c      | 90 ++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/free-space-cache.c | 85 ++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/free-space-cache.h |  2 +
 fs/btrfs/inode-map.c        |  2 +
 fs/btrfs/super.c            |  2 +-
 fs/btrfs/volumes.c          | 33 +++++++++++++----
 8 files changed, 215 insertions(+), 27 deletions(-)

-- 
2.1.3

