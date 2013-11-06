Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56115 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3KFXP5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:57 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/16] btrfs-progs: fix potential double-frees in cmd_subvol_delete()
Date: Wed,  6 Nov 2013 17:15:40 -0600
Message-Id: <1383779755-18228-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we "goto again" in cmd_subvol_delete(), and error out to out:
before re-allocating the dupdname and dupvname pointers, we'll
double-free them.

Set them to NULL after freeing to avoid this.

Resolves-Coverity-CID: 1125944
Resolves-Coverity-CID: 1125945
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-subvolume.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 63c708e..89b90cf 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -288,6 +288,8 @@ again:
 out:
 	free(dupdname);
 	free(dupvname);
+	dupdname = NULL;
+	dupvname = NULL;
 	cnt++;
 	if (cnt < argc)
 		goto again;
-- 
1.7.1

