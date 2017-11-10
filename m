Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:50283 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755576AbdKJBe0 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 9 Nov 2017 20:34:26 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/3] btrfs-progs: test/fsck/020: Cleanup custom check function by overriding check_image function
Date: Fri, 10 Nov 2017 09:34:18 +0800
Message-Id: <20171110013419.15159-2-wqu@suse.com>
In-Reply-To: <20171110013419.15159-1-wqu@suse.com>
References: <20171110013419.15159-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/fsck-tests/020-extent-ref-cases/test.sh | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tests/fsck-tests/020-extent-ref-cases/test.sh b/tests/fsck-tests/020-extent-ref-cases/test.sh
index 1e1e4e2386fb..f5c6591a92b8 100755
--- a/tests/fsck-tests/020-extent-ref-cases/test.sh
+++ b/tests/fsck-tests/020-extent-ref-cases/test.sh
@@ -19,12 +19,11 @@ source "$TOP/tests/common"
 
 check_prereq btrfs
 
-for img in *.img *.raw.xz
-do
-	image=$(extract_image "$img")
+check_image() {
+	local image
 
-	# Since the return value bug is already fixed, we don't need
-	# the old grep hack to detect bug.
+	image=$1
 	run_check "$TOP/btrfs" check "$image"
-	rm -f "$image"
-done
+}
+
+check_all_images
-- 
2.15.0

