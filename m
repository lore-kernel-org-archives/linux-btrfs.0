Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56127 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab3KFXP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/16] btrfs-progs: pass positive errno to strerror in cmd_df()
Date: Wed,  6 Nov 2013 17:15:50 -0600
Message-Id: <1383779755-18228-12-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

get_df returns a negative error number, but then
we pass it to strerror, which wants a positive value...

Resolves-Coverity-CID: 1125929
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-filesystem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index df9d1ff..b1291d6 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -173,7 +173,7 @@ static int cmd_df(int argc, char **argv)
 		print_df(sargs);
 		free(sargs);
 	} else {
-		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(ret));
+		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
 	}
 
 	close_file_or_dir(fd, dirstream);
-- 
1.7.1

