Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48892 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3FVFdB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Jun 2013 01:33:01 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH 0/5 v2] multiple disks restore support of btrfs-image
Date: Sat, 22 Jun 2013 13:32:40 +0800
Message-Id: <1371879165-4993-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1-3 are bug fixes for several places.

Patch 4 is a cleanup for btrfs-image usage description.

Patch 5 adds btrfs-image support of multiple disks restore.

v1->v2:
- rebase onto the lastest btrfs-progs
- add support to restore data extent

Liu Bo (5):
  Btrfs-progs: fix misuse of skinny metadata in btrfs-image
  Btrfs-progs: skip open devices which is missing
  Btrfs-progs: delete fs_devices itself from fs_uuid list before
    freeing
  Btrfs-progs: cleanup btrfs-image usage
  Btrfs-progs: enhance btrfs-image to restore image onto multiple disks

 btrfs-image.c |  315 +++++++++++++++++++++++++++++++++++++++++++++++----------
 ctree.h       |    1 +
 disk-io.c     |  232 ++++++++++++------------------------------
 disk-io.h     |    6 +
 extent_io.c   |   87 ++++++++++++++++
 extent_io.h   |    2 +
 volumes.c     |  147 +++++++++++++++++++++++++++
 volumes.h     |    5 +
 8 files changed, 579 insertions(+), 216 deletions(-)

-- 
1.7.7

