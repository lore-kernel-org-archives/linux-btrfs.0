Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C90357D18;
	Sun, 23 Aug 2026 14:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787494985; cv=none; b=PBUOQfBWxVgGCN+5QlgWYws0s9z2Hp/d+qHuJpuZQM97Y30CpRiDX0O/QYRFCVByISCXOY/uA6/d4w4oK2tTtn33BEA1c/GBuG6e98GTwRXm7pcJM+YfS0QWmAgHz/RkveDtWlHqQySRP7gTgyVcjSZxXzum17FvjDK27lc9cB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787494985; c=relaxed/simple;
	bh=fZARiJBtnd8V149ZzbZMF3idR8Ym9zqq+0dFV7mSuxY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=M+Wahh9us3SZXD6+A+RfVfSqwChbPODx4vZM/qk3dADWh6vGBbN5gHi3IdbRTGCtYPTYoGRPsdRbFZCnAUvo0KjuzVk1cKV5raPN2Znm7+pdDgfs0lGsFtuJpFvNJNIbl+tRPrIqU1ArbnwuLTy/JCaW7H18hVyCqu2ZhkTh+bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLp3jDRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLp3jDRe"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DA46C2BCF4;
	Sun, 23 Aug 2026 14:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787494984;
	bh=fZARiJBtnd8V149ZzbZMF3idR8Ym9zqq+0dFV7mSuxY=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=GLp3jDReFrinHEfgAPu1Gml2b8rKCzWX12OZbA9qa4IyDUGLs5cAVDx22gCumNrKN
	 GCh8BLTWSM4gXdA7dLo+BqhIIFvhuDYBRgyZBwQmpWAAkWAm5rOfLxL6eIL5yo2AU1
	 dmLpdf4nATw0pW7XVdDpypL6PC1Llz9gYMsWjEQ197TwGnPWL0ZN0By5uHr530EDp3
	 rStSwUS3qGxEXowDveoTTtwDwVgWoLerxGb2sb+w23ocWDXHTZCjsca8swyA9BE9Gj
	 gmQTc/i9HxpQWFBaGCJZ240JkaNG/H5Vaig81fX+sy/qwi8RvMjiqYxco1Mc5kyhst
	 qKuHsrLErJyBQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE87CC5DF81;
	Sun, 23 Aug 2026 14:23:03 +0000 (UTC)
From: FAN YE via B4 Relay <devnull+fy15309206903.gmail.com@kernel.org>
Date: Sun, 23 Aug 2026 14:23:03 +0000
Subject: [PATCH] btrfs: zstd: fix hang when the workspace preallocation
 fails
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260823-btrfs-zstd-prealloc-hang-v1-1-d11d25cfb467@gmail.com>
X-B4-Tracking: v=1; b=H4sIAEYCi2oC/yWMQQqDMBBFryKzdiAmtUSvIi5MHNspopKJpVS8u
 1GXj//f20AoMAnU2QaBviw8TwmKPAP/7qYXIfeJQSv9VFYbdDEMgn+JPS6BunGcPZ5HNM6qwpU
 PW1EFSU/rwL8r3bQ3y+o+5OPZg30/AC4pwI18AAAA
X-Change-ID: 20260823-btrfs-zstd-prealloc-hang-3b801b5489e9
To: Nick Terrell <terrelln@fb.com>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787494982; l=4802;
 i=fy15309206903@gmail.com; s=tbnet3; h=from:subject:message-id;
 bh=UCmNia2x7JWgu3N0r50Qjrgy2VR0ohDOUqm2J+6lnXQ=;
 b=5DBetzW/YfLuhfiOmNxmCoNffdfumE9zGRbaC7sGHhYl8u5dSqqHzNyKC/MOEB2bVKrkQB14V
 ZssMG/UOwb1BvwTSmC1hzvUczPJ4AydGIyBbStX4RbsfqvvtYToYPUT
X-Developer-Key: i=fy15309206903@gmail.com; a=ed25519;
 pk=6QsQIrI/kruYWIJyCH9ntPMXsHCqF5JtK/DCMtOCzdc=
X-Endpoint-Received: by B4 Relay for fy15309206903@gmail.com/tbnet3 with
 auth_id=929
X-Original-From: FAN YE <fy15309206903@gmail.com>
Reply-To: fy15309206903@gmail.com

From: FAN YE <fy15309206903@gmail.com>

zstd_alloc_workspace_manager() only warns when the max level workspace it
preallocates cannot be allocated, and the mount comes up with none.
zstd_get_workspace() still sleeps on zwsm->wait when its own allocation
fails, but zstd_put_workspace() wakes that queue only for a max level
workspace, and nothing creates one unless the max level is requested.
Until something on the filesystem asks for it the sleeper has no possible
waker, and stays in TASK_UNINTERRUPTIBLE in the write path long after the
memory pressure is over.

