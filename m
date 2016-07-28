Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42349 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1163416AbcG1HI7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 03:08:59 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id F2BEA4295F9F
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 15:08:43 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Date: Thu, 28 Jul 2016 15:08:12 +0800
Message-ID: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [PATCH 00/13] btrfs-progs: check: check fs roots in low_memory mode
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset implements check fs trees in low memory mode, and fix the
return value bug of the function cmd_check().

Lu Fengqi (13):
  btrfs-progs: move btrfs_extref_hash() to hash.h
  btrfs-progs: check: introduce function to find dir_item
  btrfs-progs: check: introduce function to check inode_ref
  btrfs-progs: check: introduce function to check inode_extref
  btrfs-progs: check: introduce function to find inode_ref
  btrfs-progs: check: introduce a function to check dir_item
  btrfs-progs: check: introduce function to check file extent
  btrfs-progs: check: introduce function to check inode item
  btrfs-progs: check: introduce function to check fs root
  btrfs-progs: check: introduce function to check root ref
  btrfs-progs: check: introduce low_memory mode fs_tree check
  btrfs-progs: check: fix the return value bug of cmd_check()
  btrfs-progs: check: fix false warning for check_extent_item()

 cmds-check.c | 1165 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 hash.h       |   10 +
 inode-item.c |    8 +-
 3 files changed, 1164 insertions(+), 19 deletions(-)

-- 
2.7.4



