Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2761F3921D6
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 06:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776063187; cv=none; b=l+qPRjlpPf5WBla0b5UWrVjoU7hTWMPwRTXDpIMTz1gg67kucfFDq2GiU50mYSExAYbsHqa8MQUkndDRDuQq+nuJITEo/NDrMY4U6TNnwAxeMciS8NdEOrwAmS4UwvYRnCH3YO3TbX733Ir4IVugsPMxQd08GuCJc7GvdaBovL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776063187; c=relaxed/simple;
	bh=vLExNXRNHZjLbeKKhFKoEbTczazmYmenYBsB5TW5ql4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Thx/ECPfn1CjefZYQaoWRZ5YGjwZLx4vP/vsFqD7Mv2NhoheSVxe4eBmmt31vL2b/rza9cwzCbyO+PGdSFHJHwhQTAI/XihAB3G+T4MAQ15JLpAgnKzftrhbCZV+H+ElXdhF8LTRIg8WLLs/cQQWHQn3k34yffdSE9SBzqiIejo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=AkMVZVN8; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="AkMVZVN8"
From: robbieko <robbieko@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1776063183; bh=vLExNXRNHZjLbeKKhFKoEbTczazmYmenYBsB5TW5ql4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkMVZVN8CmTZEnkLAUDPQL7sRrnNj38fpIHhA6WzYthQap7lU8l6DRpddtM+pahnN
	 1PT7mYfT4XV7wEDtokbMvl+KgXM3AIVQDSnNVPBTfiGDdrY9afYQfGuOqGAjanjhUz
	 ML2sceEa+fwsWfSuDi1JQwIDQEWBDwrZAA9zdfCk=
To: linux-btrfs@vger.kernel.org
Cc: robbieko <robbieko@synology.com>
Subject: [PATCH 6/6] btrfs: check return value of btrfs_partially_delete_raid_extent()
Date: Mon, 13 Apr 2026 14:52:37 +0800
Message-ID: <20260413065249.2320122-7-robbieko@synology.com>
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

btrfs_partially_delete_raid_extent() returns an error code (e.g.
-ENOMEM from kzalloc, or errors from btrfs_del_item/btrfs_insert_item),
but all three call sites in btrfs_delete_raid_extent() discard the
return value, silently losing errors and potentially leaving the stripe
tree in an inconsistent state.

Fix by capturing the return value into ret at all three call sites and
breaking out of the loop on error where appropriate.

Signed-off-by: robbieko <robbieko@synology.com>
---
 fs/btrfs/raid-stripe-tree.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 1e8392a6c5a4..22327f483311 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -223,8 +223,9 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 			/* The "left" item. */
 			path->slots[0]--;
 			btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-			btrfs_partially_delete_raid_extent(trans, path, &key,
-							   diff_start, 0);
+			ret = btrfs_partially_delete_raid_extent(trans, path,
+								 &key,
+								 diff_start, 0);
 			break;
 		}
 
@@ -240,8 +241,11 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 		if (found_start < start) {
 			u64 diff_start = start - found_start;
 
-			btrfs_partially_delete_raid_extent(trans, path, &key,
-							   diff_start, 0);
+			ret = btrfs_partially_delete_raid_extent(trans, path,
+								 &key,
+								 diff_start, 0);
+			if (ret)
+				break;
 
 			start += (key.offset - diff_start);
 			length -= (key.offset - diff_start);
@@ -264,9 +268,10 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 		if (found_end > end) {
 			u64 diff_end = found_end - end;
 
-			btrfs_partially_delete_raid_extent(trans, path, &key,
-							   key.offset - length,
-							   length);
+			ret = btrfs_partially_delete_raid_extent(trans, path,
+								 &key,
+								 key.offset - length,
+								 length);
 			ASSERT(key.offset - diff_end == length);
 			break;
 		}
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