Count the max level workspaces in existence and retry the allocation
instead of sleeping when there are none, backing off with
memalloc_retry_wait() so the retry does not spin against reclaim.
btrfs_get_workspace() guards the same preallocation failure the same way,
using total_ws.

Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
Assisted-by: Claude:claude-opus-5
Signed-off-by: FAN YE <fy15309206903@gmail.com>
---
Reproduced under QEMU/TCG, 4 writers, one forced zstd_alloc_workspace()
failure, mount time preallocation forced to fail.  Columns are "slept with no
max level workspace in existence" / "max level puts" / result:

  prealloc failed, zstd:3,  unpatched    1 / 0    / hang
  prealloc failed, zstd:3,  patched      0 / 0    / ok
  prealloc failed, zstd:15, unpatched    1 / 4848 / ok
  prealloc ok,     zstd:3,  unpatched    0 / 7240 / ok

Row 1 hangs in zstd_get_workspace()'s schedule() (btrfs-delalloc kworker,
hung_task >122s, all four writers stuck behind it).  Row 3 is the same code
and the same sleep, and recovers only because level 15 traffic creates the
workspace whose put wakes it.

With every allocation failed for 20s the retry runs 46230/s and the delalloc
workers burn 11.1 CPU seconds without the backoff, 2733/s and 0.56s with it;
upstream hangs outright under the same load.  55883 backoff calls under
KASAN + PROVE_LOCKING + DEBUG_ATOMIC_SLEEP are clean.
Compile-tested (W=1 and W=2, x86_64 defconfig + CONFIG_BTRFS_FS=y).
---
 fs/btrfs/zstd.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 86919293fd54..ef850dd43d3f 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -83,6 +83,8 @@ struct zstd_workspace_manager {
 	unsigned long active_map;
 	wait_queue_head_t wait;
 	struct timer_list timer;
+	/* Number of max level workspaces alive, only their put wakes @wait. */
+	atomic_t nr_max_level_ws;
 };
 
 static size_t zstd_ws_mem_sizes[ZSTD_BTRFS_MAX_LEVEL];
@@ -138,6 +140,9 @@ static void zstd_reclaim_timer_fn(struct timer_list *timer)
 		list_del(&victim->list);
 		zstd_free_workspace(&victim->list);
 
+		if (level == ZSTD_BTRFS_MAX_LEVEL - 1)
+			atomic_dec(&zwsm->nr_max_level_ws);
+
 		if (list_empty(&zwsm->idle_ws[level]))
 			clear_bit(level, &zwsm->active_map);
 
@@ -204,6 +209,7 @@ int zstd_alloc_workspace_manager(struct btrfs_fs_info *fs_info)
 	} else {
 		set_bit(ZSTD_BTRFS_MAX_LEVEL - 1, &zwsm->active_map);
 		list_add(ws, &zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1]);
+		atomic_set(&zwsm->nr_max_level_ws, 1);
 	}
 	return 0;
 }
@@ -280,7 +286,8 @@ static struct list_head *zstd_find_workspace(struct btrfs_fs_info *fs_info, int
  * If @level is 0, then any compression level can be used.  Therefore, we begin
  * scanning from 1.  We first scan through possible workspaces and then after
  * attempt to allocate a new workspace.  If we fail to allocate one due to
- * memory pressure, go to sleep waiting for the max level workspace to free up.
+ * memory pressure, go to sleep waiting for the max level workspace to free up,
+ * or retry the allocation if no max level workspace exists to wake us.
  */
 struct list_head *zstd_get_workspace(struct btrfs_fs_info *fs_info, int level)
 {
@@ -303,6 +310,22 @@ struct list_head *zstd_get_workspace(struct btrfs_fs_info *fs_info, int level)
 	ws = zstd_alloc_workspace(fs_info, level);
 	memalloc_nofs_restore(nofs_flag);
 
+	if (!IS_ERR(ws) && clip_level(level) == ZSTD_BTRFS_MAX_LEVEL - 1)
+		atomic_inc(&zwsm->nr_max_level_ws);
+
+	/* Waiting without a workspace that can wake us would never end */
+	if (IS_ERR(ws) && !atomic_read(&zwsm->nr_max_level_ws)) {
+		static DEFINE_RATELIMIT_STATE(_rs,
+				/* once per minute */ 60 * HZ,
+				/* no burst */ 1);
+
+		if (__ratelimit(&_rs))
+			btrfs_warn(fs_info,
+				   "no zstd compression workspace, low memory, retrying");
+		memalloc_retry_wait(GFP_KERNEL);
+		goto again;
+	}
+
 	if (IS_ERR(ws)) {
 		DEFINE_WAIT(wait);
 

---
base-commit: 2709dd5ae32f0828f386327c76bba9f39f63a1c6
change-id: 20260823-btrfs-zstd-prealloc-hang-3b801b5489e9

Best regards,
--  
FAN YE <fy15309206903@gmail.com>


