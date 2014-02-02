Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50887 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbaBBXt5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Feb 2014 18:49:57 -0500
Date: Mon, 3 Feb 2014 10:49:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [ANNOUCE] xfstests: updated to ad969ca
Message-ID: <20140202234952.GO13997@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
just been updated. Patches often get missed, so please check if your
outstanding patches were in this update. If they have not been in
this update, please resubmit them to xfs@oss.sgi.com so they can be
picked up in the next update.

The new head of the master branch is commit:

ad969ca btrfs/030: add more test cases

New Commits:

Brian Foster (2):
      [20641b8] xfs: remove spurious line continuation from _require_xfs_crc
      [710281f] generic/313: initialise TEST_DIR before use

Eric Whitney (1):
      [138ea5c] ext4/306: avoid failures caused by incompatible mount options

Filipe David Borba Manana (2):
      [fd7a8e8] btrfs/025: make test more robust
      [ad969ca] btrfs/030: add more test cases

Josef Bacik (2):
      [78d86b9] btrfs/029: filter mkfs and cp output
      [8ebabf7] generic/299: truncate can fail with ENOSPC

Wang Shilong (2):
      [6717b24] Btrfs: add regression test for transaction abortion when remounting
      [cd86825] Btrfs: add regression test for iterating backrefs


Code Diffstat:

 common/rc           |  2 +-
 tests/btrfs/025     | 34 ++++++++++-----------
 tests/btrfs/025.out | 12 --------
 tests/btrfs/029     |  6 ++--
 tests/btrfs/029.out |  4 +--
 tests/btrfs/030     | 86 ++++++++++++++++++++++++++++++++++++++++-------------
 tests/btrfs/032     | 57 +++++++++++++++++++++++++++++++++++
 tests/btrfs/032.out |  3 ++
 tests/btrfs/033     | 71 +++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/033.out |  2 ++
 tests/btrfs/group   |  2 ++
 tests/ext4/306      | 21 +++++--------
 tests/generic/299   |  2 +-
 tests/generic/313   |  3 +-
 14 files changed, 233 insertions(+), 72 deletions(-)
 create mode 100755 tests/btrfs/032
 create mode 100644 tests/btrfs/032.out
 create mode 100755 tests/btrfs/033
 create mode 100644 tests/btrfs/033.out
-- 
Dave Chinner
david@fromorbit.com
