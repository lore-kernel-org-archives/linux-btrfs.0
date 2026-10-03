Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC1648C408
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791046813; cv=none; b=FYpz8gLvTGAQWJ8Vl0VddvqX9znlb3r7JllPrz0kwVD7QQ51bzuZGxb/84cZkoTqRv8QqsXaAcParCyKGpY1M1o+Cj2pJH3uBA0eMKjIyYW2W32Mmu4RhqREc5xMDNAMRrMUGagebkjXpsS7PyEax0WXKfStQX8V3S/J1QlNPE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791046813; c=relaxed/simple;
	bh=Rbg8ZriW/dHoW8h+2MsW+JuOg1ndGL9N5K+u7iYbfkA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rf2rUKdxHSESSKgWks8Z/fcLK19vMRfZ0ntO+nYYloihbeRBrdW6dDUx8h2tNY3ipDvZkHHRHJMmTv5AZNZAm5dQsKeyDyLrGYXbdoS5GxKcvtKXjo+GJ/gzGcLSA2h3CiAqtacONdy4k7C2ZO1MAM2XB921BUEzAIYyM2tR7QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SqcBdDKq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SqcBdDKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFA21F0089B
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 17:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791046811;
	bh=PNMB88vm83Mhr2XZ62OGaPMYLBfVi5W1R+QC28Rq7Pg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=SqcBdDKqVCXmBrcJXeiUojY6pEIVjkiOt4fs6uk9E8oknhAvDL4zSjo2eqMZtn6dc
	 QV4/yqg8ouXCoZauJOsFKKoadTjEZbPUq25GDLadVm48xfEL+auJw2l5aBOh7I4jpc
	 kR67t03XddAm+6nzwvPY1WqsWYRxZDNIsiQJRMYntj2FUz7moQlnm9/b9lKFqO1PCx
	 0wPsoOfCdTyNdKhBszA/rxO/V3KxmYnMlvY0kfes6PIlWg98Oj/RkiF6H2uVpSEh5o
	 sIdMfIapQ4d7ifOMABJyf7Z4EY3VI3jSW1qVptKFEvx/pB3Zg5N2jubrjXi+ZH4QQC
	 zVHqZtphBTXyQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/6] btrfs: qgroup: fix leak of qgroups in rb tree after failure to enable quotas
Date: Sat,  3 Oct 2026 18:00:02 +0100
Message-ID: <2435981dcde450de7ffedc604e39168c19c2c4ab.1791046651.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1791046651.git.fdmanana@suse.com>
References: <cover.1791046651.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When enabling quotas we add struct btrfs_qroup items to the rbtree
fs_info->qgroup_tree, however if there's an error during the quota enable
operation after adding those items, we exit without removing the items
from the rbtree and freeing them.

Fix this by calling btrfs_free_qgroup_config() on error, which also
deletes all sysfs entries (it calls btrfs_sysfs_del_qgroups()).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4b6c82a24bc5..9f21b091c545 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1293,8 +1293,13 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	if (ret)
 		btrfs_put_root(quota_root);
 out:
-	if (ret)
-		btrfs_sysfs_del_qgroups(fs_info);
+	if (ret) {
+		/*
+		 * Free all qgroups previously added with add_qgroup_rb() and
+		 * sysfs entries.
+		 */
+		btrfs_free_qgroup_config(fs_info);
+	}
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	if (ret && trans)
 		btrfs_end_transaction(trans);
-- 
2.47.2

