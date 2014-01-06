Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23518 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaAFB5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 20:57:45 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s061vfHM002425
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jan 2014 09:57:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/9] btrfs: Add missing pairing mount options.
Date: Mon, 6 Jan 2014 09:58:24 +0800
Message-Id: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some options should be paired to support triggering different functions
when remounting.

This patchset add these missing pairing mount options except noinode_cache,
which may need more investigation to ensure the safety and will be sent as
independent patch.

Qu Wenruo (9):
  btrfs: Add "barrier" option to support "-o remount,barrier"
  btrfs: Add noautodefrag mount option.
  btrfs: Add nodiscard mount option.
  btrfs: Add noenospc_debug mount option.
  btrfs: Add noflushoncommit mount option.
  btrfs: Add acl mount option.
  btrfs: Add datacow mount option.
  btrfs: Add datasum mount option.
  btrfs: Add treelog mount option.

 Documentation/filesystems/btrfs.txt | 47 +++++++++++++++++++------------
 fs/btrfs/super.c                    | 55 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 84 insertions(+), 18 deletions(-)

-- 
1.8.5.2

