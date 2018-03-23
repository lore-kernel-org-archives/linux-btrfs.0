Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751400AbeCWOsR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 10:48:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8468DB00C
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 14:48:16 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs-progs: Add test for collision DIR_ITEM handling
Date: Fri, 23 Mar 2018 16:48:14 +0200
Message-Id: <1521816494-22947-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1521816494-22947-1-git-send-email-nborisov@suse.com>
References: <1521816494-22947-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Verify that if we have an otherwise clean filesystem, containging collided 
DIR_ITEM, btrfs check lowmem's mode can correctly handle those and not produce
any false positives. 

This if fixed by commit titled:

 "btrfs-progs: Fix DIR_ITEM checking in lowmem" 

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 .../031-lowmem-collission-dir-items/test.sh        | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100755 tests/fsck-tests/031-lowmem-collission-dir-items/test.sh

diff --git a/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh b/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh
new file mode 100755
index 0000000..8a01889
--- /dev/null
+++ b/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh
@@ -0,0 +1,27 @@
+#!/bin/bash
+# Ensure that running btrfs check in lowmem mode on a fs
+# which contains DIR_ITEM with collissions handles it
+# properly
+source "$TEST_TOP/common"
+
+check_prereq btrfs
+check_prereq mkfs.btrfs
+
+setup_root_helper
+prepare_test_dev
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check_mount_test_dev
+
+# Create 2 files whose names collide
+
+run_check $SUDO_HELPER touch "$TEST_MNT/5ab4e206~~~~~~~~XVT1U3ZF647YS2PD4AKAG826"
+run_check $SUDO_HELPER touch "$TEST_MNT/5ab4e26a~~~~~~~~AP1C3VQBE79IJOTVOEZIR9YU"
+
+run_check_umount_test_dev
+
+# The fs is clean so lowmem shouldn't produce any warnings
+run_check "$TOP/btrfs" check --mode=lowmem --readonly "$TEST_DEV"
+if [ $? -ne 0 ]; then
+	_fail "check --lowmem doesn't handle collissioned DIR_ITEMs correctly"
+fi
-- 
2.7.4

