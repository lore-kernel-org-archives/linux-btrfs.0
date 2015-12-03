Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34756 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759489AbbLCKKp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Dec 2015 05:10:45 -0500
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] fstests: Fix generic/102 fail for btrfs
Date: Thu, 3 Dec 2015 18:08:36 +0800
Message-ID: <56d7fca5e2f5dadceb4a3ec3d4589fec54da8d3b.1449137276.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

generic/102 sometimes fails in newest btrfs toolchain,
because it use non-mixed mode in default, which request more space
for metadata, and no space for data writing.

This patch force mixed mode for btrfs in generic/102.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/generic/102 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/generic/102 b/tests/generic/102
index abc3994..8c01fb5 100755
--- a/tests/generic/102
+++ b/tests/generic/102
@@ -48,6 +48,8 @@ _require_scratch
 
 rm -f $seqres.full
 
+[[ "$FSTYP" = "btrfs" ]] && MKFS_OPTIONS+=" --mixed"
+
 dev_size=$((512 * 1024 * 1024))     # 512MB filesystem
 _scratch_mkfs_sized $dev_size >>$seqres.full 2>&1
 _scratch_mount
-- 
1.8.5.1



