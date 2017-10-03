Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:44152 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdJCGwd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 02:52:33 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id E97D3AC0653
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Oct 2017 15:47:31 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 3AAFF5842F7
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Oct 2017 15:47:31 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: misc-test: use raid1 for data to enable mount
 with -o degraded
Message-ID: <8a2f2ee0-dda6-0a6d-ded2-a93a449013f4@jp.fujitsu.com>
Date: Tue, 3 Oct 2017 15:47:26 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel 4.14 introduces new function for checking if all chunks is ok for
mount with -o degraded option.

  commit 21634a19f646 ("btrfs: Introduce a function to check if all
  chunks a OK for degraded rw mount")

As a result, raid0 profile cannot be mounted with -o degraded on 4.14.
This causes failure of the misc-test 011 "delete missing device". 

Fix this by using raid1 profile for both data and metadata.
This also should work for kernel before 4.13.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 tests/misc-tests/011-delete-missing-device/test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/misc-tests/011-delete-missing-device/test.sh b/tests/misc-tests/011-delete-missing-device/test.sh
index e817d90..8a1b14b 100755
--- a/tests/misc-tests/011-delete-missing-device/test.sh
+++ b/tests/misc-tests/011-delete-missing-device/test.sh
@@ -50,7 +50,7 @@ dev1=${loopdevs[1]}
 devtodel=${loopdevs[3]}
 TEST_DEV=$dev1
 
-test_do_mkfs
+test_do_mkfs -m raid1 -d raid1
 test_wipefs
 test_delete_missing
 
-- 
2.9.5

