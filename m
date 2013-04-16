Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49401 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab3DPKTM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 06:19:12 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r3GAJ59n030997
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 18:19:09 +0800
Message-ID: <516D265F.4020806@cn.fujitsu.com>
Date: Tue, 16 Apr 2013 18:22:23 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove unused variable in the iterate_extent_inodes()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index bd605c8..fa531e8 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1461,8 +1461,6 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				iterate_extent_inodes_t *iterate, void *ctx)
 {
 	int ret;
-	struct list_head data_refs = LIST_HEAD_INIT(data_refs);
-	struct list_head shared_refs = LIST_HEAD_INIT(shared_refs);
 	struct btrfs_trans_handle *trans;
 	struct ulist *refs = NULL;
 	struct ulist *roots = NULL;
-- 1.7.7.6

