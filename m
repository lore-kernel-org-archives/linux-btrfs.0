Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C713F3B8130;
	Tue, 28 Jul 2026 08:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228339; cv=none; b=ujVHTEHRBXdHEd6e7s/1myjRdUu0QjHgJ6dr5lkwYVYolWk69gGIs9byLqjlC/mFvHK+CvcYeNZ7DpZ4KH3OQNWGTY5b+EXSJFEn5aO/Nka5bKbM9Zu2Oo22q6AgrSAf0A3zO4SRwuBXTbjeV27b8835A8IH+xTc7CXcqftizhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228339; c=relaxed/simple;
	bh=GaU+MUpBBEzlGBFeGr9MO+6HV18oMkGOhQjEc0O5uos=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=eQTesVIHpmeVzVos+5CQVyn/MY4zNz9nrhEYQoUBCmReskv3Jhek9QHmCsvRZoZ0lhoRc06DiiaHvTKBmttkIeLyzHHou74vZxRs6xb2jcvFGLVKpaaaANv+yAMPOppSaSCTkkF5NiybNSp9m7kjlxtybdLU3hTxaso+YzWRoZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TIxiKLXL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TIxiKLXL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0B1821F000E9;
	Tue, 28 Jul 2026 08:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228337;
	bh=zFYfuQtZjiKfLefqr6y3lq1bsD3pWDs9wcgpYsGLSVI=;
	h=From:To:Cc:Subject:Date;
	b=TIxiKLXLXvX+K/+oy3Ys/cpUbKR6iOKkY17Cxhuq0t+EVjtcc30SmU15FRT0T1a3J
	 HW8AF1fyEDB7NzWTaMZl/cFGJvOwt9N4X3TwXJhIMARMZEvoiOg/4SXQnwyDxVk/vb
	 xXPWT3ae5N9mTWyedymSNmSLs/6r/nyFAJf8URjtKOUfKJVCsR2TohQpvR0C+8DICu
	 D5Ap1LZ5+9az5VahokAXM0BKDDzR/auf/vi1nVCwHxy7mb8mv2lW18+WJTCUj/mFTD
	 EXQRWdYbfyYyfQfkrr9VZXY/a8T6WlCZWABt+WfTe4JUoJlSCwiKw+C0c2+lhr0vpn
	 xGOc4o1bkwTkw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>, "Chris Mason" <clm@fb.com>, "David Sterba" <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>, "Yan, Zheng" <zheng.yan@oracle.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] btrfs: commit current transaction in btrfs_relocate_block_group
Message-ID: <a06b5077-baa5-473f-9c65-bf72ac651b14@mail.kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 28 Jul 2026 08:45:36 +0000 (UTC)

From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>

During block group relocation, btrfs_relocate_block_group() is called to
relocate a block group. It first makes the block group read-only by calling
btrfs_inc_block_group_ro(). If there are pending space reservations or
pinned extents in the current transaction, making the block group read-only
can fail, leading to a transaction abort and a warning in
cleanup_transaction() during the transaction commit in
prepare_to_relocate().

To fix this, commit the current transaction before calling
btrfs_inc_block_group_ro() in btrfs_relocate_block_group(). This drains the
current transaction before the block group becomes read-only, ensuring that
pending extents are unpinned and space reservations are committed. This
does not claim global settlement of every reservation or later transaction,
but it provides a clean state for marking the block group read-only. The
setup commit in prepare_to_relocate() remains necessary because it commits
the transaction started during the relocation setup (such as creating the
reloc tree) to ensure everything is in a consistent state before starting
to move extents.

WARNING: fs/btrfs/transaction.c:2068 at cleanup_transaction+0x727/0x7c0
Call Trace:
 <TASK>
 btrfs_commit_transaction+0x262c/0x30b0 fs/btrfs/transaction.c:2664
 prepare_to_relocate+0x3dd/0x4e0 fs/btrfs/relocation.c:3541
 relocate_block_group+0x141/0xe90 fs/btrfs/relocation.c:3566
 do_nonremap_reloc+0xa7/0x560 fs/btrfs/relocation.c:5323
 btrfs_relocate_block_group+0x6e2/0xaf0 fs/btrfs/relocation.c:5490
 btrfs_relocate_chunk+0x114/0x830 fs/btrfs/volumes.c:3647
 __btrfs_balance+0x1b6e/0x29e0 fs/btrfs/volumes.c:4586
 btrfs_balance+0xaa6/0x1180 fs/btrfs/volumes.c:4973
 btrfs_ioctl_balance+0x3dd/0x640 fs/btrfs/ioctl.c:3474
 </TASK>

Fixes: 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC handling for balance")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=021d10c4d4edc87daa03
Link: https://syzkaller.appspot.com/ai_job?id=ca6bd6c4-fbcf-4533-af07-79b4a0eba74d
Signed-off-by: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>

---
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index fb85bc8b3..05f5110c2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -5430,6 +5430,10 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
 	if (ret < 0)
 		goto out_put_rc;
 
+	ret = btrfs_commit_current_transaction(extent_root);
+	if (ret)
+		goto out;
+
 	ret = btrfs_inc_block_group_ro(rc->block_group, true);
 	if (ret)
 		goto out;


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
