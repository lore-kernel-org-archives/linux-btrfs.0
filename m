Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51959 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdLJJU2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 04:20:28 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/5] define BTRFS_DEV_STATE
Date: Sun, 10 Dec 2017 17:15:17 +0800
Message-Id: <20171210091522.6061-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now device properties and states are being represented as int
variable, patches here makes them bit flags instead. Further, wip
patches such as device failed state needs this cleanup.

v2:
 Adds BTRFS_DEV_STATE_REPLACE_TGT
 Adds BTRFS_DEV_STATE_FLUSH_SENT
 Drops BTRFS_DEV_STATE_CAN_DISCARD
 Starts bit flag from the bit 0
 Drops unrelated change - declare btrfs_device

v3:
 Fix static checker warning, define respective dev state as bit number

Anand Jain (5):
  btrfs: cleanup device states define BTRFS_DEV_STATE_WRITEABLE
  btrfs: cleanup device states define BTRFS_DEV_STATE_IN_FS_METADATA
  btrfs: cleanup device states define BTRFS_DEV_STATE_MISSING
  btrfs: cleanup device states define BTRFS_DEV_STATE_REPLACE_TGT
  btrfs: cleanup device states define BTRFS_DEV_STATE_FLUSH_SENT

 fs/btrfs/dev-replace.c |   8 ++-
 fs/btrfs/disk-io.c     |  29 ++++++---
 fs/btrfs/extent-tree.c |   5 +-
 fs/btrfs/extent_io.c   |   3 +-
 fs/btrfs/ioctl.c       |   4 +-
 fs/btrfs/scrub.c       |  13 +++--
 fs/btrfs/super.c       |   8 ++-
 fs/btrfs/volumes.c     | 156 ++++++++++++++++++++++++++++---------------------
 fs/btrfs/volumes.h     |  11 ++--
 9 files changed, 143 insertions(+), 94 deletions(-)

-- 
2.7.0

