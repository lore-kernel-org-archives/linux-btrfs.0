Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42182 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbdEIS5y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 14:57:54 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@gmail.com>,
        Eryu Guan <eguan@redhat.com>
Subject: [PATCH 1/6] fstests: add _filter_filefrag
Date: Tue,  9 May 2017 11:56:06 -0600
Message-Id: <1494352571-17199-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1494352571-17199-1-git-send-email-bo.li.liu@oracle.com>
References: <1494352571-17199-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

_filter_filefrag is a helper function to filter filefrag's output and it can be
used to get a file's file offset and physical offset.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 common/filter | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/common/filter b/common/filter
index 5fd71a8..1ef342b 100644
--- a/common/filter
+++ b/common/filter
@@ -418,5 +418,24 @@ _filter_ovl_dirs()
 	    -e "s,$OVL_WORK,OVL_WORK,g"
 }
 
+# interpret filefrag output,
+# eg. "physical 1234, length 10, logical 5678" -> "1234#10#5678"
+_filter_filefrag()
+{
+	perl -ne '
+	if (/blocks? of (\d+) bytes/) {
+		$blocksize = $1;
+		next
+	}
+	($ext, $logical, $physical, $length) =
+		(/^\s*(\d+):\s+(\d+)..\s+\d+:\s+(\d+)..\s+\d+:\s+(\d+):/)
+	or next;
+	($flags) = /.*:\s*(\S*)$/;
+	print $physical * $blocksize, "#",
+	      $length * $blocksize, "#",
+	      $logical * $blocksize, "#",
+	      $flags, "\n"'
+}
+
 # make sure this script returns success
 /bin/true
-- 
2.5.0

