Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6D74CEE6C
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789575384; cv=none; b=DctEeK6bJBNyTHzLFBzjGUbmStspNxmrmMIiiSEFlRjBQWSehyj6vVeFP3uwmyJEWZ4qZKpa4rj7DSicE0qUYE/SdAxe0G9z6GEd6lrn7/2H5XZaFpZnCNcMwAOaueRs3fm32QFEbcaseuIe7rpyXRG+kObIgCRE0JJsCppePhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789575384; c=relaxed/simple;
	bh=IH1vjbCMJIkW/r2FrSruVh88yYDj3jHKiGeDAOeJgYU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=MmNcRycBVDXx1bTEHOl7WpYsdt2pqV30hmfTVPX79DZKU0IlhZ0sknDn05ed/n3N3t8404+kEjImWR9jVs/XATjmiewoVjc1qBHfW+WPdN0mGgs14qp0ijUl4AgK2Wn3aXHLEteP3/HuYu9ffc9bx6tA9EKp0I7NxdgsCE2g2F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozkDuQal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozkDuQal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1221F000FF
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789575381;
	bh=31rnwPl1R9oQxSFWWX8aSB/rl2J4aGDefxo1jOWTjPs=;
	h=From:To:Subject:Date;
	b=ozkDuQalzT0lsbs8VBMik72FYDZdd0QfxLpUbl1ZYk3BtZyjaXsmmTlaXthKdyDWp
	 uXoOF6f3j+NHLW7OdYMGcDuUIGVWFy6BZ7fpDR7tCdf4ogn6Y38ZsW3czj4xoQcnD9
	 lPKBgXvz4LHOOSMmxuub9EleRk6nUOIE/na3O1+Hci0KYUD4qYF9P6g70prw7yvcA7
	 oKH7KV4S7CwE6fumHwjYPE/YyMmc0BBQmdSVmAkLXNpetcu8P2hgHRMwhaf8D1hkBU
	 mCCLZcaZ6FcphpPp73VLLFFJ58CUhiXRtbPKzVaqOXCXh81noV9LogwWqyuKrMtJcG
	 z6ctc7U2SXbBA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add missing unlikely to a couple error checks during sys chunk array validation
Date: Wed, 16 Sep 2026 17:16:18 +0100
Message-ID: <0748c218c84df0cb8a9231b5e108e12ad28e9b6a.1789575353.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

It's unexpected to find errors during sys chunk array validation and all
checks use the unlikely tag except for two of them, so add it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c      | 2 +-
 fs/btrfs/tree-checker.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 94a7e9059a7b..21b72c90bd90 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2387,7 +2387,7 @@ static int validate_sys_chunk_array(const struct btrfs_fs_info *fs_info,
 		}
 		ret = btrfs_check_chunk_valid(fs_info, NULL, chunk, key.offset,
 					      sectorsize);
-		if (ret < 0)
+		if (unlikely(ret < 0))
 			return ret;
 		cur += btrfs_chunk_item_size(num_stripes);
 	}
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 0f4f1b347c9e..9cd79d97b9b5 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1121,9 +1121,9 @@ int btrfs_check_chunk_valid(const struct btrfs_fs_info *fs_info,
 		return -EUCLEAN;
 	}
 
-	if (!remapped &&
-	    !valid_stripe_count(type & BTRFS_BLOCK_GROUP_PROFILE_MASK,
-				num_stripes, sub_stripes)) {
+	if (unlikely(!remapped &&
+		     !valid_stripe_count(type & BTRFS_BLOCK_GROUP_PROFILE_MASK,
+					 num_stripes, sub_stripes))) {
 		chunk_err(fs_info, leaf, chunk, logical,
 			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
 			num_stripes, sub_stripes,
-- 
2.47.2

