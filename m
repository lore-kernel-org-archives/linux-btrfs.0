Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:60038 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbeCOIP5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 04:15:57 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id EA633AC0234
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:15:52 +0900 (JST)
Received: from g01jpexchyt38.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 2004158436C
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:15:52 +0900 (JST)
Subject: [RFC PATCH v2 7/8] btrfs-progs: test: Add helper function to check if
 test user exists
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <226b6805-c5aa-c40d-4ea6-f81dc1b7de20@jp.fujitsu.com>
Message-ID: <3ebafef6-45eb-a27a-644c-4bdd1ff09870@jp.fujitsu.com>
Date: Thu, 15 Mar 2018 17:15:48 +0900
MIME-Version: 1.0
In-Reply-To: <226b6805-c5aa-c40d-4ea6-f81dc1b7de20@jp.fujitsu.com>
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
index fae30f1d..e8f7c061 100644
--- a/tests/common
+++ b/tests/common
@@ -307,6 +307,16 @@ check_global_prereq()
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

