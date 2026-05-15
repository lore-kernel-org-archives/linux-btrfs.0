Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10234EA381
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864437; cv=none; b=WtGU61eVrZA4zgq7mdFuqJaif1BCBAXT5PzdqdhxY8JeS8Jr7tN8kIe8X5R+QakKC3mOvUOxR062yYkCKcZffGSSBRi2MwI1NPhVNtfKbry9iYUm/qTl4b94RzOrBgFcAaW/3vBtzdDJNKyjR34VZjHHBMNWUArE12Ev94rXqkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864437; c=relaxed/simple;
	bh=Y3kEdabZjoBPrZIO+fGVMKTYhmCBjCbAv85x/pltMlo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSRuWdv0uLS1tcPVJJVifqjPPSvRFWCl7sFDI+xqbslraUVxkUFelgatgrtb0xmtisvJzqvJSO+DwNXLGHhQJW8gbIU5LylHTehlxGF/Mq0xNe5Z+9lhuusEJqOEEXyzpmajTP6WrbMTZOKSJlnvAsbPnh8CcWYiCsRLOU11P1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbhiEkWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbhiEkWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30E0C2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864437;
	bh=Y3kEdabZjoBPrZIO+fGVMKTYhmCBjCbAv85x/pltMlo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fbhiEkWbhbERSZiAxJmn7JNvBlPegOOtoFavrRECvhJrTc9f6HT33Rwqrt47Rz0VP
	 lion0DzgsfHzLP5JEJgPDlP4TdqQucbmBPlma5wB2yju1ozD1XYy7rgTkNF9rpao4w
	 viZc10umakM4Vjn1HU1RMM1VLie3D7IxPZWHwbhrDrjNcQRruWPqBskKejC6A9+1pW
	 +mc+VUE+WIdtAl7VjJBS4OibMH7YbHTwONWmLVSnXxmGdaQ6onfCV+pF4gVtw2ZTWg
	 4BVZRJqnPF8S58gFsKNFGMH+Aomkna/RFvaC7Eo5s3bBi67NFpv4qv8Vy08qYAMvll
	 K/pWSPYRcQP3g==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/28] btrfs: tracepoints: add trace event for the start of a new transaction
Date: Fri, 15 May 2026 18:00:05 +0100
Message-ID: <2e2bfbcbb096517c9b213076abe24870b641ed23.1778776707.git.fdmanana@suse.com>
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
or aborted, but also when a new one is started. So add a trace event for
transaction starts.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c       |  1 +
 include/trace/events/btrfs.h | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 277953906b91..9ff8792d7182 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -394,6 +394,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	cur_trans->transid = fs_info->generation;
 	fs_info->running_transaction = cur_trans;
 	cur_trans->aborted = 0;
+	trace_btrfs_transaction_start(cur_trans);
 	spin_unlock(&fs_info->trans_lock);
 
 	return 0;
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index cb9b6188fcdd..e43528003848 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -32,6 +32,7 @@ struct btrfs_raid_bio;
 struct raid56_bio_trace_info;
 struct find_free_extent_ctl;
 struct btrfs_trans_handle;
+struct btrfs_transaction;
 
 #define show_ref_type(type)						\
 	__print_symbolic(type,						\
@@ -181,6 +182,23 @@ FLUSH_STATES
 #define TP_printk_btrfs(fmt, args...) \
 	TP_printk("%pU: " fmt, __entry->fsid, args)
 
+TRACE_EVENT(btrfs_transaction_start,
+
+	TP_PROTO(const struct btrfs_transaction *trans),
+
+	TP_ARGS(trans),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,  generation		)
+	),
+
+	TP_fast_assign_btrfs(trans->fs_info,
+		__entry->generation	= trans->transid;
+	),
+
+	TP_printk_btrfs("gen=%llu", __entry->generation)
+);
+
 TRACE_EVENT(btrfs_transaction_commit,
 
 	TP_PROTO(const struct btrfs_trans_handle *trans),
-- 
2.47.2

