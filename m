Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9805A35DA47;
	Fri,  3 Jul 2026 05:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783058109; cv=none; b=avoOPq6/f7fx/4Tfr7DDySi5zfROWS6YQq+8lQVtn2jy9mSCBEFcY6x5tRMoR8RrJW3Hp+ytH4/AlRTUfPOjAax6ge9fKn0KCEbiREqHSO0dwhwbkB2dpyrQkCHNlVMX6ljaRScZIqI4rFaijRNrxcoCgjv+QGWHXJM9qxQiIdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783058109; c=relaxed/simple;
	bh=IfqVpGyPaL/hIOC4xZ3LLuQMyCpwwmV4T/tArhLCz5I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kCKu8PaezX2FICnoMMwji9NrswF9UzUgR+i4M9UkTVrH8Pu343ph1hueFaA/i4LB/Qk9D5AaKaJmy9F/PCSUy4nlXODg65WtRcKsI5+zyyshL/wXIO8J9Qr/JuR4zfJQH5C7tyqs5Rba/qO8WUKJuiRPDgGc3gDKJl5LnHUOi0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=K9O/8Tum; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="K9O/8Tum"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783058107; x=1814594107;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IfqVpGyPaL/hIOC4xZ3LLuQMyCpwwmV4T/tArhLCz5I=;
  b=K9O/8TumLr6Gg53N40jTcvt/BuMtOMfXaT04g+OhKWka9G1FwRyUHl37
   hdK7oShu3OWIySutTmGgPJOPdVAz14//IUx+7CQiaLv4SOaIuDcLgKPU9
   m91wzpdtvc58Ofx918h2E0X+dnAFwaheyUkahsgigbmlqj9x2kbYzNmOe
   7I3ZUdBNyBJlPUd8u2yVrFkfsBlFaC2RKs4DtmkTudIPPWL/e2jXJTYdv
   j8u09jNzXMDP741eN/c3al82b5Q7l8ApDXJiFQrHlPkxcmrLg8luupYg4
   0XFlUtpWucM5uU9IPp3KCDqPZTXgr96tuqMjloYEBtcyLG2RzppPzv7Rp
   Q==;
X-CSE-ConnectionGUID: VBRT9IrwRj68FSdxtvKvPA==
X-CSE-MsgGUID: XZlCdEzbS9mluFniIqNiYA==
X-IronPort-AV: E=Sophos;i="6.25,145,1779120000"; 
   d="scan'208";a="151204826"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2026 13:55:00 +0800
X-CSE-ConnectionGUID: fvSo9rs/R7GLYznw0O3KCA==
X-CSE-MsgGUID: VK3c4DKRQQ+qSkG6HCzuRA==
IronPort-SDR: 6a474e9f_g4Uxf2QoAYQnA+dLk6L/G4rxlFu8t4E9JOKCJd5grMJ2v7s
 q2vHMics9Hz0EglI9DOnYeQuNmqcYYMyKdaCouQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Jul 2026 22:54:38 -0700
X-CSE-ConnectionGUID: bq3cUPlASg+YILR45vb9UQ==
X-CSE-MsgGUID: wgRBIiq8SPu77AF5fjIbhw==
WDCIronportException: Internal
Received: from c02g32sfmd6m.ad.shared (HELO neo.wdc.com) ([10.224.28.132])
  by uls-op-esai1-o.wdc.com with ESMTP; 02 Jul 2026 22:54:38 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: zoned: don't submit orphaned extent buffers
Date: Fri,  3 Jul 2026 07:54:31 +0200
Message-ID: <20260703055431.117181-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a zoned filesystem btree_writepages() can encounter a dirty metadata
extent buffer whose block group no longer exists. Submitting a write for
such a buffer maps it to a stale/removed block-group and leaves the folio
under writeback forever, hanging later in filemap_fdatawait_range(), for
example the iput(btree_inode) in close_ctree(), which then hangs unmount.

This is caused by btrfs_clear_buffer_dirty() not clearing the dirty bit of
a freed tree block but it sets EXTENT_BUFFER_ZONED_ZEROOUT and keeps the
buffer dirty so that it is still written out to keep the zone's
meta_write_pointer advancing sequentially. So a freed metadata block
legitimately stays dirty until that zero-write completes.

Dropping these buffers is safe: the block group is empty, so they are
stale, unreferenced, already-freed blocks. Once the zone is reset their
zero-write is unneeded. Instead of submitting a such a write, finish the
writeback immediately.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: 7db94301a980 ("btrfs: zoned: introduce block group context to btrfs_eb_write_context")
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0edd532174fa..4a029ae719e9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2280,7 +2280,8 @@ static void prepare_eb_write(struct extent_buffer *eb)
 }
 
 static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
-					    struct writeback_control *wbc)
+					    struct writeback_control *wbc,
+					    bool submit)
 {
 	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_bio *bbio;
@@ -2310,6 +2311,12 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
 		wbc_account_cgroup_owner(wbc, folio, range_len);
 		folio_unlock(folio);
 	}
+
+	if (!submit) {
+		btrfs_bio_end_io(bbio, BLK_STS_OK);
+		return;
+	}
+
 	/*
 	 * If the fs is already in error status, do not submit any writeback
 	 * but immediately finish it.
@@ -2397,6 +2404,8 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		struct extent_buffer *eb;
 
 		while ((eb = eb_batch_next(&batch)) != NULL) {
+			bool submit = true;
+
 			ctx.eb = eb;
 
 			ret = btrfs_check_meta_write_pointer(eb->fs_info, &ctx);
@@ -2411,6 +2420,9 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 				continue;
 			}
 
+			if (btrfs_is_zoned(fs_info) && !ctx.zoned_bg)
+				submit = false;
+
 			if (!lock_extent_buffer_for_io(eb, wbc))
 				continue;
 
@@ -2420,7 +2432,7 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 				btrfs_schedule_zone_finish_bg(ctx.zoned_bg, eb);
 				ctx.zoned_bg->meta_write_pointer += eb->len;
 			}
-			write_one_eb(eb, wbc);
+			write_one_eb(eb, wbc, submit);
 		}
 		nr_to_write_done = (wbc->nr_to_write <= 0);
 		eb_batch_release(&batch);
-- 
2.54.0

