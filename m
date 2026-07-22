Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360E3331EC0
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724117; cv=none; b=mkCrbo0lhJoBch3dTBm+lWtbTd547yHv0WlJXbXTxF6Z+Rv2c27IS7l16/Vm/a1OJaM4vUWLmlANz8u7fAgGD8xqB/GSo8vV3//DJxRXhnwdQ7KEpfmoZta395mCOPWAywBJoDAl1SqOmcFhPjak/eTZaNKlr+MIaKGNIvsCaAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724117; c=relaxed/simple;
	bh=ol9tUEkV7XKY2GsG+PCn2xQ4IpjffPavLlA1tHhHntA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6sYbCzwM5a/Ihom1qmf2aqVPIoKQ0YAdHJcn1lRnFPKcfiJwsFdVtHPSTJF/829rFy5UT3mBo8Pvw4w30BRLdD6CBJLNaDiTup97Z8xmMcfcgaMIfmJ0JW3kUzBkDk+DSYnqkD+8OvXgq1uKunWU1CP+5tJ4aJuRjQwEw2yGho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SM8Ytpyd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SM8Ytpyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CCF1F000E9
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784724112;
	bh=GtMXt48ZgKxXDQBllh06tWu50mgfWA70xJT2GuOWDiw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=SM8YtpyddZbYriIFAKfpN1YMcxr+AlhXOVQWyhJDetBJCAxZcK0GvHS22Qq8eqOVW
	 fGr81Omf9Eqe3b2uLTKgqAaR0B8fV8Zdlt2ZRnY7ykaqPsailpZ9mzXdQdNAMsSwYK
	 jvmhKpsGs5VKtuPDdcU+5gsOOArmZYOrfXDMvDfCZd96x5jjo37g0rcjaicORUUWqi
	 49FwwopGtz1eIaG0ziXMlumW//4SdJoJIWbfyFG21CR3GAxWZD2KhZKeXLH3HQwgi3
	 xUbsObmIyiRpw1moMz9eg85L3n0Uy222vpemWGJEhonPwNg19N9VEOtsFHGIJLXJa5
	 yxy5HFvZLFTzw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/7] btrfs: check for exit condition after waking in wait_log_commit()
Date: Wed, 22 Jul 2026 13:41:42 +0100
Message-ID: <c629e07efa3749bef9fdf9a3821947386b6e53a6.1784656641.git.fdmanana@suse.com>
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
index f33392da78ef..f2d0f6fb3eae 100644
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

