Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794350342;
	b=L5qx+Vwbal1ylwWDTcdIqnp3Fk/MOqBKsAFJmEtRZg6Fl9Xbs7zDPMeEPhSs0/0aqeLk
	 lmIaZ3gun91HtS6esTuDXNu/JUODgL3khfDR6JxO25BcZeSsIDOVQ4IcpulRqRznwcX0O
	 VYfHT7KbQ7FE7ZAWHRfEOk/uEhz8c10nRMnbsAtaFt6fl9Pq/A0lDinuZzdkHqy5yI/Iw
	 NOgZabLfEt2lKM5IqDYvhcDQCRW6+g7pGpP6FisFXQcO6XzvMf2LQ5JtdnqftPhvL7D03
	 7JxW7HQdGZ2WsllXnMSWyVz4NXR5k/TnQC54N944KnBMLV9rAyuYWWN+wv+Wb7il3iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794350342;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dAn9BRnMEdw62ipwmJ1r9hnK7L45Q4EfFHbfLwTI8ns=;
	b=NR1PZJ4LAWvEVMlVR31oWcKXFGt4tDVI6HeznRIcLQNM8O0ilCP0G/J6ozCoFEcetdCU
	 jAFMDQrcjgQf/6A4Z01QV0ENIE5PJ1b8FlGbHozF+ztRzn4mav/dfmfXIcaEZYIKVvuqm
	 vnZ/rpMdToSd+QBMNxfBSMDJGrZmriH7dVzups/i1lhaT1jGFO8nafCi62aKv007TYXjp
	 cNrCh+Q7bVQdIjQDfEcgYLDfLM3iQHjjKLD4xu1O1+vNnOyBDUza7Ex7pepHj1Zyko/Rv
	 Wb5iFkhHiocX29unOHf87pkGy7Yf47S1ic1cnSsi1/XHt+gXQfOKXCqSNJpYhqVQTfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mkfFsJGP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CD9606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mkfFsJGP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9671F008A2
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794350341;
	bh=dAn9BRnMEdw62ipwmJ1r9hnK7L45Q4EfFHbfLwTI8ns=;
	h=From:To:Subject:Date;
	b=mkfFsJGP+t3zLn6aEH9NUUpg9lEDVE136rtoU3vnJER4UH9+w369nd5WWM2lvUwxl
	 GdTDUTR+/kQuxOA7UDq45KzjJRxs+SRY8Ajco91Bovq6IY0UFyGn/P8M8OjB5np3nK
	 /DlAReXhdXr3UWoH0zvIvq59T6U1lBexGm2EzURE6EmzoxWhCVuevUJhEbOABTZg+2
	 SnHfVV79iu/xun7ar8UV7Qion2HgASY9gbHjcm7qHk78JUYO3uIVvyUP7ogPSMuGku
	 /7TlvHIoj/I9g48F8t7fKY5+hFolw4nzifGiR9XEPkEH0rHpGFgWyrxjooVwC1+3dt
	 D2oe3UCUabzHg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: zstd: fix UAF due to race between putting workspace and reclaim
Date: Tue, 10 Nov 2026 22:38:36 +0000
Message-ID: <e99992bc6c660128215a601d84675ede40930789.1794350146.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When we put a workspace with a level matching the requested level, we add
it back to the lru list of the workspace manager and set the timer to
run the reclaim function (zstd_reclaim_timer_fn()). If that workspace than
gets used by some other task, obtained with zstd_find_workspace(), for
some compression level lower than the workspace's level, we set the
workspace's req_level field to the requested level (done in
zstd_find_workspace()) and leave it in the lru list without updating the
last_used field of the workspace. Once the last_used field ages past the
ZSTD_BTRFS_RECLAIM_JIFFIES value, when zstd_put_workspace() is called it
skips the lru update branch because the workspace's req_level does not
match its level, and then it sets its req_level to 0 before releasing
the workspace manager's lock - and after that and before
zstd_put_workspace() does:

  if (workspace->level == clip_level(ZSTD_BTRFS_MAX_LEVEL))
       cond_wake_up(&zwsm->wait);

the reclaim function, zstd_reclaim_timer_fn(), can run, see the workspace
in the lru list and see that it has a req_level of 0 and an expired
last_used time, and therefore call zstd_free_workspace() to free the
workspace, right before the task that is putting the workspace executes
the code above to read its level.

Fix this by reading the workspace's level before unlocking the workspace
manager in zstd_put_workspace().

Link: https://sashiko.dev/#/bug/linux-92b08485-a86c-4bb5-9138-fa80c84389f0
Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/zstd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index b686f67d52ec..8756b19f37b6 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -340,6 +340,7 @@ void zstd_put_workspace(struct btrfs_fs_info *fs_info, struct list_head *ws)
 {
 	struct zstd_workspace_manager *zwsm = fs_info->compr_wsm[BTRFS_COMPRESS_ZSTD];
 	struct workspace *workspace = list_to_workspace(ws);
+	bool wakeup;
 
 	ASSERT(zwsm);
 	spin_lock_bh(&zwsm->lock);
@@ -363,9 +364,14 @@ void zstd_put_workspace(struct btrfs_fs_info *fs_info, struct list_head *ws)
 	list_add(&workspace->list, &zwsm->idle_ws[workspace->level]);
 	workspace->req_level = 0;
 
+	/*
+	 * Check if we should wakeup before releasing the lock because after
+	 * that the reclaim function can run and free the workspace.
+	 */
+	wakeup = (workspace->level == clip_level(ZSTD_BTRFS_MAX_LEVEL));
 	spin_unlock_bh(&zwsm->lock);
 
-	if (workspace->level == clip_level(ZSTD_BTRFS_MAX_LEVEL))
+	if (wakeup)
 		cond_wake_up(&zwsm->wait);
 }
 
-- 
2.53.0

