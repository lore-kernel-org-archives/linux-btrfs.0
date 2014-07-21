Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24780 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbaGUI6D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 04:58:03 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, fdmanana@gmail.com, dsterba@suse.cz
Subject: [PATCH] xfstest/btrfs: check for matching kernel send stream ver 2
Date: Mon, 21 Jul 2014 17:01:19 +0800
Message-Id: <1405933279-21309-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The test case btrfs/049 is relevant to send stream version 2, and
needs kernel patches as well. So call _notrun if there isn't
matching kernel support as shown below

btrfs/047	 [not run] Missing btrfs kernel patch for send stream version 2, skipped this test
Not run: btrfs/047

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 common/rc | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/common/rc b/common/rc
index 4a6511f..1c914bb 100644
--- a/common/rc
+++ b/common/rc
@@ -2223,6 +2223,11 @@ _require_btrfs_send_stream_version()
 	if [ $? -ne 0 ]; then
 		_notrun "Missing btrfs-progs send --stream-version command line option, skipped this test"
 	fi
+
+	# test if btrfs kernel supports send stream version 2
+	if [ ! -f /sys/fs/btrfs/send/stream_version ]; then
+		_notrun "Missing btrfs kernel patch for send stream version 2, skipped this test"
+	fi
 }
 
 _require_btrfs_mkfs_feature()
-- 
2.0.0.153.g79dcccc

