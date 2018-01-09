Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47546 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbeAICbo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 21:31:44 -0500
Subject: [PATCH V4 0/3] Add missing flags in the kernel
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
References: <20180109010543.16053-1-anand.jain@oracle.com>
Message-ID: <ad6d353e-ba02-3d1f-cff8-23b5a3fb8016@oracle.com>
Date: Tue, 9 Jan 2018 10:32:36 +0800
MIME-Version: 1.0
In-Reply-To: <20180109010543.16053-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(added reroll count in the $subject)

v3->v4:
Patch reordered.
Add BTRFS_SUPER_FLAG_METADUMP_V2 to BTRFS_SUPER_FLAG_SUPP

v2->v3:
Modify BTRFS_SUPER_FLAG_SUPP so that it would fail instead of warn.

v1->v2:
Fail to mount if BTRFS_SUPER_FLAG_CHANGING_FSID is set.

Following bits are already used in user land, so bring it to the kernel
as well.

#define BTRFS_SUPER_FLAG_METADUMP_V2   (1ULL << 34)
#define BTRFS_SUPER_FLAG_CHANGING_FSID (1ULL << 35)

Anand Jain (3):
   btrfs: define SUPER_FLAG_METADUMP_V2
   btrfs: add support for SUPER_FLAG_CHANGING_FSID in btrfs.ko
   btrfs: fail mount when sb flag is not in BTRFS_SUPER_FLAG_SUPP

  fs/btrfs/disk-io.c              | 9 ++++++---
  include/uapi/linux/btrfs_tree.h | 2 ++
  2 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.15.0
