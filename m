Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E62A3E558A
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790967356; cv=none; b=Um4/uswCcgVFRGsO3eEBrIO8uxYnxUmYYYzDc5ItEKko1VBPFK0Mgu86aAdKhdwLKR3JtPbwPmqrRm/EdBPmptfJLC6eVdqQLts1rDf149uZZWHGd9CHxd6cY9BBalOSwe4tQLUcoVA+bhhhVP1Qe489n2VcuAAxDmTmPtL0Vyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790967356; c=relaxed/simple;
	bh=Rbg8ZriW/dHoW8h+2MsW+JuOg1ndGL9N5K+u7iYbfkA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0oWEFMZtkuSUtnDYg0BqHuKAERAiGCbV9duT0ywF64KYQn6kgLCdGjuMs28CWktk3wWIteo7oTEX8d5SyXl/rUsTgfI1wWN5BVGpr4Jh+xAGfJrUvYPQOjN8EzWRI8jKvnVj0tTU0tr8VJsphH9+pPQwbojvwxZIcqQ3QdMhps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0bNSe9y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0bNSe9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722491F000FF
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790967354;
	bh=PNMB88vm83Mhr2XZ62OGaPMYLBfVi5W1R+QC28Rq7Pg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=e0bNSe9yOqCyKtX+mHhdA99UNWg4KSOT2jtlCzvzVIUafUWSBtwp97UE3QyTDLsYN
	 P12aUPc8+sKCW2ieyFJobU7suSm0QcSQ9G23cXnV+ojshE/qdycj0PZ8hTHUZh6dH/
	 f1tYuOXa8LoHx1FEG1vnQrO0pJT0TvPwo4+mrmNa9fGVe9VQPytgSrLKXP7wft/TjU
	 2d5nHdrpLyoBn2248ksDiBaN3nWEyJ733xFn7txyESBivFwThF8AGj1/qLN8LUFu7Y
	 e8VDxdlIzcsdfb+8mnGl8dNMNdjHOxrf7sME3CmDGaL8R89g/nl2jE08jdmFO5C7wx
	 31VLp2WYiAKDg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: qgroup: fix leak of qgroups in rb tree after failure to enable quotas
Date: Fri,  2 Oct 2026 19:55:44 +0100
Message-ID: <f88973fbdc498f7e9363e7202ba53963608f7b33.1790967259.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1790967259.git.fdmanana@suse.com>
References: <cover.1790967259.git.fdmanana@suse.com>
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

