Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5185B386C20
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784733898; cv=none; b=hva3Tc9QYYA42LsebwqGpHeeahH2QTggA2Hn03yF/gWp6Rv68bxh/bpeacG9WlKgVdF2d/ad9Q6WvGDiP6x8Ajw9GfuMktD+JTdtxKnl3rsJXDXYa0obbY1ShMWS2DRAQktPu74AiHyhs5hl3DJB+YlUyLce/8Tfeyeuz8HgAiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784733898; c=relaxed/simple;
	bh=OYIsax7yoZrGGkOlVqaUc5wk3ZbFvlOF7g2iGwsmPzg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gw1HtRhVE2pMkTz9gEY+Xwh3MamO/zRP/Xf8aO3wash3KsyCBu5RX4d1GE7b0jz3tEM84cMqVQKYHHOpWUI4kp9umQl4kehUrB7n0c6OVSk7j6hGt3qkH5TGWHl6HaIoQDLOCQs/QJbM9qWJfA/jInFf8kPpFCXdBRhgBEqEQgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edtxnHak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edtxnHak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7F11F00A3F
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 15:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784733889;
	bh=waPmZS8CaGZ76pmMEJhDthoS6QqLkDkhAfH4Ye8HsEc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=edtxnHakNch0zXjrocysVw9+aSq77Kg6t9239lZw0kZMrZ0UBv8ohal619/ueuOmN
	 /fJicm95bn5iOYjBbSmQDQwKyNF23naRTSomN4lxCkAj3tB05K31cG1fQq5JgMwE4S
	 8OHxePUNHcONgY7v3cp8vZ7A2gyxBiPx8xXebJeLzbcI8+Bkn4mzOsngXo/PKQszxc
	 m47+aPDNmxzgeBirmx8bnNOT1ibEfP58p5JDbTaA+isqMRLhCZGXF+RGZu+7shiC4h
	 VLuboHOJtrFMvmc1IUQHCJkj00+nrGhv1grT+0Yhk6105vmU9OUgFXet4IAKkH+ws7
	 fOEuko6FWcAfg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/5] btrfs: check for exit condition after waking in wait_log_commit()
Date: Wed, 22 Jul 2026 16:24:41 +0100
Message-ID: <3a13f0663e98ee665922226c64b4577f31b13327.1784733396.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1784733395.git.fdmanana@suse.com>
References: <cover.1784733395.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We check for the exit condition after we add ourselves to the wait queue
and before we unlock the root's log_mutex, sleep and lock again log_mutex.
This is not incorrect, but it's not optimal since in the first iteration
this is pointless because we already know that root->log_commit[index] is
not zero, so we should check the exit condition only after unlocking
log_mutex, sleeping, waking up and locking again the log_mutex.

So move the check for the exit condition to bottom of the loop, after we
were woken and locked log_mutex again.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index b6ed6671ee26..fe96810d3363 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3182,13 +3182,13 @@ static bool wait_log_commit(struct btrfs_root *root, int transid)
 		prepare_to_wait(&root->log_commit_wait[index],
 				&wait, TASK_UNINTERRUPTIBLE);
 
-		if (!(root->log_transid_committed < transid &&
-		      atomic_read(&root->log_commit[index])))
-			break;
-
 		mutex_unlock(&root->log_mutex);
 		schedule();
 		mutex_lock(&root->log_mutex);
+
+		if (!(root->log_transid_committed < transid &&
+		      atomic_read(&root->log_commit[index]) != 0))
+			break;
 	}
 	finish_wait(&root->log_commit_wait[index], &wait);
 
-- 
2.47.2

