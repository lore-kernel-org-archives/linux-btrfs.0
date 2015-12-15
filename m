Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24407 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965018AbbLOLM3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 06:12:29 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 9D51F409255B
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 19:11:42 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/4] btrfs: return all mirror whether need_raid_map set or not
Date: Tue, 15 Dec 2015 19:09:48 +0800
Message-ID: <cover.1450177455.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_map_block() should return all mirror on WRITE,
REQ_GET_READ_MIRRORS, and RECOVERY case, whether need_raid_map set
or not.

need_raid_map only used to control is to set bbio->raid_map.

Current code works right becuase there is only one caller can
trigger above bug, which is readahead, and this function happened
to bypass on less mirror.

But after we fixed __btrfs_map_block(), readahead will be really
works, and exit with warning at another bug.
This patchset fixed __btrfs_map_block(), and disable raid56
readahead temp temporary, (actually, it already disable by this bug),
and I'll fix raid56 readahead next.

Zhao Lei (4):
  btrfs: Disable raid56 readahead
  btrfs: return all mirror whether need_raid_map set or not
  btrfs: Small cleanup for get index_srcdev loop
  btrfs: Use direct way to determine raid56 write/recover mode

 fs/btrfs/reada.c   |  5 +++++
 fs/btrfs/volumes.c | 50 ++++++++++++++++++++++++--------------------------
 2 files changed, 29 insertions(+), 26 deletions(-)

-- 
1.8.5.1



