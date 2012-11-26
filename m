Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26172 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab2KZJtv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 04:49:51 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAQ913Zj007891
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 17:01:04 +0800
Message-ID: <50B32FE7.5080908@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 17:01:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/5] random fix for autodefrag
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fixes some bugs of autodefrag. We can pull this patchset
from the URL

	git://github.com/miaoxie/linux-btrfs.git autodefrag

Thanks
Miao
---
Miao Xie (5):
  Btrfs: use slabs for auto defrag allocation
  Btrfs: fix unprotected defragable inode insertion
  Btrfs: restructure btrfs_run_defrag_inodes()
  Btrfs: fix freeze vs auto defrag
  Btrfs: fix remount vs autodefrag

 fs/btrfs/ctree.h   |   4 +
 fs/btrfs/disk-io.c |   2 +-
 fs/btrfs/file.c    | 301 +++++++++++++++++++++++++++++++++++------------------
 fs/btrfs/super.c   |  38 ++++++-
 4 files changed, 239 insertions(+), 106 deletions(-)

-- 
1.7.11.7
