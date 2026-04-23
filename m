Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0652D3A60
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 11:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776944297; cv=none; b=Q3P8EwJshLWfHFschiARtrsbMpg43Dt9k0BXP/1pyJ5yFr4cvQ42nuvFva9GNINtnaqxXv2gqBAIVZnsEjiFnLJfu/ac+ph9E9dSjrFkZT/8MrHo4x8IGj9imFnGyU8h7n3TKqp0yidqLQwLkY05M2B7Vpa7debwHjWFhPtuHWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776944297; c=relaxed/simple;
	bh=CD+ouLdq7HvcUoG4v5/8/C0Xe9PMQ+nGgLhMrF9CdZY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PvvfKWg3T5oEN9aAboMN0ahqQ2L9+dMbmRQtaYOZXJZDuzhSathc3GcgI3Pd09MWBwMYAsJXs0Fcaj6CVyIb4Q999pEleP513oI0FU5H/AeJFRf/F5OUgu+Gb6C9ZE4nPpVB3EGhJLgqvIjcDf1CXUVr/CNHWR2U1ZyBx5ZcYBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iyCIAnZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iyCIAnZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B494BC2BCAF
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 11:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776944296;
	bh=CD+ouLdq7HvcUoG4v5/8/C0Xe9PMQ+nGgLhMrF9CdZY=;
	h=From:To:Subject:Date:From;
	b=iyCIAnZAL8R2L2l97k1Ujd8Zrz0P7xZ3zLQ6Wla+67iNfq3L+byRWdyQl7nxVqiX2
	 i9J5xeu4dsN9x4rb08yHLDlV93OQiNEUj47uc4iWlir39qVIqWF0IDZj5uKc434pFx
	 bPWAapyZ0dpHhoau7Yqve6ReZZe/A3KDvN/j+SmGJJ8338kuoHLefiwpjrQwvSRsHH
	 GFZuGgXNhMLep2k56hRJblaU2ZTagV5FGp9PXmGqPzQEbgvOLKRGQOEuEGL3UvXNS7
	 jC7ZeaGFQ1jjSNMnyAFy/5NXxs9cm+FgpGyQ5yDZT/vqvLddbk3OtN98KkTSAeNn1d
	 aAswprdDlIwMg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: collapse report_eb_range() into its single caller
Date: Thu, 23 Apr 2026 12:38:13 +0100
Message-ID: <b2dc0f485fc063e2b666e150002f59a278b97023.1776944252.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no point in having this static function since it's too short and
it has a single caller (check_eb_range()), so move its code into the
caller and remove it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent_io.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6a6d98eec787..2b0aec031a9a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3976,17 +3976,6 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int mirror_num,
 	return 0;
 }
 
-static bool report_eb_range(const struct extent_buffer *eb, unsigned long start,
-			    unsigned long len)
-{
-	btrfs_warn(eb->fs_info,
-		"access to eb bytenr %llu len %u out of range start %lu len %lu",
-		eb->start, eb->len, start, len);
-	DEBUG_WARN();
-
-	return true;
-}
-
 /*
  * Check if the [start, start + len) range is valid before reading/writing
  * the eb.
@@ -4000,8 +3989,13 @@ static inline int check_eb_range(const struct extent_buffer *eb,
 	unsigned long offset;
 
 	/* start, start + len should not go beyond eb->len nor overflow */
-	if (unlikely(check_add_overflow(start, len, &offset) || offset > eb->len))
-		return report_eb_range(eb, start, len);
+	if (unlikely(check_add_overflow(start, len, &offset) || offset > eb->len)) {
+		btrfs_warn(eb->fs_info,
+		   "access to eb bytenr %llu len %u out of range start %lu len %lu",
+			   eb->start, eb->len, start, len);
+		DEBUG_WARN();
+		return true;
+	}
 
 	return false;
 }
-- 
2.47.2

