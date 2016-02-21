Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 17.mo4.mail-out.ovh.net ([46.105.41.16]:57478 "EHLO
	17.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbcBUVG3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 16:06:29 -0500
Received: from mail178.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id 2B8E210F802D
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Feb 2016 21:50:47 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Loctaux <phil@philippeloctaux.com>
Subject: [PATCH] Btrfs: async: fixed a brace coding style issue
Date: Sun, 21 Feb 2016 21:50:42 +0100
Message-Id: <1456087842-29045-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fixed a coding style issue.

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/async-thread.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 5fb60ea..7914dd2 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -227,9 +227,9 @@ static inline void thresh_exec_hook(struct __btrfs_workqueue *wq)
 out:
 	spin_unlock(&wq->thres_lock);
 
-	if (need_change) {
+	if (need_change)
 		workqueue_set_max_active(wq->normal_wq, wq->current_active);
-	}
+
 }
 
 static void run_ordered_work(struct __btrfs_workqueue *wq)
-- 
2.7.1

