Return-Path: <SRS0=DXmw=ZV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201FEC43215
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Nov 2019 04:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA64A21781
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Nov 2019 04:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfK2E5u (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Nov 2019 23:57:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:54372 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726800AbfK2E5u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Nov 2019 23:57:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4EDB7AC1A;
        Fri, 29 Nov 2019 04:57:48 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: common: Allow user to keep $seqres.dmesg for all tests
Date:   Fri, 29 Nov 2019 12:57:43 +0800
Message-Id: <20191129045743.47105-1-wqu@suse.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently fstests will remove $seqres.dmesg if nothing wrong happened.
It saves some space, but sometimes it may not provide good enough
history for developers to check.
E.g. some unexpected dmesg from fs, but not serious enough to be caught
by current filter.

So instead of deleting the ordinary $seqres.dmesg, provide a new config:
KEEP_DMESG, to allow user to choose whether to keep the dmesg.

The default value for it is 0, which keeps the existing behavior by
deleting ordinary dmesg.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/config | 4 ++++
 common/rc     | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/common/config b/common/config
index 1b75777f..b409f32c 100644
--- a/common/config
+++ b/common/config
@@ -22,6 +22,9 @@
 # RMT_IRIXTAPE_DEV- the IRIX remote tape device for the xfsdump tests
 # RMT_TAPE_USER -   remote user for tape device
 # SELINUX_MOUNT_OPTIONS - Options to use when SELinux is enabled.
+# KEEP_DMESG -      whether to keep all dmesg for each test case.
+#                   1: keep all dmesg
+#                   0: only keep dmesg with error/warning (default)
 #
 # - These can be added to $HOST_CONFIG_DIR (witch default to ./config)
 #   below or a separate local configuration file can be used (using
@@ -757,6 +760,7 @@ if [ -z "$CONFIG_INCLUDED" ]; then
 	[ -z "$TEST_FS_MOUNT_OPTS" ] && _test_mount_opts
 	[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
 	[ -z "$FSCK_OPTIONS" ] && _fsck_opts
+	[ -z "$KEEP_DMESG" ] && export KEEP_DMESG=0
 else
 	# We get here for the non multi section case, on every test that sources
 	# common/rc after re-sourcing the HOST_OPTIONS config file.
diff --git a/common/rc b/common/rc
index e5535279..a1386f61 100644
--- a/common/rc
+++ b/common/rc
@@ -3634,7 +3634,9 @@ _check_dmesg()
 		_dump_err "_check_dmesg: something found in dmesg (see $seqres.dmesg)"
 		return 1
 	else
-		rm -f $seqres.dmesg
+		if [ "$KEEP_DMESG" != 1 ]; then
+			rm -f $seqres.dmesg
+		fi
 		return 0
 	fi
 }
-- 
2.23.0

