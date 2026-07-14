Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D17715E5DC;
	Tue, 14 Jul 2026 09:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022961; cv=none; b=QwfUv/Fgtt4/onJMwv7wrOuE0y9pgItqWVewmwtILpxbEmAl9e4+A6IbUDR/TCwtW2aoxs11E34MCgIdIBKZlxULskllkcuogRBRh1GlnQAjui3N86Wq8sPGaVb7gyAk/vKqVEfGiOvwGXQZCyVObzLFsTBvq9a3IXkFFys1Qzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022961; c=relaxed/simple;
	bh=Czl1a3vjWJkd9UVpn7P3qE6klnHjIGtpIEO0BK4B2zU=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=AvfCh9qP87uyOelLSX2+UiZAtC3BloG8FOIp+LXifG+ojwAwYaYhe6TSookR032QbnqL86UGb4p5iMYewpVF09mkwHVEzpnqJCu/mVnJ0py9ShiIpy/mH8RVjAsW1/Fs/IFQF/CU2y0eW5D5JHUU+vE6iLq96ds6bSqpB7wk20g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=IfUNk7uV; arc=none smtp.client-ip=43.163.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="IfUNk7uV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1784022950; bh=11j/NZ2olRIA3EKe/4buA3yuUuWstguLgmXBdlHlVF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IfUNk7uVg3aYWbU0/y/fbvwVTM0ebG/PQ/hufkimT6SzVGevjiwCelcun6dQFJp0G
	 FtfqNaX656iVO0c/k/pTn10xUo8fGUEpA9WB9kYDFmwQluuUdLveT6+M7IGrryuixd
	 Oq4kxS5k3Y0sHKOzZ52jKc4bqBc+xJHNKQZnMZKU=
Received: from ikun ([2001:250:480c:2501::42d])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id DEF1FC5F; Tue, 14 Jul 2026 17:55:47 +0800
X-QQ-mid: xmsmtpt1784022947t20zeyj3v
Message-ID: <tencent_7498732A1B9E13C552CFF1101E377288C407@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNznwjnRTPwg1G/oinVO/apQqZC2b8zjtDqRUd5KXZtm77jhMeQaRs
	 JZP49wwz3NmbtuFCZ9XVdg2LL3YvG9iS+cdY7PUqhnNUyfZ4jT4RH3csTirgLRVXfoyAjxqoRUde
	 PWkD2n+kJcU1KwO7tlgOp2RmSAISZExaO/Ily910TZrD5SfRXA3DytgSmGLdUS4J7K0lC5kSUNtQ
	 AMH1FAdDeE+6lmtqs3nGNe77K8OteoR9/Mdw5P0di6GzfzPnIRgfqKSC5RJLJ2OPP08WAPrUu4aD
	 n0YG1rFQiHumxeHUcrAGDSdx5xcUebvEqTxOwvEzZenEgFf4BZXfww0k8eseSH8cJZQW7GiRno06
	 G0IwrkS8fvQ/5KBsEOp/cs7we/9xpM4Wxm7MNp+Cw+J65n0YXL9FZ8ihrXuSPJkUJQnYjB2ci9xd
	 Zz8g/vCJyPv+3zu7g2wZA9K2Y0DUASIWoWqhptPvuOUI7rGUKz9/1Wbm+E6pWB7XT1ZTXZA93hF4
	 DR9woy1eSrb8qWnz1AXHex0IB5mQBUU8x6/QJEdtste02PTtPwTe0vbeVPO1IdtvWl3pQv++EWcg
	 wAiGfj8M3P5LuanMfPkCzHV4jwtIkSI5zncQqGIg1rlIJJPpF+b6qkbE5NO2sRRz8E50oo5wrjX4
	 qNdwG4LjzI22D1uKVAJ6JAU94Zg0ikrgSsC8tVIKgJMhXvQlwNycYpHGMigwTZN+z9VyhPhLT1Zw
	 RGjmT0XYcNUJkxl1GuhOAmnmtlJpPzWcxGxBiZRGgKVsMI6mNSKpSnEO7ou2Ynv6tzpnFCVSWw7V
	 7xB1oBtJ+FojUNo1ZdzoktlO9+vrHxdP0ZC4BbdTogJMuSmYz0hqo9J2eCvIdaKf0mrzO5GVCDUC
	 vG3qYAFUgP2DMPS8jz3Kj5cabJRS5zDVIyf5dHzEcv2boCF7ycCOz9bBDpXZdqZpT5T08mWRcRVp
	 TL56AI0DuEsGyFSCOoC7dz2IurO9kG6VxXV4Cj1HAYrb8d7dI/hj35/qo9/EmpqsX1hBSudH8Gcl
	 j4P/Y/R9UqP1U5K6EEyRJS9lMUgNY=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	naohiro.aota@wdc.com,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>,
	stable@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] btrfs: zoned: fix missing chunk metadata reservation
