Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43279 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753566AbbIHNSa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 09:18:30 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t88DIFYv018022
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Sep 2015 21:18:15 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/3] btrfs-progs: Avoid uninitialized data in output of btrfs-convert
Date: Tue, 8 Sep 2015 21:16:48 +0800
Message-ID: <cover.1441718128.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sequence, transid and reserved field of inode was write to disk
with uninitizlized value, this patchset fixed it, also fixed some
other typo.

Zhao Lei (3):
  btrfs-progs: fix set_get typo of btrfs_inode_item->sequence
  btrfs-progs: Avoid uninitialized data in output of btrfs-convert
  btrfs-progs: add ext2fs_close_inode_scan to copy_inodes

 btrfs-convert.c | 5 +++++
 ctree.h         | 4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

-- 
1.8.5.1

