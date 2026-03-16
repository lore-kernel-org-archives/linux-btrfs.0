Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3CA332EB1
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677660; cv=none; b=gaKVO9slPHGQvNv3FhphUQzDg8v8Szj5ykcq5ONg/Rn/g+ChElOnvbzqgHui1I1BJaPLVLBCNSx2WRhrUI/DTFLm2oWczuTWNvr+BYATsfABCYl8kg8oC2vgIlGcY2cwHID2KhYDjaZWmtTC3qVZWcuIkDheac9x/Cw69INzDno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677660; c=relaxed/simple;
	bh=SwM2jDT50jd2BwvXKliu2Y3gzmplOC53d+FBjGSQvTI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/3ghzOmTVpXA8AZ5xJip5iOR/9L6atLf5S+xEqZOkoZZCtiB6rfQ4bEqArYLCliUAHbJuAsxBnaITSF7YNUHGPLoimj104o4Xz2Oh7zEkZL5U5+ZZUvxjGp56hsqZNxSbONdGEDU7yFoUhq1hMTenPMtWMWsa1R69QfmPugGSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ALlLK6Ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ALlLK6Ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41FBC2BC87
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677660;
	bh=SwM2jDT50jd2BwvXKliu2Y3gzmplOC53d+FBjGSQvTI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ALlLK6Tyn+gMj/JbNXyt43hstCVXS7m69vgJhx1nvrg0psdqiqFpCkAMTRVAMWwuM
	 x6Gymgb3bTnwxk6fqZ1W9wkZk4yRDvnsfBWbEyKsHnXaolEhzRrEyiR9nLHVw6gcFx
	 ZQOUbFIEwWIzPmD0vfWC5yKAAwK2M/FXy3RygP1jOu0yENnexfEpJ1VzGqH1ZDQzgf
	 pwGvJubUNqGDpx23UlFFoYrCLH4vqgou37UppRgBlL277uVLU4K2FVgmkX50kJmEaw
	 /DlG65fOhbAsf7GeMUUp1b5B7D1AmeouohPA2Xk8goR+xZQDt9r6kraRdX1+oT5I+4
	 vsqb9ZC4LJFEQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/11] btrfs: turn extent_io_tree_panic() into a macro for better error reporting
Date: Mon, 16 Mar 2026 16:14:05 +0000
Message-ID: <f64d9ff4d080180e1d865def0d0c1900953d9214.1773676775.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1773676775.git.fdmanana@suse.com>
References: <cover.1773676775.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When extent_io_tree_panic() is called we get a stace trace that is not
very useful since the error message reports the location inside the
extent_io_tree_panic() function and not in the caller of the function.

