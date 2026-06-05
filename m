Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010493EDE4B
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 07:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780643255; cv=none; b=MXNbJEvdyz6hW3G1JYkPAbre8MDZ5ydIyar0ckh/IM6wcKeuY7MFu64a3CeVjjpM3/PhTLGGkJ3gRscKvEtWSK4ruRLKU+jYrKDxfJU5xQO4rVD+Nx/L+pS11cu90eDH8N+tiXdIjzgwovV2337JlPMl+3jcv0DlwF0XBSR1TWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780643255; c=relaxed/simple;
	bh=x+dRrafcWsTvtEu2VSzxrlSDOuyVRgDgXuNBRaYJquE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hu0pf97F5zHG2uz1p/HiYxLeIExYguFge3Ml66HY2pvJj2h9jQqxlu/D8Hkbj5YUw38JFNlJQdQOyBsWJcT0cvs4g2ijSnAEym/jZuaTF/aIimswCTSsebIdtE4jl2TEuni2UIcnxRvIUyAEDvGlceL6sxpz5mAun1iy1m99IqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=gmku931b; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="gmku931b"
From: samho <samho@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synology.com;
	s=123; t=1780642935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iK97qsak83rF2JUZpxKYv784pdO6VfEvTGJkr9VLuFs=;
	b=gmku931btA6t91Ha7IdlNSeYxlbpFySrsfxaYv0UwQYmIQFf23QJXEwNWSN1bF1H7QNRyY
	hcsDzRZLe6gjAGNSbUi1ZF3T9UK3sWoFsDVq2bnM3krc9Dr8vfjLk9gojHA9wGfPztW7Lr
	Wp1bXNygblKLaDQJGVNyNWDBJP1zA0M=
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	Sam Ho <samho@synology.com>
Subject: [PATCH] btrfs: send: bail out on fatal signals during long-running operations
Date: Fri,  5 Jun 2026 07:02:01 +0000
Message-Id: <20260605070201.3687844-1-samho@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Auth: pass

From: Sam Ho <samho@synology.com>

A send operation can run for a very long time, for example when sending
a large subvolume or one with a huge number of extents and shared
references. While running, the send ioctl spends most of its time in a
few tight loops that never check for pending signals, so the only points
where the task can react to a signal are the occasional memory
allocations down the call chain.

As a result, a user that starts a send and then tries to abort it, even
with a SIGKILL, can be left waiting for a long time (potentially minutes)
until the operation reaches one of those incidental cancellation points
or finishes on its own. The task stays in an uninterruptible-like state
from the user's point of view, which is surprising and inconvenient.

Fix this by adding explicit cancellation points that bail out with
-EINTR when a fatal signal is pending in the main long-running paths of
send:

1) changed_cb() - the per-item callback invoked for every key while
   iterating the trees, used by both full and incremental sends. This
   covers the main send loop.

2) send_extent_data() - the inner loop that writes out the data of a
   single extent. A large extent is written in chunks without going back
   through changed_cb(), so it needs its own check.

3) iterate_backrefs() - the callback invoked for every backref found
   while resolving clone sources. Backref walking for a heavily shared
   extent can be expensive and iterate over many references.

The returned -EINTR propagates up to the ioctl handler, which performs
the normal cleanup, so no resources are leaked.

We only check for fatal signals (fatal_signal_pending()) rather than any
pending signal, so that a send is not aborted by signals the caller may
legitimately use for other purposes, and to match the existing
convention used for cancelling balance and relocation (see
btrfs_should_cancel_balance()).

Signed-off-by: Sam Ho <samho@synology.com>
---
 fs/btrfs/send.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 89d72d8cb85f..8e7b27146925 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1310,6 +1310,9 @@ static int iterate_backrefs(u64 ino, u64 offset, u64 num_bytes, u64 root_id,
 	struct backref_ctx *bctx = ctx_;
 	struct clone_root *clone_root;
 
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
 	/* First check if the root is in the list of accepted clone sources */
 	clone_root = bsearch((void *)(uintptr_t)root_id, bctx->sctx->clone_roots,
 			     bctx->sctx->clone_roots_cnt,
@@ -5701,6 +5704,9 @@ static int send_extent_data(struct send_ctx *sctx, struct btrfs_path *path,
 		u64 size = min(len - sent, read_size);
 		int ret;
 
+		if (fatal_signal_pending(current))
+			return -EINTR;
+
 		ret = send_write(sctx, offset + sent, size);
 		if (ret < 0)
 			return ret;
@@ -7181,6 +7187,9 @@ static int changed_cb(struct btrfs_path *left_path,
 		ASSERT(test_bit(EXTENT_BUFFER_UNMAPPED,
 				&right_path->nodes[0]->bflags));
 
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
 	if (result == BTRFS_COMPARE_TREE_SAME) {
 		if (key->type == BTRFS_INODE_REF_KEY ||
 		    key->type == BTRFS_INODE_EXTREF_KEY) {
-- 
2.34.1

