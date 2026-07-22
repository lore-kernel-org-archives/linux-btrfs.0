Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8721D3368B2
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724116; cv=none; b=V7/AmvsSbje6nQVNuXObMosQw7LuzgCZyUpKrzqXeEvgwPcRKbgU8HfS2paHynLZIP6Tg3hWHMDJag+lJkBSSi0ASY16bRvdsHik9ILDZo0GJDMg+AGGdLBWcRUy7ooHHcFPcPdTTj+fFtjRZbKAKHMnb7XH68LQVRvtRVmxZJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724116; c=relaxed/simple;
	bh=e0zlBFJvIUzR3isk3Pn4K0t9lcgt6nfj3fMtPZOQGyE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNmMZ41Mrrm+wyY+HSN8/35HoDQoBRbTJxw0xGOFDvMfZR5/H622OkQkW07tXceMau/LYHHgCY6MItLayupMPFNepFWtkiZaT0FBiITxWaX0iH0g+igpqRnIHYWrC7t37I0K2qFt52UbHpDnIWCRaliWb+anrfZf/u/fjziXqkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuUW1NxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuUW1NxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC0A1F00A3F
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784724110;
	bh=oM6a6e4Z9xc7P47pddqzgLQR1ysGLSWt0yMc+0wjVVQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=MuUW1NxBuF64znVvdeGUnpNrXQ+qfxc+AENCgIlEEkM6mHZzJyF7di0VBbJvDanRv
	 Jqv+UIa6QRWTAyZ0W6RAPakjpusSIwl4uhJXbxfBkaG2Oycbp7ZnfsAtKDH8NploSq
	 HbMKiSJAowp5jTklGjGqdJcYu10LBngQVk5Xr3ibMGm8zEu4Env9Q8CbC+QoNNxhl1
	 B+LzNdhjxz9eA1IVh9iWBYUULdGlM436UErewGuN4lTStbcerV+S1BySbGDaO1CM97
	 mkyTHleSTfRuDn7Bo6mMydsi7b4ed9/ZBOkfSX9aRtGUQE7Lq96pYWXAVzkidfkUED
	 WwAEzQLJrmk5A==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/7] btrfs: check for log writers count first in wait_for_writer()
Date: Wed, 22 Jul 2026 13:41:40 +0100
Message-ID: <e8c75f644119b2ce31a5846c9f04ffe0f75bf3c5.1784656641.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1784656641.git.fdmanana@suse.com>
References: <cover.1784656641.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

In wait_for_writer() we first add the wait queue entry to the wait queue
and then check for the number of log writers. In case where right in the
first iteration of the loop we have no log writers, we end up wasting time
adding the wait queue entry to the wait queue (function call, locking the
queue with irq disable and enable on unlock, etc). So check first for the
number of log writers before adding to the wait queue.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 191308982e9c..08af1e66c758 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3202,11 +3202,11 @@ static void wait_for_writer(struct btrfs_root *root)
 	DEFINE_WAIT(wait);
 
 	for (;;) {
-		prepare_to_wait(&root->log_writer_wait, &wait,
-				TASK_UNINTERRUPTIBLE);
-		if (!atomic_read(&root->log_writers))
+		if (atomic_read(&root->log_writers) == 0)
 			break;
 
+		prepare_to_wait(&root->log_writer_wait, &wait,
+				TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&root->log_mutex);
 		schedule();
 		mutex_lock(&root->log_mutex);
-- 
2.47.2

