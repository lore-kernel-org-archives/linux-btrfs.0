Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4EF41A916
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 11:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784203045; cv=none; b=SEB7PlFF/2B5l01usQ8jKYRX0o+SAifXYUejJjKSctzfXjMCuozwjEJwGHQZCuClvJheR3fVzhwyC1ScUuJfiJmWIxQ+wagZp8i3v44cBhfJ2MvGDX680fJokwBsfsTofBVz+edNnjldiMSowLtDHyLNoz2v426jVcq8KgPAKF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784203045; c=relaxed/simple;
	bh=rHtHxD0Ocl7ZmYTDn3Ys2R6h16khMzUCBEr2ZHMsMWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnQIOwJo0SSiqQ5ycco9H9w2SDRxqpFRcGcRvaOa0VKbDo7DkXbj8yYOvZo172NXnIWPSDvIre+rfY6c8sNk1VCPqFC32+mzQmxqBsJwijDFaNMjA8wPqafnaMWtjIW7S5QzzmlAiZVmQ8ofHe4Ei0vmS97xGgG5vkKWQLLfqpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fZgSHSUQ; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fZgSHSUQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784203043; x=1815739043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rHtHxD0Ocl7ZmYTDn3Ys2R6h16khMzUCBEr2ZHMsMWE=;
  b=fZgSHSUQkbiHMwRoIabjUFUMnmUupKFQihTTQAbEuUBtP2IkjSu1rEJf
   bgkOELmWxaLYPzj5p3sYomGUf2KRU3J5pTuimi6g3n3ERbKX/ZdDFvK8T
   hi64BjCAXKvasLR6v7PomY1JZjvfZijpuvr9h5Ge+g2UwCG0wkNwa1fi/
   uReX2+nZN7LXfVVl+Z9bUsfApnc7l+ishqSs1bO7erveRxq1rF9RYAy6E
   jYFQUsNf78VYYxmOCrbiJf3zo7dZx1vArNbB41iENjToAT9N1rRkNU27R
   UHxZyQlIMx9zl0G3DzmFYu0ZqCnQexInEdwkNwLNE699Toq7gESD30K+O
   g==;
X-CSE-ConnectionGUID: T/k9yEPoRdGrnDPgsR+Xsg==
X-CSE-MsgGUID: xPwM+42IQNSiScDjDs1rfA==
X-IronPort-AV: E=Sophos;i="6.25,167,1779120000"; 
   d="scan'208";a="150860085"
Received: from unknown (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2026 19:57:14 +0800
X-CSE-ConnectionGUID: 1d4cojSWS7S2/XP8dLocyw==
X-CSE-MsgGUID: Bc5gJ3wwQO++jfZfRV6H4A==
IronPort-SDR: 6a58c712_ih2FL0/yQfDgTbDLa2yNq3rc1TxDjg6Cjc9KYx1tSYUdfV6
 Y46FxUdjl4M2goEWeoLRC1tEz0P+y+64/wK2qRw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jul 2026 04:57:06 -0700
X-CSE-ConnectionGUID: G/9vLAYhSo2kHocAsJAGOQ==
X-CSE-MsgGUID: OaiQFpn2S0+3SDwgJOfg1Q==
WDCIronportException: Internal
Received: from wdap-fln31fg1cp.ad.shared (HELO neo.wdc.com) ([10.224.28.153])
  by uls-op-esai1-o.wdc.com with ESMTP; 16 Jul 2026 04:57:05 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 3/5] btrfs: walk waited ordered extents in place
Date: Thu, 16 Jul 2026 13:56:54 +0200
Message-ID: <20260716115656.1319295-4-johannes.thumshirn@wdc.com>
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

btrfs_wait_ordered_extents() splices root->ordered_extents onto a private
list while it flushes and waits, making the ordered extents temporarily
invisible on the root. Walk the list in place instead, moving each entry to
the tail as it is processed and guarding against re-queueing with the new
BTRFS_ORDERED_FLUSHING flag.

