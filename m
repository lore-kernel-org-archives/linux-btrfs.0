Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45943 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752191AbbC0KXD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Mar 2015 06:23:03 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2RALxhv021657
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2015 18:21:59 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: wait for delayed iputs on no space
Date: Fri, 27 Mar 2015 18:21:26 +0800
Message-ID: <cover.1427450911.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

This is another fix of no_space case.

All patchs for fix no_space bug are available at fix_no_space
branch on:
  git://github.com/zhaoleidd/btrfs

Any suggestions are welcome.

Zhao Lei (1):
  btrfs: wait for delayed iputs on no space

 fs/btrfs/extent-tree.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
1.8.5.1

