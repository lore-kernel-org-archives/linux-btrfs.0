Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E804F7970
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864436; cv=none; b=Tzv2ahJogwERjSa1M4j60JH2lLQPH2jD041Sk9mpHUvf7Nsacx00+qjSoHqAL8eDWfn7Cn/ShYTVJ0PZJcE9XhNED0k8frzmqN/EyCgu6VNbNhPfWF2WkrlgqfNSWlxSvIgYhj04+KP0pAgKcgT69YEsrWVGi+VqNNMRyHc7wII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864436; c=relaxed/simple;
	bh=AuuT4e/0LbJIjslR44ZZVSpH5ERAcHfterODgncSYQo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0awIrdFL+dlKaRfy5sAZOceoOksaH/uF6Xf99Q9hzlOMXluJYiEm3r0/CPEgJt9V0IlNZixr1kVYtI5svalPkdm0Xu/16ujiX/Q2fgswUhbv3GzdBoXMXyQL4gFjO9vb08OmE3UGDtuKqUgEzavD9bpuYnunpQI3jEjm+/81so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rOY0RdPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rOY0RdPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08FAC2BCB3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864436;
	bh=AuuT4e/0LbJIjslR44ZZVSpH5ERAcHfterODgncSYQo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rOY0RdPX0gn4iX+Pd1+BFfRg2tqehYzXlteDA7awqNqno5TAWct5Rn1JtvdEx8Hhk
	 cwN3wul3T5L2eST25e3vJ3nsPvqI+JAdCZBSt63a06NS7ZSa02xT5k5jrBApKufVOD
	 2yXY10r8QxZNeL15vUZos5bnP//xTrog7k3XuJvfarwdysWbrrdzGgfPvsni/SSSPD
	 Un+HWcRGweRHkQ355eain/AR7xfdG0roZqK4CXu0gSpsCw2e7zlLnsyHKZ6Wewy8zp
	 mbphANE4U5mS7U5uaJnJwuJtlDS5iIKFSMsv4uQ/hhK10Q3nyADX3GsESZ9l6V/nbs
	 YAh1YR1LakPHQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/28] btrfs: tracepoints: add trace event for transaction aborts
Date: Fri, 15 May 2026 18:00:04 +0100
Message-ID: <f3aa9fc9f4162f9adce4bc9e0b44c905f93377be.1778776707.git.fdmanana@suse.com>
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

While tracing it's useful to know not just when a transaction is committed
but also when one is aborted. So add a trace event for transaction aborts.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c       |  1 +
 include/trace/events/btrfs.h | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b98cb7b0630a..277953906b91 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2731,6 +2731,7 @@ void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 
 	WRITE_ONCE(trans->aborted, error);
 	WRITE_ONCE(trans->transaction->aborted, error);
+	trace_btrfs_transaction_abort(trans);
 	if (first_hit) {
 		btrfs_err(fs_info, "Transaction %llu aborted (error %d)",
 			  trans->transid, error);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4e077abd6704..cb9b6188fcdd 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -201,6 +201,28 @@ TRACE_EVENT(btrfs_transaction_commit,
 			__entry->in_fsync)
 );
 
+TRACE_EVENT(btrfs_transaction_abort,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans),
+
+	TP_ARGS(trans),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,  generation		)
+		__field(	bool, in_fsync			)
+		__field(	int,  error			)
+	),
+
+	TP_fast_assign_btrfs(trans->fs_info,
+		__entry->generation	= trans->transid;
+		__entry->in_fsync	= trans->in_fsync;
+		__entry->error	        = trans->aborted;
+	),
+
+	TP_printk_btrfs("gen=%llu in_fsync=%d error=%d", __entry->generation,
+			__entry->in_fsync, __entry->error)
+);
+
 DECLARE_EVENT_CLASS(btrfs__inode,
 
 	TP_PROTO(const struct inode *inode),
-- 
2.47.2

