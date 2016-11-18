Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:55800 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbcKRFuK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 00:50:10 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 02675AC024F
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 14:50:01 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
        by m3051.s.css.fujitsu.com (Postfix) with SMTP id CE5D3826
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 14:50:00 +0900 (JST)
Message-Id: <201611180549.AA00019@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Fri, 18 Nov 2016 14:49:51 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: test: fix convert-tests 004 failure
In-Reply-To: <201611180544.AA00017@WIN-5MHF4RKU941.jp.fujitsu.com>
References: <201611180544.AA00017@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

convert-tests 004 failed because the argument to check_all_images
is not specified.

# make test-convert
    [TEST]   convert-tests.sh
    [TEST/conv]   004-ext2-backup-superblock-ranges
find: '': No such file or directory
#

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh b/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
index c56650b..d764ed8 100755
--- a/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
+++ b/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
@@ -39,4 +39,4 @@ function check_image() {
 	rm -f $TEST_DEV
 }
 
-check_all_images
+check_all_images `pwd`
-- 
2.9.3
