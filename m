Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:41847 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2GCEI1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 00:08:27 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q6348OYE030896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2012 04:08:25 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q6348OUK003359
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2012 04:08:24 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q6348OiN011106
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Jul 2012 23:08:24 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH] Seg fault when csum-tree root is corrupted.
Date: Tue,  3 Jul 2012 12:04:44 +0800
Message-Id: <1341288284-2702-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <4FE95146.2030707@oracle.com>
References: <4FE95146.2030707@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Segmentation fault with the following trace when csum-tree is
deliberately corrupted using btrfs-corrupt-block

read block failed check_tree_block
Couldn't setup csum tree
checking extents
Check tree block failed, want=29376512, have=0
::
read block failed check_tree_block <---- !!
Segmentation fault (core dumped) <--- !!

The below fix will redirect btrfsck user to use --init-csum-tree
when csum root is corrupted
---
 btrfsck.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 7aac736..6ced7b5 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -3483,6 +3483,10 @@ int main(int ac, char **av)
 		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
 		return -EIO;
 	}
+	if (!extent_buffer_uptodate(info->csum_root->node) && !init_csum_tree) {
+		fprintf(stderr, "Checksum root corrupted, run 'btrfsck --init-csum-tree'\n");
+		return -EIO;
+	}
 
 	root = info->fs_root;
 
-- 
1.7.1

