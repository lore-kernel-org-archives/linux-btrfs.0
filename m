Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E4DC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DBE8206B7
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547472713;
	bh=uArKxEItyt6m/gASFUd4HzKQiCvoLNBcKUqG8kCFK/Q=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=da72rTHod0n1Yw0afROM5fyNcjcW/t/ZQFOBoM4rv/qbo57MPQfzcZoVxc2ONOx3I
	 s3suGMw4NSHVB5/VGMBChjlbg/kydBtLQemrA5ECV+A5loOgBDy7If9zVEvsfOP5By
	 Jsi7nGVr0+fO9ArxAnWeBRq0VLcPvdvtOJ9FC9JI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfANNbw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:31:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbfANNbw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 08:31:52 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C290B20651;
        Mon, 14 Jan 2019 13:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547472711;
        bh=uArKxEItyt6m/gASFUd4HzKQiCvoLNBcKUqG8kCFK/Q=;
        h=From:To:Cc:Subject:Date:From;
        b=1NVKVt20wZCNRy7VIGRFLlExD5nwNKwFGU8SOVq5I8k8fV7KT8kM4vjA09oSOqaFv
         VWuiJM5g7tUn5LiNi1fexHMp0njpfkr+xQs2EHJjUKclfAruQIH12bWFL0FRZzskNI
         fcJGfI6DHpRMvTKcBQJrG211/QBC9QwPNL2jMiE8=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     ddis@suse.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 3/3] Btrfs-progs: add test for receive
Date:   Mon, 14 Jan 2019 13:31:46 +0000
Message-Id: <20190114133146.18424-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Add a test for a scenario that used to fail due to find_mount_root()
incorrectly determining the mount point for the receive path due to the
fact that a different mount point with a path that is a prefix of the
receive path exists.

This is fixed by a recent patch titled:

  "Btrfs-progs: fix mount point detection due to partial prefix match"

Reported-by: David Disseldorp <ddis@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 .../034-receive-common-mount-point-prefix/test.sh  | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100755 tests/misc-tests/034-receive-common-mount-point-prefix/test.sh

diff --git a/tests/misc-tests/034-receive-common-mount-point-prefix/test.sh b/tests/misc-tests/034-receive-common-mount-point-prefix/test.sh
new file mode 100755
index 00000000..e2a6fdfc
--- /dev/null
+++ b/tests/misc-tests/034-receive-common-mount-point-prefix/test.sh
@@ -0,0 +1,47 @@
+#!/bin/bash
+# Test that receive determines the correct mount point path when there is
+# another mount point that matches the destination's path as a prefix.
+
+source "$TEST_TOP/common"
+
+check_prereq btrfs
+check_prereq mkfs.btrfs
+
+setup_root_helper
+
+rm -f dev1 dev2
+run_check truncate -s 1G dev1
+run_check truncate -s 1G dev2
+chmod a+w dev1 dev2
+
+loop1=$(run_check_stdout $SUDO_HELPER losetup --find --show dev1)
+loop2=$(run_check_stdout $SUDO_HELPER losetup --find --show dev2)
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$loop1"
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$loop2"
+
+run_check $SUDO_HELPER mount "$loop1" "$TEST_MNT"
+mkdir "${TEST_MNT}/ddis"
+mkdir "${TEST_MNT}/ddis-not-a-mount"
+run_check $SUDO_HELPER mount "$loop2" "${TEST_MNT}/ddis"
+
+echo "some data" > "${TEST_MNT}/ddis/file"
+
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot -r \
+	  "${TEST_MNT}/ddis" "${TEST_MNT}/ddis/snap"
+
+rm -f send.data
+run_check $SUDO_HELPER "$TOP/btrfs" send -f send.data "${TEST_MNT}/ddis/snap"
+
+# The following receive used to fail because it incorrectly determined the mount
+# point of the destination path to be ${TEST_MNT}/ddis and not $TEST_MNT.
+run_check $SUDO_HELPER "$TOP/btrfs" receive -f send.data \
+	  "${TEST_MNT}/ddis-not-a-mount"
+
+run_check $SUDO_HELPER umount "${TEST_MNT}/ddis"
+run_check $SUDO_HELPER umount "$TEST_MNT"
+
+# Cleanup loop devices and send data.
+run_check $SUDO_HELPER losetup -d "$loop1"
+run_check $SUDO_HELPER losetup -d "$loop2"
+rm -f dev1 dev2 send.data
-- 
2.11.0

