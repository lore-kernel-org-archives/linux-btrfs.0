Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:34858 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbeDWFJy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 01:09:54 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 2196FAC00CE
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 14:09:49 +0900 (JST)
Received: from g01jpexchyt36.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 2FCD56D663B
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 14:09:48 +0900 (JST)
Subject: [RFC PATCH v4 5/6] btrfs-progs: test: Add helper function to check if
 test user exists
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <70590827-0c29-75ea-5e43-2e53264b3d4c@jp.fujitsu.com>
Message-ID: <5a4e94d8-297c-938d-ec9e-29a970a02d55@jp.fujitsu.com>
Date: Mon, 23 Apr 2018 14:09:44 +0900
MIME-Version: 1.0
In-Reply-To: <70590827-0c29-75ea-5e43-2e53264b3d4c@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test user 'progs-test' will be used to test the behavior of normal user.

In order to pass this check, add the user by "useradd -M progs-test".
Note that progs-test should not have root privileges.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 tests/common | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tests/common b/tests/common
index 4b266c5b..76006efa 100644
--- a/tests/common
+++ b/tests/common
@@ -314,6 +314,16 @@ check_global_prereq()
 	fi
 }
 
+check_testuser()
+{
+	id -u progs-test > /dev/null 2>&1
+	if [ $? -ne 0 ]; then
+		_not_run "Need to add user \"progs-test\""
+	fi
+	# Note that progs-test should not have root privileges
+	# otherwise test may not run as expected
+}
+
 check_image()
 {
 	local image
-- 
2.14.3

