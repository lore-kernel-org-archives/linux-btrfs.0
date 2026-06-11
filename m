Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9561137D110
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 22:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781215223; cv=none; b=PAoxxVWslAxLjo7wK/kyY/GxrIMmxbuhg0y2a85gXBjpROwhwN/wyUZZTXtJbfPiaAvxl8OyuiDI8nBDQRAt4+roG83lZXxV3ndp2sTO9Eckoq2NwoTu73JhwUdIiGbqJq1Wh7bBpqiLwXbPespeaQBb81AlwpaxVocHPgmDREE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781215223; c=relaxed/simple;
	bh=06boAcv5xD7BQWwnrBg8RGT+AvZe5cbfMVcJmpJgK34=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=X5RpIIT5r8MCNFrGO4LOCrJI2y/p3o6XbiF/vWUwSBIxjBVlPOEHgTAz+rjWlTVaObByEKHDpNFtTFMF6Dji69pCK0i40CToUG/4jeg+qMqqezHj5F2HvDEoIqyIN/X9JPw+epp0o6/wjWAMxjbf20PRVXguocL5p3gRKqjvaVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=AOgRL5h6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Vc4uHsvj; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="AOgRL5h6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Vc4uHsvj"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id CF41AEC0196;
	Thu, 11 Jun 2026 18:00:20 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 11 Jun 2026 18:00:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1781215220; x=1781301620; bh=6bnOsAWwoh1/KjxJA3ddq
	B2dkwDuhWEBWni2NQ35JQc=; b=AOgRL5h6rSQp3CCIQsfIjI1DMr3PFqAHh8/4c
	OkCXLmuKVKLyFw3vbWGa16RBWHmlJZMhRvuz5sveT3Qw1BK2Xqf78i8CHOgqzQ7P
	KiZlwbWFb9ewOK0J1qFaBnLRv/tJU1oYKCEYMnN4Bt8QFaxM61gYGPKECJHljlGQ
	K9aFKHuYTZLocJ880VFTBXjKwYT5rJ4Imq/X5LAuWHz6bWz8eDUcO9VPmInu9cXv
	hYZuIrOpDckUccLnX8jvlW80RW6xUnrd0b6szkY/vQ9+OD3/LzVfVFJlfxMCq2QP
	zlmKHHmMh/TndceZtwRAXekr99l4Xvwv6xUdHSTQxfPvXIqjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1781215220; x=1781301620; bh=6bnOsAWwoh1/KjxJA3ddqB2dkwDuhWEBWni
	2NQ35JQc=; b=Vc4uHsvjyQHSiDzsBYpeydgJwy9JqitBRihMMZxqiNF4kTfGNdV
	RLI/G5bF3qyhKIuiRZ8doqX+RH5NpdH/NjAsSOA4M4j6RnCAPjy937/G4NMCUctF
	mwcHsL/njJf0sdm523PuxwUWVm/j1UYfL9iCEOPcqjpgcmTTOddbsb0xxvqnr780
	njz/XRu8PhYKKvGaU5dMJU4wtrPn/vegy2b8igX48EqONjh+b7yoLc/bdNv7v1m5
	R91n8ICEohS0vSsmr26ibiMbk5dyyV7wovEmMo2C2RX6JeJY8rIeVDT3VPvuKyqa
	yVA8X7m/0/ntFEmChRJuxTNv0XXj6kQ8a2Q==
X-ME-Sender: <xms:9C8rak1dRUJ0HvjGFB-lzYN4NFRzgvmX2m0K0uKL1tSCf0NTxowldA>
    <xme:9C8ralGH6ypWGN6c4Zb31cBYHIQ-Y2VbgOBv9zGQhNsLdHFb0dEKsX-eOKDBMqV17
    hwJtdzECFsE1J9qUtV6QdGjUwbPsc_TaGSFlLHjDxa3ra2Ul-Km9Ko>