No functional change for current callers; this lets a future lock-free
waiter observe all in-flight ordered extents.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/ordered-data.c | 35 +++++++++++++++++++++--------------
 fs/btrfs/ordered-data.h |  2 ++
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index b32d4eabe0ab..11aa7e8efe04 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -751,6 +751,13 @@ static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
 	complete(&ordered->completion);
 }
 
+static bool ordered_in_range(const struct btrfs_ordered_extent *ordered,
+			     u64 range_start, u64 range_end)
+{
+	return !(range_end <= ordered->disk_bytenr ||
+		 ordered->disk_bytenr + ordered->disk_num_bytes <= range_start);
+}
+
 /*
  * Wait for all the ordered extents in a root. Use @bg as range or do whole
  * range if it's NULL.
@@ -759,13 +766,12 @@ u64 btrfs_wait_ordered_extents(struct btrfs_root *root, u64 nr,
 			       const struct btrfs_block_group *bg)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	LIST_HEAD(splice);
-	LIST_HEAD(skipped);
 	LIST_HEAD(works);
 	struct btrfs_ordered_extent *ordered, *next;
 	u64 count = 0;
 	u64 range_start, range_len;
 	u64 range_end;
+	u64 remaining;
 
 	if (bg) {
 		range_start = bg->start;
@@ -778,20 +784,22 @@ u64 btrfs_wait_ordered_extents(struct btrfs_root *root, u64 nr,
 
 	mutex_lock(&root->ordered_extent_mutex);
 	spin_lock(&root->ordered_extent_lock);
-	list_splice_init(&root->ordered_extents, &splice);
-	while (!list_empty(&splice) && nr) {
-		ordered = list_first_entry(&splice, struct btrfs_ordered_extent,
+	remaining = root->nr_ordered_extents;
+	while (remaining && nr && !list_empty(&root->ordered_extents)) {
+		remaining--;
+		ordered = list_first_entry(&root->ordered_extents,
+					   struct btrfs_ordered_extent,
 					   root_extent_list);
+		list_move_tail(&ordered->root_extent_list,
+			       &root->ordered_extents);
 
-		if (range_end <= ordered->disk_bytenr ||
-		    ordered->disk_bytenr + ordered->disk_num_bytes <= range_start) {
-			list_move_tail(&ordered->root_extent_list, &skipped);
-			cond_resched_lock(&root->ordered_extent_lock);
+		if (!ordered_in_range(ordered, range_start, range_end))
+			continue;
+
+		/* Already queued to 'works' by this call, skip on revisit. */
+		if (test_and_set_bit(BTRFS_ORDERED_FLUSHING, &ordered->flags))
 			continue;
-		}
 
-		list_move_tail(&ordered->root_extent_list,
-			       &root->ordered_extents);
 		refcount_inc(&ordered->refs);
 		spin_unlock(&root->ordered_extent_lock);
 
@@ -806,13 +814,12 @@ u64 btrfs_wait_ordered_extents(struct btrfs_root *root, u64 nr,
 		count++;
 		spin_lock(&root->ordered_extent_lock);
 	}
-	list_splice_tail(&skipped, &root->ordered_extents);
-	list_splice_tail(&splice, &root->ordered_extents);
 	spin_unlock(&root->ordered_extent_lock);
 
 	list_for_each_entry_safe(ordered, next, &works, work_list) {
 		list_del_init(&ordered->work_list);
 		wait_for_completion(&ordered->completion);
+		clear_bit(BTRFS_ORDERED_FLUSHING, &ordered->flags);
 		btrfs_put_ordered_extent(ordered);
 		cond_resched();
 	}
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 8d5d5ba1e02f..f4d0675bb9c3 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -63,6 +63,8 @@ enum {
 	BTRFS_ORDERED_LOGGED_CSUM,
 	/* We wait for this extent to complete in the current transaction. */
 	BTRFS_ORDERED_PENDING,
+	/* Flush work is queued by btrfs_wait_ordered_extents(), avoid requeue. */
+	BTRFS_ORDERED_FLUSHING,
 
 	/*
 	 * Different types for ordered extents, one and only one of these types
-- 
2.54.0

