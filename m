Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22182 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751127AbcCGE6n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Mar 2016 23:58:43 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 464EC42AC84B
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Mar 2016 12:58:38 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Add new option for specify chunk root bytenr
Date: Mon, 7 Mar 2016 12:57:40 +0800
Message-ID: <1457326661-9646-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new btrfsck option, '--chunk-root', to specify chunk root bytenr.Modify 
open_ctree_fs_info() function to accept chunk_root_bytenr to override the 
bytenr in superblock. 

Lu Fengqi (1):
  btrfs-progs: Add new option for specify chunk root bytenr

 btrfs-debug-tree.c |  2 +-
 btrfs-find-root.c  |  2 +-
 btrfs-image.c      |  4 ++--
 cmds-check.c       | 10 ++++++++--
 cmds-filesystem.c  |  2 +-
 cmds-restore.c     |  2 +-
 disk-io.c          | 27 +++++++++++++++++++++------
 disk-io.h          |  4 +++-
 8 files changed, 38 insertions(+), 15 deletions(-)

-- 
2.5.0



