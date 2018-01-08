Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47300 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755852AbeAHIDc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 03:03:32 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Subject: [PATCH v3 0/3] Add missing flags in the kernel.
Date: Mon,  8 Jan 2018 16:04:18 +0800
Message-Id: <20180108080421.17668-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v2->v3:
Modify BTRFS_SUPER_FLAG_SUPP so that it would fail instead of warn.

v1->v2:
Fail to mount if BTRFS_SUPER_FLAG_CHANGING_FSID is set.

Following bits are already used in user land, so bring it to the kernel
as well.

#define BTRFS_SUPER_FLAG_METADUMP_V2   (1ULL << 34)
#define BTRFS_SUPER_FLAG_CHANGING_FSID (1ULL << 35)

Anand Jain (3):
  btrfs: fail mount when sb flag is not in BTRFS_SUPER_FLAG_SUPP
  btrfs: define SUPER_FLAG_METADUMP_V2
  btrfs: add support for SUPER_FLAG_CHANGING_FSID in btrfs.ko

 fs/btrfs/disk-io.c              | 6 ++++--
 include/uapi/linux/btrfs_tree.h | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.15.0

