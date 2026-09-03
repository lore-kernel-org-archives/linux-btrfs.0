Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3F44E378B
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788450214; cv=none; b=gAhiHfn6BNL0nzy5UB0F5GPIvXWIUF08wQfcR9k2SEf72tzQKPpd18m1RX8b1oE5pA/F5/lvWZWkQzBs5yWI2dOCyIcBhkD3CM7uCwFsSMudNXH2WJ9rNS+IR5JOWr+IZUWwGgtX1tyrDweuXye7YSr3GGnk6k8OkOVJKDHIiYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788450214; c=relaxed/simple;
	bh=sl0g3fB0VB1v+wKOorak7lAtsbC6UraKEIf0F0ByrMo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQg/qZmWd8bZj1b93zwMQc2vwckVKbZNXHtZjT54B9OilSOGXRqeZsx4nSLUpISSEX4dql2ywIIJZbS9W2oreEJgX8+7BQG+vHujiUTBM+5hDfvRPZQg2wHe5UvCBAWXZXAO6kl5vteDO+/Sn/v2EWjrN3p9rkS7Z14a5SEcvG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ADC5/o+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ADC5/o+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CACC1F00A3A
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 15:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788450212;
	bh=1LGIdWnWQvxABm14OGY6ECQA33Ls7hK+Tw8No2JW98w=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ADC5/o+jRHHwTrCqJdgsu+ahuXt3VxuwIK+s0e/CYfPxyDBdvPxh1ZGpV5mHQttcl
	 il8USP9wt3uah5SCSMUbEZJ8Mf9XYmL6qEjOHsN61KjR7fn1RD3JbkhfNMfCIipOJE
	 ooBjKNM6VVZFxOgnZrfv82TUUNZ+a6S3fD8kULRBmeToC8Tb7E3kwxUp9YNNp9Kbbo
	 Sa/O8QDoKMbeT7yxS2aocuXfa5gA9hm8YxY7semm8fxPVcWXyk0Iseu4dgJqTpxGXo
	 hv77b9VUQSNUQEibHxMrftspm50X2qb3YkudTBG4O3N0moimMkjDVEFaIFjZQGsKaj
	 q1OnkyJqcG3Sg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: tree-checker: validate parent field for inode extref items
Date: Thu,  3 Sep 2026 16:43:08 +0100
Message-ID: <d29d414ab98243855afeb6361ad773e7f0a9689c.1788449622.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1788449622.git.fdmanana@suse.com>
References: <cover.1788449622.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

For a subvolume tree, the parent field of an inode extref item corresponds
to an inode number, and that must always be within the range:

   [ BTRFS_FIRST_FREE_OBJECTID (256), BTRFS_LAST_FREE_OBJECTID (-256) ]

Add a check for that in check_inode_extref().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-checker.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index baddde54dfab..9dabae134e93 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1962,12 +1962,14 @@ static int check_inode_extref(struct extent_buffer *leaf,
 {
 	unsigned long ptr = btrfs_item_ptr_offset(leaf, slot);
 	unsigned long end = ptr + btrfs_item_size(leaf, slot);
+	const bool is_fstree = btrfs_is_fstree(btrfs_header_owner(leaf));
 
 	if (unlikely(!check_prev_ino(leaf, key, slot, prev_key)))
 		return -EUCLEAN;
 
 	while (ptr < end) {
 		struct btrfs_inode_extref *extref = (struct btrfs_inode_extref *)ptr;
+		u64 parent;
 		u16 namelen;
 
 		if (unlikely(ptr + sizeof(*extref) > end)) {
@@ -1977,6 +1979,16 @@ static int check_inode_extref(struct extent_buffer *leaf,
 			return -EUCLEAN;
 		}
 
+		parent = btrfs_inode_extref_parent(leaf, extref);
+		if (unlikely(is_fstree && (parent < BTRFS_FIRST_FREE_OBJECTID ||
+					   parent > BTRFS_LAST_FREE_OBJECTID))) {
+			inode_ref_err(leaf, slot,
+		      "invalid parent for extref key, have %llu expect [%llu, %lld]",
+			      parent, BTRFS_FIRST_FREE_OBJECTID,
+				      BTRFS_LAST_FREE_OBJECTID);
+			return -EUCLEAN;
+		}
+
 		namelen = btrfs_inode_extref_name_len(leaf, extref);
 		if (unlikely(ptr + sizeof(*extref) + namelen > end)) {
 			inode_ref_err(leaf, slot,
-- 
2.47.2

