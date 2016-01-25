Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36676 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933447AbcAYQJF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 11:09:05 -0500
Received: by mail-pf0-f195.google.com with SMTP id n128so7009814pfn.3
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 08:09:05 -0800 (PST)
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Subject: [PATCH][btrfs-progs] Include file verification with convert-tests
Date: Mon, 25 Jan 2016 21:38:33 +0530
Message-Id: <1453738113-19583-1-git-send-email-Lakshmipathi.G@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 tests/convert-tests.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index b26c069..b3d9797 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -45,10 +45,14 @@ convert_test() {
 	run_check $SUDO_HELPER mount -o loop $IMAGE $TEST_MNT
 	run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/test bs=$nodesize \
 		count=1 1>/dev/null 2>&1
+        run_check_stdout $SUDO_HELPER md5sum $TEST_MNT/test > $TEST_MNT/test.md5sum
 	run_check $SUDO_HELPER umount $TEST_MNT
 	run_check $TOP/btrfs-convert ${features:+-O "$features"} -N "$nodesize" $IMAGE
 	run_check $TOP/btrfs check $IMAGE
 	run_check $TOP/btrfs-show-super $IMAGE
+	run_check $SUDO_HELPER mount -o loop $IMAGE $TEST_MNT
+	run_check_stdout $SUDO_HELPER md5sum -c $TEST_MNT/test.md5sum | grep -q 'OK' || _fail "file validation failed."
+	run_check $SUDO_HELPER umount $TEST_MNT
 }
 
 if ! [ -z "$TEST" ]; then
-- 
1.8.3.1

