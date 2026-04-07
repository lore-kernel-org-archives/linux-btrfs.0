Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D1B272803
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 03:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775533001; cv=none; b=TfyB+WX5jmDYO4ZFmBxR5k4u+ae53VbY5EUedJd46uWq9SRvRyqJbu9HSxdR56aDgGrjIS9tby0HdamuKAqRVTeqzhzC1zOTewZ9UYb/VSV2mboe0mPgspSwu376GuO/PuMR3ec/yo44VjQcrl3SsmzmuPxaOQ5WOYWW6uHoL2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775533001; c=relaxed/simple;
	bh=b7eEWkHt3b4mePNIbFE8JsC7JaKzzvcOB/lD1wrTVJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t4t3Rd2eoP6PUaHtGY9hTumg5qTw5MKC/uR4yFy6KiJsTyN+G1H35lN3DVYK1SpqjRNFEUbP2D+dLXz0RXTEBbOtvlYVTNnmpiuEVtV9iCfWEnebajgj7uW5C6XY59Ve24E2pYfwktg0clfFKYBlXH+3oZRd83WZmGxS28mg3pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=eabJkcGp; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="eabJkcGp"
Received: from 11212-DT-014.. (unknown [10.17.40.185])
	by mail.synology.com (Postfix) with ESMTPA id 4fqX1F2bD0zHnNFrL;
	Tue,  7 Apr 2026 11:36:33 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1775532995; bh=b7eEWkHt3b4mePNIbFE8JsC7JaKzzvcOB/lD1wrTVJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eabJkcGp02n4Ru52KGOInmxF8GOG4ywr4hGEJjbt9sIJm3TU4M8ZBGzRrxc4jFOZ5
	 KDiOdY8kkofzbDUIHOVtUHwC0PxSBdpbQvkq68ownmTLI7ERnG5nqHk6mfi8bEVloU
	 bjQPJ98EFFmwXcaSDHbgY8yq1F1sjTgJqUOKyAUQ=
From: Dave Chen <davechen@synology.com>
To: fdmanana@kernel.org
Cc: cccheng@synology.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	robbieko@synology.com,
	Dave Chen <davechen@synology.com>,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] btrfs: use BTRFS_FS_UPDATE_UUID_TREE_GEN flag for UUID tree rescan check
Date: Tue,  7 Apr 2026 11:36:24 +0800
Message-ID: <20260407033624.1218932-1-davechen@synology.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260402064348.2807138-1-davechen@synology.com>
References: <20260402064348.2807138-1-davechen@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
Content-Type: text/plain

The UUID tree rescan check in open_ctree() compares
fs_info->generation with the superblock's uuid_tree_generation.
This comparison is not reliable because fs_info->generation is
bumped at transaction start time in join_transaction(), while
uuid_tree_generation is only updated at commit time via
update_super_roots().

Between the early BTRFS_FS_UPDATE_UUID_TREE_GEN flag check and the
late rescan decision, mount operations such as file orphan cleanup
from an unclean shutdown start transactions without committing
them. This advances fs_info->generation past uuid_tree_generation
and produces a false-positive mismatch.

Use the BTRFS_FS_UPDATE_UUID_TREE_GEN flag directly instead. The
flag was already set earlier in open_ctree() when the generations
were known to match, and accurately represents "UUID tree is up to
date" without being affected by subsequent transaction starts.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Dave Chen <davechen@synology.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
---
v2:
- Drop Fixes tag, no benchmark numbers to justify it (Filipe)
- Reword subject and commit message as a correctness improvement

 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1b0eb246b7147..70357b12508d0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3674,7 +3674,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 
 	if (fs_info->uuid_root &&
 	    (btrfs_test_opt(fs_info, RESCAN_UUID_TREE) ||
-	     fs_info->generation != btrfs_super_uuid_tree_generation(disk_super))) {
+	     !test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags))) {
 		btrfs_info(fs_info, "checking UUID tree");
 		ret = btrfs_check_uuid_tree(fs_info);
 		if (ret) {
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
