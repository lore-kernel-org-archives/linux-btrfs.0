Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbaBCSXV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 13:23:21 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E265CAAD1
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Feb 2014 18:23:20 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/6] btrfs: send: remove prepared member from fs_path
Date: Mon,  3 Feb 2014 19:23:19 +0100
Message-Id: <5ce2bdc21c1b17d2c44e75972637bde349cef870.1391447200.git.dsterba@suse.cz>
In-Reply-To: <cover.1391447200.git.dsterba@suse.cz>
References: <cover.1391447200.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The member is used only to return value back from
fs_path_prepare_for_add, we can do it locally and save 8 bytes for the
inline_buf path.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/send.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 04c07ed51df5..524086a882f9 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -51,7 +51,6 @@ struct fs_path {
 		struct {
 			char *start;
 			char *end;
-			char *prepared;
 
 			char *buf;
 			int buf_len;
@@ -338,7 +337,8 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 	return 0;
 }
 
-static int fs_path_prepare_for_add(struct fs_path *p, int name_len)
+static int fs_path_prepare_for_add(struct fs_path *p, int name_len,
+				   char **prepared)
 {
 	int ret;
 	int new_len;
@@ -354,11 +354,11 @@ static int fs_path_prepare_for_add(struct fs_path *p, int name_len)
 		if (p->start != p->end)
 			*--p->start = '/';
 		p->start -= name_len;
-		p->prepared = p->start;
+		*prepared = p->start;
 	} else {
 		if (p->start != p->end)
 			*p->end++ = '/';
-		p->prepared = p->end;
+		*prepared = p->end;
 		p->end += name_len;
 		*p->end = 0;
 	}
@@ -370,12 +370,12 @@ out:
 static int fs_path_add(struct fs_path *p, const char *name, int name_len)
 {
 	int ret;
+	char *prepared;
 
-	ret = fs_path_prepare_for_add(p, name_len);
+	ret = fs_path_prepare_for_add(p, name_len, &prepared);
 	if (ret < 0)
 		goto out;
-	memcpy(p->prepared, name, name_len);
-	p->prepared = NULL;
+	memcpy(prepared, name, name_len);
 
 out:
 	return ret;
@@ -384,12 +384,12 @@ out:
 static int fs_path_add_path(struct fs_path *p, struct fs_path *p2)
 {
 	int ret;
+	char *prepared;
 
-	ret = fs_path_prepare_for_add(p, p2->end - p2->start);
+	ret = fs_path_prepare_for_add(p, p2->end - p2->start, &prepared);
 	if (ret < 0)
 		goto out;
-	memcpy(p->prepared, p2->start, p2->end - p2->start);
-	p->prepared = NULL;
+	memcpy(prepared, p2->start, p2->end - p2->start);
 
 out:
 	return ret;
@@ -400,13 +400,13 @@ static int fs_path_add_from_extent_buffer(struct fs_path *p,
 					  unsigned long off, int len)
 {
 	int ret;
+	char *prepared;
 
-	ret = fs_path_prepare_for_add(p, len);
+	ret = fs_path_prepare_for_add(p, len, &prepared);
 	if (ret < 0)
 		goto out;
 
-	read_extent_buffer(eb, p->prepared, off, len);
-	p->prepared = NULL;
+	read_extent_buffer(eb, prepared, off, len);
 
 out:
 	return ret;
-- 
1.7.9

