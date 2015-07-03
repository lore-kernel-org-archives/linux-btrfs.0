Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24915 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754279AbbGCBT7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jul 2015 21:19:59 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t631IH62024005
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jul 2015 09:18:17 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: remove empty header file extent-tree.h
Date: Fri, 3 Jul 2015 09:17:54 +0800
Message-ID: <1435886274-8309-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The empty file is introduced as an careless 'git add', remove it.

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 fs/btrfs/extent-tree.h

diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
deleted file mode 100644
index e69de29..0000000
-- 
2.4.4

