Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997A2365A0B
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 06:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776063185; cv=none; b=fGC2PQnWDoEg6z9HruvEUHRBDcKe2a0RSCFUNz8xRn7+XvtllVmKDRVfclpBhtWkX6x875kN17mmesDhY/b8fEFtrSTTI7SKPRy6GERNFRAQdJac8xraFX35twuFgfw+haNEOyDYZnk5PNCl++1xIDi2atcpIece5ETsXD07T8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776063185; c=relaxed/simple;
	bh=0kBs6Hxqdw49soOgijbws6Uw0ldRKFIkIxvvlzqN3tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iSgAOGZdaLKOaswhmtY2oFQCgRmQFEL62Rgw6EU84KYHtjFdajur3c4I6Aqo469514N64hGcygaAyafc/pl3JXhWeT0oR+nn76LSLJq2MIbKwLvyeAFUcic7w1diH/FGzry6k9I0qaOksRMrmTsB67ay/UBbgmPT6Aq/JokE56Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=mlchPqBq; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="mlchPqBq"
From: robbieko <robbieko@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1776063182; bh=0kBs6Hxqdw49soOgijbws6Uw0ldRKFIkIxvvlzqN3tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlchPqBqcP/KPfHVvQeP+WUiW3ZLQK34plp/SLDgDHr8zeQoMA4E5CWXQExup0xHT
	 NYPLjYekYhYu+E+7Fon1BXlhWgBuZLS9n9WsDFP9qpqzCIe383+ufa3BGm970DJY/5
	 9rydlaTznQIEf0SUcJS1QkDzCyy8r8ggta5GwQgA=
To: linux-btrfs@vger.kernel.org
Cc: robbieko <robbieko@synology.com>
Subject: [PATCH 4/6] btrfs: replace ASSERT with proper error handling in stripe lookup fallback
Date: Mon, 13 Apr 2026 14:52:35 +0800
Message-ID: <20260413065249.2320122-5-robbieko@synology.com>
In-Reply-To: <20260413065249.2320122-1-robbieko@synology.com>
References: <20260413065249.2320122-1-robbieko@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
Content-Type: text/plain

After falling back to the previous item in btrfs_delete_raid_extent(),
the code uses ASSERT(found_start <= start) to verify the found extent
actually precedes our target range. If the B-tree state is unexpected
(e.g. no overlapping extent exists), this triggers a kernel BUG/panic
in debug builds, or silently continues with wrong data otherwise.

Replace the ASSERT with a proper bounds check that returns -ENOENT if
the found extent does not actually overlap with the start position.

Signed-off-by: robbieko <robbieko@synology.com>
---
 fs/btrfs/raid-stripe-tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 2f41cec637d4..5909ad35a1b0 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -154,7 +154,10 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 			btrfs_item_key_to_cpu(leaf, &key, slot);
 			found_start = key.objectid;
 			found_end = found_start + key.offset;
-			ASSERT(found_start <= start);
+			if (found_start > start || found_end <= start) {
+				ret = -ENOENT;
+				break;
+			}
 		}
 
 		if (key.type != BTRFS_RAID_STRIPE_KEY)
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
