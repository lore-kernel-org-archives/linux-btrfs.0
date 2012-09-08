Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:43576 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2IHCDa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2012 22:03:30 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, dave@jikos.cz
Subject: [PATCH v2 0/6] bug-fixes and cleanup
Date: Sat,  8 Sep 2012 10:01:24 +0800
Message-Id: <1347069690-30223-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liub.liubo@gmail.com>

This is a collection of some posted patches.

It is also available in
	git://github.com/liubogithub/btrfs-work.git for-chris

v1->v2: patch 1 (Btrfs: fix a bug of per-file nocow) is the only one to
        update since we missed the regular file check while others
        remain unchanged.

Liu Bo (5):
  Btrfs: fix a bug of per-file nocow
  Btrfs: update delayed ref's tracepoints to show sequence
  Btrfs: fix a bug in parsing return value in logical resolve
  Btrfs: use helper for logical resolve
  Btrfs: use larger limit for translation of logical to inode

liubo (1):
  Btrfs: cleanup for unused ref cache stuff

 fs/btrfs/backref.c           |   26 +++++++++++++++++---------
 fs/btrfs/backref.h           |    3 ++-
 fs/btrfs/ctree.h             |    3 ---
 fs/btrfs/disk-io.c           |    5 -----
 fs/btrfs/inode.c             |    3 +--
 fs/btrfs/ioctl.c             |   28 ++++++++++------------------
 fs/btrfs/scrub.c             |   14 ++++++++------
 fs/btrfs/send.c              |    7 ++++---
 include/trace/events/btrfs.h |   14 ++++++++++----
 9 files changed, 52 insertions(+), 51 deletions(-)

-- 
1.7.7.6

