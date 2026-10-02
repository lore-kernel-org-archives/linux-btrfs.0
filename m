Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629AF3E49EB
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790967359; cv=none; b=RqWPd4lpdAB0tgq7gMNFsxNogwbqgiNoeQKiPbdWOvUNwNPgTVmAGGvvuID6XLsc1P/IrdggKIouHlWiqOc1X64t+akvHUqKyb1AmsyxFo1FVOT6bVkNjF9IWMnNEkO43OPifGHCXDrBY8AdtOY45h+dv5iMDxeU83ZAmggWrwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790967359; c=relaxed/simple;
	bh=udOtcNmFsSo6aM3K94BbBSbIrbPFSK3GckaG7q41oMY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0NZElfvNaOvGCk/qqqkJyQOET8Vpp7dvAmwUqQArwSlbwOamjuTK/e6ZMRHnX3pJBoQ0ReJAeX/85ZqfpySwrY/kZfmO+zsKPOHdyjEvqJXmSaBjFOvytnpFWoWgmDHC/eqUo2k5kfZ+s9NegzxtQQN0CQ1wNHtfNYdl9sF3n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chIb4LSe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chIb4LSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A221F00893
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790967357;
	bh=U9ZMVNrZ8kuWLvWwJjmRVtLOJDG6JD2xh0bBfqRT3D0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=chIb4LSeEt1gbLzIlLq/2nZGKIuczCbHmOGgty4o6v7fJ5obEns7XR06mpKHBcfku
	 Tzg2SDheBHnIQBkjfGoFGQ2/L50kh/HMNYKnML756lgixnG0ltJKrZ/SG+k9Vo30tN
	 8f05SaxU1x+GBGOkz+TU1Qn0K2xGWLWfWWfWNF6Ax5LSr4dZHNo8J7PuOrOl9P38WU
	 64aeTYzE3akGNwS51zh5O+VEzF2hxfL1EMCItrtQg/uqjaWhLoRWiTZajxXG5tF01J
	 fZ/PRsxrz+UY3n17eztImjMOZdamWEaYgdqr+voOLc3rzlINMqoyn5P5q20ihHj0EZ
	 lP9HnS/Tzqb8w==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: qgroup: fix off-by-one max level check in qgroup_trace_new_subtree_blocks()
Date: Fri,  2 Oct 2026 19:55:47 +0100
Message-ID: <4d5762cf51f22eff2c91770fb23e0a637e6fcc42.1790967259.git.fdmanana@suse.com>
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

We have maximum of 8 (BTRFS_MAX_LEVEL) levels in a btree, going from 0 to
7, so the upper bound checks should be:

  >= BTRFS_MAX_LEVEL

and not:

  >= BTRFS_MAX_LEVEL - 1

In practice this will hardly ever be a problem since having a btree with
8 levels would imply a massively huge fs.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c9fc3b6a5132..54d82d6fd4bb 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2491,8 +2491,8 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 	int i;
 
 	/* Level sanity check */
-	if (unlikely(cur_level < 0 || cur_level >= BTRFS_MAX_LEVEL - 1 ||
-		     root_level < 0 || root_level >= BTRFS_MAX_LEVEL - 1 ||
+	if (unlikely(cur_level < 0 || cur_level >= BTRFS_MAX_LEVEL ||
+		     root_level < 0 || root_level >= BTRFS_MAX_LEVEL ||
 		     root_level < cur_level)) {
 		btrfs_err_rl(fs_info,
 			"%s: bad levels, cur_level=%d root_level=%d",
-- 
2.47.2

