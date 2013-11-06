Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56124 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab3KFXP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/16] btrfs-progs: fix resource leak in scrub_start()
Date: Wed,  6 Nov 2013 17:15:47 -0600
Message-Id: <1383779755-18228-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the "nothing to resume" case we return directly and leak
several bits of memory; goto out to free them properly.

Resolves-Coverity-CID: 1125934
Resolves-Coverity-CID: 1125935
Resolves-Coverity-CID: 1125936
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-scrub.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 605af45..5f3eade 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1261,7 +1261,8 @@ static int scrub_start(int argc, char **argv, int resume)
 		if (!do_quiet)
 			printf("scrub: nothing to resume for %s, fsid %s\n",
 			       path, fsid);
-		return 2;
+		err = 2;
+		goto out;
 	}
 
 	ret = prg_fd = socket(AF_UNIX, SOCK_STREAM, 0);
-- 
1.7.1

