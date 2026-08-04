Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B6346D2DD;
	Tue,  4 Aug 2026 15:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785858293; cv=none; b=mnTEJfuuZpl172mA7y6IaxpNLVmIrWPE9nOpTwYk6wJSdAsxaVt0u4lavpBjYqkeJvW76qVOehBXNHpgwxFqUbs2V3bHi0IzXYQ2LFP7u98C8QgrtVY8tRxBbWCmO6y5zfhBBwMEJnjZbM7PQx6EUc252+i0tYoN4RnVKvrdchs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785858293; c=relaxed/simple;
	bh=zQQV/u1yIfIRCr9Itdqa5ZvznM219db8HeXfOMO7EQ0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XaBQvGEBTilxOIg39Odij9NLqAg/h3vsFlTG65XYoiEoww/AEyuvBKhcbMFVKwrnS+w6qzC5Y6TeXAPaUIhjkErEzV85NDVVqE9aVhqIhBoQqLSQBYiE7SBCOhNb4PQ8A3RuFMKU3Qy8ijhT0JiHS4GVV3e1KFZA+8SdPy025/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIJkWjy7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIJkWjy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF211F000E9;
	Tue,  4 Aug 2026 15:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785858291;
	bh=hDwRa6sFsazKkAZEv89WhYO4cShXG6abaHduCfbLYuQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lIJkWjy7uOdBmc0jeJRNVV/4H5ylStzU8o0yNhueG5qZyskj8l/b4b77g9otcIjqH
	 EnkXuKXxXcX+QlBKSZYt5baUp5SiHC7q2ygMMzzmnFiA3vdBxKiYu+No6tBzXrkNGA
	 cLDNFxch05x73VkhDC0uCWt36n2EkcmDKyKSkYnWr4wVAm+uJaAspiQwnaAjRPmxZu
	 hVQ2UJPq7vf1h7FMfHkeCNWLz3Cklbpc2czdtRn/ykWfeyXBoO7La8rlq4IrAnmzsQ
	 jypWmXCRLSc736vS2n1HVE+I1FFesR3BUr4uHp7qrkrowQ49yb6tBUFQrxBI7/0aqJ
	 MxjXV6QE0WkrQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 04 Aug 2026 11:44:36 -0400
Subject: [PATCH v2 4/5] btrfs: handle ENOMEM from btrfs_insert_dir_item()
 without aborting
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-btrfs-enomem-v2-4-4d923170e8c1@kernel.org>
References: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
In-Reply-To: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1925; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=zQQV/u1yIfIRCr9Itdqa5ZvznM219db8HeXfOMO7EQ0=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqcgjvUNJKRTDi4okqZFBAx3neIzUwHp7np12ed
 8k9Dzxn0LWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCanII7wAKCRAADmhBGVaC
 FbiHEAC6l1bknkpcKePaa/VFRzYX76QrKl25L259mTD5+ieCauGyBEYfXbEb2c5xeaTAVlhKanp
 daofyNPqUBHFNAiZe+S6QT2Iq9uBfLgzv/k0n6tkYMd9uoxUYAZBk+1w61e5vxpTJCGp3552GMM
 KPR15DqGC99K+Oczt0zjWqMrnE9pVdKze0MHFx1axRiQ58pUrD/vutvX1WS2culk47+iCvCGXu7
 fRQ1xcEzxNr2qpSs8VKkpB56HvpW8E9SHKsaOn5Do5xDgp/eEDlaJytkJvRsksE5oMocYXZgZ3o
 0+TzmrTu+pzckLhkWR6AlYQ4AOYTgtxO5Psa/yW3KuOpWIQLXQ2AYV+gMS6SRztGHaOo3+TACPC
 8vai6CuHkdIRa1DwEeRW5tC3iixqR98/OjNX2dFhb4qPqxJkoTsBBlNkHkdazQGmlCDQnyT8GAS
 zYIMznUYFYGFjlyEw0pqlC9KN/XDQ+x00f23kVJUaZ4Ea/W6Qz/0QsRemeY5enij6igZILUp4NX
 LpBQ0ue4v+Xll98bMxZVaQcAoWLuO174dPjHVjeSR/QxkAtef5L9jA8XP9ArbsVpDvzRjevzf+X
 CkM8I/aqIGarLWaS15waTOfRdK8GQ0D2UVB0KrOhuNGESnvOMfNNl229rfoLQiIEeOiHW9yM2eF
 /PrRwHTDex0w4Mw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

Now that btrfs_insert_dir_item() returns -ENOMEM before modifying the
btree (thanks to delayed dir index pre-allocation), callers can handle
ENOMEM gracefully instead of aborting the transaction.

- btrfs_add_link(): add -ENOMEM to the recoverable errors alongside
  -EEXIST and -EOVERFLOW.
- btrfs_create_new_inode(): on -ENOMEM from btrfs_add_link(), clear
  nlink and orphan the newly-created inode instead of aborting.

This turns a filesystem-killing abort into a graceful -ENOMEM return for
create(), mkdir(), mknod(), symlink(), and link() under memory pressure.

Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/inode.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3a2dca093c7d..99e990c592f6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6863,7 +6863,17 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 	} else {
 		ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode), name,
 				     false, BTRFS_I(inode)->dir_index);
-		if (unlikely(ret)) {
+		if (ret == -ENOMEM) {
+			clear_nlink(inode);
+			/*
+			 * btrfs_orphan_add() aborts the transaction itself if it
+			 * fails, so only override ret to -ENOMEM on success.
+			 */
+			ret = btrfs_orphan_add(trans, BTRFS_I(inode));
+			if (!ret)
+				ret = -ENOMEM;
+			goto discard;
+		} else if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			goto discard;
 		}
@@ -6925,7 +6935,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_dir_item(trans, name, parent_inode, &key,
 				    btrfs_inode_type(inode), index, NULL);
-	if (ret == -EEXIST || ret == -EOVERFLOW)
+	if (ret == -EEXIST || ret == -EOVERFLOW || ret == -ENOMEM)
 		goto fail_dir_item;
 	else if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);

-- 
2.55.0

