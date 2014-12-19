Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaLSQGd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:06:33 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 32E8AAC2E
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 16:06:32 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/6] btrfs-progs: fragments, close output file on error
Date: Fri, 19 Dec 2014 17:06:31 +0100
Message-Id: <fe4faae136f941466325234ba2a2f6b347d1dbb4.1419005022.git.dsterba@suse.cz>
In-Reply-To: <cover.1419005022.git.dsterba@suse.cz>
References: <cover.1419005022.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resolves-Coverity-CID: 1258794
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs-fragments.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/btrfs-fragments.c b/btrfs-fragments.c
index d03c2c3e7319..360f10f87bfa 100644
--- a/btrfs-fragments.c
+++ b/btrfs-fragments.c
@@ -233,7 +233,7 @@ list_fragments(int fd, u64 flags, char *dir)
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		if (ret < 0) {
 			fprintf(stderr, "ERROR: can't perform the search\n");
-			return ret;
+			goto out_close;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
 		if (sk->nr_items == 0)
@@ -373,7 +373,10 @@ skip:;
 		fprintf(html, "</p>");
 	}
 	fprintf(html, "</body></html>\n");
-	
+
+out_close:
+	fclose(html);
+
 	return ret;
 }
 
-- 
2.1.3

