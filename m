Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:64955 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbcKRFsS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 00:48:18 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id A914FAC04CE
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 14:48:09 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
        by m3051.s.css.fujitsu.com (Postfix) with SMTP id 95ADC1E0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 14:48:09 +0900 (JST)
Message-Id: <201611180547.AA00018@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Fri, 18 Nov 2016 14:47:59 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: test: expand size of test device of fsck-tests 013
In-Reply-To: <201611180544.AA00017@WIN-5MHF4RKU941.jp.fujitsu.com>
References: <201611180544.AA00017@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In my test environment, size of /lib/modules/`uname -r`/* is
larger than 1GB, so test data can not copy to testdev.
Therefore we need expand the size of testdev.

# make test-fsck
    [TEST]   fsck-tests.sh
    [TEST/fsck]   013-extent-tree-rebuild
failed: cp -aR /lib/modules/4.9.0-rc5/ /test/btrfs-progs/tests/mnt
test failed for case 013-extent-tree-rebuild
Makefile:272: recipe for target 'test-fsck' failed
make: *** [test-fsck] Error 1
#

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 tests/fsck-tests/013-extent-tree-rebuild/test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index f678e29..92c5d04 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -7,7 +7,7 @@ check_prereq mkfs.btrfs
 check_prereq btrfs
 
 setup_root_helper
-prepare_test_dev 1G
+prepare_test_dev 2G
 
 # test whether fsck can rebuild a corrupted extent tree
 test_extent_tree_rebuild()
-- 
2.9.3
