Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56120 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab3KFXP5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:57 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/16] btrfs-progs: fix test for return of realpath in find_mount_root()
Date: Wed,  6 Nov 2013 17:15:43 -0600
Message-Id: <1383779755-18228-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

find_mount_root() tries to test for realpath() failure, but
tests the wrong value.  Fix it.

Resolves-Coverity-CID: 1125940
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-send.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 39110e7..53e9a53 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -98,7 +98,7 @@ int find_mount_root(const char *path, char **mount_root)
 
 	ret = 0;
 	*mount_root = realpath(longest_match, NULL);
-	if (!mount_root)
+	if (!*mount_root)
 		ret = -errno;
 
 	free(longest_match);
-- 
1.7.1

