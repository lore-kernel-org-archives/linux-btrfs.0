Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA574EC669
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452872; cv=none; b=RQ2mYu18mccitQVFTa8Na9cUkZ6ZDyKVC9kN+1rzQ6Wtc4Ey6dj/tE4D6E95DD4sIoYOFmKrYVqDf9gxa9IupkgGx3UQECsreejTnAsD8ptsEFafudX0Lxw7EFOogbAheqqTHChN27QyNOe03mrGaa2E9lfsoUPt+TiqdCmdkN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452872; c=relaxed/simple;
	bh=A8oVxHqjCtJi3oVNr3+kg7dDPKcZTVgPXouozE8bz8M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Nng9hCeBszaHS381EMZUt0vEWMOldAmQHLF88j87WobtLzFY3gvKzAKGi8X91pJi3zIG6QdfeatNw38LwmfgtiLF30fcR/TC7GCPkEF6lzWlE6thCu4plQM9Sy8W+V6M/f1KEFgyHH1amEa/2Azkvx9B8tV7BJfIkZOyjC+AeTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJ9qOTfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJ9qOTfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FEE1F000E9
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452870;
	bh=5KrIYFQXxGYlY6RPD7+UfRzfZUJRU8DEwue7viap4Z4=;
	h=From:To:Subject:Date;
	b=kJ9qOTfoQgK6gBizNyWJBykD3TtK8hoaLOjZRRa0iLB9pZl/xrOahPi5+c26tjPJC
	 fHuDTisCxyM0pKSXHo3MzZekACSXUm+5N7hMs5Bi2GCfi43yeOGunbQKJIur3Ntt2g
	 ljZvGdL+E8sezL8XX4NvUltI7XlW+SLjks7QHGX32e6rfY+dMZ2m4BWlPNXiHCv+ug
	 E5p+HLxUnP70Olci+6Hsdwx0Ihowk7UEBfVd2DABAuX+RcX6CcKfxS/R1AWkc/dfIa
	 Uv2LvkWH7l+CGLAYAp+CrbvKvdReigjIQRxESh3j3YWX+WZRWVyA5x6yGgtHak7sZn
	 j1l1ND0aVprsw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: validate name length for extref items
Date: Thu,  3 Sep 2026 17:27:48 +0100
Message-ID: <0fbde4f56df4c84aa62864a2641217fe2a8132c1.1788452841.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We are validating the name length of inode ref items, but we miss the same
validation for extref items. Sashiko pointed this out while reviewing
other patch. Add the missing validation, similar to what was done in commit
3dc22abc21f5 ("btrfs: tree-checker: validate INODE_REF's namelen").

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-checker.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 3a0715798282..401fd40ec7b2 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2032,6 +2032,13 @@ static int check_inode_extref(struct extent_buffer *leaf,
 		}
 
 		namelen = btrfs_inode_extref_name_len(leaf, extref);
+		if (unlikely(namelen == 0 || namelen > BTRFS_NAME_LEN)) {
+			inode_ref_err(leaf, slot,
+				"invalid inode extref name length, has %u expect [1, %u]",
+				namelen, BTRFS_NAME_LEN);
+			return -EUCLEAN;
+		}
+
 		if (unlikely(ptr + sizeof(*extref) + namelen > end)) {
 			inode_ref_err(leaf, slot,
 				"inode extref overflow, ptr %lu end %lu namelen %u",
-- 
2.47.2

