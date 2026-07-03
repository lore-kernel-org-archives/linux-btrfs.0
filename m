Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E9435E1B7;
	Fri,  3 Jul 2026 05:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783058110; cv=none; b=WUmu/A7/eiIfz1Y8tx08PZttQjcnZ6xQmBL52v9vF5hSW/1FnSOUAG/oC0XES2m3wiC66EUxIu3FvMhAtr+rBVxa1mn4jdHXbmug/QzfnYxbMGb5DL13mEhCsdrkRtJFy790nu43cVaElmh0+BaUyDSMkQlqs5z2bjmqJTAK7zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783058110; c=relaxed/simple;
	bh=HZ940njk/imdBMAxkHL70w+s5951Eaq4ctiR93S50Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=juLWj+FTt8ppcIZ4iGPqgmYqrlDOsVSBjCZvm2yV4vioLr1+WZbb9uSW1neT2y7U0nQTiAWPiabtX+OGnA6fIqjCRDv57cFGTDl5YYGOQkVPnrhgKhRGo9F7QQa04kVmuD057jxC713wmFuBqVddCMleExbWEJv05URfnXyoyec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=aoIS4pIZ; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aoIS4pIZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783058108; x=1814594108;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HZ940njk/imdBMAxkHL70w+s5951Eaq4ctiR93S50Bk=;
  b=aoIS4pIZbIAGrOLt6Ra9iT9TFc3cRQsvoygPOicNa0LZRAD657rOCvp7
   aABKy/9SbUHm2+UR+umVcaq0RHoEBeQcjSB5eWlleEdoxEBDWMJUFtNE+
   ixeJroML7HjTCCIV37jYp7cRfKat6mGqgtUfzThm2xJ8UPXSLOfQsCUV1
   VzthbjKQxCfEfBHyPz8M2BAjxa8EkojG97/Be6xXwEX2mG6YzatQ5bT+L
   Yxpq3c5OlQG/v4wJZX5Zve7qHdxePFWD5il8OR9xyMmC+DhnvPNtn5W0E
   Eao3b86l7Q1ZcndVndTIWOxklIBXSgyj7P/OmtqKpMNvg7CTNhAoFJAD3
   g==;
X-CSE-ConnectionGUID: mZf18FFeRHyN42qTdnLWbA==
X-CSE-MsgGUID: PVi8hKpSTeW1uw0svizDNQ==
X-IronPort-AV: E=Sophos;i="6.25,145,1779120000"; 
   d="scan'208";a="151204827"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2026 13:55:00 +0800
X-CSE-ConnectionGUID: Xm0Uw8uaSGO8b71cx3oK1Q==
X-CSE-MsgGUID: qexn4wrGR/uwBl1YXk3QKA==
IronPort-SDR: 6a474ea4_19aiTuAvlWVyiWi2dV6ffw4ttlldeUvGaIgBdqSEhJYtXcM
 wJ5OgoQqdbR8fGj6KMUnkip4Y1s9Vx5WYyuEkTQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Jul 2026 22:54:43 -0700
X-CSE-ConnectionGUID: OcxMWKp2TeqCXvdGWAFMwA==
X-CSE-MsgGUID: BU7BFkHcQbOXah8660fx5A==
WDCIronportException: Internal
Received: from c02g32sfmd6m.ad.shared (HELO neo.wdc.com) ([10.224.28.132])
  by uls-op-esai1-o.wdc.com with ESMTP; 02 Jul 2026 22:54:43 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: zoned: fix deadlock between metadata writeback and transaction commit
Date: Fri,  3 Jul 2026 07:54:40 +0200
Message-ID: <20260703055440.117200-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When writing out metadata extent buffers in a zoned filesystem,
btree_writepages() holds fs_info->zoned_meta_io_lock across the whole
writeback loop, including the call to btrfs_check_meta_write_pointer() ->
check_bg_is_active().

For the tree-log block group, check_bg_is_active() may fail to activate
the zone and fall back to btrfs_zone_finish_one_bg() to free an active
zone. That path waits for the running transaction to commit while still
holding zoned_meta_io_lock, but the committer needs that same lock to
write out the tree extents, so the two tasks deadlock:

  Task A (kworker, metadata writeback)      Task B (fsstress, transaction commit)
  ------------------------------------      -------------------------------------
  wb_workfn()                               btrfs_commit_transaction(T)
   btree_writepages()                        btrfs_write_and_wait_transaction()
    btrfs_zoned_meta_io_lock()                btrfs_write_marked_extents()
    btrfs_check_meta_write_pointer()           btree_writepages()
     check_bg_is_active() [treelog_bg]          btrfs_zoned_meta_io_lock()
      btrfs_zone_finish_one_bg()               <blocks on zoned_meta_io_lock,
       btrfs_zone_finish()                      held by Task A>
        do_zone_finish()
         btrfs_inc_block_group_ro()
          btrfs_wait_for_commit()
           <blocks waiting for commit
            of transaction T, done by
            Task B>

The sibling branch in check_bg_is_active() already drops zoned_meta_io_lock
around do_zone_finish() for this exact reason. Do the same in the tree-log
branch: release the lock around btrfs_zone_finish_one_bg() and re-acquire
it afterwards. The lock only protects fs_info->active_{meta,system}_bg,
which this branch does not touch, and ctx->zoned_bg keeps a reference to
the block group across the unlock, so nothing is lost while the lock
is dropped.

This hang occasionally reproduces with fstests generic/475 on a zoned
btrfs filesystem.

Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 97f06dd01693..44a13ed6b8b2 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2190,7 +2190,11 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 
 	if (fs_info->treelog_bg == block_group->start) {
 		if (!btrfs_zone_activate(block_group)) {
-			int ret_fin = btrfs_zone_finish_one_bg(fs_info);
+			int ret_fin;
+
+			btrfs_zoned_meta_io_unlock(fs_info);
+			ret_fin = btrfs_zone_finish_one_bg(fs_info);
+			btrfs_zoned_meta_io_lock(fs_info);
 
 			if (ret_fin != 1 || !btrfs_zone_activate(block_group))
 				return false;
-- 
2.54.0

