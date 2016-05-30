Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933116AbcE3PxM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 11:53:12 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 792CAAB43
	for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 15:53:11 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: tests: run rollback after conversion
Date: Mon, 30 May 2016 17:52:34 +0200
Message-Id: <1464623554-5119-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 tests/convert-tests.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 3fce8915f94a..2806b921544b 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -138,6 +138,9 @@ convert_test() {
 	run_check_stdout $SUDO_HELPER md5sum -c $CHECKSUMTMP |
 		grep -q 'FAILED' && _fail "file validation failed."
 	run_check_umount_test_dev
+
+	run_check $TOP/btrfs-convert --rollback $TEST_DEV
+	run_check fsck -n -t ext2,ext3,ext4 $TEST_DEV
 }
 
 if ! [ -z "$TEST" ]; then
-- 
2.7.1

