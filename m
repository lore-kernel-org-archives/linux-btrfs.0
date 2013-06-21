Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:58144 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945951Ab3FUUav (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 16:30:51 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2AFB99A06A1
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 14:30:51 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id rQ2OFntvrfnOie3N (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 14:30:50 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] xfstests: make fs for 274 larger
Date: Fri, 21 Jun 2013 16:30:48 -0400
Message-ID: <1371846648-21841-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs will default to mixed block groups for 1 gigabyte file systems and
smaller, which means data and metadata share the same area.  This makes
generic/274 fail for us because we cannot reserve enough metadata space to do
our writes.  Bumping the scratch fs up to 2 gigabytes allows us to do our normal
metadata/data seperation and allows us to pass this test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/generic/274 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/generic/274 b/tests/generic/274
index da45fab..7c4887f 100755
--- a/tests/generic/274
+++ b/tests/generic/274
@@ -57,7 +57,7 @@ echo "------------------------------"
 rm -f $seqres.full
 
 umount $SCRATCH_DEV 2>/dev/null
-_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
 _scratch_mount
 
 # Create a 4k file and Allocate 4M past EOF on that file
-- 
1.7.7.6

