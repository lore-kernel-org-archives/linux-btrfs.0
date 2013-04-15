Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44374 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3DOGhd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:37:33 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 05/11, RESEND] btrfs-progs: mkfs stdout print to match chronology
Date: Mon, 15 Apr 2013 14:38:11 +0800
Message-Id: <1366007897-26567-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
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
index a58b313..2eb3087 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1472,6 +1472,12 @@ int main(int ac, char **av)
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
@@ -1545,13 +1551,7 @@ raid_groups:
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

