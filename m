Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18247 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756753AbdGLHNv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 03:13:51 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: fix the path use full_path as provided by the root info
Date: Wed, 12 Jul 2017 15:20:27 +0800
Message-Id: <20170712072027.2459-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a kind of preparatory patch for the patch which will add
--rootid and --uuid options for the btrfs subvol show command.

As of now btrfs subvol show is using the external user provided subvol
path to show in the output. Which is kind of confusing.

btrfs su show /btrfs
/btrfs <--
	Name: 			<FS_TREE>

It will be even more confusing when proposed --uuid or --rootid
options are used.

btrfs su show --rootid 258 /btrfs
/btrfs <--
	Name: 			snap <--
	UUID: 			9630a45f-e647-4242-bd19-97590b4e20b2
	Parent UUID: 		30129358-c69d-3e4a-a662-29509cc69c95
	Received UUID: 		-
	Creation time: 		2017-07-12 12:43:28 +0800
	Subvolume ID: 		258
	Generation: 		9
	Gen at creation: 	9
	Parent ID: 		257
	Top level ID: 		257
	Flags: 			-
	Snapshot(s):

Now with this patch, it will only show what is provided by the root_info.

btrfs su show --rootid 258 /btrfs
sv1/snap <--
	Name: 			snap
	UUID: 			9630a45f-e647-4242-bd19-97590b4e20b2
	Parent UUID: 		30129358-c69d-3e4a-a662-29509cc69c95
	Received UUID: 		-
	Creation time: 		2017-07-12 12:43:28 +0800
	Subvolume ID: 		258
	Generation: 		9
	Gen at creation: 	9
	Parent ID: 		257
	Top level ID: 		257
	Flags: 			-
	Snapshot(s):

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 674a3a51f6f9..de6204eabeaf 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -934,7 +934,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	}
 
 	/* print the info */
-	printf("%s\n", fullpath);
+	printf("%s\n", get_ri.full_path);
 	printf("\tName: \t\t\t%s\n", get_ri.name);
 
 	if (uuid_is_null(get_ri.uuid))
-- 
2.13.1

