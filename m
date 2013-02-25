Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:39429 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754434Ab3BYVzP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:15 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 02/17] btrfs-progs: fix btrfs_get_subvol cut/paste  error
Date: Mon, 25 Feb 2013 16:54:35 -0600
Message-Id: <1361832890-40921-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

in btrfs_get_subvol(), there is a cut and paste error:

       if (ri->full_path)
               the_ri->full_path = strdup(ri->full_path);
       else
               the_ri->name = NULL;

It should be setting the_ri->full_path to NULL here.
Do it in a function instead of the cpoy & paste to avoid future
errors.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 btrfs-list.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index d02d620..ab9179f 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1515,6 +1515,13 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	return 0;
 }
 
+char *strdup_or_null(const char *s)
+{
+	if (!s)
+		return NULL;
+	return strdup(s);
+}
+
 int btrfs_get_subvol(int fd, struct root_info *the_ri)
 {
 	int ret = 1, rr;
@@ -1537,18 +1544,9 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri)
 		}
 		if (!comp_entry_with_rootid(the_ri, ri, 0)) {
 			memcpy(the_ri, ri, offsetof(struct root_info, path));
-			if (ri->path)
-				the_ri->path = strdup(ri->path);
-			else
-				the_ri->path = NULL;
-			if (ri->name)
-				the_ri->name = strdup(ri->name);
-			else
-				the_ri->name = NULL;
-			if (ri->full_path)
-				the_ri->full_path = strdup(ri->full_path);
-			else
-				the_ri->name = NULL;
+			the_ri->path = strdup_or_null(ri->path);
+			the_ri->name = strdup_or_null(ri->name);
+			the_ri->full_path = strdup_or_null(ri->full_path);
 			ret = 0;
 			break;
 		}
-- 
1.7.1