Example:

  [ 7830.424291] BTRFS critical (device sdb): panic in extent_io_tree_panic:334: extent io tree error on add_extent_changeset state start 4083712 end 4112383 (errno=1 unknown)
  [ 7830.426816] ------------[ cut here ]------------
  [ 7830.427581] kernel BUG at fs/btrfs/extent-io-tree.c:334!
  [ 7830.428495] Oops: invalid opcode: 0000 [#1] SMP PTI
  [ 7830.429318] CPU: 5 UID: 0 PID: 1451600 Comm: fsstress Not tainted 7.0.0-rc2-btrfs-next-227+ #1 PREEMPT(full)
  [ 7830.430899] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
  [ 7830.432771] RIP: 0010:extent_io_tree_panic+0x41/0x43 [btrfs]
  [ 7830.433815] Code: 75 0a 48 8b (...)
  [ 7830.436849] RSP: 0018:ffffd2334f4a3b68 EFLAGS: 00010246
  [ 7830.437668] RAX: 0000000000000000 RBX: 00000000003ebfff RCX: 0000000000000000
  [ 7830.438801] RDX: ffffffffc08d4368 RSI: ffffffffbb6ce475 RDI: ffff896501d6b780
  [ 7830.439671] RBP: 0000000000001000 R08: 0000000000000000 R09: 00000000ffefffff
  [ 7830.440575] R10: 0000000000000000 R11: 0000000000000003 R12: 0000000000000000
  [ 7830.441458] R13: ffff896547374c08 R14: 00000000003effff R15: ffff896547374c08
  [ 7830.442333] FS:  00007f3e252af0c0(0000) GS:ffff896c6185d000(0000) knlGS:0000000000000000
  [ 7830.443326] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [ 7830.444047] CR2: 00007f3e252ad000 CR3: 0000000113b0a004 CR4: 0000000000370ef0
  [ 7830.444905] Call Trace:
  [ 7830.445229]  <TASK>
  [ 7830.445557]  btrfs_clear_extent_bit_changeset.cold+0x43/0x80 [btrfs]
  [ 7830.446543]  btrfs_clear_record_extent_bits+0x19/0x20 [btrfs]
  [ 7830.447308]  qgroup_free_reserved_data+0xf9/0x170 [btrfs]
  [ 7830.448040]  btrfs_buffered_write+0x368/0x8e0 [btrfs]
  [ 7830.448707]  btrfs_direct_write+0x1a5/0x480 [btrfs]
  [ 7830.449396]  btrfs_do_write_iter+0x18c/0x210 [btrfs]
  [ 7830.450167]  vfs_write+0x21f/0x450
  [ 7830.450662]  ksys_write+0x5f/0xd0
  [ 7830.451092]  do_syscall_64+0xe9/0xf20
  [ 7830.451610]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Change extent_io_tree_panic() to a macro so that we get a report that
gives the exact place where the error happens.

Example after this change:

  [63677.406061] BTRFS critical (device sdc): panic in btrfs_clear_extent_bit_changeset:744: extent io tree error on add_extent_changeset state start 1818624 end 1830911 (errno=1 unknown)
  [63677.410055] ------------[ cut here ]------------
  [63677.410910] kernel BUG at fs/btrfs/extent-io-tree.c:744!
  [63677.411918] Oops: invalid opcode: 0000 [#1] SMP PTI
  [63677.413032] CPU: 0 UID: 0 PID: 13028 Comm: fsstress Not tainted 7.0.0-rc2-btrfs-next-227+ #1 PREEMPT(full)
  [63677.415139] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
  [63677.417283] RIP: 0010:btrfs_clear_extent_bit_changeset.cold+0xcd/0x10c [btrfs]
  [63677.418676] Code: 8b 37 48 8b (...)
  [63677.421917] RSP: 0018:ffffd2290a417b30 EFLAGS: 00010246
  [63677.422824] RAX: 0000000000000000 RBX: 00000000001befff RCX: 0000000000000000
  [63677.424320] RDX: ffffffffc0970348 RSI: ffffffffa92ce475 RDI: ffff8897ded9dc80
  [63677.429772] RBP: 0000000000001000 R08: 0000000000000000 R09: 00000000ffefffff
  [63677.430787] R10: 0000000000000000 R11: 0000000000000003 R12: 0000000000000000
  [63677.431818] R13: ffff8897966655d8 R14: 00000000001bffff R15: ffff8897966655d8
  [63677.432764] FS:  00007f5c074c50c0(0000) GS:ffff889ef3b1d000(0000) knlGS:0000000000000000
  [63677.433940] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [63677.434787] CR2: 00007f5c074c3000 CR3: 000000014b9de002 CR4: 0000000000370ef0
  [63677.435960] Call Trace:
  [63677.436432]  <TASK>
  [63677.436838]  btrfs_clear_record_extent_bits+0x19/0x20 [btrfs]
  [63677.437980]  qgroup_free_reserved_data+0xf9/0x170 [btrfs]
  [63677.439070]  btrfs_buffered_write+0x368/0x8e0 [btrfs]
  [63677.439889]  btrfs_do_write_iter+0x1a8/0x210 [btrfs]
  [63677.441460]  do_iter_readv_writev+0x145/0x240
  [63677.446309]  vfs_writev+0x120/0x3b0
  [63677.446878]  ? __do_sys_newfstat+0x33/0x60
  [63677.447759]  ? do_pwritev+0x8a/0xd0
  [63677.449119]  do_pwritev+0x8a/0xd0
  [63677.452342]  do_syscall_64+0xe9/0xf20
  [63677.452961]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-io-tree.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 4ba916cb27ac..68e48b493950 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -326,15 +326,10 @@ static inline struct extent_state *tree_search(struct extent_io_tree *tree, u64
 	return tree_search_for_insert(tree, offset, NULL, NULL);
 }
 
-static void __cold extent_io_tree_panic(const struct extent_io_tree *tree,
-					const struct extent_state *state,
-					const char *opname,
-					int err)
-{
-	btrfs_panic(btrfs_extent_io_tree_to_fs_info(tree), err,
-		    "extent io tree error on %s state start %llu end %llu",
-		    opname, state->start, state->end);
-}
+#define extent_io_tree_panic(tree, state, opname, err)                      \
+	btrfs_panic(btrfs_extent_io_tree_to_fs_info((tree)), (err),         \
+		    "extent io tree error on %s state start %llu end %llu", \
+		    (opname), (state)->start, (state)->end)
 
 static void merge_prev_state(struct extent_io_tree *tree, struct extent_state *state)
 {
-- 
2.47.2

