Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BFF2836A3
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2025 16:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757954240; cv=none; b=WNFKeogfVgHzgDQLx1zFQySbEPJzRdrX1L0h2+s8F8e+njdEvNcX1iSIPWjzJeH9sCc9lzxNxmol0eSoIFFxER1h+zPooNuDw7V6h673mmiXJIsaTFl2TyZ9ntM59nCY8tMkKBvj3u/ZSLsq5WTLAMH3f+NDhJB56OPZynJgYgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757954240; c=relaxed/simple;
	bh=WSbcvjewNvb+yUZSxJyiQLnZ8qE3d0JRcNoD8hHAuNE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHoP0ZypQEYtOpVxcLfZ87QQERVhMM+laSLCxIuyDUTl42ifYDwMnC2WaGYRhwSJSmExwGzlV3HEqKEFWLK+ZsYgZADfDtJudqUvxkciwuP9HRzpXyJ7asT59cOyIOJpl7Vn5hvxNKS/WCSktK4Ql1Qxe9iUwPccdwjFExbWBNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwI+dL71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwI+dL71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66C1C4CEF7
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2025 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757954240;
	bh=WSbcvjewNvb+yUZSxJyiQLnZ8qE3d0JRcNoD8hHAuNE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nwI+dL718ywgJqJiVFYt4dWdxCzhpVkLJOJo+zaVfsrVodoFZnIyolg+YNTJnsUGN
	 RIdmsY9o8/R9g1q1Gg/l69Ue34BSzy3WSPBtM+msNwEbvD2nPFKiRRErN36F43aZDN
	 OTTTcWO4a97uuyMXM75RZtgad9USCzFUTPGpkaVIuMJ4+VyJOfYAAhyT+lmzgHpmM5
	 HyJS8psOAh429eJ2YTEUSopjJMMOfj2IZ+jnhgv8yHcGUenGWmO0LvyqS2hyH4FQuo
	 5QV5YMifinJ8GDGvFDCGwduMWuUcedHPMykJMLUX5nuSpMO+5B/Asgdka+bwVrsv76
	 6vac9EfJyRJCw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/11] btrfs: print-tree: print dir items for dir index and xattr keys too
Date: Mon, 15 Sep 2025 17:37:05 +0100
Message-ID: <fd0eeb17bb7def82a6e9be88ae24926ae22ff701.1757952682.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1757952682.git.fdmanana@suse.com>
References: <cover.1757952682.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Currently we only print the dir items for BTRFS_DIR_ITEM_KEY keys, but
we also have dir items for BTRFS_DIR_INDEX_KEY and BTRFS_XATTR_ITEM_KEY
keys too. So print them for those keys too.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/print-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index df7fe10061ab..5ae611cb3f2e 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -315,6 +315,8 @@ void btrfs_print_leaf(const struct extent_buffer *l)
 			print_inode_item(l, i);
 			break;
 		case BTRFS_DIR_ITEM_KEY:
+		case BTRFS_DIR_INDEX_KEY:
+		case BTRFS_XATTR_ITEM_KEY:
 			print_dir_item(l, i);
 			break;
 		case BTRFS_ROOT_ITEM_KEY:
-- 
2.47.2

