Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab3LPPrJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 10:47:09 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1DDCBABC7
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 15:47:08 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: send: check if parent or clone sources are read-only
Date: Mon, 16 Dec 2013 16:47:07 +0100
Message-Id: <1387208827-10831-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The reference roots have to be read-only otherwise the results of send
stream could be undefined if the roots accidentaly change during the
process.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-send.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/cmds-send.c b/cmds-send.c
index 302f5a89790a..85461d5b0283 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -504,6 +504,18 @@ int cmd_send(int argc, char **argv)
 						"root_id for %s\n", subvol);
 				goto out;
 			}
+
+			ret = is_subvol_ro(&send, subvol);
+			if (ret < 0)
+				goto out;
+			if (!ret) {
+				ret = -EINVAL;
+				fprintf(stderr,
+				"ERROR: cloned subvol %s is not read-only.\n",
+					subvol);
+				goto out;
+			}
+
 			add_clone_source(&send, root_id);
 			subvol_uuid_search_finit(&send.sus);
 			free(subvol);
@@ -532,6 +544,18 @@ int cmd_send(int argc, char **argv)
 						"%s\n", optarg, strerror(-ret));
 				goto out;
 			}
+
+			ret = is_subvol_ro(&send, snapshot_parent);
+			if (ret < 0)
+				goto out;
+			if (!ret) {
+				ret = -EINVAL;
+				fprintf(stderr,
+					"ERROR: parent %s is not read-only.\n",
+					snapshot_parent);
+				goto out;
+			}
+
 			full_send = 0;
 			break;
 		case 'i':
-- 
1.8.5