Date: Tue, 14 Jul 2026 17:55:43 +0800
X-OQ-MSGID: <20260714095543.32-1-3497809730@qq.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <tencent_860054603C488A379E3D21126EA610D63108@qq.com>
References: <tencent_860054603C488A379E3D21126EA610D63108@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

reserve_chunk_space() stores the return value of
btrfs_zoned_activate_one_bg() in ret. The helper can return 1 after
successfully activating a block group, but ret is later used to decide
whether to reserve metadata for chunk tree updates.

As a result, successful activation skips btrfs_block_rsv_add() and leaves
trans->chunk_bytes_reserved unchanged. Use a separate variable for the
activation result so positive success does not affect the later
reservation. Keep activation failures in ret instead of returning early so
the function uses the common tail path.

Fixes: b6a98021e401 ("btrfs: zoned: activate necessary block group")
Cc: stable@vger.kernel.org
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
Changes since v1:
- Keep activation failures in ret instead of returning early from
  reserve_chunk_space(), as suggested by Johannes / sashiko.

Testing:
- Targeted zoned null_blk reproducer with 4G host-managed device,
  256MiB zones and zone_max_active=8. The helper returned 1 and
  btrfs_block_rsv_add() reserved 393216 bytes in the reproduced path.
- xfstests was not run because the test host does not have an xfstests
  tree installed.

 fs/btrfs/block-group.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ab76a5173272..8def7abb728f 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4532,25 +4532,29 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 		if (IS_ERR(bg)) {
 			ret = PTR_ERR(bg);
 		} else {
+			int activate_ret;
+
 			/*
 			 * We have a new chunk. We also need to activate it for
 			 * zoned filesystem.
 			 */
-			ret = btrfs_zoned_activate_one_bg(info, true);
-			if (ret < 0)
-				return;
-
-			/*
-			 * If we fail to add the chunk item here, we end up
-			 * trying again at phase 2 of chunk allocation, at
-			 * btrfs_create_pending_block_groups(). So ignore
-			 * any error here. An ENOSPC here could happen, due to
-			 * the cases described at do_chunk_alloc() - the system
-			 * block group we just created was just turned into RO
-			 * mode by a scrub for example, or a running discard
-			 * temporarily removed its free space entries, etc.
-			 */
-			btrfs_chunk_alloc_add_chunk_item(trans, bg);
+			activate_ret = btrfs_zoned_activate_one_bg(info, true);
+			if (activate_ret < 0) {
+				ret = activate_ret;
+			} else {
+				/*
+				 * If we fail to add the chunk item here, we end
+				 * up trying again at phase 2 of chunk allocation,
+				 * at btrfs_create_pending_block_groups(). So
+				 * ignore any error here. An ENOSPC here could
+				 * happen, due to the cases described at
+				 * do_chunk_alloc() - the system block group we
+				 * just created was just turned into RO mode by a
+				 * scrub for example, or a running discard
+				 * temporarily removed its free space entries, etc.
+				 */
+				btrfs_chunk_alloc_add_chunk_item(trans, bg);
+			}
 		}
 	}
 

base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
2.52.0.windows.1

