Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56063 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab2KHJx4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Nov 2012 04:53:56 -0500
Message-ID: <509B8145.2020802@cn.fujitsu.com>
Date: Thu, 08 Nov 2012 17:54:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>, wangshilong <wangsl-fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] Btrfs-progs: check the relation of two group by real
 level numbers
References: <509B7C28.10406@cn.fujitsu.com>
In-Reply-To: <509B7C28.10406@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Comparing qgroupid is not good way to check the relationship of two groups,
the right way is to compare the real level numbers.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-qgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index c4122bf..70019d0 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -50,7 +50,7 @@ static int qgroup_assign(int assign, int argc, char **argv)
 	/*
 	 * FIXME src should accept subvol path
 	 */
-	if (args.src >= args.dst) {
+	if ((args.src >> 48) >= (args.dst >> 48)) {
 		fprintf(stderr, "ERROR: bad relation requested '%s'\n", path);
 		return 12;
 	}
-- 1.7.7.6 









