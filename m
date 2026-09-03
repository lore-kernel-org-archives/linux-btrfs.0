Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7173D372B2F
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 16:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451240; cv=none; b=JXb+cXk6HcXpWa20yc9cqLzAfe+voHTsYh3s3bx4kzb0DeJ0KprRlflTEXfPbXZ3WyXpEUjQknwP+rzQbmem3t4kEgeVE8t/SAuk96fJwnUH8c5+CeL4J/riJ6CzW4N8Tw8277p/OkuiilgtwJuIBnxcQFWBGShvHoOx20okWnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451240; c=relaxed/simple;
	bh=cGiI7AynV1RaV7MoP4yPE4fHhgplfeSmdEUktAM9QY0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVPyZZcQ87o0g6WcJTcSW0dTBO68R8TtYuHN/XepexvlDEKfH+PuFiju/Gi/68C2PH/E3Lg2MaZw3ql3BIXDceWhB1UAbdtm+EI9JSMuXl3bSkXCTEoQ+kfbcyh5UwjUYwzMKnWTm+D+/FvgHNU/64kofgR9tf3F7p1ZBH9G7bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5FSPuRt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5FSPuRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5B01F00AC4
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 16:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788451239;
	bh=jYFEh71jAzgO9UOQn6O+i3FABuQtSm73mWQAnEmgqy0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=h5FSPuRt5hY4/WxkT3J+HRbOOE0wEHo3Yw9iMnSMQsfiIqR0jXfMGr0az3oy5Mh4/
	 BsUBST9JxqHXq6Wj/LTr9hqucfJhDfpPuhDRbAQH8606Ur5JMtM/i1t/UH/EdAkYNC
	 1A/SGEUEqQ3xuphuQoRw3nSc34yQlOKZVfgh9TTFUqc8IfvkYBLTeecpqEFAGOHc3X
	 vnMb0iNxkn7NJ15lSCxjHLvjSQmeYrjocntQqtR2EsjT2hAtn3dp4l5WrtPdn9uII/
	 +Z64U9YXQC33NRCypEPKLAvmwwiXns6D9QbDHxyluiqMf1KluOZTKDbSFHh/6sSmhz
	 /YndpF3gGQofg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/3] btrfs: tree-checker: validate parent field for inode extref items
Date: Thu,  3 Sep 2026 17:00:33 +0100
Message-ID: <e7e6810201fbe03c51faf3dfb8459dac2fe7ae20.1788451065.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1788451065.git.fdmanana@suse.com>
References: <cover.1788451065.git.fdmanana@suse.com>
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
index 7dff824cfc4c..3a0715798282 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2004,12 +2004,14 @@ static int check_inode_extref(struct extent_buffer *leaf,
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
@@ -2019,6 +2021,16 @@ static int check_inode_extref(struct extent_buffer *leaf,
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

