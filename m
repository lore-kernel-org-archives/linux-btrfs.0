Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7B941D65E
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 11:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784203044; cv=none; b=XPL989lCp9x64H3IRBpt7pPXBP34gPIP2UD/SCRCq/vf/Zmy1+67EDdusa2hGRc8hbIFkh3ysILkaP0KprC0XTDAIxRaTFSRsNYDzfnPB9p68DU2NwtDQBiDaVG6VtrbcgwReXLnSpw0VEYct+CLMSABD2TvVShcTEukOCwSk5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784203044; c=relaxed/simple;
	bh=FINdKRYFegXavfZFnLParpIGsmCB67mZImckioQwYvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsDS2GeKNunrhqiBvNK5bYtvsrPCI2VPtYQrJ9pRQA8ccj3akH+r3KXXCUitk7Ke+BjAIcKwf9B9H3ZXRO7xFT7K7Has8Jd5oLq4bcdgx3VGavyktdYhraOydgcri318638id9LdIqO/Sv11q/5ownyV8m03RZm7rYu3391pHPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gk1iYhQ2; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gk1iYhQ2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784203042; x=1815739042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FINdKRYFegXavfZFnLParpIGsmCB67mZImckioQwYvQ=;
  b=gk1iYhQ2cn83bLEvKeQ0JAkgWIczpc1B10m0GeBFLYoCXh4Bjuj4VI2A
   vrJnVkAHVsmAceyt7z0ZL74sF6wAftbVFQ5YkJHd7TZQOTxRhBhV1wupQ
   JWhOO+d0ZVU03NQzT7ayzU7ru4GexB20kTaqR6CnUwSBj0tgPO2crHlBt
   GANG5fho1OKkqfeUOpFj8vqKOt3axaRXyFsdnw66s5JiDhDrvNfHeqyZt
   w4ykl71P6UAvCIDsVglIgZZaCvDQuK9BXMl3GzfTOKC70J7QplVQ0VeKU
   xvCkXuTAATU/j9KqreQO5rQZGAYflRb//5TUBjGOb+4hjKB+u82jUPWKC
   Q==;
X-CSE-ConnectionGUID: uBYv5AmfSQOybWuXLIqE5A==
X-CSE-MsgGUID: WbXrPjxcSDCmIVsF5ySVUg==
X-IronPort-AV: E=Sophos;i="6.25,167,1779120000"; 
   d="scan'208";a="150860083"
Received: from unknown (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2026 19:57:14 +0800
X-CSE-ConnectionGUID: sLtxjI9sQvCMyEq7j6mX/g==
X-CSE-MsgGUID: RtfYk5DvTZuU2H96hRojVg==
IronPort-SDR: 6a58c710_xQKPiUOShUpvp0FiSgCCxh2G8Az0A4kwAuzK9ayGhdM646e
 e+/4Y2uIMegM4VBqA9CkqqwGkAih6MWIo1VOA5Q==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jul 2026 04:57:04 -0700
X-CSE-ConnectionGUID: pxYV20UjSMqguzb5oE73iw==
X-CSE-MsgGUID: f+s5THV8Teq7WEBJNSaklg==
WDCIronportException: Internal
Received: from wdap-fln31fg1cp.ad.shared (HELO neo.wdc.com) ([10.224.28.153])
  by uls-op-esai1-o.wdc.com with ESMTP; 16 Jul 2026 04:57:03 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/5] btrfs: zoned: drop stale dirty btree buffers at close_ctree()
Date: Thu, 16 Jul 2026 13:56:53 +0200
Message-ID: <20260716115656.1319295-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
References: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a zoned filesystem btrfs_clear_buffer_dirty() keeps a freed-but-dirty
tree block dirty (EXTENT_BUFFER_ZONED_ZEROOUT) so its zero-out keeps the
zone write pointer moving. A block left ahead of the block group's
meta_write_pointer (e.g. a tree-log block freed before being written) can
never be written by btree_writepages() and survives to unmount.

close_ctree() stops the endio workqueues before the final iput() of the
btree inode but frees the block groups only afterwards. Once the block
group is gone btrfs_check_meta_write_pointer() no longer defers the buffer,
so the iput() submits it for writeback; its completion can no longer be
queued on the destroyed endio_meta_workers and umount hangs on writeback
that never finishes.

btrfs_free_block_groups() has to stay after btrfs_stop_all_workers()
(see also commit 5cdd7db6c5c9), so instead drop the dirty state of such
stale buffers in invalidate_and_check_btree_folios(), which still runs
while the workqueues are alive.

Assisted-by: LLM (debugging, commit message)
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/disk-io.c   |  4 ++++
 fs/btrfs/extent_io.c | 12 ++++++++++++
 fs/btrfs/extent_io.h |  1 +
 3 files changed, 17 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index acff40469589..b66525701b33 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3317,6 +3317,10 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
 		if (test_bit(EXTENT_BUFFER_READING, &eb->bflags))
 			wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
 				       TASK_UNINTERRUPTIBLE);
+
+		if (btrfs_is_zoned(fs_info) &&
+		    test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
+			btrfs_clear_stale_buffer_dirty(eb);
 		/*
 		 * The refs threshold is 2, one held by us at the beginning
 		 * of the loop, one for the ownership in the buffer tree.
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4dd8fc5ad247..480d4ec8ca7f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3841,6 +3841,18 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 	__btrfs_clear_buffer_dirty(eb);
 }
 
+/*
+ * Drop the dirty state of a stale, already-freed metadata buffer, bypassing
+ * the zoned EXTENT_BUFFER_ZONED_ZEROOUT deferral of btrfs_clear_buffer_dirty().
+ */
+void btrfs_clear_stale_buffer_dirty(struct extent_buffer *eb)
+{
+	btrfs_tree_lock(eb);
+	clear_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags);
+	__btrfs_clear_buffer_dirty(eb);
+	btrfs_tree_unlock(eb);
+}
+
 void set_extent_buffer_dirty(struct extent_buffer *eb)
 {
 	bool was_dirty;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 869925337699..290d6cff6ddb 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -393,6 +393,7 @@ void extent_clear_unlock_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 				  u32 bits_to_clear, unsigned long page_ops);
 void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *buf);
+void btrfs_clear_stale_buffer_dirty(struct extent_buffer *eb);
 
 static inline void btrfs_clear_folio_dirty_tag(struct folio *folio)
 {
-- 
2.54.0

