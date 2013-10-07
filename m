Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab3JGVnT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:43:19 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97LhIKh003448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:43:18 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 11/12] btrfs-progs: remove unused variables
Date: Mon,  7 Oct 2013 14:43:04 -0700
Message-Id: <1381182185-10896-12-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-1-git-send-email-zab@redhat.com>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Presumably people missed these warnings because btrfs-fragments isn't
built by default.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-fragments.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/btrfs-fragments.c b/btrfs-fragments.c
index cedbc57..160429a 100644
--- a/btrfs-fragments.c
+++ b/btrfs-fragments.c
@@ -191,7 +191,6 @@ list_fragments(int fd, u64 flags, char *dir)
 	u64 bgused = 0;
 	u64 saved_extent = 0;
 	u64 saved_len = 0;
-	u64 saved_flags = 0;
 	int saved_color = 0;
 	u64 last_end = 0;
 	u64 areas = 0;
@@ -202,7 +201,6 @@ list_fragments(int fd, u64 flags, char *dir)
 
 	gdImagePtr im = NULL;
 	int black = 0;
-	int white = 0;
 	int width = 800;
 
 	snprintf(name, sizeof(name), "%s/index.html", dir);
@@ -280,7 +278,6 @@ list_fragments(int fd, u64 flags, char *dir)
 				im = gdImageCreate(width,
 					(sh->offset / 4096 + 799) / width);
 
-				white = gdImageColorAllocate(im, 255, 255, 255);
 				black = gdImageColorAllocate(im, 0, 0, 0);  
 
 				for (j = 0; j < ARRAY_SIZE(colors); ++j)
@@ -308,13 +305,11 @@ list_fragments(int fd, u64 flags, char *dir)
 				saved_len = 0;
 			}
 			if (im && sh->type == BTRFS_EXTENT_ITEM_KEY) {
-				u64 e_flags;
 				int c;
 				struct btrfs_extent_item *item;
 
 				item = (struct btrfs_extent_item *)
 						(args.buf + off);
-				e_flags = btrfs_stack_extent_flags(item);
 
 				if (use_color)
 					c = colors[get_color(item, sh->len)];
@@ -328,7 +323,6 @@ list_fragments(int fd, u64 flags, char *dir)
 				if (sh->objectid == bgend) {
 					saved_extent = sh->objectid;
 					saved_len = sh->offset;
-					saved_flags = e_flags;
 					saved_color = c;
 					goto skip;
 				}
-- 
1.7.11.7

