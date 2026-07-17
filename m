Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEED442BC53;
	Fri, 17 Jul 2026 16:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307188; cv=none; b=SOu/PlmQPZqdDVWYvgWPlz5+lrNqDWI2+VnXB+NBb+i70GwhHAhSwzlnhTCP+vs5ZyjyoYdIevuNpoKB34EnHL0Ya1ecNgTAgTwiglK5ZMutTb4in2iNZ+Tfjr60tQapCrwYqmRRAsfMcwq9iY+z3bJ1LxQWLPOhbPI3yGcIL/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307188; c=relaxed/simple;
	bh=KxUpBjE7GkEdx2Qqgqyitbvr6gIa/qqxQ25dhmZMRY0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BIJ77gOLeRD7XI0HZCGAmgnV9QuUF4wg45dnPsMCOfiNFaFmPlBpoWIqcJk2KrOyWJbrqfWvPwBvBgQGB52q0+/9schqFap8ePmzax+ypn/5UdJhE4vyN35Yew22/6TsqlEgOjHPrPa5hp14W2ItbQZgapHhQmAaEU+yMQWOCmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EtNheuhu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EtNheuhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462421F000E9;
	Fri, 17 Jul 2026 16:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307187;
	bh=+otu3tSxhx7AZpD7m5U/RbIcK04drt8wAOdP9GSvoSs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EtNheuhuZMmqYglBAN0iU6nyOudntdYJ1yikXm8U0lOhPe3wfl6yKeuYrA5D7jFW5
	 VU6ZLxX8FVVheeThSRHjS2BBuQLi9gD/opiuCsvdYeECCReSRE4CpxJhXIkLjf/+27
	 aXTLO0/EpXtd+B9Yr4l5JS6NPewYHSH26Hz7Da3eb0AD5/tBvPIK8x/zD1/9Mhp5Bm
	 c/jszlugYKIB/l82s+m7Pyy4tPtk8xEF2rU2OF/axomcniQRpYroIIYr9iLrXyDekm
	 1u2T2e/NPor+bYG64PEh16A2181IiHt3GhQZ+cU8GMmzPeJNohv+kDWYSMCo4+yh7U
	 idrn7Fzkbi6/g==
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 17 Jul 2026 12:52:38 -0400
Subject: [PATCH 3/4] btrfs: handle ENOMEM from btrfs_insert_dir_item()
 without aborting
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-btrfs-enomem-v1-3-cdc9c0e265d0@kernel.org>
References: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
In-Reply-To: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-team@fb.com, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2498; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=KxUpBjE7GkEdx2Qqgqyitbvr6gIa/qqxQ25dhmZMRY0=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqWl3wFMnxMX9gtEODcJiDSiLSbOh3LgWKm8foA
 ctbUjf50BeJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCalpd8AAKCRAADmhBGVaC
 Fa9pD/0aZwcuPu7skU6agqHaXRHF0Cn2L5XbbiSyDpdeJtnFOcGxKGuJTp1OyyWnbHHH3+AzajY
 RHgaWZ3/y3HhK5KZ+uCguJ2QcZkLJL03ngEQBdJ6QnRETc39Zyumc/FohLhEMPZ3l2DHcvDJgUb
 RQYUBLTMFN9abBEb8K2eU9oddAMrTI3Tgi3NX1p0bRqqswjxgww3j8R93luGrCaEzyuls7grriM
 oARYta3FBXPtDMhzfPXo93dXP5fuoZe7aVnj5GuYzUwy7ubMWIt5fIOC0RfaL0TKoxmzm8W9kt9
 Dl/34rw/Gdzc+OwYa182hjKCV7AjIxeeH9zX1cgZv4vygZUBL2nGiIHrrPU9348AY7c3oJ0KuY1
 /stvub2TnF3XLHFYfkffK8DQ/6vF7LcG292z5qsuU+wh7ofO86AogaQ0tcPL1p1Mch6fiRm0dl2
 0d8otYnLp17d5j20zHdxVgPdR6CoimeAB3x8wG421bAKnawCsekUj+VRZ6JAo6eQr+qxMd7unK2
 HRDJp4Ug2/50Th40PsC0yjPI38yNdOYK4z64rkkVTlci1RrXWO5QBjjBtjCsB64knBdS0QRNLgH
 QI/OXcn5GY+vWQoiJQD/EJzPqWrOK50tpiNeFHyCusi6Xntg5+rFiSB1T1kvoWbBkAWZM8LSNnA
 S9blFEjXmzjK9Pw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

Now that btrfs_insert_dir_item() returns -ENOMEM before modifying the
btree (thanks to delayed dir index pre-allocation), callers can handle
ENOMEM gracefully instead of aborting the transaction.

In btrfs_add_link(), add -ENOMEM to the set of recoverable errors
alongside -EEXIST and -EOVERFLOW. The fail_dir_item cleanup path
unwinds the inode_ref/root_ref and returns the error to userspace.

In btrfs_create_new_inode(), when btrfs_add_link() fails with -ENOMEM,
convert the newly-created inode into an orphan instead of aborting.
This is done by clearing nlink and adding an orphan item, which ensures
btrfs_evict_inode() will delete the INODE_ITEM and INODE_REF, and
crash-recovery will clean it up via orphan processing. If
btrfs_orphan_add() itself fails, we fall back to aborting.

This turns a filesystem-killing transaction abort into a graceful
-ENOMEM return to userspace for create(), mkdir(), mknod(), symlink(),
and link() operations under memory pressure.

Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/inode.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b7b4e6177135..4d9947ae08f7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6676,7 +6676,20 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 	} else {
 		ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode), name,
 				     false, BTRFS_I(inode)->dir_index);
-		if (unlikely(ret)) {
+		if (ret == -ENOMEM) {
+			/*
+			 * The ENOMEM came before the DIR_ITEM was inserted,
+			 * so the btree has our INODE_ITEM + INODE_REF but no
+			 * directory entry. Convert this into an orphan so
+			 * eviction (or crash-recovery) cleans up the inode.
+			 */
+			clear_nlink(inode);
+			ret = btrfs_orphan_add(trans, BTRFS_I(inode));
+			if (unlikely(ret))
+				btrfs_abort_transaction(trans, ret);
+			ret = -ENOMEM;
+			goto discard;
+		} else if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			goto discard;
 		}
@@ -6738,7 +6751,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_dir_item(trans, name, parent_inode, &key,
 				    btrfs_inode_type(inode), index, NULL);
-	if (ret == -EEXIST || ret == -EOVERFLOW)
+	if (ret == -EEXIST || ret == -EOVERFLOW || ret == -ENOMEM)
 		goto fail_dir_item;
 	else if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);

-- 
2.55.0

