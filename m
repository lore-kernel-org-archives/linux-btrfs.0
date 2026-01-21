Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AC14963C2
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013064; cv=none; b=kTptVIu6ZpWXC0kpnw+0iRqX7/lH6TLbmOTChq/YYTHfFIIDS1xljgr8vCA4Bn/MAC6w5W5/a/JQA8twnuj4aWIVy3/fDrURnAWM93cRGPKns93spsUAM3FaZ6d2xmND5xn5BlxtuGsb5peSalMs3dcru8Go4BRippIykRORdTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013064; c=relaxed/simple;
	bh=4M+9R5CziadNALs948lx2cTnTC0LKbQM7m4OnXn1Qe4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMexYZQ3a18O1lQnnftbbyT/izGDguSBQoyKgvPwgXUq1miBPHnF1YYAXixhTn6NhH7bb3CLki3ixGsPrHNbFkQ6gziVcbHBPmksM4zyXuY4xhQ6OA+XDP3KQPbDG1rjqP0bq1x2uZ3xu0t/zFcQMHB3KOncDeoEdSEuPYqYg2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDNuBvF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDNuBvF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4E7C116D0
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769013064;
	bh=4M+9R5CziadNALs948lx2cTnTC0LKbQM7m4OnXn1Qe4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZDNuBvF+mTn8+mkxbEKVwvFjMfibzazzks5DNz5gRks+jWumnyWLSplS1SybzdyY6
	 Qh0xHPJnvFKJzhOPkL4euyAba1Ci+MBSzCvd2aYPRBkoJgImMxMPWYLD+o/hC19qs6
	 YYgdelWFdCbAZlA19KLkpqO+956IBRfmwe5Fe7sB9Aow75BaNGcREyNZWGWFzkz+Dp
	 TmZVu14hhhP2gl6o9vG/KKatOyvlxd98UZJ1lsiaGvoGYgxekQLVnooxohilBpn7+r
	 eWqQOaj8Oz5ke803L+h+YW/u26cOyWhqLlXK5/50HiBfOsH5L5SoMWK8RejbHnbM7R
	 VyrlhdpY0lLeA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 17/19] btrfs: remove out label in btrfs_check_rw_degradable()
Date: Wed, 21 Jan 2026 16:30:43 +0000
Message-ID: <7bb366396aabb116d58ed9809e7f6943aaa0ee3c.1769012877.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1769012876.git.fdmanana@suse.com>
References: <cover.1769012876.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There is no point in having the label since all it does is return the
value in the 'ret' variable. Instead make every goto return directly
and remove the label.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index af0197b242a7..cff2412bc879 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7576,10 +7576,9 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
 
 	map = btrfs_find_chunk_map(fs_info, 0, U64_MAX);
 	/* No chunk at all? Return false anyway */
-	if (!map) {
-		ret = false;
-		goto out;
-	}
+	if (!map)
+		return false;
+
 	while (map) {
 		int missing = 0;
 		int max_tolerated;
@@ -7604,15 +7603,14 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
 	"chunk %llu missing %d devices, max tolerance is %d for writable mount",
 				   map->start, missing, max_tolerated);
 			btrfs_free_chunk_map(map);
-			ret = false;
-			goto out;
+			return false;
 		}
 		next_start = map->start + map->chunk_len;
 		btrfs_free_chunk_map(map);
 
 		map = btrfs_find_chunk_map(fs_info, next_start, U64_MAX - next_start);
 	}
-out:
+
 	return ret;
 }
 
-- 
2.47.2

