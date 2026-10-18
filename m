Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B8938DC4C;
	Sun, 18 Oct 2026 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792337909; cv=none; b=ShkskNrnIEF5riHPrYgw7JgVhfoSA77zjI/KKhagAUiimH+rDubMNYXpMO2U9yVI1Xvz/BE2fUUytGtFxeFDfdkEpY8+JenHadkLs1fOhRv2hXF6Tfwd7cz6CvnaG1W38ViPhqqIF4XX6u21SGRXzs7bd8tLYTC04rUAMe/tKTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792337909; c=relaxed/simple;
	bh=ki2dJIdNQ7javRTzaztK0vLz0oKE/NRrVmqBqi4sLps=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nNj8dWD8Ec4dws03JZ6VSX9gmryW8NQFx0NDrxV7Ml+TQl4XndLPLGHqzLAzicTcm4jF+cbjEDIdE/dgZA6wge1oOPNGjimJ6FHPYrBDJQ1xGNywqNlXeuyPkiaSoUbInI01/PlMp8hvD3xpksmk9fXgYZ0DlEmH36a9ecUK6Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=Km5UYluf; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="Km5UYluf"
Received: from localhost (gyproxy-mailtls3-entmail-gy2-virt38.gy.ntes [IPV6:2409:8d28:134:eea:b3c7:b48c:ed5c:b15])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5171d82b3;
	Sun, 18 Oct 2026 23:38:17 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] btrfs: prevent deleting the wrong subvolume by ID
Date: Sun, 18 Oct 2026 15:38:10 +0000
Message-Id: <20261018153810.2692021-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261018073709.1586733-1-guolingxing@tju.edu.cn>
References: <20261018073709.1586733-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa14fa9e96503a2kunm453fc5f0117af0
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGk9DVh9PQ05OThhJQk1PHVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSkhPQR4eGkEZSBhMQRlPQxhBHh9OGEEZSk
	5ZV1kWGg8SFR0UWUFZT0tIVUpLSEpMTU1VSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=Km5UYlufDwQrBTXYK8zzzdCIPfSlMMmdCq1BD60RCHep8gppp9WRi5iCb3Q4Go72wLUY/LEoOxcOa8Wp9NGg9xp9sYTK8iawkbkRrH+gEXnZ+TbKNwd1L19h0lpoxfY+6CtqhVJ9msWJgf8rS8rXB3KD6RH5hsvAlGPzjV7kCnw=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=dYkS3t96wAxupPcTikKeWXJjbBOJRkN1uFMvedhCh/A=;
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
requested ID while holding the parent directory lock. Return -EAGAIN
on a mismatch so that userspace can retry the operation instead of
being told that the requested subvolume does not exist.

Fixes: 949964c92843 ("btrfs: add new BTRFS_IOC_SNAP_DESTROY_V2 ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
Changes since v1:
- Return -EAGAIN instead of -ENOENT on a subvolume ID mismatch,
  as suggested by Qu Wenruo.


Testing:
- Unpatched kernel: 9 wrong deletions in 14 independent runs.
- v2 patched kernel: 0 wrong deletions in 30 independent runs.
- EAGAIN was observed in 14 runs; all 30 runs successfully deleted
  the requested subvolume while preserving the other one.

 fs/btrfs/ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 576cd76ca0bf..d82a7f3f3d14 100644
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
+		ret = -EAGAIN;
+		goto out_end_removing;
+	}
+
 	if (!capable(CAP_SYS_ADMIN)) {
 		/*
 		 * Regular user.  Only allow this with a special mount
-- 
2.34.1

