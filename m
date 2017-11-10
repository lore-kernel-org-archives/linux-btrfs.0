Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33445 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755578AbdKJBe0 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 9 Nov 2017 20:34:26 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3] btrfs-progs: test/fsck/021: Cleanup custom check by overriding check_image
Date: Fri, 10 Nov 2017 09:34:19 +0800
Message-Id: <20171110013419.15159-3-wqu@suse.com>
In-Reply-To: <20171110013419.15159-1-wqu@suse.com>
References: <20171110013419.15159-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../fsck-tests/021-partially-dropped-snapshot-case/test.sh | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh b/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
index 44a33a63d269..a5e166ec5060 100755
--- a/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
+++ b/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
@@ -5,14 +5,18 @@ source "$TOP/tests/common"
 
 check_prereq btrfs
 
-for img in *.img
-do
-	image=$(extract_image "$img")
+check_image()
+{
+	local image
+
+	image=$1
+
 	run_check_stdout "$TOP/btrfs" check "$image" 2>&1 |
 		grep -q "Errors found in extent allocation tree or chunk allocation"
 	if [ $? -eq 0 ]; then
 		rm -f "$image"
 		_fail "unexpected error occurred when checking $img"
 	fi
-	rm -f "$image"
-done
+}
+
+check_all_images
-- 
2.15.0

