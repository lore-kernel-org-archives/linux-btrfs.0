Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq6.tb.mail.iss.as9143.net ([212.54.42.169]:60266 "EHLO
        smtpq6.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751677AbcJIPuX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Oct 2016 11:50:23 -0400
Received: from [212.54.42.118] (helo=lsmtp4.tb.mail.iss.as9143.net)
        by smtpq6.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
        (envelope-from <laks@webminal.org>)
        id 1btFiQ-0003jG-VR
        for linux-btrfs@vger.kernel.org; Sun, 09 Oct 2016 17:08:38 +0200
Received: from 31-151-236-204.dynamic.upc.nl ([31.151.236.204] helo=webminal.org)
        by lsmtp4.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
        (envelope-from <laks@webminal.org>)
        id 1btFiG-0008Aa-Ra
        for linux-btrfs@vger.kernel.org; Sun, 09 Oct 2016 17:08:38 +0200
Received: from localhost.localdomain (fedori [127.0.0.1])
        by webminal.org (8.14.4/8.14.4) with ESMTP id u99F8MPQ002120
        for <linux-btrfs@vger.kernel.org>; Sun, 9 Oct 2016 17:08:32 +0200
Received: (from laks@localhost)
        by localhost.localdomain (8.14.4/8.14.4/Submit) id u99F8C3j001826
        for linux-btrfs@vger.kernel.org; Sun, 9 Oct 2016 17:08:12 +0200
Date: Sun, 9 Oct 2016 17:08:12 +0200
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH]btrfs-progs: Add fast,slow symlinks,fifo types to convert test
Message-ID: <20161009150811.GA32553@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 tests/common.convert | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/tests/common.convert b/tests/common.convert
index 1e00d38..5083e65 100644
--- a/tests/common.convert
+++ b/tests/common.convert
@@ -25,10 +25,10 @@ generate_dataset() {
 			done
 			;;
 
-		symlink)
+		fast_symlink)
 			for num in $(seq 1 $DATASET_SIZE); do
 				run_check $SUDO_HELPER touch $dirpath/$dataset_type.$num
-				run_check $SUDO_HELPER ln -s $dirpath/$dataset_type.$num $dirpath/slink.$num
+				run_check $SUDO_HELPER cd $dirpath && ln -s $dataset_type.$num $dirpath/slink.$num && cd /
 			done
 			;;
 
@@ -71,12 +71,26 @@ generate_dataset() {
 				run_check $SUDO_HELPER setfattr -n user.foo -v bar$num $dirpath/$dataset_type.$num
 			done
 			;;
+
+		fifo)
+			for num in $(seq 1 $DATASET_SIZE); do
+				run_check $SUDO_HELPER mkfifo $dirpath/$dataset_type.$num
+			done
+			;;
+
+		slow_symlink)
+			long_filename=`date +%s | sha256sum | cut -f1 -d'-'`
+			run_check $SUDO_HELPER touch $dirpath/$long_filename
+			for num in $(seq 1 $DATASET_SIZE); do
+				run_check $SUDO_HELPER ln -s $dirpath/$long_filename $dirpath/slow_slink.$num
+			done
+			;;
 	esac
 }
 
 populate_fs() {
 
-        for dataset_type in 'small' 'hardlink' 'symlink' 'brokenlink' 'perm' 'sparse' 'acls'; do
+        for dataset_type in 'small' 'hardlink' 'fast_symlink' 'brokenlink' 'perm' 'sparse' 'acls' 'fifo' 'slow_symlink'; do
 		generate_dataset "$dataset_type"
 	done
 }
-- 
1.9.3

