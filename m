Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:57078 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754044AbdKABaw (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 31 Oct 2017 21:30:52 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v4 3/4] btrfs-progs: test/common: Enhance prepare_test_dev to reset device size
Date: Wed,  1 Nov 2017 09:30:42 +0800
Message-Id: <20171101013043.19294-4-wqu@suse.com>
In-Reply-To: <20171101013043.19294-1-wqu@suse.com>
References: <20171101013043.19294-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So prepare_test_dev() can be called several times in one test case, to
test different device sizes.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/common | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tests/common b/tests/common
index 977bade201a6..63750dbfeffe 100644
--- a/tests/common
+++ b/tests/common
@@ -441,8 +441,12 @@ prepare_test_dev()
 	# num[K/M/G/T...]
 	local size="$1"
 
-	[[ "$TEST_DEV" ]] && return
 	[[ "$size" ]] || size='2G'
+	# Still truncate it to new size
+	if [[ "$TEST_DEV" ]]; then
+		truncate -s "$size" "$TEST_DEV"
+		return;
+	fi
 
 	echo "\$TEST_DEV not given, use $TOP/test/test.img as fallback" >> \
 		"$RESULTS"
-- 
2.14.3

