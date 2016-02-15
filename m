Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43249 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbcBOUqa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 15:46:30 -0500
Subject: [PATCH 1/3] generic/304: fix high offset
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Mon, 15 Feb 2016 12:46:14 -0800
Message-ID: <20160215204614.7977.2848.stgit@birch.djwong.org>
In-Reply-To: <20160215204608.7977.2802.stgit@birch.djwong.org>
References: <20160215204608.7977.2802.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"Invalid argument" is a better response to an impossibly high offset
dedupe request than "extents don't match", so change the test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/304.out |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/304.out b/tests/generic/304.out
index 4af2a39..7b5ff0e 100644
--- a/tests/generic/304.out
+++ b/tests/generic/304.out
@@ -8,7 +8,7 @@ dedupe: Invalid argument
 Dedupe past maximum file size in dest file (should fail)
 dedupe: Invalid argument
 Dedupe high offset to low offset
-dedupe: Extents did not match.
+dedupe: Invalid argument
 Dedupe past source file EOF (should fail)
 dedupe: Invalid argument
 Dedupe max size at nonzero offset (should fail)