X-ME-Received: <xmr:9C8raqhZ0BJd_pbiQs8cPdI0vzUTTkKmhFIaWRRy38R06R_nK3_qBnkjDB8>
X-ME-Proxy-Cause: dmFkZTGF0QvBhnwjPWymQFSkLfqh0ft4UQoH+Q9kDn3DwuezSm9iKhKXbo3zfHhRH8ETOv
    l7N/Vq2WRqq7zdaK8fB2bwf3LXUZU4jt6Ejeh1o2zb5frhYurlbXkyXoxQ/V2vW30Bk6Vi
    XkGbiMJSCwyrDTwzz3r/POrku5VSNePJ0+F0Ix5uk52hARQsYNoEcSQQIYbhGvLm16znV8
    7m94GWsiWT8ZQc261H3txGylmsTMnthFc90pJ5m6cZd/LbDYQTtC46P8/i8Dm/ptXHYV9Q
    kznUO/Yf4TlyXX0DaVdJ8dr3FiMHzIHEjIn9Th3+VYweTNgj1zgIu37VVeVkmiIQ6+pjb0
    AKQUXMVAwZOrzP+dTSlNybmKOTzjuCE8GKXbmgIa6/XGbNPLM5/GCT66Na1Abw1Zig59PO
    Vyd+oXox1PPKMBxRURjD0to5ujcSnkQHp7drjo+gr2w8PVVaz5lqS8m2U8wyB9ZQ4/jPLE
    f3Q7BtjQeg4jolGUaZFVkSd4QvXiqCCYREN4xNI9FJZOmfTUJUlYMknb4kpQKD9sNc55NW
    Unyp7EdM/ZCa0u97gGA+GVczZk8K5Usn5DtKLwqvBVC8xr2u5kAJzFbG3is+7KUn16t4/p
    4bmyFTRMKF38MsjwKOctnIuAPSqAoFg+VqX9yM8MDq5m1P0etCKFgB23/VFw
X-ME-Proxy: <xmx:9C8rao9l_bFw2lwSVLms2AAGl9vRsiIt_saONtiCVrgF1nXP2KmikA>
    <xmx:9C8rapo1vf0DgdaZmP0vV7gNdjrppY360is9Z8F-b6MQtTYH7UDkPg>
    <xmx:9C8rav8ZSJvzlaZRdFkHJ1T6rpkjApIpoUAIVr5nl6BVY9sdI_H4XA>
    <xmx:9C8ralXettlLQHlvZd2reWGkfZfU8S3kHS_Z7ADR9VDRJ7OVOYTFWw>
    <xmx:9C8rauZSMOnPhQftZ_qA_nfY40q2ZBZvTOn0AnAqCie3nvP13_bC0pGr>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Jun 2026 18:00:20 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH] btrfs: fallback to transaction csum tree on a commit root csum miss
Date: Thu, 11 Jun 2026 15:00:15 -0700
Message-ID: <e0b2579b1ae150d02550823b837ae3e6a14af644.1781215153.git.boris@bur.io>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We have been running with commit root csums enabled for some time and
have noticed a slight uptick in zero csum errors. Investigating those
revealed that they were same transaction reads of extents that were just
relocated, but the extent map generation was long ago.

It turns out that relocation intentionally does not update the extent
generation (replace_file_extents(), but must write a new csum since the
data has moved, so we must account for this with commit root csum reading.

Luckily this is a short lived condition: after the relocation transaction
the commit root will once again have the csum. So we can add a generic
fallback to the lookup to try again with the transaction csum root.

Fixes: f07b855c56b1 ("btrfs: try to search for data csums in commit root")
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/file-item.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 9f6454e9db818..cf50fd623f41a 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -358,6 +358,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 	const unsigned int nblocks = orig_len >> fs_info->sectorsize_bits;
 	int ret = 0;
 	u32 bio_offset = 0;
+	bool using_commit_root = false;
 
 	if ((inode->flags & BTRFS_INODE_NODATASUM) ||
 	    test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state))
@@ -431,6 +432,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 	 * from across transactions.
 	 */
 	if (bbio->csum_search_commit_root) {
+		using_commit_root = true;
 		path->search_commit_root = true;
 		path->skip_locking = true;
 		down_read(&fs_info->commit_root_sem);
@@ -463,6 +465,28 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 		 * assume this is the case.
 		 */
 		if (count == 0) {
+			/*
+			 * If an extent is relocated in the current transaction
+			 * then relocation writes a new csum without updating
+			 * the extent map generation. Until the next commit, we
+			 * will see a hole in that case, so we need to fallback
+			 * to searching the transaction csum root.
+			 *
+			 * Note that a commit root lookup of a referenced extent can
+			 * only miss, not return a stale csum. A freed extent's csum
+			 * is deleted in the same transaction and its bytenr is not
+			 * reusable until that transaction has committed and the
+			 * extent is unpinned.
+			 */
+			if (using_commit_root) {
+				up_read(&fs_info->commit_root_sem);
+				using_commit_root = false;
+				path->search_commit_root = false;
+				path->skip_locking = false;
+				btrfs_release_path(path);
+				continue;
+			}
+
 			memset(csum_dst, 0, csum_size);
 			count = 1;
 
@@ -481,7 +505,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 		bio_offset += count * sectorsize;
 	}
 
-	if (bbio->csum_search_commit_root)
+	if (using_commit_root)
 		up_read(&fs_info->commit_root_sem);
 	return ret;
 }
-- 
2.52.0

