Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38611 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161470Ab3DEFxx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:53 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355rqmO001862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:53 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355rqDG012073
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:52 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355rp6u017115
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:51 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] btrfs-progs: mkfs stdout print to match chronology
Date: Fri,  5 Apr 2013 13:55:00 +0800
Message-Id: <1365141303-10571-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A trivial fix: To match the events inside to what
being printed out

before:
----
::
adding device /dev/dm-3 id 2
adding device /dev/dm-4 id 3
adding device /dev/dm-5 id 4
fs created label (null) on /dev/dm-2
nodesize 4096 leafsize 4096 sectorsize 4096 size 213.20GB
Btrfs v0.20-rc1-235-gdd21bc1
----

After:
----
::
fs created label (null) on /dev/dm-2 id 1
	nodesize 4096 leafsize 4096 sectorsize 4096 size 59.99GB
adding device /dev/dm-3 id 2
adding device /dev/dm-4 id 3
adding device /dev/dm-5 id 4

Btrfs v0.20-rc1-235-gdd21bc1
----

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index dc4120a..de83cc8 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1596,6 +1596,12 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
+	printf("fs created label %s on %s id 1\n\tnodesize %u leafsize %u "
+	    "sectorsize %u size %s\n",
+	    label, first_file, nodesize, leafsize, sectorsize,
+	    pretty_buf = pretty_sizes(btrfs_super_total_bytes(root->fs_info->super_copy)));
+	free(pretty_buf);
+
 	trans = btrfs_start_transaction(root, 1);
 
 	if (dev_cnt == 0)
@@ -1671,13 +1677,7 @@ raid_groups:
 		printf("Setting RAID5/6 feature flag\n");
 	}
 
-	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
-	    "sectorsize %u size %s\n",
-	    label, first_file, nodesize, leafsize, sectorsize,
-	    pretty_buf = pretty_sizes(btrfs_super_total_bytes(root->fs_info->super_copy)));
-	free(pretty_buf);
-
-	printf("%s\n", BTRFS_BUILD_VERSION);
+	printf("\n%s\n", BTRFS_BUILD_VERSION);
 	btrfs_commit_transaction(trans, root);
 
 	if (source_dir_set) {
-- 
1.8.1.227.g44fe835

