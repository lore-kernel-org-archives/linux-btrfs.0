Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAC03AC00;
	Sun, 18 Oct 2026 07:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792309362; cv=none; b=c608FJRxnzh2e0LrcgIKbqD5t1TrFeKp0OrMyBFcbvqFO6TeWxVz3/Q9JeRO7+YlTmLcrKUEqk31weyTAfaiH3luoy8pV/LLY+ha2qhr4Bcn/fuDrZ8U6jDcOpwAtKDyZUOQO4bJPerWjyEclfeRViFvY+XiNuPM3Z6t/vK2MaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792309362; c=relaxed/simple;
	bh=PTLmGUYf1L+IhBboMm3l/gy64uIEFFUTTVwBj1GGuXw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DPRqvKn87crN7FiRjsAj63rQcMn9QFaUFftvarii0yEN0rFK4b7RVyMzh4B6SN+Yag5shCtkZZqVABlS8QsJrcH44JJe3DpdP5cY+QXqfYTu2x4mb6DtC2ntgUr1QYGPtutVw+q3XyNIo2ARWLmz1/uwzdNuWW9/vh5kpujN2Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=aLGdK5Wi; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="aLGdK5Wi"
Received: from localhost (gyproxy-mailtls0-entmail-virt215.gy.ntes [IPV6:2409:8d28:134:eea:b3c7:b48c:ed5c:b15])
	by smtp.qiye.163.com (Hmail) with ESMTP id 516e654e0;
	Sun, 18 Oct 2026 15:37:16 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>
Subject: [PATCH] btrfs: prevent deleting the wrong subvolume by ID
Date: Sun, 18 Oct 2026 07:37:09 +0000
Message-Id: <20261018073709.1586733-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa14df185c703a2kunma9560eb7105ca2
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaH01DVkxLGkNOSxkdHUpKSlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSkhPQR4eGkEZSBhMQRlPQxhBHh9OGEEZSk
	5ZV1kWGg8SFR0UWUFZT0tIVUpLSUJDTUJVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=aLGdK5Widk0+y6PYQxb1RDXGJDfQyAfyakNQuNgPc14H+cNS1U2GHLOjCx4bj82jbhq/2khCnFXDgnN11/wCs/tD1FyyiEtQuXJh2aHen9U27gR5ht+s0ifSAAKSYNmZKfh05FHasgYU1qz7jpY+UoxFqj/KXgGJ14GfvgP8dOs=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=tqqhX2ibl3bn7nnE7A8H2Ocg7wGjsk8EuNRaGSS3sU4=;
	h=date:mime-version:subject:message-id:from;

When deleting a subvolume by ID, btrfs_ioctl_snap_destroy() first
resolves the requested ID to a name, then looks up that name again
under the parent directory lock.

A concurrent rename can change which subvolume is associated with
the name between these operations. Since the deletion path does not
verify the ID of the resolved subvolume, it can delete a different
subvolume while leaving the requested one intact.

This was reproduced by repeatedly exchanging the names of two
subvolumes using renameat2(RENAME_EXCHANGE) while deleting one of
them by ID. The wrong subvolume was deleted in 9 out of 14 independent
tests.

Fix this by checking that the resolved subvolume ID matches the
requested ID while holding the parent directory lock. Return -ENOENT
if the IDs differ, preventing deletion of the wrong subvolume.

Fixes: 949964c92843 ("btrfs: add new BTRFS_IOC_SNAP_DESTROY_V2 ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/btrfs/ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 576cd76ca0bf..39eb7722998d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2380,6 +2380,17 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
 	inode = d_inode(dentry);
 	dest = BTRFS_I(inode)->root;
+
+	/*
+	 * A concurrent rename may have changed which subvolume the name
+	 * refers to. Verify that the resolved ID still matches the requested ID.
+	 */
+	if (destroy_v2 && (vol_args2->flags & BTRFS_SUBVOL_SPEC_BY_ID) &&
+	    btrfs_root_id(dest) != vol_args2->subvolid) {
+		ret = -ENOENT;
+		goto out_end_removing;
+	}
+
 	if (!capable(CAP_SYS_ADMIN)) {
 		/*
 		 * Regular user.  Only allow this with a special mount
-- 
2.34.1

