Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo102.cox.net ([68.230.241.214]:41497 "EHLO
	eastrmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3ATVEl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:04:41 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo102.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120210440.OLQU7113.eastrmfepo102.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:04:40 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 08/13] Btrfs-progs: bugfix for subvolume parent determination in btrfs send
Date: Sun, 20 Jan 2013 16:04:13 -0500
Message-Id: <1358715858-4469-9-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-1-git-send-email-gene@czarc.net>
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jan Schmidt <list.btrfs@jan-o-sch.net>

We missed to add the default subvolume, because it has no ROOT_BACKREF_ITEM.
This made get_parent always fail for direct decendants of the default
subvolume, resulting in lots of full streams where incremental streams were
requested.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Reviewed-by: Alexander Block <ablock84@googlemail.com>
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 send-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/send-utils.c b/send-utils.c
index fcde5c2..d8d3972 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -240,7 +240,8 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 				memcpy(&root_item, root_item_ptr,
 						sizeof(root_item));
 				root_item_valid = 1;
-			} else if (sh->type == BTRFS_ROOT_BACKREF_KEY) {
+			} else if (sh->type == BTRFS_ROOT_BACKREF_KEY ||
+				   root_item_valid) {
 				if (!root_item_valid)
 					goto skip;
 
@@ -274,7 +275,6 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 				subvol_uuid_search_add(s, si);
 				root_item_valid = 0;
 			} else {
-				root_item_valid = 0;
 				goto skip;
 			}
 
-- 
1.8.1

