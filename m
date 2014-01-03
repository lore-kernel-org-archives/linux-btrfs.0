Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47985 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbaACGJr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 01:09:47 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0369f9I003655
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jan 2014 14:09:41 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 00/11] btrfs: Add missing pairing mount options.
Date: Fri, 3 Jan 2014 14:10:23 +0800
Message-Id: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some options should be paired to support triggering different functions
when remounting.

This patchset add these missing pairing mount options.

changelog:
v1: Initial commit with only barrier option
v2: Add other missing pairing options

Qu Wenruo (11):
  btrfs: Add "barrier" option to support "-o remount,barrier"
  btrfs: Add noautodefrag mount option.
  btrfs: Add nocheck_int mount option.
  btrfs: Add nodiscard mount option.
  btrfs: Add noenospc_debug mount option.
  btrfs: Add noflushoncommit mount option.
  btrfs: Add noinode_cache mount option.
  btrfs: Add acl mount option.
  btrfs: Add datacow mount option.
  btrfs: Add datasum mount option.
  btrfs: Add treelog mount option.

 Documentation/filesystems/btrfs.txt | 56 ++++++++++++++++++----------
 fs/btrfs/super.c                    | 74 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 110 insertions(+), 20 deletions(-)

-- 
1.8.5.2

