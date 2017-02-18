Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43301 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752754AbdBRB3X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 20:29:23 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/7] cleanup __btrfs_map_block
Date: Fri, 17 Feb 2017 17:28:14 -0800
Message-Id: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is attempting to make __btrfs_map_block less scary :)

The major changes are

1) split operations for discard out of __btrfs_map_block and we don't copy
discard operations for the target device of dev replace since they're not
as important as writes.

2) put dev replace stuff into helpers since they're basically
self-independant.


Liu Bo (7):
  Btrfs: create a helper for getting chunk map
  Btrfs: separate DISCARD from __btrfs_map_block
  Btrfs: introduce a function to get extra mirror from replace
  Btrfs: handle operations for device replace separately
  Btrfs: do not add extra mirror when dev_replace target dev is not
    available
  Btrfs: helper for ops that requires full stripe
  Btrfs: convert BUG_ON to WARN_ON

 fs/btrfs/extent_io.c |   3 +-
 fs/btrfs/volumes.c   | 824 +++++++++++++++++++++++++++------------------------
 fs/btrfs/volumes.h   |   2 +-
 3 files changed, 445 insertions(+), 384 deletions(-)

-- 
2.5.5

