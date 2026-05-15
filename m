Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87182380FD3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864456; cv=none; b=UpHMwnnl3mwWvo4OroBEyf9o6ST3jVP8ssVRfW2o+WDK97a2RaSn4+cGFGm+lIPbsCfa1xzX+wVTco97KcKHND2d79K2NfKN+zECRY7v+RUAQeu5IFJKeSP7CecMOZN7UNG+ZzdQeY9jCNX6BZQ326/k5yoj3xSu2HkBlstM4pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864456; c=relaxed/simple;
	bh=h+AK/o158oy70Ec1ymR9o4HI2StXm4w1ABzB0SUebQU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odqyqFMlligCJWDOT9ZqO4nHHaeRY6NkG9Vn2AJDPEZ31CcZ053HPqG5TTaNt0W+Ip9/+yHRBoMGhurmNcLtzUgdc6zcRigDciaihfwkzz/tDMMdWTX7qwghf0S10bYlmc+5SejJJSFJ57DM1Q0NA8X3qJBEZf73AsPJXElexzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JaDQuT1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JaDQuT1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0734C2BCB3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864456;
	bh=h+AK/o158oy70Ec1ymR9o4HI2StXm4w1ABzB0SUebQU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JaDQuT1/+owHeUJp0ipLnK/ztp57Vh2KAcRoxb45k3XJfByY/fh+61zs+daJQG+7k
	 v8N4aD3LJhU9Crl/Azd/HG+airBx19SZNf9vbks9BKkXPUOfviXsdUDgUyDFjkbfT/
	 Sdx4iQB/roAU7EggJiIrze+oRks5vBL2EURtCJzZfglIEAXr02U/mKPY6zEyM7pJUG
	 sGDiI4WFdxXLr2EmPXAQxVAZGcei2ma8VJZXCdSio5Smc+b68ymBBtlKFQFwQSTUC4
	 U2MSUL7DYIKl4cuunlcxplFhb45zT6RI6NwqpCYvPpU6SSfEj1L2IniryPL2mVGcLt
	 YfScweQdgBuAw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 28/28] btrfs: tracepoints: show inode type in btrfs_sync_file_enter() event
Date: Fri, 15 May 2026 18:00:25 +0100
Message-ID: <210160789c4ed07acf1ed736185c18f4af761aca.1778776707.git.fdmanana@suse.com>
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

Print the type of the inode (directory, regular file, symlink, etc) to
facilitate debugging.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 include/trace/events/btrfs.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 2285f5156f29..b931634ac2f2 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -830,10 +830,11 @@ TRACE_EVENT(btrfs_sync_file_enter,
 	TP_ARGS(file, datasync),
 
 	TP_STRUCT__entry_btrfs(
-		__field(	u64,	ino		)
-		__field(	u64,	parent		)
-		__field(	int,    datasync	)
-		__field(	u64,    root_objectid	)
+		__field(	u64,		ino		)
+		__field(        umode_t,        mode            )
+		__field(	u64,		parent		)
+		__field(	int,    	datasync	)
+		__field(	u64,    	root_objectid	)
 	),
 
 	TP_fast_assign(
@@ -846,13 +847,13 @@ TRACE_EVENT(btrfs_sync_file_enter,
 		__entry->parent		= btrfs_ino(BTRFS_I(parent_inode));
 		__entry->datasync	= datasync;
 		__entry->root_objectid	= btrfs_root_id(BTRFS_I(inode)->root);
+		__entry->mode           = inode->i_mode;
 	),
 
-	TP_printk_btrfs("root=%llu(%s) ino=%llu parent=%llu datasync=%d",
-		  show_root_type(__entry->root_objectid),
-		  __entry->ino,
-		  __entry->parent,
-		  __entry->datasync)
+	TP_printk_btrfs("root=%llu(%s) ino=%llu type=%s parent=%llu datasync=%d",
+			show_root_type(__entry->root_objectid), __entry->ino,
+			show_inode_type(__entry->mode), __entry->parent,
+			__entry->datasync)
 );
 
 TRACE_EVENT(btrfs_sync_file_exit,
-- 
2.47.2

