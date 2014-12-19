Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaLSQGj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:06:39 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CA2FEAC19
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 16:06:38 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 5/6] btrfs-progs: check allocation result in add_clone_source
Date: Fri, 19 Dec 2014 17:06:38 +0100
Message-Id: <c95d6b73e37beb2e877ef36f0645f0b7269b27f7.1419005022.git.dsterba@suse.cz>
In-Reply-To: <cover.1419005022.git.dsterba@suse.cz>
References: <cover.1419005022.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resolves-Coverity-CID: 1054894
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-send.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index b17b5e2ca666..9b32c1f0e624 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -172,11 +172,16 @@ out:
 	return ret;
 }
 
-static void add_clone_source(struct btrfs_send *s, u64 root_id)
+static int add_clone_source(struct btrfs_send *s, u64 root_id)
 {
 	s->clone_sources = realloc(s->clone_sources,
 		sizeof(*s->clone_sources) * (s->clone_sources_count + 1));
+
+	if (!s->clone_sources)
+		return -ENOMEM;
 	s->clone_sources[s->clone_sources_count++] = root_id;
+
+	return 0;
 }
 
 static int write_buf(int fd, const void *buf, int size)
@@ -475,7 +480,11 @@ int cmd_send(int argc, char **argv)
 				goto out;
 			}
 
-			add_clone_source(&send, root_id);
+			ret = add_clone_source(&send, root_id);
+			if (ret < 0) {
+				fprintf(stderr, "ERROR: not enough memory\n");
+				goto out;
+			}
 			subvol_uuid_search_finit(&send.sus);
 			free(subvol);
 			subvol = NULL;
@@ -575,7 +584,11 @@ int cmd_send(int argc, char **argv)
 			goto out;
 		}
 
-		add_clone_source(&send, parent_root_id);
+		ret = add_clone_source(&send, parent_root_id);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: not enough memory\n");
+			goto out;
+		}
 	}
 
 	for (i = optind; i < argc; i++) {
@@ -671,7 +684,11 @@ int cmd_send(int argc, char **argv)
 			goto out;
 
 		/* done with this subvol, so add it to the clone sources */
-		add_clone_source(&send, root_id);
+		ret = add_clone_source(&send, root_id);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: not enough memory\n");
+			goto out;
+		}
 
 		parent_root_id = 0;
 		full_send = 0;
-- 
2.1.3

