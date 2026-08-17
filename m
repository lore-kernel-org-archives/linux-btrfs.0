Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B831FECBA;
	Mon, 17 Aug 2026 01:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786931207; cv=none; b=cTap9RJsLJs4w8KDCAOaXyVXXvIPnXLdK2az1ANSxCGsJDA1feVPs7M2HeKWVw+6wZmOjiZhGQ4dDeiOs6hX39AgaiIHmf6na3uHDOj4KHRgACACN2iDI0WGAgz3FGY3vCNTRpq6anHbuvd/0StUUD2IqtxaFAGInwO4acbEPUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786931207; c=relaxed/simple;
	bh=xCalpKfJwppbsjEw142Sk0IZWbTHlPAac+YOCWP48vA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=MiiY+HIGuQiHcixfMEeR+a5yQO24xw9+fggZfbvJnX3iMBn929uPyxxvfAG81MKc7cWSBQ06ppnfQbHoh0bZjf+SHE8oPaCfF/m3qTSFW1Z3Aqt0YDHRZr+R84X3ZLMo3J2JNY+y1uM240aDB7vzFS9+nNxHP1M3CFMjK3BDDwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 7c1ea80c99dd11f19a56ed5b684f684d-20260817
X-CID-CACHE: Type:Local,Time:202608170945+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:b6af0a6c-7b88-4604-8cb2-dac2cff18a14,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:edb4ca3ec98e39d76c197dc47d296679,BulkI
	D:nil,BulkQuantity:0,SF:102|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:n
	il,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LE
	S:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7c1ea80c99dd11f19a56ed5b684f684d-20260817
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2024071357; Mon, 17 Aug 2026 09:46:37 +0800
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
Subject: [PATCH] btrfs: fix use-after-free in mark_block_group_to_copy
Date: Mon, 17 Aug 2026 09:46:33 +0800
Message-Id: <20260817014633.13293-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

mark_block_group_to_copy() iterates over the commit root with
skip_locking=true to avoid lock contention. Without holding
commit_root_sem,a concurrent transaction commit can swap and free
the commit root during iteration, leading to use-after-free when
accessing extent buffers.

The fix adds commit_root_sem locking, but CRITICALLY must only cover the
actual search period (btrfs_for_each_slot), NOT the preceding while loop
which calls btrfs_commit_transaction(). If held during that loop, we get
self-deadlock: down_read(commit_root_sem) → btrfs_commit_transaction()
→ switch_commit_roots() → down_write(commit_root_sem), blocking forever
on our own read lock.

Lock scope:
- down_read() after path setup, before btrfs_for_each_slot
- up_read() immediately after btrfs_for_each_slot completes
- NOT held during while loop (btrfs_commit_transaction) path
- NOT held on the !path error path (goto unlock before lock
  acquisition)

This matches the established btrfs pattern used in send.c, backref.c, etc.:
hold commit_root_sem read lock ONLY while searching commit root, never
across transaction commits.

Fixes: 78ce9fc269af ("btrfs: zoned: mark block groups to copy for device-replace")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 fs/btrfs/dev-replace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index dc0834f920c3..734807bf48b3 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -499,6 +499,7 @@ static int mark_block_group_to_copy(struct btrfs_fs_info *fs_info,
 	key.type = BTRFS_DEV_EXTENT_KEY;
 	key.offset = 0;
 
+	down_read(&fs_info->commit_root_sem);
 	btrfs_for_each_slot(root, &key, &found_key, path, iter_ret) {
 		struct extent_buffer *leaf = path->nodes[0];
 
@@ -525,6 +526,8 @@ static int mark_block_group_to_copy(struct btrfs_fs_info *fs_info,
 	if (iter_ret < 0)
 		ret = iter_ret;
 
+	up_read(&fs_info->commit_root_sem);
+
 	btrfs_free_path(path);
 unlock:
 	mutex_unlock(&fs_info->chunk_mutex);
-- 
2.25.1

