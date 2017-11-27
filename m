Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59951 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750841AbdK0DKK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Nov 2017 22:10:10 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH 0/3] btrfs-progs: check: fix up bugs of lowmem mode
Date: Mon, 27 Nov 2017 11:13:50 +0800
Message-ID: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be fetched from my github:
https://github.com/Damenly/btrfs-progs/tree/lowmem
which is based on Qu's branch on
https://github.com/adam900710/btrfs-progs/tree/lowmem_fix

The first two patches fix minor bugs:
1) Extent buffer leaks while repairing data extent items in lowmem mode.
2) Repair in lowmem mode always reports error about block group accounting.

The third patch excludes extents of all treeblocks and extent items to
avoid wrong extent overwrite. Then repair in lowmem mode should work
again.

Su Yue (3):
  btrfs-progs: check: release path in repair_extent_data_item()
  btrfs-progs: check: record returned errors after walk_down_tree_v2()
  btrfs-progs: check: exclude extents of tree blocks and extent items

 cmds-check.c | 126 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 114 insertions(+), 12 deletions(-)

-- 
2.15.0



