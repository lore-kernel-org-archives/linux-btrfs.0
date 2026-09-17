Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7664B8289
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 10:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789642764; cv=none; b=oeOqHV5/P5OCRiD0SgXObJvxWIKuENaQBaau/mau0ffxe0Qy4J6WI5T7JADkuPqZrPFHfy1AsnwXc4oOaXroTOdlRCHHYhda/A582XgeXm2viJpCsM2sQtXOjiInOv93t1orPvPKC6AglLlwJTKJ3FW8hfY2LPPeId2rm/64nCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789642764; c=relaxed/simple;
	bh=W1gS5Wjb83sZcS/FEVYEvkcsNWu667nfL2FXiWA4Usg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=aohR0ENIK/ybQIcXlOJwZCR/baGINDXHfG6QH5UkLpw5DRh6CN2VSpaxQ9DKIuSNd4ND/w9u4lc0II/7XiDcragwSG5bZCqeKITpN2JjJ8RXrqq0WthG6N/H6/fIKXcj7aS+IHb9o1Bpr5eKhQ4Oy46EUY6Ri93rIVkIAFNpjsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TETZRbmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TETZRbmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C6C1F00893
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 10:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789642752;
	bh=pKK0zMWwSWSlAhS7zlQD/ZgmMHIoujlvompuKqvYciw=;
	h=From:To:Subject:Date;
	b=TETZRbmRQhbwlcJZDl9BsOSA45/9EsOam+LXm4r7hlSryE4JYXrJCNFhlwFs0s3uq
	 zFmoRAPXQ2RLXaNieOxEebcWT4dcZaoTQUFOoQVwz2jqBNyDuKnFrhjO09KS59GZLv
	 st8LeGY74edh9dpE2GNvBMkGxnVhlElZaWiejPYVrARp+wGAkVNwqiRd/J1qT0xD7+
	 LTcPrucjsrOIDR7/w35sFmn/OepuS+Hi1+1DvFmtPEmEyjLaVizV/oI+YVt+teEs3+
	 Syblbv3Xnd50mlb44QgOIPXUKUhr0XLsXsEzEJPO1+pwFbtEerjuwM4QjVwo6SxF6f
	 /HYZcONKNlQNQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix off by one super block end offset calculation in write_dev_supers()
Date: Thu, 17 Sep 2026 11:59:09 +0100
Message-ID: <c5e7ed76826ca4504f5b0bb7de9f5f2e45365143.1789642741.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We are skipping the write of a super block mirror if its end offset
matches exactly the device's end offset. This happens because we are using
a greater than or equals comparison instead of just a greater than
comparison.

Fixes: 935e5cc935bc ("Btrfs: fix wrong disk size when writing super blocks")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a8535e309b57..619a49a55783 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3909,8 +3909,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			atomic_inc(&device->sb_write_errors);
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		btrfs_set_super_bytenr(sb, bytenr_orig);
-- 
2.47.2

