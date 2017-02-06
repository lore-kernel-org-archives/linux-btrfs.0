Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60909 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751218AbdBFFsA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 00:48:00 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <calestyo@scientia.net>, <chris@colorremedies.com>, <dsterba@suse.cz>
Subject: [PATCH v2 09/12] btrfs-progs: fsck-test: Make 013 compatible with lowmem mode
Date: Mon, 6 Feb 2017 13:47:32 +0800
Message-ID: <20170206054735.5227-10-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
References: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fsck-tests/013-extent-tree-rebuild uses "--init-extent-tree", which
implies "--repair".

But the test script doesn't specify "--repair" for lowmem mode test to
detect it.

Add it so lowmem mode test can be happy with it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/fsck-tests/013-extent-tree-rebuild/test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index 37bdcd9c..08c1e50e 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -36,7 +36,7 @@ test_extent_tree_rebuild()
 
 	$SUDO_HELPER $TOP/btrfs check $TEST_DEV >& /dev/null && \
 			_fail "btrfs check should detect failure"
-	run_check $SUDO_HELPER $TOP/btrfs check --init-extent-tree $TEST_DEV
+	run_check $SUDO_HELPER $TOP/btrfs check --repair --init-extent-tree $TEST_DEV
 	run_check $SUDO_HELPER $TOP/btrfs check $TEST_DEV
 }
 
-- 
2.11.0



