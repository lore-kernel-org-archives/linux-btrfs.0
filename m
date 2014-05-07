Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19475 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbaEGUyw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 16:54:52 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: [PATCH] xfstests: fix flink test
Date: Wed, 7 May 2014 16:54:47 -0400
Message-ID: <1399496087-20431-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't have flink support in my xfsprogs, but it doesn't fail with "command not
found" or whatever, it fails because I don't have the -T option.  So fix
_require_xfs_io_command to check for an invalid option and not run.  This way I
get notrun instead of a failure.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 common/rc | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/rc b/common/rc
index 5c13db5..4fa7e63 100644
--- a/common/rc
+++ b/common/rc
@@ -1258,6 +1258,8 @@ _require_xfs_io_command()
 		_notrun "xfs_io $command support is missing"
 	echo $testio | grep -q "Operation not supported" && \
 		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
+	echo $testio | grep -q "invalid option" && \
+		_notrun "xfs_io $command support is missing"
 }
 
 # Check that a fs has enough free space (in 1024b blocks)
-- 
1.8.3.1

