Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0E533F599;
	Tue, 25 Aug 2026 16:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673900; cv=none; b=mo4Tp9GiEqFtXrQ43TpdaLUgzOUI6u7SbXSA//OQDE/SCG1eEYjhp/ij3Iuqv+UzPN0DjuWSz81ArdJFdZhhjxQ8SuMHRGMc2tbOnPE514s+scewTgIGcjinB9UebyxXAYyNjxD+7HDfSYrEYvACs2EiAv3AgKeBZkE/+sBLFX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673900; c=relaxed/simple;
	bh=i8QCxSVOV0LcFs+6/Mjy+uu1WcgS6N7H0r4iR2hOgvk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b4V+iWcvD9MGnkuY83OY189cktwnH1ZbLtjjeUBLFvfWKIN13NxDEsikdzO3Ok3wcQIGjLaW1gY3ikeonvyjqZrGgcOsxptZ4GYwvV0utWDdFp0NpmMEKqnDbTkl+XFDyawL3nzMqkc0NaYBNpUY8ay9HYnMWarPu5Vn9fbaWH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mxlkg/pX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mxlkg/pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C891F000E9;
	Tue, 25 Aug 2026 16:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673899;
	bh=0KxVljklGd97b9rZMT8e3dxgS3KH3MdjoX7XMkwh6Ws=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Mxlkg/pXlqp1iY0GWQLs5Qy4ikG3PsSkdFWMdgUWcSi25RlzZU3eUXzbMR3sQg8if
	 oAXfzBc7vYz2+iGRUKBtPkxTsesSTTV0LPal5zfNmrpUe5uB1XjI1hdUbBttA+Px90
	 vKqH2+ZGMhfwS2HF6aC+AixM4+D4Uy5/zrBFZiqoNCmj9wucNTRCzc332RCtJRj0Yp
	 2lyMWcynK5hIISy9ca1OKFRIkQ9h21AFgu39KHoiChWzk+EbU9oLOEtLFpscDzUKDC
	 HHj4k1XU0GbbCI33W5EK0LFillnNfzlLnoRyZEDTCcf/QuZCZ2kFTVkVyJVC0XyFbm
	 a20tjlCj/6ubQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 25 Aug 2026 12:04:19 -0400
Subject: [PATCH v4 3/4] btrfs: handle ENOMEM from btrfs_insert_dir_item()
 without aborting
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260825-btrfs-enomem-v4-3-b9363fa8714a@kernel.org>
References: <20260825-btrfs-enomem-v4-0-b9363fa8714a@kernel.org>
In-Reply-To: <20260825-btrfs-enomem-v4-0-b9363fa8714a@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2667; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=i8QCxSVOV0LcFs+6/Mjy+uu1WcgS6N7H0r4iR2hOgvk=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqjb0nXsbRuLB/O//XQ8gUI0nUov+CJplV6cfyt
 DWI2u0otASJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCao29JwAKCRAADmhBGVaC
 Fc40EACWbJo4afArILrHkethA0h5h5wo4x69vZQnwwP7ogkW49uFNDwbn2ubO+Wuo7BvF/cgUqW
 WOSPsCVM+IFK/gyoO+cds63JkmcADVKyg1I494AXealDy2ns9Vqmj6BnzRcwrJXPuNsPouHwIVF
 CmWqaqOUDrHZjLVLhPff2YycYqQgejmzmeSLfd/SUEUphc51RJQGoWe0xtopMyFCuMqZ7Nf9Xl3
 wpTfY/C1Tajqi+y1rZbnHN/mHTduetKWHeoVOKsA3bX2df8k6h1LTAA+K5aaUDpbI8Ib9g4ybF3
 cOJckeGMLy1xqtuzMHec60bYpE7mYJv4WWGcxiLKRDPPTC7wrzLVdhBvkTv9CB632pQ9XDrgYq8
 iOgkGNNGnUmlmgMjJWGhpUNKHu3BtnmZh8uL8ZvyLe8FFcxRRoKL5+iEZ9sFGAc3ytWNBHUOwAt
 pgFYIt2xbFkv54TXTX5y7+UAmBkOPzg6WkYuHAG7yT4prg/diuC6AbS7MIMtNs5nGo3SHx8nSWy
 DXcWUQ+O5zOXTSYg/18aQiFdWxrie2MIfyH4V5vpElLc/I5x7dcBwOCOtQgxFkVUKeZmrafAl1z
 d8+MPTDdbTn/B0NEkBYjGOztw9Q2PIFner8f4eEsXkyMYRTABlc1hxvXMTOxQd+mjUG2KyIAx+p
 Zd1hhEMx1/I6ZJA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

Now that btrfs_insert_dir_item() returns -ENOMEM before modifying the
btree (thanks to delayed dir index pre-allocation), callers can handle
ENOMEM gracefully instead of aborting the transaction.

- btrfs_add_link(): add -ENOMEM to the recoverable errors alongside
  -EEXIST and -EOVERFLOW.
- btrfs_create_new_inode(): on -ENOMEM from btrfs_add_link(), orphan the
  newly-created inode instead of aborting. The inode item was already
  written with nlink 1, and discard_new_inode() marks it bad so eviction
  won't delete it. So clear_nlink() alone is not enough: persist nlink 0
  via btrfs_update_inode(), otherwise orphan cleanup would see nlink > 0,
  drop the orphan item, and leak the inode. Fall back to aborting only if
  that update also fails.

This turns a filesystem-killing abort into a graceful -ENOMEM return for
create(), mkdir(), mknod(), symlink(), and link() under memory pressure.

Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/inode.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3a2dca093c7d..5b79910d72f5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6863,7 +6863,27 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 	} else {
 		ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode), name,
 				     false, BTRFS_I(inode)->dir_index);
-		if (unlikely(ret)) {
+		if (ret == -ENOMEM) {
+			/*
+			 * Orphan the new inode instead of aborting. The inode
+			 * item was already written with nlink 1, and discard's
+			 * eviction won't delete a bad inode, so nlink 0 must be
+			 * persisted here or orphan cleanup would see nlink > 0,
+			 * drop the orphan item, and leak the inode.
+			 */
+			clear_nlink(inode);
+			/* btrfs_orphan_add() aborts the transaction on failure. */
+			ret = btrfs_orphan_add(trans, BTRFS_I(inode));
+			if (ret)
+				goto discard;
+			ret = btrfs_update_inode(trans, BTRFS_I(inode));
+			if (ret) {
+				btrfs_abort_transaction(trans, ret);
+				goto discard;
+			}
+			ret = -ENOMEM;
+			goto discard;
+		} else if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			goto discard;
 		}
@@ -6925,7 +6945,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_dir_item(trans, name, parent_inode, &key,
 				    btrfs_inode_type(inode), index, NULL);
-	if (ret == -EEXIST || ret == -EOVERFLOW)
+	if (ret == -EEXIST || ret == -EOVERFLOW || ret == -ENOMEM)
 		goto fail_dir_item;
 	else if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);

-- 
2.55.0

