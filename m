Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:50079 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761791Ab2KAPBa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 11:01:30 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: ablock84@googlemail.com, sensille@gmx.net
Subject: [PATCH 2/2] Btrfs-progs: bugfix for subvolume parent determination in btrfs send
Date: Thu,  1 Nov 2012 16:01:26 +0100
Message-Id: <1351782086-23435-3-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1351782086-23435-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1351782086-23435-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We missed to add the default subvolume, because it has no ROOT_BACKREF_ITEM.
This made get_parent always fail for direct decendants of the default
subvolume, resulting in lots of full streams where incremental streams were
requested.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Reviewed-by: Alexander Block <ablock84@googlemail.com>
---
 send-utils.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
1.7.1

