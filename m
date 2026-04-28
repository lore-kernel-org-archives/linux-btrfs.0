Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC7C43636B
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 16:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392348; cv=none; b=IWVp7FxfcN1eO36SmLcSnNye2AP9Vtx7CS+zPzLB9M7N7zPq78LX3djAbYkDJgRAWsDhjer1mx61mUF45aUrg4AVv4c8NBsOK2yfNa6LEV5SVjMCbwOz1T9A92x97If2+scnstaM4v/rZXwjlnNJ844pPRqkS/nULnsaLs69lJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392348; c=relaxed/simple;
	bh=l5MfCkhmrfStJKIMlqXY8Yap/7oNpKCRxj2d3eKe+jg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bpbO7Uan1ygHqs+hisqZm0A+ebW/E/jcn4RnTItol09ShWk2PTDrk7wyC8VNDlzfLUR4zl72iT69cZZXbrZIqJz7aLYkchrgoLxyJDxLRzNOUr5CsipCNsl+zHzZSEroW+RhOxDgd7QjUkiI/VUhDey4NuMW+4U1tRUdl+F+pLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXnYtwy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXnYtwy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF5AC2BCF6
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 16:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777392347;
	bh=l5MfCkhmrfStJKIMlqXY8Yap/7oNpKCRxj2d3eKe+jg=;
	h=From:To:Subject:Date:From;
	b=BXnYtwy6IORS0Os/4jr5pIh1A6NFdHIiVnoCONugv2ILlarH2a3vubUplF7MyEDYd
	 6gLguVMH1nbUXM+WRTAZry2vrhskhHGJkSkJAQGz3qUehOKOmpJqAj+yrV7zFkAGNL
	 Dv510ZdjMjclFQi4CnyDD0r5KBSRAH0QvFbRvl9q9Eua3F6vJVNhc8EaXW4BDorM4F
	 C1k2vUKRGmzL3v11yOkzLaVN5IdxCFNSPJwL2Q4Gootfjr9F5X9kVUuItZrMk/NFzK
	 BuRIqO9kBOLcT7XHL32XFRu/VFJXZ07N4InaBkbH4RlewVLjyX42y8NETxpaXLp2nE
	 LWf5SR/K0lk/g==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tracepoints: fix sleep while in atomic context in btrfs_sync_file()
Date: Tue, 28 Apr 2026 17:05:43 +0100
Message-ID: <d93784745689ea623c8c1156755d0113344a9354.1777392274.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The trace event btrfs_sync_file() can be called in an atomic context and
its call to dput(), which is needed due to the call to dget_parent(), can
sleep, triggering a kernel splat.

This can be reproduced by enabling the trace event and running btrfs/056
from fstests for example. The splat shown in dmesg is the following:

   [84853.995109] BUG: sleeping function called from invalid context at fs/dcache.c:970
   [84853.996457] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 32773, name: xfs_io
   [84853.997858] preempt_count: 2, expected: 0
   [84853.998647] RCU nest depth: 0, expected: 0
   [84853.999403] Preemption disabled at:
   [84853.999404] [<0000000000000000>] 0x0
   [84854.000708] CPU: 0 UID: 0 PID: 32773 Comm: xfs_io Tainted: G        W           7.1.0-rc1-btrfs-next-232+ #1 PREEMPT(full)
   [84854.000710] Tainted: [W]=WARN
   [84854.000711] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
   [84854.000712] Call Trace:
   [84854.000714]  <TASK>
   [84854.000716]  dump_stack_lvl+0x56/0x80
   [84854.000719]  __might_resched.cold+0xd6/0x10f
   [84854.000722]  dput.part.0+0x24/0x110
   [84854.000728]  trace_event_raw_event_btrfs_sync_file+0x75/0x140 [btrfs]
   [84854.000809]  btrfs_sync_file+0x1ed/0x530 [btrfs]
   [84854.000887]  ? __handle_mm_fault+0x8ae/0xed0
   [84854.000889]  btrfs_do_write_iter+0x172/0x210 [btrfs]
   [84854.000951]  vfs_write+0x21f/0x450
   [84854.000954]  __x64_sys_pwrite64+0x8d/0xc0
   [84854.000956]  ? do_user_addr_fault+0x20c/0x670
   [84854.000959]  do_syscall_64+0x60/0xf20
   [84854.000962]  ? clear_bhb_loop+0x60/0xb0
   [84854.000964]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

So stop using dget_parent() and dput() and access the parent dentry
directly as dentry->d_parent. This is also what ext4 is doing in
its equivalent trace event ext4_sync_file_enter().

Fixes: a85b46db143f ("btrfs: tracepoints: get correct superblock from dentry in event btrfs_sync_file()")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 include/trace/events/btrfs.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 8ad7a2d76c1d..ec1df8b94517 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -771,10 +771,8 @@ TRACE_EVENT(btrfs_sync_file,
 	TP_fast_assign(
 		struct dentry *dentry = file_dentry(file);
 		struct inode *inode = file_inode(file);
-		struct dentry *parent = dget_parent(dentry);
-		struct inode *parent_inode = d_inode(parent);
+		struct inode *parent_inode = d_inode(dentry->d_parent);
 
-		dput(parent);
 		TP_fast_assign_fsid(btrfs_sb(inode->i_sb));
 		__entry->ino		= btrfs_ino(BTRFS_I(inode));
 		__entry->parent		= btrfs_ino(BTRFS_I(parent_inode));
-- 
2.47.2

