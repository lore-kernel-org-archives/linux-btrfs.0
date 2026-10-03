Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7D248F037
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 17:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791046815; cv=none; b=NQPufGkLyXZjMY2GqZ5DqNQQ4LIb1qpAdgzJtMJIgZVLiZtuU+K6SU9zfm19HwOFTvfLin8sBElVebIP/4fUnNinLWufIdzpEWOKJqtfsYvGw9+VIqIKuszgaSwe2Ff1xZP6nN7vfQMeTKHK9jio1O3rNWzFQ+daVbsTobZc3I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791046815; c=relaxed/simple;
	bh=udOtcNmFsSo6aM3K94BbBSbIrbPFSK3GckaG7q41oMY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vlu0UuI/LFsEYoIe6TURoC1aAN5440Ea8pWNqa2aIktCji+ex8mWAML/4hHBBw4/xG7pFruiF+Oaxsj/ADXFRL4xx2DUnP9KaSBrcXUiJAqNOgMbDK0nMir83xNIkqcvYMyQtP+1RwSgDHkQ+BgY/4yV6r7TgYklbHnAivEtS20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeVBu/nS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeVBu/nS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0106A1F0089B
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791046814;
	bh=U9ZMVNrZ8kuWLvWwJjmRVtLOJDG6JD2xh0bBfqRT3D0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=PeVBu/nS07I0dwqXhisJHhTYsyiIo/W44K7+IeOFzifmWb8nxh2cpxh4PONMxCiXA
	 R2lG8B5hPa3L+KwVnMYJluVM7sSI3VEGkAvhjyMWTs7j11rPRGoywnaCo68HlAR6eS
	 4/XJiL+aNiHTOiOFzj58KvkK20U21n6P3A5jWbVPlIdCwYua1otiFJeij6LZ474pf7
	 Pu8mlpsM02o2FFcyyzP4w2p1dm+h8gr0mfNIEarnrNLv7Q/RgSKVLjWptXp8N+1N0k
	 qw3yd1RNGOpm1a2CIh7lpHmXmnVcs5aMW0pDd5qqEsVynP0wwO41LEoZerrvZeAMxE
	 EsV6wgQm9KYfw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 6/6] btrfs: qgroup: fix off-by-one max level check in qgroup_trace_new_subtree_blocks()
Date: Sat,  3 Oct 2026 18:00:05 +0100
Message-ID: <866f66a876b64f392fd225f0cb291dc8eae0ac7e.1791046651.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1791046651.git.fdmanana@suse.com>
References: <cover.1791046651.git.fdmanana@suse.com>
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

