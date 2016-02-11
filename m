Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbcBKRX1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 12:23:27 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL] [PATCH 0/6] B-tree key space extensions
Date: Thu, 11 Feb 2016 18:23:25 +0100
Message-Id: <cover.1455209994.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this patchset renames some existing key types and gives them a more generalized
meaning (backward compatible). This is motivated by requirements of b-tree
extensions by various patchsets, eg. the deduplication.

The new key type added there BTRFS_DEDUP_STATUS_ITEM_KEY does not use the
objectid or offset members and maps to a single structure. This is very similar
to the balance status item.

The idea is to allow for extensions without key type exhaustion. Obviously we have
to use new values when the offset and objectid are used.

This patchset introduces two types of persistent items to store status data:

* temporary - eg. exists to store state of a running operation like balance
* permanent - eg. exists if a feature is used

The increased variability of the key type will require more parsing, but will
give more flexibility to developers of new features.

The changes are just renames, there's only one user of each type, so no
backward compatibility concerns.

Please consider for 4.6.

----------------------------------------------------------------
The following changes since commit 388f7b1d6e8ca06762e2454d28d6c3c55ad0fe95:

  Linux 4.5-rc3 (2016-02-07 15:38:30 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/rename-keys

for you to fetch changes up to 9f07e1d76eaeeddedcf9651395b4a8f870df31f0:

  btrfs: teach print_leaf about temporary item subtypes (2016-02-11 16:15:43 +0100)

----------------------------------------------------------------
David Sterba (6):
  btrfs: introduce key type for persistent temporary items
  btrfs: switch balance item to the temporary item key
  btrfs: introduce key type for persistent permanent items
  btrfs: switch dev stats item to the permanent item key
  btrfs: teach print_leaf about permanent item subtypes
  btrfs: teach print_leaf about temporary item subtypes

 fs/btrfs/ctree.h      | 39 ++++++++++++++++++++++++++++++++++++---
 fs/btrfs/print-tree.c | 23 +++++++++++++++++++++--
 fs/btrfs/volumes.c    | 14 +++++++-------
 3 files changed, 64 insertions(+), 12 deletions(-)

-- 
2.7.1

