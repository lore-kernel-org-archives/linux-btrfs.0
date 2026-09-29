Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECB3332EC8
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 00:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641248; cv=none; b=dSlOlONl2ETwR6eaKNFDHriGVhfCheuQQuOifnKvuJPXsAhpRs324CXc96BxGAV+J77GL5butbNRC7qxNixmzyF7Ota58PaJF09SJfy9agkDKC86eBFqKdCUfogJ2cOzL35VOioePxx1nw2MVWueEA7qOW0g7JgQdGBZdQoBavM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641248; c=relaxed/simple;
	bh=Zvo6p9DQqAOlR4m0YJBIzFi053sqY127BgVdY0VnqHo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxwlVKaJejQ7GIqA2UcU1ERrNGxSrpdyf0f0RtglkIn6vwz7GlcOnerLQ2NohQCR4/1NFqmpABwQqwzUVnecqanox5NgCyDREPOF4cvgtP25ET2ViZH/dj5ajwrCAaXPGbq6oL8AI5C4fIkUY7WqVCzWt8IhhDWLf/zPowdoLqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Tzeaw7Qw; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rq3dfHl1; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Tzeaw7Qw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rq3dfHl1"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 92473EC01F9;
	Mon, 28 Sep 2026 20:20:45 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 28 Sep 2026 20:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1790641245; x=
	1790727645; bh=Bzywt4YAQuBwW1VKMXlOUJd5o4oh7oum8BWnENPl6rw=; b=T
	zeaw7Qw1GACe2JNen+/GJw/Mnjdu69/bbf5d63oZ6fYIcDN5Yk3s1ExK7YzRsv5T
	0SC1jIbdSoIUCBwLy9icehtMxisycyP1O64s3PL4i36LkoL8FAcUBMFX1L7u3Vly
	WLxZ0UDbOfdoSzYlKMlr6oULUQBisGF5P1bVo45Han+VHWmFhPpepRWMy3zVpkQW
	dF26b+eO0hzM2jx8oTW8BKrHA1CvfoFZgfZ4ol10y7VG6rwUbIbDNM4P36YJFSBG
	ooVVsdmxMQO5l60CfLC3QT5jk2WKE14ZUW77bG7IAeFdSOidmppOnYJX1QRG+Bo1
	PUypzzVbicgLk4i5FGmsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790641245; x=1790727645; bh=Bzywt4YAQuBwW1VKMXlOUJd5o4oh
	7oum8BWnENPl6rw=; b=rq3dfHl15YX7JW1gr4VaAyNNEfamM9kPueJvHcwxZi3G
	4AGUjJFtYYsX/oqthLB2wKKc+ZJTBSddbLhWdLz7MWKw1iagsp1RyB2tMgPXmqq7
	RoDUGoppYnaqB++bynGtbxi3+GMbulYkyCc4qiMEHdYDxJlK1rwTLWhR853BmQL3
	dqnnzWl5oJeqhxZypwJkOcRil2IJrG/F6CVPnE/qG/V/Wk9FwV3C3fh2Uc8jY74k
	dqV+PWvRUXOBnH6wD0n26TMajp6y4PGKRV7E1q30P/UbGgc2HkVoH3pWI/0ILgef
	G/Witlcw8X+2YSznlyVwUt3JOc+yb2L5eD+dpeRKIw==
X-ME-Sender: <xms:XQS7akf5w2slqBo5Jz2i6SmPzqjQhDlraffPvhm2JCqywYQXpZqcyQ>
    <xme:XQS7asOMbiw6Bp8Az5dzfTXCdYLrK7ePAr6kV5yyrbOiGQ-4YbEsML77fEsjAQR-b
    EwdqBmPknP6nuk9ZbocynmAxpiM2khJBJjTOvhWw0SAfmwMEj_P99Bv>
