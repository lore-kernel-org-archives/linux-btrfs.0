Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE98841F7FE
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jul 2026 11:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783338255; cv=none; b=oLHsI44qgdIyBY+a8HVYQq9MSCdvEHLq6J1QDWdYcQIIuVGp+1Paq0KnfK6r7MfvxdeOdSKyWi/bO/iIRLmfx2Znpu2emiXg/ReE8piMyTpMMXtCeo5MOoItIi7gN6aPCrwe5rBEl6GRqe2coRJHxEb2Qlam/msV8esUQ8puags=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783338255; c=relaxed/simple;
	bh=MsSnMTk0vl41A3jDPdx+DWfFthrj6tmL2uzp6HSbw0o=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=gc9HOVDs2rFLWgWA4h7113h2FEa0t/cENBwO14/eV+mD5B5IaFrKL4fEqxNTWyYG7cHNeCOa9f2+0WMquptcvUTLmXM3AlizKkl3l1SWcEig5iDbSaPJbRZOzIzVOlfYkrfLpBHdaU7kcRe76XCysoLP2kzNEs/Z9VrvAzq0564=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nl9sd2KC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nl9sd2KC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D421F000E9
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jul 2026 11:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783338253;
	bh=xuw+LGqMIyYvLChcqyiv4HPj8vhaW96PARHWgEwnW1Q=;
	h=From:To:Subject:Date;
	b=Nl9sd2KCEnJ4LfHuLAE7GOrWpTzV9W116WUXd/195WoYYrEZxY4f0tSW84NASxEbz
	 ntJpAGF/Tpy2tuBIdB1GqT3xcV9FNjD10PP0w67jm57UHvKQY8HMl1CeGz2bOaRcK0
	 IWL+6/9g16c+VV+RGk295yNdey02xnfj9HRkE2EANitpkqBFq2bjh5N97Wx0niKa4/
	 nr4MF/XYpYgz6CiPP8WhmUOaVzYXzn43vkOSQMM8WwZUkSuuQfPdTrlJhXp+3gL8R4
	 aKF097HpfC2UQw3drgrYIP29clR2sJh4US+oG/Z1y1nxzUXZFcg6tD2idWVQMRU4Yy
	 KIAM6AqGhcS8w==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: get rid of useless label in btrfs_create_dio_extent()
Date: Mon,  6 Jul 2026 12:44:09 +0100
Message-ID: <74bcf9563b76639f84210fb5ee006d5a865280c0.1783338152.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no point in having a label where under it we do nothing but return
a variable. So remove it and directly return where we used to goto.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/direct-io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 27d227f5bdc0..ed1779ccb4de 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -150,7 +150,7 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 	if (type != BTRFS_ORDERED_NOCOW) {
 		em = btrfs_create_io_em(inode, start, file_extent, type);
 		if (IS_ERR(em))
-			goto out;
+			return em;
 	}
 
 	ordered = btrfs_alloc_ordered_extent(inode, start, file_extent,
@@ -167,7 +167,6 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 		ASSERT(!dio_data->ordered);
 		dio_data->ordered = ordered;
 	}
- out:
 
 	return em;
 }
-- 
2.47.2

