Received: from mail-oo2-f11.google.com (mail-oo2-f11.google.com [74.125.231.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF153822B4
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 00:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787100031; cv=none; b=eK+jKLAzaVLHF4AqPWskvDqoXMGQd6xP20Or/sWa0G7V1efEYbvsB3tLuO4kioDc9GOBMZE2eCsBXskzqubARvWL1v/nc+msNRIVTnzeoD9wwrRik1kC3Z3ctG8tpG7KArSMYc6ofp9FuEBBvV41Lb1KkHtCt7HYZWZ6ZhNbsRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787100031; c=relaxed/simple;
	bh=XDrZLBuOInroCq7eBP8MpsrFsdRb91W6vX6r83xVdLA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HHGWjOYv79wpnhiz2d2197yyHIinUGgqtwEDmtBVQr4QMXX2pIcPHw4KmjlMLaxJCWe2L2HxouSMl/ri2IEF4728X9m18YUPUbQaPaeoK4xvgf4FUHWUsSnbsNi/Fi1SpIaWMyemA3du+TPiIKdxEnoOOYi2rCUW3xE325XSPwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UFKzhMEA; arc=none smtp.client-ip=74.125.231.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UFKzhMEA"
Received: by mail-oo2-f11.google.com with SMTP id 006d021491bc7-6b12d30261cso115976eaf.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 17:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787100026; x=1787704826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/7H02fS9J+kIylLg1nNS7BqX5LaXGZpwW+oYL3M+hxY=;
        b=UFKzhMEAsnCB8GQoRu1FqMJmXl5Ozok1JiVlDNRpiL70dyirUasC6/fbT3DclwBr83
         7SM0TvZKDzONXAxw5ncixXjxJPTcOyBNEy70n/tA2lvYyI7o9VLCoK0SWUgRRHQu6FDB
         MhrTRtG5YwJZ9cx3wl3en8SXlBAw+zeGmsspvWJkLcT0LMW9bc8cQjVxyNdG/++qiaeu
         hJnMHMM3zVV8vW6w8xa6dLwk6+Zx+4/Pzq2n5G9tN9oRiIcQGrmYWd5AHMQU7w3+T9VK
         WSF2JUdO9qQj93Lcm5d5nFbzGDB1FRz0Jn5zS1Mqn9lZ0I8vOPAEmacWBOP6yfNolXsV
         L30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787100026; x=1787704826;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/7H02fS9J+kIylLg1nNS7BqX5LaXGZpwW+oYL3M+hxY=;
        b=knkQtFdD3PXeqCwS+gRonZipGr3F2GgWTddD9xDdqw1+RoHMiYI+VW/xEyFKRP328K
         Q0gqpkQCzt8mhHk11yWGPCXmvGLLn2ssMHZ2NnnaM2pLvvFBTmArg2Xo8AYrTxRdYFam
         P1tFvYx+4M9qhfVRHjHeQkIz8Z+baHohXaGgDLksdphzYjtnfWTy3ulOHFg6RrFG4/Tv
         Bl5wX+eHJtD3XY72O/uxGj2O4tiEmkJ2OvOdRskeEClprEEKbGi43JtwO3WCvmc+ZSG6
         8bDt5A6Cg6FDbS1VU9O5poM5jY0wyPDkCfx+v2KIMxcCHB3TYc9udy13nbX8bx0bojFY
         482A==
X-Gm-Message-State: AOJu0YzZ2XnX+ur43umUENmOWxiVZwvSLyNrJ/h9K2gjICV1iYKFo/LJ
	sizzE4AVBkqANMunfwQlwZpqN0LIoakLbKygyOoR1xz4S/XEI4CJOu01XlG5juuy
X-Gm-Gg: AR+sD10qt8cDrNOMnHKdiJQaZuAHDb0M6sEcBgD1ijkgTkKB29qp2nuqPgzN6wN6C7f
	fMuo8o8r6CdrYWFi3uTW60/OKTejySXfsZN2fgI4p330TxD48L8R0F40t6mOXMDNBar/TG6f8BF
	+Rs0+ZRc27TY94pLMjLxCCrYDeBrWDRrhU5IUgiBjuHjBl5Xu3VSE30kiMW4bRZrLpeVH3wk19n
	ZBkAba4fEVyx5T9X3eWXAOr6gvMPukwqE3i8M5upika69aGHq8Sv1q2OpHkCBCmTvDoIzjA6co/
	3Ue3R/qG6NmfqHYOEpuuy0S1nysdDAI78+Jiz1/WrRC/vocXF+BdNzW+CoQ8dSR5swG1nR249jz
	NCZu4cBmLRX4Y+vdNIQ7TU7U2XctO6KQ0+h1wFWIeT99dO//tjxhB5bMU0XtoZ8QikZYoPNzOhq
	tRFg4woq+0BqDyRO+iBGtm9uN+/Rq7ipSG+pPwvccNdw1ZVlMq0ROaNt7XfD2H8A21Bg==
X-Received: by 2002:a05:6820:a290:10b0:6b1:377b:8b7e with SMTP id 006d021491bc7-6b13c5a2694mr876380eaf.23.1787100026298;
        Tue, 18 Aug 2026 17:40:26 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f44009007csm172493a34.26.2026.08.18.17.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 17:40:25 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: abort transaction before releasing tree_log_mutex on commit failure
Date: Tue, 18 Aug 2026 17:40:10 -0700
Message-ID: <698c480ec13cd6e74c2175924f614b7e324e6cc3.1787099421.git.loemra.dev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When transaction metadata writeout fails in btrfs_commit_transaction(),
the current code only logs the error, drops tree_log_mutex and then goes
through cleanup_transaction(), which aborts the transaction and records
the fs error.

That is too late for the tree log side. A log sync can already be
waiting on tree_log_mutex, because the committing transaction is moved
to TRANS_STATE_UNBLOCKED while that mutex is held, which lets fsyncs
join the next transaction and queue up in btrfs_sync_log(). Once the
failed commit drops tree_log_mutex, such a log sync acquires it, sees
BTRFS_FS_ERROR() still clear, and writes super_for_commit. That
superblock holds the roots prepared for the transaction that has just
failed to write out its metadata, so it can point at tree blocks that
never reached the disk, and the next mount fails with a parent transid
mismatch.

Commit 165ea85f1483 ("btrfs: do not write supers if we have an fs
error") fixed this class of problem by making btrfs_sync_log() check for
an fs error right after taking tree_log_mutex. That check only works if
the commit path publishes the fs error before it releases the same
mutex, and commit 68d4ece9c30e ("btrfs: don't call
btrfs_handle_fs_error() in btrfs_commit_transaction()") removed the only
thing that did so.

Restore the ordering by aborting the transaction while tree_log_mutex is
still held. We have a transaction handle here, so this does not need to
bring back the btrfs_handle_fs_error() call: __btrfs_abort_transaction()
records the fs error itself, which is all btrfs_sync_log() looks at, and
the error message put in its place is kept.

This is what commit 3810ab40afa5 ("btrfs: abort transaction on error in
write_all_supers()") already does for the next call in this function.

This is reproducible on an unmodified kernel by failing the first
couple of bios of a transaction commit with fail_make_request while a
concurrent fsync workload keeps log syncs queued on tree_log_mutex.

Fixes: 68d4ece9c30e ("btrfs: don't call btrfs_handle_fs_error() in btrfs_commit_transaction()")
Cc: stable@vger.kernel.org # 7.0+
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
---
 fs/btrfs/transaction.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 13a7e5f4e08c..ed850bf0546a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2583,6 +2583,12 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	ret = btrfs_write_and_wait_transaction(trans);
 	if (unlikely(ret)) {
 		btrfs_err(fs_info, "error while writing out transaction: %pe", ERR_PTR(ret));
+		/*
+		 * Abort before releasing tree_log_mutex, so a log sync waiting
+		 * on it sees the fs error and skips writing super_for_commit
+		 * for this failed transaction. See btrfs_sync_log().
+		 */
+		btrfs_abort_transaction(trans, ret);
 		mutex_unlock(&fs_info->tree_log_mutex);
 		goto scrub_continue;
 	}
-- 
2.53.0-Meta