X-ME-Received: <xmr:XQS7ajIXlk8GiREDxDQ_zOYA7kbujy5rxeXIa6assYrAejAb03awe_0>
X-ME-Proxy-Cause: dmFkZTEsnGc0Sn/bgLgWyfKxIhdNE7j7GWUHzWmyZxbkV4WBZRaFWWFBI1S27JJi1ggv+a
    d3o5M55SXmNA89Q7HYh838dv8j5nQE0mrtHfWGhvRREvniwfvJiZLN4XgU4DlNMeapCz6G
    GS6trNj5loAjujzN/hMn6nvoR1EYgnrhccI4/nfJutv8Dzm2j8pzv09ixP+++CVQ2jWebB
    ThnyxvbbtCVX7jsTvHo2CIaM9ldNsxVFVxocajiGvCl+Eo4hNvstnxKgVMF12TOFZskQWE
    1Z6AehbeX4D+G1ExyyNey/PjZXJZVcYjn2WIgFvNlpC2BxJA+7t7+yjafdl+1RlrykwgSX
    SK2CxA97xfYajne5gOHZ9/NAbVU2yhyguekOc4w7WN3/ofyLyoXbRztih/Vo1eXnsDxp7p
    jPRuZVRkgZ/3FGG60kXUAY97mQMLZ2L4l+d5UVk3kMfm9Nxo+h2ExQT69a9z8ws3xDPy7z
    HArg6/ygPJNcNd92Hpz+OhxN/poqyHhVEaZQopVT16Fyl1AlHxN1CKMeyWCB7h+fXS4l7c
    5csGqGda37Yi+9ELpt1336jqUpORKSI8fJS9v9/7nWVBWOV2ivkCoJt2hBWe0PiGqSlZDo
    HI9zCu3SRQw5gQKRxGuz+BHoA7H9b3B5Vcm5ZxI+rgtwjWk2lKsNzs+Hp0+w
X-ME-Proxy: <xmx:XQS7alEVsaFG1DDIMZIc2jL0Cud_LYtFazy-4f1YLVQC_UAW-Ks9Ng>
    <xmx:XQS7ajRX_7-wjCV-TsM0eENQEY6v5upGiAuZpMsjgbt-ykf0i5GhKg>
    <xmx:XQS7apHEmEEpvBwRAfn3LVK-XkYfTXCpRx1rRyURyKCc8qxld9nVqA>
    <xmx:XQS7an-q5v109y9rswx1bLB5fBJrTpHsehGe7DmGfsrYQiAM_47sOQ>
    <xmx:XQS7aqct3Ynf9Jlx3XiyDjEzIYLJ4IdYP4BO_lG8yKRNXNXvM0o3YVBG>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 20:20:45 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 2/2] btrfs: commit after deleting an unused block group if system space is low
Date: Mon, 28 Sep 2026 17:20:34 -0700
Message-ID: <589c813eda39e4512f34844a0a593aba97659928.1790641111.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790641111.git.boris@bur.io>
References: <cover.1790641111.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the device is fully allocated and the system space_info has no room
for a second copy of the chunk tree, deleting many unused block groups
in one transaction aborts it with -ENOSPC in btrfs_remove_chunk(). While
we can get ahead of this problem in practice by allocating the system
space more aggressively, that doesn't help a system that already got
into this state anyway. In particular, this would be a problem on
systems that got into this state on old code from before that
improvement, but it is also a backstop in case we do mess up and still
end up with too little system space.

The way we end up needing a lot of system chunk space in practice is if
we need to delete many bgs at once, resulting in touching many
nodes/leaves in the chunk tree. Therefore, if we detect we are in a
condition where we are low on system space, commit a single transaction
deleting a single bg, which should not need much system chunk space.
After this we have the freed bg and can proceed as usual. Any additional
chunk allocations (for any reason) will also check the system space and
are very likely to allocate more system space, so this should be a
relatively robust mechanism.

Assisted-by: LLM
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/block-group.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 0a41b16ed270..c148b9d6e597 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1596,6 +1596,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 	LIST_HEAD(retry_list);
 	struct btrfs_block_group *block_group;
 	struct btrfs_space_info *space_info;
+	struct btrfs_space_info *system_info;
 	struct btrfs_trans_handle *trans;
 	const bool async_trim_enabled = btrfs_test_opt(fs_info, DISCARD_ASYNC);
 	int ret = 0;
@@ -1613,10 +1614,13 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 	if (!mutex_trylock(&fs_info->reclaim_bgs_lock))
 		return;
 
+	system_info = btrfs_find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
+
 	spin_lock(&fs_info->unused_bgs_lock);
 	while (!list_empty(&fs_info->unused_bgs)) {
 		u64 used;
 		int trimming;
+		bool low;
 
 		block_group = list_first_entry(&fs_info->unused_bgs,
 					       struct btrfs_block_group,
@@ -1864,7 +1868,18 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 			btrfs_get_block_group(block_group);
 		}
 end_trans:
-		btrfs_end_transaction(trans);
+		/*
+		 * If we are low on system space, commit immediately to get back
+		 * unallocated space to greatly improve the chances of
+		 * successfully allocating a system chunk.
+		 */
+		spin_lock(&system_info->lock);
+		low = system_info->total_bytes < system_space_target(system_info);
+		spin_unlock(&system_info->lock);
+		if (unlikely(!ret && low))
+			ret = btrfs_commit_transaction(trans);
+		else
+			btrfs_end_transaction(trans);
 next:
 		btrfs_put_block_group(block_group);
 		spin_lock(&fs_info->unused_bgs_lock);
-- 
2.55.0

