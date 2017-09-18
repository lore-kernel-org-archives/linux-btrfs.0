Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50785 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751861AbdIRHWA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:22:00 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 09/14] btrfs-progs: tests/common: Introduce optional parameter to specify destination directory for generate_dataset
Date: Mon, 18 Sep 2017 16:21:34 +0900
Message-Id: <20170918072139.6300-10-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Normally generate_dataset() will create data into
$TEST_MNT/$dataset_type.

This is OK since most tests are doing their operation in $TEST_MNT.
However this is not the case for "mkfs --rootdir" test.

This patch will adds an optional parameter for generate_dataset() to
specify the destination directory, for later "mkfs --rootdir" test
cases.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 tests/common | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tests/common b/tests/common
index 9aebe3e7..242ded1d 100644
--- a/tests/common
+++ b/tests/common
@@ -440,7 +440,11 @@ DATASET_SIZE=50
 generate_dataset() {
 
 	dataset_type="$1"
-	dirpath=$TEST_MNT/$dataset_type
+	if [ -z "$2" ]; then
+		dirpath="$TEST_MNT/$dataset_type"
+	else
+		dirpath="$2/$dataset_type"
+	fi
 	run_check $SUDO_HELPER mkdir -p "$dirpath"
 
 	case "$dataset_type" in
-- 
2.14.1

