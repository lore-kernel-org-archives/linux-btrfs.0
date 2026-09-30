Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141BE4E06CB
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 15:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781611; cv=none; b=j1pySpozvX+zm8ajauqW2Mx8XfmwM8DzewwtwJ3sKuHOi5IRcfjz4iaokAHPnSRlslfqdYsEXvn6SF4hHYrpY5tQwaWyyjL1p/qXEA+7xn5+6OdFsDyKRONdjm/CylYWdyS3+r/hRdUBDptSJcUFjapVwgOn9gWmGWQMcex2b84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781611; c=relaxed/simple;
	bh=An/BNTH6jRWTMVTLVk0lA/eViXEm1br56pQcB6fapwI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=meIj9W02vZHR78lHXVNh1p27La+PRhs6axwJzjiNgIij7CTaH2lzIuKJGKw7Ayn93gYCCUhVlGxFwhnOFeIt2N9gcmKN5Jg7c5yDeykhVtuDi5NRq7o0emf0EEb+ON67YpRyel5RySVgmJGL5qOcAa5YLaVoJx4NlsvOl6hGwdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gO7Aw2tB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gO7Aw2tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A26B1F000FF
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790781601;
	bh=UnV9cIkeG1rn9wvuhKgKOnAC1cBNWR02on4DGwsLELo=;
	h=From:To:Subject:Date;
	b=gO7Aw2tBM3zAi4mD55NIbBb9Bt+zZSxchxy/VOFodgETluM/Uy6olq52gcfW0c8uw
	 Nh0LnnKjV1+pUccl6tQs21uhmUflx0XnC8BeRnvjwvSkU79i8WJwRCZ4SrzbOBQRyK
	 vhObUCECjJJGwzwlxhMwhGlPG1O6nO6ghm5hBS4IivwQYVMd+AynsTiSsemKktTc2v
	 oojJTkSCdAcvjes2Iy/9VKFhrtR4G/VtevntG7AxevklYN/Ygu9209QZyaUSX+IZyJ
	 V12TXHqBmI6yOK2E2J/5+UR0yVuJBG/RlWLx6l9IqwsP3ZmIbEmY6PgNHn9wyzNxA8
	 3kMB+XQCRkrPw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix off-by-one end offset check in report_setget_bounds()
Date: Wed, 30 Sep 2026 16:19:57 +0100
Message-ID: <d424b06da106d3e4bc54416eca428701647e8f08.1790781569.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The addressable range with an extent buffer goes from byte 0 to byte
eb->len - 1, so if a byte address matches eb->len, it's already beyond
the addressable range and we should log that it's bad start address
and not end address.

Fixes: 234fdd2815ce ("btrfs: remove redundant check in up check_setget_bounds")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/accessors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/accessors.c b/fs/btrfs/accessors.c
index 1248aa2535d3..d63ac6eb92de 100644
--- a/fs/btrfs/accessors.c
+++ b/fs/btrfs/accessors.c
@@ -16,7 +16,7 @@ static void __cold report_setget_bounds(const struct extent_buffer *eb,
 
 	btrfs_warn(eb->fs_info,
 		   "bad eb member %s: ptr 0x%lx start %llu member offset %lu size %d",
-		   (member_offset > eb->len ? "start" : "end"),
+		   (member_offset >= eb->len ? "start" : "end"),
 		   (unsigned long)ptr, eb->start, member_offset, size);
 }
 
-- 
2.47.2

