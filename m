Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40333 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753038AbbBYCx4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 21:53:56 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1P2r2M6031605
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2015 10:53:02 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 0/2] btrfs: Set relative data on clear btrfs_block_group_cache->pinned
Date: Wed, 25 Feb 2015 10:52:42 +0800
Message-ID: <1424832762-24926-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Changelog v1->v2:
 drop patch of:
  Remove BUG_ON() when failed searching block_group_cache in unpin_extent_range()
 because Filipe Manana <fdmanana@suse.com> already fixed it with
 better way.

Zhao Lei (2):
  btrfs: Set relative data on clear btrfs_block_group_cache->pinned
  btrfs: add WARN_ON() to check is space_info op current

 fs/btrfs/extent-tree.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

-- 
1.8.5.1

