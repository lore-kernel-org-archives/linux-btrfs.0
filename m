Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35986 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbaFXPBb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 11:01:31 -0400
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] btrfs compression: reuse recently used workspace
Date: Wed, 25 Jun 2014 00:00:44 +0900
Message-Id: <1403622044-2964-2-git-send-email-sergey.senozhatsky@gmail.com>
In-Reply-To: <1403622044-2964-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1403622044-2964-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add compression `workspace' in free_workspace() to
`idle_workspace' list head, instead of tail. So we have
better chances to reuse most recently used `workspace'.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 fs/btrfs/compression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 92371c4..1daea0b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -821,7 +821,7 @@ static void free_workspace(int type, struct list_head *workspace)
 
 	spin_lock(workspace_lock);
 	if (*num_workspace < num_online_cpus()) {
-		list_add_tail(workspace, idle_workspace);
+		list_add(workspace, idle_workspace);
 		(*num_workspace)++;
 		spin_unlock(workspace_lock);
 		goto wake;
-- 
2.0.0.548.ge727dec

