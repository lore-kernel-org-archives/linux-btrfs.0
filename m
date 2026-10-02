Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B88C3E5A0E
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790967354; cv=none; b=iiGkRAdoGHV8B8h8Xwy1KLPV32DJJOtCnd75msGl3jhFeJWuzv6qok+ZbtGA5DPPzCD7eIpVfZA4RpdQvXDy+fwZZ3podnwVqohoq4Fi3q9NFQLk/oWWEEMEbdIEXgts9LwDzCYEbnupGhhZFwLRhAT+83atBi0HKONSmNS998U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790967354; c=relaxed/simple;
	bh=axR8p1uFEQiK36kKzP8ueUu0hbcWJpFJN8fsEJerhuE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTw6NlCDzknWWSW2qUGChvJU17njOVT/DHI+ovXC829JuA2NLfUW7pEybV8UQz1xou467X42nsfDWbtpxd6qWyQR/HGxK36V6calTX5yUuagOnIxaM5Dik2PoneRoEn1wST5TTt5ncxR3luMWq9S4/R+Z626yPsfxS1UBmP8AN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UeN/Z3y5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UeN/Z3y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1121F00898
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790967353;
	bh=uu+GKScYyPfEHXnePXxla6bh+aCLLpFwu9iCUKXMgW8=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=UeN/Z3y5dY7OBshkx7klBG0pdCvDIZIGo2kuQSuf1VFrgx3u2U74XmfklezLUiYCK
	 j6PYcjGEqEmegVJ4a7Mcz3+caEcK+7fmqvJ4GmgpiYch9wdEENX7XjG13TiUum7utc
	 FKPbrMo0jE+ip2bii425hAZFTsnCwVBkXwo+9UxMj4n/VCEs5BxSY2XRPJduCOPBe4
	 Dh4ghMOowSxwSEVaN5f4ZPirroGawcvesGfu8VBJtoqUqyRbQmj82j3A5b3OqlvuI3
	 oghwsQ22Wj2qLWlWqMFherxlf4In89XKOt+R9dxSH8yma8W9mgpfYH5uM6iKOdpr4h
	 59N1nBbFPhcnQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs: qgroup: fix swapped blocks existence check when tracing after COW
Date: Fri,  2 Oct 2026 19:55:42 +0100
Message-ID: <13d832272a848474d479cd21f6d3f3f6eff54bc6.1790967259.git.fdmanana@suse.com>
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

In btrfs_qgroup_trace_subtree_after_cow(), after we erase the swapped
block, iterate over all possible tree levels to check if we sill have
other swapped blocks. However the check is wrong, it considers that there
are other swapped blocks if any rbtree for any level is empty, instead of
not empty. As a consequence we set blocks->swapped to true basically every
time since we always find an empty rbtree at least at level 7, since in
practice it's nearly impossible to find such a huge btree. This makes
every future call to btrfs_qgroup_trace_subtree_after_cow() do an
unnecessary rbtree search instead of returning immediately.

Fix this by updating the condition to set swapped to true if we find an
rbtree that is not empty.

Fixes: f616f5cd9da7 ("btrfs: qgroup: Use delayed subtree rescan for balance")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 46de0a5e80d5..798f21608de5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4913,7 +4913,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
 	/* Found one, remove it from @blocks first and update blocks->swapped */
 	rb_erase(&block->node, &blocks->blocks[level]);
 	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
-		if (RB_EMPTY_ROOT(&blocks->blocks[i])) {
+		if (!RB_EMPTY_ROOT(&blocks->blocks[i])) {
 			swapped = true;
 			break;
 		}
-- 
2.47.2

