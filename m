Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795433249;
	b=N704QkC6a7FoZphmPvHF3A0rDohXpY8RQ2Du4EMkCS8PVDlJ/puucmHtPROrHc0adXt/
	 wV2iwfv6qDcDCd1GUHk8vn3lDo/Vge6HWJheIaAkp7VDPMZ2pUeBGzYy/jqREl2PRGfBV
	 SQ2hKcbTKCECKcBKTwQkFjgBtvb+sEH+YL/o2CCZTVwYIyYJUDtNp7stjN2cscqliRrRd
	 q9SAj1nlQaBYT7HqKS2ZZwY5P0XuYci3vhS9zLg2Q0T8VRb+qvZ9fHVpkYqHbb+M/4c6y
	 AgEmHhFdecsDtjPJmWIWl7qT8he1I/OJflDeSaXmaE354/KaSG2NtRXoPLV/NDNQbLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795433249;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=V+VTXpCnr6NdSPZ1vDdcOZNFPIBauUD69OBx2ZVZ69I=;
	b=Cus55EVFIeIJ4wphIo5KkkFEkH4B1+aJWhybHPHkzYuEydzc/yjLFFn8QowDrKcFfU9M
	 S0vbsa5oBCnSGE4aIxugi6Gw104f4rGHKc3iUNW4saSdD559LeZJTrDyAlvga1XulN/SV
	 AoZdPTPfj28yCKv1Ts8zG0rLnwmrr0deLiC4A/94ZcOw6BeeKDcFSny1WXWJZ1ao8hv88
	 hbv70r8jDxxsFuyEB/w61IcDkJc0njW8KSvdiSsvvnbZ6m5k5Athw+TeCTPfR63C09TqJ
	 2FNshoZkyNZNclbV5lXhhg7szYMVeX40DyS58absw1/sB2QHInEWvlLQjMahqSgakUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CCaL0irl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8740606A338
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CCaL0irl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154EB1F000E1
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795433249;
	bh=V+VTXpCnr6NdSPZ1vDdcOZNFPIBauUD69OBx2ZVZ69I=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=CCaL0irlN129NIjsE3BZI70PN6npUtUxPzXCHKCG1Xvam/mwpDA5jCy7HfeJtHlP1
	 n8vNiPz0IfGMw9roc3p6muyC/VtbTFCeklZMT++7bYTCYUhEzuEq2UpU9clEbFET8I
	 pbZjzrrPnD0Aa+5fWT/aBlZ+zq4/pX8fFqpRoWXDX0Us+1B5V84A8RBvK/wkqkiiUj
	 KoKCIu2jE1jlQnCDr10BBWexT0nQpdh8fY3qhFwED356umfphW0yB4ynJJ5uHK/ied
	 i/i4+95ZfPJsyjn4h+aZygwn0iRAnRoNJ5nExJhDMJ3AXJwGEF08OWLIY9CcnCTkWd
	 klnJ+r8BupT/w==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: assign boolean literals to fragmented field of btrfs_free_cluster
Date: Mon, 23 Nov 2026 11:27:24 +0000
Message-ID: <14a3f1989e3c8b46706f65a058ee3375bdd883ac.1795433118.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1795433118.git.fdmanana@suse.com>
References: <cover.1795433118.git.fdmanana@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The fragmented field is defined as a boolen in struct btrfs_free_cluster
but we have a couple places that assign literal integers to it. While
it's not incorrect, as 1 and 0 are converted to true and false, it's less
readable then using plain boolean literals.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0008cbc12412..4eb69e5bce4e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2881,7 +2881,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 		if (cluster && cluster->fragmented &&
 		    total_unpinned > empty_cluster) {
 			spin_lock(&cluster->lock);
-			cluster->fragmented = 0;
+			cluster->fragmented = false;
 			spin_unlock(&cluster->lock);
 		}
 
@@ -3956,7 +3956,7 @@ static int find_free_extent_unclustered(struct btrfs_block_group *bg,
 	 */
 	if (unlikely(last_ptr)) {
 		spin_lock(&last_ptr->lock);
-		last_ptr->fragmented = 1;
+		last_ptr->fragmented = true;
 		spin_unlock(&last_ptr->lock);
 	}
 	if (ffe_ctl->cached) {
-- 
2.53.0

