Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC462CCC5;
	Mon, 31 Aug 2026 05:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788154698; cv=none; b=dDQ/YQk7d1OxgkCMrRBYUw9jhxtCBoYGFtvbV51TXvzmJPQWjAmtUhwyC09ShfFGXBaEnC5D8MjffCLmhgSOJGgokSi2yPVIAX16hVJOsW+QarlC4wCYl1CHMhnUmKqHvRsx+rOiiAPppmwW1WN5lehzvawjRv8MAGAI40ePF7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788154698; c=relaxed/simple;
	bh=Xq7lF0JX5Qs6qWwD/tZfn8icxXTNUlJyBtkmCU3HryQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UQyyhbDsi5aSS9hZmFVL1EUB+1/GpufNO1Ok92kfnjdsMT6J3LpmYP4xobc5v5UICnzkMEzDideE8YD4Zsg5UcQXDx3uBLnnMetttDjdct1yh2a8Ihei/RIwanI/q1+lvmy/SduZ7j8WQ2zXNaOIGiwGh+RKSvbWHqoGz6vzhgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2467d1b6a4fe11f19a56ed5b684f684d-20260831
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:f0cf5e45-151a-4fb7-b88d-e2e7752e4859,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:7db8b62,CLOUDID:81a64449fd5c99891e51fe21e071e77a,BulkI
	D:nil,BulkQuantity:0,SF:102|850|865|898,TC:nil,Content:0|15|50,EDM:5,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2467d1b6a4fe11f19a56ed5b684f684d-20260831
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1530979641; Mon, 31 Aug 2026 13:38:06 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: clm@fb.com,
	dsterba@suse.com,
	naohiro.aota@wdc.com,
	josef@toxicpanda.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH RESEND v2] btrfs: fix use-after-free in mark_block_group_to_copy
Date: Mon, 31 Aug 2026 13:38:01 +0800
Message-Id: <20260831053801.51572-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mark_block_group_to_copy() iterates over the commit root with
skip_locking=true. A concurrent transaction commit can swap and free
the commit root during iteration, causing use-after-free when
accessing extent buffers.

Fix by using path->need_commit_sem to protect the commit root search.

Fixes: 78ce9fc269af ("btrfs: zoned: mark block groups to copy for device-replace")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
  - Use path->need_commit_sem instead of manual commit_root_sem locking
    suggested by Qu Wenruo.
  - Remove the unmatched manual up_read().
  - Add LLM usage disclosure
---
 fs/btrfs/dev-replace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index dc0834f920c3..0310aa3add54 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -494,6 +494,7 @@ static int mark_block_group_to_copy(struct btrfs_fs_info *fs_info,
 	path->reada = READA_FORWARD;
 	path->search_commit_root = true;
 	path->skip_locking = true;
+	path->need_commit_sem = true;
 
 	key.objectid = src_dev->devid;
 	key.type = BTRFS_DEV_EXTENT_KEY;
-- 
2.25.1

