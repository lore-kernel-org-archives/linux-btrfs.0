Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57506 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485AbaEHSio (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 May 2014 14:38:44 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>, <sandeen@redhat.com>
Subject: [PATCH] xfstests: fix flink test V2
Date: Thu, 8 May 2014 14:38:30 -0400
Message-ID: <1399574310-13718-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't have flink support in my xfsprogs, but it doesn't fail with "command not
found" or whatever, it fails because I don't have the -T option, whereas Eric
gets an error about $TEST_DIR being a directory because his xfs_io tries to open
the directory first before it parses the options.  So fix this by checking flink
with these two cases and don't run if we hit either of them.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: check for "Is a directory" errors that Eric mentioned, move test up into
the flink specific case.

 common/rc | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/rc b/common/rc
index 5c13db5..f37b310 100644
--- a/common/rc
+++ b/common/rc
@@ -1248,6 +1248,8 @@ _require_xfs_io_command()
 	"flink" )
 		testio=`$XFS_IO_PROG -T -F -c "flink $testfile" \
 			$TEST_DIR 2>&1`
+		echo $testio | egrep -q "invalid option|Is a directory" && \
+			_notrun "xfs_io $command support is missing"
 		;;
 	*)
 		testio=`$XFS_IO_PROG -c "$command help" 2>&1`
-- 
1.8.3.1

