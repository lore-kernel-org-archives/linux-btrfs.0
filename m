Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61818 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab3IECkh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Sep 2013 22:40:37 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r852eZ3u014030
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Sep 2013 10:40:35 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 0/5] Memory leaks amended
Date: Thu, 5 Sep 2013 10:38:53 +0800
Message-Id: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Memory leaks found by the tool--valgrind along with static reviewing.

Based on Daivd's branch 'integration-20130903'.

Gui Hecheng (5):
  btrfs-progs:free local variable buf upon unsuccessful returns
  btrfs-progs:local variable memory freed
  btrfs-progs: missing tree-freeing statements added
  btrfs-progs:free the local list pending_list in btrfs_scan_one_dir
  btrfs-progs:free strdup()s that are not freed

 btrfs-image.c    |  2 ++
 cmds-check.c     |  5 +++++
 cmds-subvolume.c | 48 ++++++++++++++++++++++++++++++++++--------------
 mkfs.c           | 12 +++++++++++-
 utils.c          | 10 ++++++++--
 5 files changed, 60 insertions(+), 17 deletions(-)

-- 
1.8.0.1

