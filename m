Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2C94EA382
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864434; cv=none; b=hBCOcEU+ris8LuYfoINdFpMJQutc8PPb6d+Q2h/lNP94045v0asVDB0/nQTKy77/Y92/56KR7eClYywG+/Vtyw4YP2RLWvpLcKWVVj5g/+EnuTsIoQxgkxI8SYTUgCPA0IBiPQ52s6n6vKQydmxXy5yHbJfu/Uh6AT8R9JFRkE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864434; c=relaxed/simple;
	bh=on+CkYbQ21maJpOpyGbK8bXGEV6gFP4w/aMsCM3fMPk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OI+6qGksBZeZexYot7sHJdaa18yIvHCIrj+3y/nPhH9gVHrA22la1ssVf9NYhBPHH6xO09gGwR9TJvZq4D1ip0FAOUlBXbhlz69JDA0x83Y2wLC3MsDFsxIouzu348YtpHZPJaicF3NCalmK2p+KTFlj81ykvFQGEFOGVGh0ncc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dr5uHZZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dr5uHZZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC82C2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864434;
	bh=on+CkYbQ21maJpOpyGbK8bXGEV6gFP4w/aMsCM3fMPk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dr5uHZZgTiUXL33Vw/snUm14NmXh8m0dk50nCQfJa0cAtsO8ZrVqZdWWIO0SzGHXh
	 g0mBUqqC/vY2qyCoRRR5qcI5LXdMfDb18NIYuVdmLl98JF6jhIshPlWOdvINa4SfCA
	 E7U6k/q3y8VJ69gvGcXFoEEafJV4jVGq3ICtYJX5sexn58BYod2g6ViP1JrBe2qrje
	 TiCaRi3Ylf/T9rPLC1xX1joxeFUuzMHGb5upNUiNXyVzltrEQiP8T6yFQ0l3oe3Ff7
	 6tYtxd6Jr2YGPkd2gFyEGKfm3DGCxN/q0LfhwIxb+m5Ay6ShQe/ilsT50Lr0/B6Quk
	 ZTk2/hhy3luWw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/28] btrfs: tracepoints: pass a transaction handle to transaction commit event
Date: Fri, 15 May 2026 18:00:02 +0100
Message-ID: <74601fdecdb5c73d792d5f671c587fc915d03ba6.1778776706.git.fdmanana@suse.com>
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

The transaction commit tracepoint prints fs_info->generation as if it
were the ID of the committed transaction but this does not always match
that ID. This is because the trace point is called in the transaction
commit path after the transaction is in the TRANS_STATE_COMPLETED state,
which means another transaction may have already started (which can happen
as soon as the transaction state was set to TRANS_STATE_UNBLOCKED), in
which case fs_info->generation was incremented and does not correspond
to the committed transaction anymore.

So fix this by passing a transaction handle to the trace event instead of
fs_info. This will also allow later for the trace event to dump other
useful information about the transaction.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c       | 4 ++--
 include/trace/events/btrfs.h | 9 +++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0fd596e2c65b..b98cb7b0630a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2114,7 +2114,7 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans, int err)
 	btrfs_put_transaction(cur_trans);
 	btrfs_put_transaction(cur_trans);
 
-	trace_btrfs_transaction_commit(fs_info);
+	trace_btrfs_transaction_commit(trans);
 
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
@@ -2632,7 +2632,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (trans->type & __TRANS_FREEZABLE)
 		sb_end_intwrite(fs_info->sb);
 
-	trace_btrfs_transaction_commit(fs_info);
+	trace_btrfs_transaction_commit(trans);
 
 	btrfs_scrub_continue(fs_info);
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index a8cdc50677a5..4cec2f8838f5 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -31,6 +31,7 @@ struct btrfs_space_info;
 struct btrfs_raid_bio;
 struct raid56_bio_trace_info;
 struct find_free_extent_ctl;
+struct btrfs_trans_handle;
 
 #define show_ref_type(type)						\
 	__print_symbolic(type,						\
@@ -182,16 +183,16 @@ FLUSH_STATES
 
 TRACE_EVENT(btrfs_transaction_commit,
 
-	TP_PROTO(const struct btrfs_fs_info *fs_info),
+	TP_PROTO(const struct btrfs_trans_handle *trans),
 
-	TP_ARGS(fs_info),
+	TP_ARGS(trans),
 
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,  generation		)
 	),
 
-	TP_fast_assign_btrfs(fs_info,
-		__entry->generation	= fs_info->generation;
+	TP_fast_assign_btrfs(trans->fs_info,
+		__entry->generation	= trans->transid;
 	),
 
 	TP_printk_btrfs("gen=%llu", __entry->generation)
-- 
2.47.2

