Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6513D5C26
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 08:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190239; cv=none; b=AvvDy3z3970WZssI1BkPwjJmzC9XfV93Ka0sy9XT92nVyYX1b4+j3FS0J29wTeTY5lpyAhVOpQCEFpKvbYFqNJ7/Szx/4ZLiXPkkKeGcYOmDQ0JvfkQLJgbH2zCK8thTm494/RwO1pbQmGYx6cfSihlueMpdHtjD75168z4tC4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190239; c=relaxed/simple;
	bh=PlWmyqM7XH+REIKazO8bSAVU6DjpktirZp9TUMiyr3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P1koMx7VcdiEPV8b+5VgbV3jIMOsLNYLxNTYpuTldn6jKmXFz0Mz18gU7iDo4oV8chkAPzO5ACR9ncsE2TXIKFCFYnqFFru6LFWybcN8xtRUrtwqH/7gBDQswPDQAqe93/fmMAgfFL7tPNEK9Kl863e9ROvBV7lepIkh8H+/QoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ArqXHJIe; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ArqXHJIe"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784190236; x=1815726236;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PlWmyqM7XH+REIKazO8bSAVU6DjpktirZp9TUMiyr3w=;
  b=ArqXHJIeuaW/spb7oU/BCgyHCB6GAW2USCOUtU7YInYpih5RFk4UxL7M
   vclcqPcUwaIHpWLwsTLLw5M/vId9fmomW9+vdHRPpXUV9MMRKA4RGagpP
   pQDP8HZp7SJ++PA1rWwVVPNXUDszQjnEyw4Qdvj5VP0JuzzjP6Lq22AnH
   tAzMm4QM6Y5Znt1/XrmX1Q8i18HufSQeksLfN9laT44w4rfeEIqmkzkn1
   AGwz4nR4wC3bLdZUhSleRgA5ht367ocPGhvg3dF78DGxQwIbACFN9cY4/
   P22NiqrLjrHarzZbjlgnQ0jAnpbT/0avtzeAxCsTOkBGhmL+kSos75xJZ
   A==;
X-CSE-ConnectionGUID: hqIlgHUfSUej8wFq2bdfWw==
X-CSE-MsgGUID: YLiYFf3LRkKM2njiazXMog==
X-IronPort-AV: E=Sophos;i="6.25,167,1779120000"; 
   d="scan'208";a="151140665"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2026 16:23:54 +0800
X-CSE-ConnectionGUID: fAVNzM9lS1uheb880xwmrA==
X-CSE-MsgGUID: SLTzNlDUTiSDTsSdh7eQCQ==
IronPort-SDR: 6a5894f3_MmWm00p8TlEBz3Nehh4vOBsNf3Za23jlmn/eBSsQHtZre3z
 ilyjxH1yLlPklzEZdqz+WzDXfZZ03EFIBHZB/0w==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jul 2026 01:23:15 -0700
X-CSE-ConnectionGUID: UdVKHvo5RuKgej9yzDu+oA==
X-CSE-MsgGUID: o0EzD0c/TZSbt6s0wfRpnQ==
WDCIronportException: Internal
Received: from wdap-fln31fg1cp.ad.shared (HELO neo.wdc.com) ([10.224.28.153])
  by uls-op-esai1-o.wdc.com with ESMTP; 16 Jul 2026 01:23:14 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: zoned: skip fully truncated ordered extents at zone finish
Date: Thu, 16 Jul 2026 10:23:12 +0200
Message-ID: <20260716082312.1252174-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A fully truncated ordered extent (truncated_len == 0) wrote no data, so its
->csum_list is empty and btrfs_finish_ordered_zoned() trips:

  assertion failed: !list_empty(&ordered->csum_list), in fs/btrfs/zoned.c:2141

Since commit 66ff4d366e7e a short or cancelled direct IO write finishes the
unsubmitted ordered extent as truncated with uptodate = true instead of
setting BTRFS_ORDERED_IOERR, so it now reaches btrfs_finish_ordered_zoned()
rather than being skipped by the IOERR check in btrfs_finish_ordered_io().
generic/208 hits this on a zoned filesystem.

Return early for these, like the BTRFS_ORDERED_PREALLOC case; there is no
zone append result to record and btrfs_finish_one_ordered() skips them too.

Fixes: 66ff4d366e7e ("btrfs: fix false IO failure after falling back to buffered write")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index bff209b552c3..9668a5928735 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2138,6 +2138,16 @@ void btrfs_finish_ordered_zoned(struct btrfs_ordered_extent *ordered)
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags))
 		return;
 
+	/*
+	 * A fully truncated ordered extent wrote no data and so has
+	 * no zone append result to record.
+	 */
+	if (test_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags) &&
+	    ordered->truncated_len == 0) {
+		ASSERT(list_empty(&ordered->csum_list));
+		return;
+	}
+
 	ASSERT(!list_empty(&ordered->csum_list));
 	sum = list_first_entry(&ordered->csum_list, struct btrfs_ordered_sum, list);
 	logical = sum->logical;
-- 
2.54.0

