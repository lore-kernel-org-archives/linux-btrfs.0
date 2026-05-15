Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B575D4EA376
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864431; cv=none; b=CyIo1dDTEEnL+YWPQLqe9Lu/GdHWHDP3tUuHKHdYptPP+urjujK/scp0B+vl9Eg2/x2w/v7LPypMiVzBh/qNWr3RRdkxLSDhDoOPrgAeMjVN7UuRCALIMNe2OQpy371dXdeGv6mKEz1xFRKUM2nArKOCBO2r5bofpSCOonvVQ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864431; c=relaxed/simple;
	bh=mhVwze583sYBXfLrEyePNovGWzceOGk0jkzN4fCRp+4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWgiJLNCL3SDZUGZ81vYfeFH6fDGD1HasbmALdMbaotRTFdoUrO6YR9htQJ6b3ZYOzEfPY5R4fek+KhNujqW0rT0Lv/9ZOpTlqRjM2Vh9wSBsscq6GQHesyyKCojgx9VDOK3lj8SifNL96+L0XD12zTYpdefiA6iI9su9Put2+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DkHXCspS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DkHXCspS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E447C2BCB3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864431;
	bh=mhVwze583sYBXfLrEyePNovGWzceOGk0jkzN4fCRp+4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=DkHXCspSouFvdV9zOQR/b7501y/vRCF8hyKA9tciAWe/XlxELbnvT1+oulMJKKLKD
	 bYz/kUUgYIcGVjKCftsfwf0QZUrhQHmb2E3urMovHVHcut+8gpgpFmynE9axyc2nEw
	 6gmCpHc53V+LlHUh9ZmYh9d4WNMbT0LiqVxZo1LBEtvWct/+zLIrGwuO1LKKXDk8VF
	 dw6rDQV4ZJeeazxt0MgCOpKlWuvtw0xX28QIjpmXktoy5JjHYL3nPOwvocJiEgOzcN
	 pDwt7AV5gLHcW/W4Tlm3r6v2YFtfxr9nwkYLkiegx5rjeJZR0icCP3RJ1sZBZ1ze/B
	 Ryt/mUvpaXKGw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/28] btrfs: tracepoints: remove pointless root field from transaction commit event
Date: Fri, 15 May 2026 17:59:59 +0100
Message-ID: <e9612a2e6c3897b51e6ea52236739068da3f75a6.1778776706.git.fdmanana@suse.com>
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

A transaction commit is global, not per root, and we are currently always
emitting a root id field matching the root tree for no good reason at all,
causing confusion for no reason at all. So remove the root field.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 include/trace/events/btrfs.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 99ae9c923070..a8cdc50677a5 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -188,17 +188,13 @@ TRACE_EVENT(btrfs_transaction_commit,
 
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,  generation		)
-		__field(	u64,  root_objectid		)
 	),
 
 	TP_fast_assign_btrfs(fs_info,
 		__entry->generation	= fs_info->generation;
-		__entry->root_objectid	= BTRFS_ROOT_TREE_OBJECTID;
 	),
 
-	TP_printk_btrfs("root=%llu(%s) gen=%llu",
-		  show_root_type(__entry->root_objectid),
-		  __entry->generation)
+	TP_printk_btrfs("gen=%llu", __entry->generation)
 );
 
 DECLARE_EVENT_CLASS(btrfs__inode,
-- 
2.47.2

