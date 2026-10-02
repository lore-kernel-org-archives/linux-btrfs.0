Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7253E4C66
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790967353; cv=none; b=H2/0Mkz7ZsX+Xw1efHt2G6zGQW4YbBL4gyEcGGaHmn3soTieU68/r8zlo99sWyKmH2o/zjl0245Z+SXMPTW/PhsTkdWPzjFN1mUwwpJ2atTKxR/nKSSTdxF/CSh73ByhMwS7gPeNtlAKpYiTKDHgy6b18qPbrBbszOGb0uTLxuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790967353; c=relaxed/simple;
	bh=l30z+V9Z8qT1ISXBhamCDYORyO2Fy+uwFcEZ1Zl6mf0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnc+NfU5Lse9coRVVuYtTklUdABNeN125DAL/HL9rvVaIia3kz9RaNO+Se4mt/1OvUf68OWlk2al13ido3C9koyh6yzQ3BlWcrtgnFpZ0kQ0BpwBY5yH2nGlqqkT4i4LOx8K1TJZuTq/8/oS0ffYrcrD2hBdBAKRUiAbaU78c7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bmq7aBFk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bmq7aBFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA0F1F000FF
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790967352;
	bh=ryVpsELI5ewiEQt1ixv5OuCcvGOzAXFK8YUbLBNeY7E=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Bmq7aBFkF7PL6OW6FQgRplmPOqCzlZdFveXW83auDermkjkXIn6DS+8hX9NKPgKQS
	 5oxMBvZiUn85n8P7mmBKZE1ipyXkgTUX2lCiYk1J3QpRKHhAtQxWRzxNcR0KtiA2vO
	 Kul/RCPiC89HxC9HGREdVtNDlFGWb97aRQ9GbdBiXo/mWFHi9Fna/8i5K/4N3ItuMR
	 OSIPUav2I8Sz93jrHifpV81uw6IBJV+zzWEwmn143HVm7L4EoPLvQTh3OFHbrWvb7U
	 yvU+3Cb/lM3G8H8APq04egMSLNecYkgjDvi1KiuG707xrayDB92SQRXApl3BGbpHko
	 mrZXSCXj+FgYg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: fix race between subvolume creation and adding/removing relations
Date: Fri,  2 Oct 2026 19:55:41 +0100
Message-ID: <1a8c03f1c6777f2cafa76ff9c4309e381c6f761a.1790954970.git.fdmanana@suse.com>
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

When using simple quotas, we can have a race between creating a subvolume
and auto inheriting quotas and the ioctls to add or remove qgroup
relations.

This happens like this:

1) Task A is doing subvolume creation and calls btrfs_qgroup_inherit()
   with the "inherit" parameter as NULL (since BTRFS_SUBVOL_QGROUP_INHERIT
   was not passed in the flags of the subvolume creation ioctl).

2) Task A enters qgroup_auto_inherit() and calls list_count_nodes() to
   get the number of nodes in a qgroup's list, then allocates an array
   with a size matching that number of nodes.

3) Task B enters the BTRFS_IOC_QGROUP_ASSIGN ioctl to add a qgroup
   relation and enters btrfs_add_qgroup_relation() where it locks
   fs_info->qgroup_lock before calling __add_relation_rb() where it
   adds to the list of the same qgroup that is being processed by
   task A.

4) Task A iterates over the qgroup's list elements and assigns to an
   array that has an insufficient size, since the number of elements in
   the list is now larger, by 1, compared to the count it got in step 2,
   resulting in an out of bounds array access.

This all happens because btrfs_qgroup_inherit() does not take the lock
fs_info->qgroup_lock before counting the number of elements in a qgroup's
list and iterating it. So all sorts of other races can happen, like
iterating the list while another task is calling either
btrfs_add_qgroup_relation() or btrfs_del_qgroup_relation() and modifying
the same qgroup list concurrently.

So make btrfs_qgroup_inherit() take fs_info->qgroup_lock.

Fixes: 5343cd9364ea ("btrfs: qgroup: simple quota auto hierarchy for nested subvolumes")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c07cf6041cb9..195326ef0388 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3256,26 +3256,34 @@ static int qgroup_auto_inherit(struct btrfs_fs_info *fs_info,
 	struct btrfs_qgroup_inherit *res;
 	size_t struct_sz;
 	u64 *qgids;
+	int ret = 0;
 
 	if (*inherit)
 		return -EEXIST;
 
+	spin_lock(&fs_info->qgroup_lock);
 	inode_qg = find_qgroup_rb(fs_info, inode_rootid);
-	if (!inode_qg)
-		return -ENOENT;
+	if (!inode_qg) {
+		ret = -ENOENT;
+		goto out;
+	}
 
 	num_qgroups = list_count_nodes(&inode_qg->groups);
 
 	if (!num_qgroups)
-		return 0;
+		goto out;
 
 	struct_sz = struct_size(res, qgroups, num_qgroups);
-	if (struct_sz == SIZE_MAX)
-		return -ERANGE;
+	if (struct_sz == SIZE_MAX) {
+		ret = -ERANGE;
+		goto out;
+	}
 
 	res = kzalloc(struct_sz, GFP_NOFS);
-	if (!res)
-		return -ENOMEM;
+	if (!res) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	res->num_qgroups = num_qgroups;
 	qgids = res->qgroups;
 
@@ -3283,7 +3291,10 @@ static int qgroup_auto_inherit(struct btrfs_fs_info *fs_info,
 		qgids[i++] = qg_list->group->qgroupid;
 
 	*inherit = res;
-	return 0;
+out:
+	spin_unlock(&fs_info->qgroup_lock);
+
+	return ret;
 }
 
 /*
-- 
2.47.2

