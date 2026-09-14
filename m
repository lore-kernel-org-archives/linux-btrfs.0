Received: from outbound.ci.icloud.com (ci-2006l-snip4-10.eps.apple.com [57.103.90.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630AF35FF5B
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 06:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.90.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789367124; cv=none; b=U7I1UcB8vhk49UdD1GuxGwz7aAx+UEmvwZ+7Psfn/gXHOH1REhpIobPso3CODDXVTyc5bsXqK2JhqNeVvQVKevIIfGOO16l0UYRpjshx+oJO2ctNTK7DpRdSc+bUKKvaaB+N9HCMLOCpUsWpEUvDWDOydwPjfhjF7CB20yCRRMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789367124; c=relaxed/simple;
	bh=T9/4c+tD653Ok1xgN4AyVryL35VgzCgoc8jquiNjOYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E2qUGYwUafkez1Gx4hevPth2iJK0UzYGXKoMi9jDRjh5NCbW5CRB2eiQxDdux6M9UmqU15niWcPJXGqubjKaMYbAsS4p2ymcm+75iN8SvY1ZFaymv0M9azCMiBJzsrUbzl0Dh5NCqBpiGW9ObgqlPGXc/0VtBCyZhczBCNZmBK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com; spf=pass smtp.mailfrom=dev.linjama.com; dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b=dj7ilZQX; arc=none smtp.client-ip=57.103.90.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b="dj7ilZQX"
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-60-percent-11 (Postfix) with ESMTPS id 4BEE81800171;
	Mon, 14 Sep 2026 06:25:21 +0000 (UTC)
X-ICL-RepId: 01a09e97-7568-70fd-bf6a-c3d9c3a7724b
X-ICL-Out-Info: HUtFAUMHWwJACUgBTUQeDx5WFlZNRAJCTQ9KHVwHXRxCD1YCXQNLVxQEHFIDXg5eMF0dRUNbAlwaWBVSQ1QEX1BfHA4JUh0cHFAWWQxaChwTVhUTH1RWB1BRHV8CCgRHBFsXRgNTRVEZFxFQAVgeVl5aF15NRx9ATWJJAVoZWxxAF0puTVMPDxRcDh0BXgVYEVQZHQ5YBhIdUBwOUQVbAEYJQQJZB10ARAxBHV4PUwtDCEseXBoPUx5QHV8tUw5EXlURXQdWBlNeWhdeUxcfSwBcRVAYRB9dHWYcXABWAlw=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev.linjama.com; s=sig1; t=1789367122; x=1791959122; bh=SX54y9GEABSTk7aBFGSEbtjXEgav7/wo2ALJjWjX/t4=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=dj7ilZQXUjIqwWarVAceVc/Dgvsg0Nw8CeYcadGaDHkx/H4LJajr6lyX0jNED6+txtsOYLVI4n3CfaMVAfL3WAUqQDSXcYcz9vS3YW5iytVxSokiRdVJx26MKfRBdZbBkdXShVQZjKJpOKO4JNiObAaIGaxsliII2nZv3ikzA1uvE1QGsdO8+ABvc/7MMGh9eMjPwe+pQq7ts2PudQDGv04LH2HIriqPMCSQObUcwaWCB/W4I3vVnrVaBf75xHn1Ig0RWpM58doXTaCVnsoLzBJtplQOpzh+JNpgwRusfEFor9riO1QwKdg37EL0W44+URMVpabfOlDlX3FbDJafqQ==
mail-alias-created-date: 1690913137769
Received: from toolbx.lan.linjama.com (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-60-percent-11 (Postfix) with ESMTPSA id E89BA180011D;
	Mon, 14 Sep 2026 06:25:19 +0000 (UTC)
From: Daniel Linjama <daniel@dev.linjama.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-kernel@vger.kernel.org,
	Daniel Linjama <daniel@dev.linjama.com>
Subject: [PATCH] btrfs: don't force the filesystem read-only on EDQUOT/ENOSPC verity rollback
Date: Mon, 14 Sep 2026 09:24:59 +0300
Message-ID: <20260914062459.3889313-1-daniel@dev.linjama.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=Ds5bOW/+ c=1 sm=1 tr=0 ts=6aa79351
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=olXNNK5aAAAA:8 a=AoYkXxg7OnMuDaBrwzQA:9 a=U4UmX7kblY_o6ZOM_jyP:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDA4OSBTYWx0ZWRfXxA2relkI/SMD
 esjRyay45CRhaBfMvmJBX8nXb43Xa2mRWmyvK5RjMtrgQJFRiW2+lajZAZeJwtJ7KPCZCKaDMEO
 0l4jWOMDGMDRu5CwbBBN1J22Pfxa6xm9OtfoCW5+LwMNVGlNZ9lzF6z4vyBv7p5/Rtu3LripZJY
 lAvsuVFJMoxu1x29xrN8qwj5KSh1dcLUevHPNQEgkjjtLgEEm1O+NxozjatvwkpalFk42N70QKS
 K/mHFzKffhHWVZvX8D2CSf3m1TE/gaUzT9IJNrSDuo4K0zYL55bj0kpNHG20aaaZL+bLyEUQ4z2
 htLrABttIiMpW76DbbgrDATndKE938Xp+Y0rZZcVBPvkh63vZdcKWdj08m2xrE=
X-Proofpoint-GUID: uiK8xOhAHJagb6kVVhEZQbhxARBZ2Wc-
X-Proofpoint-ORIG-GUID: uiK8xOhAHJagb6kVVhEZQbhxARBZ2Wc-
X-JNJ: AAAAAAAByY3P++mmj0hOe14oDYXxl5jLEO/vvlHBZLgsmdfRfKIRvQ3t0AMV+04lcnwMPLHYWAnrujRzM/VinFOuB2CxirmSZQmA949da9M/acpPvkusewDzrmQ64FDbYi3iGzqeX0MvE89tnMN6OH2/t7E8SlZg6hSklvMjopEttxx0Z2FLy8pL1EU9ff5gSjAS4bGfKK0T4LtE5F/ZuPtvXZiopHoIiypdJTMXgK4dHYPDjHWR4u1Q5TtW+/ccYJHVsgF1DAm5WqDhIVRlNXBmxNL44PdenGdOGYIALkdVNzzAPIbhqMyIsqImM4RW3TTEgOFEOSIkNmk5EXVnu+eFF52e4k7hQR7kt3qZEW460YQZooGc5PYySToRddNvJM4N6gpq5Jv2KKCcMbnBMMuT51FsRHwLXYMoT6H24hhRu3qUJDORqih2wLhAPqhsIaY952/7d3PBe8gCls36NOeqfFDOn+bNKgNepWXS806fCoHXfNlOu5dgUHLkj6TM+1UTVKb3H3A+1aqLgEiaFFAiGPLXDMq/fH59P9wQuKYu6us6xCZJfq3CirRaSFW7t/EbQmSp1WfTa966o25+uoJxGNxjaYTSd/lW65PSxKTMnfWK4xgaowKyyOpp2nWaUwJ/PFFrYxSjSHP92uHNetzPHovGmdzKlW8bpMWS34ApawVRi2OKbg2g1QMITgJnBu8GKkZBQaTbQH6MGzVWmrvVA7oOqWR5wmW0kFqYjVrA2fOuF6VP4v7aGMSKGM92ZWO7T5b2zuTE8bwTq7dzkiw2TvNhB448Me986H+KZe0QHJyGznYLs7N3Fo7QZyestVxOA7GCWeGRdhdu12s7fQQVtJkjmD4O4e0ReXh6+a66NYBTZ8H7HVlMJDfD1ZM6VMoIb+M5TA6nKxo12pGvSmE7ZXvkxuZKg+hmDuCLdVs0GS4TFr1ofnFZsQVOU7BWpKbOruVhu2VqNnyiWpwrwwI3ifYlack
 p5YltzVEJQ0zVpBdzKTFfHMTNBl+I1uDVCjJ2iY+ZkxRZ00kTRVD7bBdhqdS/Uq4ZseHm3yyR5A73HsWLZVObCoWrfQYWvuE+8Qs1vRNjKOf1hUKlAHMHK7rcbzlqw/Sy8G/+etbs9niUa45pLxRM1ieApS3wirJP0/3Bmw+3685e9tWP7CboJV1JP7C+TnZM9TSRYEFEBCy+ufuRvP0BoVBDR2nffqh0noK8wBi6KLAdpQ8b3dNM1UUlNqXeQg==

When enable_verity() hits the qgroup limit, rollback_verity() needs its
own metadata reservation. When the qgroup limit refuses the rollback,
the whole filesystem is forced read-only even though the qgroup limit
was for one subvolume only.

Skip btrfs_handle_fs_error() for -EDQUOT/-ENOSPC and just return the
error. The verity orphan item is left in place but the orphan cleanup
from commit 705242538ff3 ("btrfs: verity metadata orphan items") will
remove it at the next mount. fsverity enable still correctly fails but
the filesystem is not forced read-only.

Fixes: 146054090b08 ("btrfs: initial fsverity support")
Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
---
Verified on a virtual machine with a mainline kernel (08df884136f1) and
a loop-mounted btrfs, with either a qgroup limit on a subvolume or a
full filesystem. On the unpatched kernel the whole filesystem was forced
read-only. On the patched kernel fsverity enable returns -EDQUOT/-ENOSPC
and the filesystem stays read-write.

 fs/btrfs/verity.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 4e0ab5842274..8d0f9eea4c39 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -441,7 +441,9 @@ static int del_orphan(struct btrfs_trans_handle *trans, struct btrfs_inode *inod
  *
  * We try to handle recoverable errors while enabling verity by rolling it back
  * and just failing the operation, rather than having an fs level error no
- * matter what. However, any error in rollback is unrecoverable.
+ * matter what. Failing to delete the verity items for lack of space is
+ * tolerated, the orphan item ensures they are removed on the next mount.
+ * Any other error in rollback is unrecoverable.
  *
  * Returns 0 on success, negative error code on failure.
  */
@@ -456,9 +458,21 @@ static int rollback_verity(struct btrfs_inode *inode)
 	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	ret = btrfs_drop_verity_items(inode);
 	if (ret) {
-		btrfs_handle_fs_error(root->fs_info, ret,
-				"failed to drop verity items in rollback %llu",
-				inode->vfs_inode.i_ino);
+		/*
+		 * -EDQUOT and -ENOSPC mean we could not reserve metadata to
+		 * delete the verity items. That is not a consistency problem,
+		 * so don't turn the filesystem read-only. Leave the items and
+		 * the orphan in place, orphan cleanup on the next mount will
+		 * remove them.
+		 */
+		if (ret != -EDQUOT && ret != -ENOSPC)
+			btrfs_handle_fs_error(root->fs_info, ret,
+					      "failed to drop verity items in rollback %llu",
+					      inode->vfs_inode.i_ino);
+		else
+			btrfs_warn(root->fs_info,
+				   "failed to drop verity items in rollback %llu: %pe",
+				   inode->vfs_inode.i_ino, ERR_PTR(ret));
 		goto out;
 	}
 
-- 
2.55.0

