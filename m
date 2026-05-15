Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CF64EA36A
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864438; cv=none; b=hxEn9Ay7q2es0pvrfYJjgdo93j3P/eQ9ItEp/Bj2jmXC3wSRLJCjIFLIhOygztK+4nsYR344JoRjzrSuFp3q/Yy0GKqv95kz6lBnAorrh772/RHeDYpG6hVDF8ZL1QFdaEi0DKGUUpF/CJgW7ZAnudVXr6PMvkmBaR9IUKSllBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864438; c=relaxed/simple;
	bh=kdbMPr7KP4cY4aSJKmbp0iiXz+UKw/wvP6WkpDrNaV4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhZxC8MJXQBNBBdiC2mDxj0C1Q0cG2/mlvyJLXNYbZTzLEFBmZMZJw2vXspxjyxBxrXWTiLsmvrmHZrx+SJMKBBN6jwPKHI5IlXU+ssR4PBcllFY77YQNZv/8EoSaifKyJJRcpVYBLnjI+ZceQKrQsxaHVjdLpNfEDoUQvXAJGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GoUC89+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GoUC89+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56C7C2BCC7
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864438;
	bh=kdbMPr7KP4cY4aSJKmbp0iiXz+UKw/wvP6WkpDrNaV4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GoUC89+3mFIegD04W7C+uHZrHbfCHZ4t4uE3JWuhT9eC+eX7iJTT0mDDqIY3a58nC
	 bS9ddBlL0BEToyLCugsloGF9ok56jcu7Ff5AmTIou/In3S0y4DUfAa+qVrFKJEP9Bv
	 EZ+fqWiXwuA4tFht3pUJGyQhlj6vE4ui+HgqtIhq+Gt9gTn1Pu31ilE68J7ZhNtRNK
	 H8fo6cURnVkD/j96IZqjOlaoMJKyesU+tAcDsc9DPrgmbr+FUV6bbmZhyhPuwE9e7k
	 2XliRcK5IIfMa+0i31V5m0G7uczd4XPB0f2YGXxRZaPsru/j65V8Ge5SCibrhvP7vh
	 ApAjJbjL1zQnQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/28] btrfs: tracepoints: trace transaction states during commit phase
Date: Fri, 15 May 2026 18:00:06 +0100
Message-ID: <bfa4e4e87bf05561027d559620dd15949b280d45.1778776707.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1778776706.git.fdmanana@suse.com>
References: <cover.1778776706.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Currently the trace event is fired only when a transaction is fully
complete (its state is TRANS_STATE_COMPLETED). However during a
transaction commit we go through several states and as soon as the
state reaches TRANS_STATE_UNBLOCKED, another transaction can start.
Therefore it's useful to track every transaction state changed during
the commit of a transaction, so that we can see if a new transaction
is started before the current one is completed. Add the transaction
state to the transaction commit event and call the event everytime
we change the transaction state during commit.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c       |  8 ++++++--
 include/trace/events/btrfs.h | 17 +++++++++++++++--
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 9ff8792d7182..aef2462b25d8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2321,6 +2321,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	}
 
 	cur_trans->state = TRANS_STATE_COMMIT_PREP;
+	trace_btrfs_transaction_commit(trans);
 	wake_up(&fs_info->transaction_blocked_wait);
 	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_COMMIT_PREP);
 
@@ -2359,6 +2360,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	}
 
 	cur_trans->state = TRANS_STATE_COMMIT_START;
+	trace_btrfs_transaction_commit(trans);
 	wake_up(&fs_info->transaction_blocked_wait);
 	spin_unlock(&fs_info->trans_lock);
 
@@ -2414,6 +2416,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	spin_lock(&fs_info->trans_lock);
 	add_pending_snapshot(trans);
 	cur_trans->state = TRANS_STATE_COMMIT_DOING;
+	trace_btrfs_transaction_commit(trans);
 	spin_unlock(&fs_info->trans_lock);
 
 	/*
@@ -2562,6 +2565,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	spin_lock(&fs_info->trans_lock);
 	cur_trans->state = TRANS_STATE_UNBLOCKED;
+	trace_btrfs_transaction_commit(trans);
 	fs_info->running_transaction = NULL;
 	spin_unlock(&fs_info->trans_lock);
 	mutex_unlock(&fs_info->reloc_mutex);
@@ -2604,6 +2608,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 * which can change it.
 	 */
 	cur_trans->state = TRANS_STATE_SUPER_COMMITTED;
+	trace_btrfs_transaction_commit(trans);
 	wake_up(&cur_trans->commit_wait);
 	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_SUPER_COMMITTED);
 
@@ -2620,6 +2625,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 * which can change it.
 	 */
 	cur_trans->state = TRANS_STATE_COMPLETED;
+	trace_btrfs_transaction_commit(trans);
 	wake_up(&cur_trans->commit_wait);
 	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_COMPLETED);
 
@@ -2633,8 +2639,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (trans->type & __TRANS_FREEZABLE)
 		sb_end_intwrite(fs_info->sb);
 
-	trace_btrfs_transaction_commit(trans);
-
 	btrfs_scrub_continue(fs_info);
 
 	if (current->journal_info == trans)
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index e43528003848..801f4793e002 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -105,6 +105,15 @@ struct btrfs_transaction;
 	EM( COMMIT_TRANS,		"COMMIT_TRANS")			\
 	EMe(RESET_ZONES,		"RESET_ZONES")
 
+#define TRANSACTION_STATES							\
+	EM( TRANS_STATE_RUNNING,		"TRANS_STATE_RUNNING")		\
+	EM( TRANS_STATE_COMMIT_PREP,		"TRANS_STATE_COMMIT_PREP")	\
+	EM( TRANS_STATE_COMMIT_START,		"TRANS_STATE_COMMIT_START")	\
+	EM( TRANS_STATE_COMMIT_DOING,		"TRANS_STATE_COMMIT_DOING")	\
+	EM( TRANS_STATE_UNBLOCKED,		"TRANS_STATE_UNBLOCKED")	\
+	EM( TRANS_STATE_SUPER_COMMITTED,	"TRANS_STATE_SUPER_COMMITTED")	\
+	EMe(TRANS_STATE_COMPLETED,		"TRANS_STATE_COMPLETED")
+
 /*
  * First define the enums in the above macros to be exported to userspace via
  * TRACE_DEFINE_ENUM().
@@ -120,6 +129,7 @@ FI_TYPES
 QGROUP_RSV_TYPES
 IO_TREE_OWNER
 FLUSH_STATES
+TRANSACTION_STATES
 
 /*
  * Now redefine the EM and EMe macros to map the enums to the strings that will
@@ -208,15 +218,18 @@ TRACE_EVENT(btrfs_transaction_commit,
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,  generation		)
 		__field(	bool, in_fsync			)
+		__field(	int,  state			)
 	),
 
 	TP_fast_assign_btrfs(trans->fs_info,
 		__entry->generation	= trans->transid;
 		__entry->in_fsync	= trans->in_fsync;
+		__entry->state		= trans->transaction->state;
 	),
 
-	TP_printk_btrfs("gen=%llu in_fsync=%d", __entry->generation,
-			__entry->in_fsync)
+	TP_printk_btrfs("gen=%llu in_fsync=%d state=%d(%s)", __entry->generation,
+			__entry->in_fsync, __entry->state,
+			__print_symbolic(__entry->state, TRANSACTION_STATES))
 );
 
 TRACE_EVENT(btrfs_transaction_abort,
-- 
2.47.2

