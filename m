Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq2.tb.mail.iss.as9143.net ([212.54.42.165]:41533 "EHLO
        smtpq2.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753427AbcIOJeh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 05:34:37 -0400
Received: from [212.54.42.118] (helo=lsmtp4.tb.mail.iss.as9143.net)
        by smtpq2.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
        (envelope-from <laks@webminal.org>)
        id 1bkT3z-0007qO-Ja
        for linux-btrfs@vger.kernel.org; Thu, 15 Sep 2016 11:34:35 +0200
Received: from 31-151-236-204.dynamic.upc.nl ([31.151.236.204] helo=webminal.org)
        by lsmtp4.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
        (envelope-from <laks@webminal.org>)
        id 1bkT3p-0006ZL-F8
        for linux-btrfs@vger.kernel.org; Thu, 15 Sep 2016 11:34:35 +0200
Received: from localhost.localdomain (fedori [127.0.0.1])
        by webminal.org (8.14.4/8.14.4) with ESMTP id u8F9YHP9018178
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 11:34:28 +0200
Received: (from laks@localhost)
        by localhost.localdomain (8.14.4/8.14.4/Submit) id u8F9Y7Ud018150
        for linux-btrfs@vger.kernel.org; Thu, 15 Sep 2016 11:34:07 +0200
Date: Thu, 15 Sep 2016 11:34:07 +0200
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH]btrfs-progs: Add fast,slow symlinks and fifo types to convert
 test
Message-ID: <20160915093407.GA17835@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 tests/common.convert | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/tests/common.convert b/tests/common.convert
index 67c99b1..2790be5 100644
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
 
@@ -71,12 +71,24 @@ generate_dataset() {
 				run_check $SUDO_HELPER setfattr -n user.foo -v bar$num $dirpath/$dataset_type.$num
 			done
 			;;
+		fifo)
+			for num in $(seq 1 $DATASET_SIZE); do
+				run_check $SUDO_HELPER mkfifo $dirpath/$dataset_type.$num
+			done
+			;;
+		slow_symlink)
+			for num in $(seq 1 $DATASET_SIZE); do
+				fname64=`date +%s | sha256sum | cut -f1 -d'-'`
+				run_check $SUDO_HELPER touch $dirpath/$fname64
+				run_check $SUDO_HELPER ln -s $dirpath/$fname64 $dirpath/slow_slink.$num
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

