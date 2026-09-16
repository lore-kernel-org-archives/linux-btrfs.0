Received: from outbound.ci.icloud.com (ci-2007g-snip4-3.eps.apple.com [57.103.88.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FCC259C80
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.88.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789539394; cv=none; b=VkTcJ1jR/skSZan/3dIKXRh9154DYuqXrtKLAl5vxq/LKIjma2mlSniKMaVJBQdXi2lSYFQET1oPcE/xRlwvZeLeAFdnA7gbhZxaDa9yDvC/eno8Dusmqv0yP85fJiywFrMrYZQZlE15ISB4cM0rY2/yWkYckSdU2r3TXdQPy4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789539394; c=relaxed/simple;
	bh=cR9PlS772sPXTqow6oKOjaOoj1S4IGFajbhfdfBkEUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s5z1NDhWQE12nyzUFPvHTLofWKBUYG5Y8Bj+VJoP4ntIh9ugbjRvXCTfWuwz+92/Y2D0GczisgCcs9uCtpMOpW28/leFpRvY6V8d4zD6WXRV2iGSt2I1iZDtuzIsXsFGEcmfGWhR4GDsF13u6+omGVZPgx0iIWE09YlmEmYLT9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com; spf=pass smtp.mailfrom=dev.linjama.com; dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b=ocBkzEd8; arc=none smtp.client-ip=57.103.88.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b="ocBkzEd8"
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-10-percent-1 (Postfix) with ESMTPS id 4F3DE1800196;
	Wed, 16 Sep 2026 06:16:31 +0000 (UTC)
X-ICL-RepId: 01a0a8dc-1736-793f-8503-f8a6f60020a8
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQ9KHVwHXRxBDFYCXQ5LVxQEHFIDXg5eMF0dRUNbAlwaWBVSQ1QEX1BfHA4JUh0cHFAWWQxaChwTVhUTH1RWBFBRHV8CCgRHBFsXRgNTRVEZFxFQAVgeVl5aF15NRx9ATWJJAVoZWxxAF0puTVMPDxRcDh0BXgVYEVQZHQ5YBhIdUBwOUQVbAEYJQQJbB10DRQxOHVsPWANDD1UCQFMKXBlcFHMJUh0cHFAWWQxaChwTVhUNTUMSQhUEG0YeQwRfL10XXgxeBQ==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev.linjama.com; s=sig1; t=1789539391; x=1792131391; bh=8/G2MnAoRNDXc4Uxyoeiyh3ydGlsSZCVVlY7yqe0y3w=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=ocBkzEd8+WdfKCZVveoZRNTNr/DNyG02b1ezv0CX1G/EeLuEg5IScEttQ46xuy2IeYicqxjaguNVEQcGzCtQ3oy3vwvDDZ3E9q0vmCHiEeeYt4rj6hN8PZ7fFXfAeTU7z+/rQPYdOVgGmGCDd7GRohgtpW09J07R9MZyMdvGuJGmoXU7fHcptX5H/Tzzrm1AyRIhMFnJ8YCtO/BEq1wQrATmCLUJ0vHRH3KZPK8dYL7MIbRnh45FsLHA6ZgrHwGlt4HJth9cRk1qUP6yWB62auNyLlSQFSEbYlrPSGUbnmEDAK+v9efWagPyivWFhlD4wjndkFBuGj+omCKdYWEHaw==
mail-alias-created-date: 1690913137769
Received: from dev.linjama.com (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-10-percent-1 (Postfix) with ESMTPSA id E3AF11800186;
	Wed, 16 Sep 2026 06:16:29 +0000 (UTC)
From: Daniel Linjama <daniel@dev.linjama.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-kernel@vger.kernel.org,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Daniel Linjama <daniel@dev.linjama.com>
Subject: [PATCH v3] btrfs: handle lack of space when cleaning up verity items
Date: Wed, 16 Sep 2026 09:15:56 +0300
Message-ID: <20260916061556.683136-1-daniel@dev.linjama.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=PLYCOPqC c=1 sm=1 tr=0 ts=6aaa343f
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=olXNNK5aAAAA:8 a=KQ7dN3Ma56AJHg2-QNwA:9
 a=U4UmX7kblY_o6ZOM_jyP:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA3OCBTYWx0ZWRfX85Zj+Fyh8a3Z
 LrYtm/Tc7O2W5YnBI0kK+XEDQmGfwaXpEv602VN2DydV+VLAFHSNrzFhlmcfgL9V7tmSGtrg17f
 Cr/BRKq2hflOi9bTOB6dauPwXTBI3zn0ae0rGpgiVRS7Glrp1vgE4z5pxyFKr+D0ScPUDnTJZCW
 Jg/iVYfuqIutPl3outwX6bwTbqLkTgyVZAhX0PnZ5sXtS1+9Hz0hsfpc5ECgc8eVVTOcIeXwVUS
 pX9Rmvtdyf6m1GbbnkvTRBM0un29CZ7ByXLhiHx8rGMveYXRzgZwsHe9ZFY0sxqn3mUe0n5f3Sx
 z2g30i+1Fe0CM2lapNkSBr+mF8DjywOt6Fer23l5bW94GtcVu1G4IuNabzEN80=
X-Proofpoint-GUID: o0gDOQ40oLPC33XIHVkswmCkYc05CiHx
X-Proofpoint-ORIG-GUID: o0gDOQ40oLPC33XIHVkswmCkYc05CiHx
X-JNJ: AAAAAAABS34gK8XSx4+qpRQaekSAZTCGz6c59Q0GekNPeKsaIGwcMN8OGXxk6NA5AvDgNJ7JY0Ud+IWLsBVoKQAlocy8ggtU/ohKBd0Meygqv0DH4CGYCW1TxwShVEb5rbsbWXK85pZUymAIuPwPLnnV6Y79ShaTYJw+qCbGQ7et5T46iU3531E1IMsXRJQh80MpFG8mWtjlnaGBof5nRLGVw4po0iq6+CPu37FXU+Oe0gG8tqr1VUVRHsH7WObaRKRwyfjM/1U4MKXF1XETXU6GI+iW+TEkKZVzZhiFIvHL6Zs8+bGe0+8XArfYS2BOqgCucApcD18hTz973OpL9T8KxfhtKvSO6h5+6SPTOmW7Bwp/RSPHElcMDIXDtEBV1D6i/fZQZMWlV7nTVJrBA9ewKVA64C6OQy8h9RZYg9pr0Wh75MmHrUagdBHOTb4WwWwdt2XZ51Jk3p4K0akPkwFxDzaA8wKRoOmw9A0QRL7NaHO/+iofNvU8+9UJuUxNL7Bj+cExY3/Mh3W41gBbPacsFF5+PvMSJwg29aX0OTP3Ebi2ozcRoHyurzcA0rbVn2bOH5tYHVbV0O1nNFnGUPWVzoNLzBOihIrB5gdXSGbLrT8TAfR84XZThc63LYP4K98gOKuHhI4j38JzH76q4LlhMV4E00iLN7suEJzqaqzeQ6WBUanl0/4cqNs0Y4M3iMmSHCoW9ENgKjrwOSyniKZT99O7ZpAOJUm68yLv5Yj/rkpXmBp4GBWmMVD+EKq09Lg4JtUWPftE+IvtRAfmLapp/FQLUh0RG5LAMUEG9TkeDWeaODkveldnzCIwp0a0XcvRfCP+oq/Rz+tUSAgJLZGsRCylym07SZPILBUdNpswvPeG1XsTxFG48/7QGlZd8vefaNA0wpJFHfmZoKhaSdh4qkao45Oll83qrRHAqEQNtD7ZG5ZAQyNrId+W12Yx0JL67UC1w2mPK4UyoA6neB+grZre4dh
 kxPKsBDNt5fVA4UgV7thyhjnhrZoiJ/OWQmfUoJBZJmSJ0e+zxOwjeB9u/bxSxwL5exsWh+tecROE+VLep4+8tJpO7xmkbpH3f/GTbK7sezg9crpYsCklPo8M+W90o3xihRf1BP4Ox4L7Uvx+AR2XxnQWydOiiPv4ULmp1xrPDrnsVtzuNl8bNGs0DDrfZg1ghLszS6h/IAai0skUVX7S15/LeSoOvkfOke8n1sB8NroFDzWISpPAoJUfDrOagTEwdnp1sCv6rpuDnDQzMrp5uQ==

When enable_verity() hits the qgroup limit, rollback_verity() needs its
own metadata reservation. When the qgroup limit or lack of space refuses
the rollback, the whole filesystem is forced read-only even though the
qgroup limit was for one subvolume only. Also orphan cleanup at the next
mount fails the same way, so the leftover items are never removed: with
-EDQUOT the subvolume stays unreachable, and with -ENOSPC on a full
filesystem the next read-write mount fails.

Start transactions with btrfs_start_transaction_fallback_global_rsv() in
btrfs_orphan_cleanup(), drop_verity_items() and rollback_verity(). Those
calls only delete items and free the space in the end, so they may use
the global reserve and skip the qgroup limit, which avoids -ENOSPC and
-EDQUOT.

Fixes: 146054090b08 ("btrfs: initial fsverity support")
Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
---
Changes since v2:
- Explain in the commit message why the global reserve fallback and
  skipping the qgroup limit are right here, as Qu Wenruo asked.
- A helper in verity.c for the two verity call sites carries the one
  comment, as Qu Wenruo suggested; the orphan cleanup call site only
  notes what it does.

v2: https://lore.kernel.org/linux-btrfs/20260915055109.311839-1-daniel@dev.linjama.com/
v1: https://lore.kernel.org/linux-btrfs/20260914062459.3889313-1-daniel@dev.linjama.com/

 fs/btrfs/inode.c  |  3 ++-
 fs/btrfs/verity.c | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 93ef3cec191e..84dc44af17d7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3877,7 +3877,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				if (ret)
 					goto out;
 			}
-			trans = btrfs_start_transaction(root, 1);
+			/* Only deletes the orphan */
+			trans = btrfs_start_transaction_fallback_global_rsv(root, 1);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
 				goto out;
diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 4e0ab5842274..18b9d14f2e8c 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -93,6 +93,20 @@ static loff_t merkle_file_pos(const struct inode *inode)
 	return rounded;
 }
 
+/*
+ * Start a transaction for removing verity items or the verity orphan.
+ *
+ * Like unlink, this only deletes items and frees space in the end, so the
+ * reservation may come from the global reserve when the filesystem is full
+ * (-ENOSPC) and is not subject to the qgroup limit (-EDQUOT). Otherwise a
+ * failed enable could never be cleaned up in either situation.
+ */
+static struct btrfs_trans_handle *start_verity_cleanup_trans(struct btrfs_root *root,
+							      unsigned int num_items)
+{
+	return btrfs_start_transaction_fallback_global_rsv(root, num_items);
+}
+
 /*
  * Drop all the items for this inode with this key_type.
  *
@@ -120,7 +134,7 @@ static int drop_verity_items(struct btrfs_inode *inode, u8 key_type)
 
 	while (1) {
 		/* 1 for the item being dropped */
-		trans = btrfs_start_transaction(root, 1);
+		trans = start_verity_cleanup_trans(root, 1);
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
 
@@ -466,7 +480,7 @@ static int rollback_verity(struct btrfs_inode *inode)
 	 * 1 for updating the inode flag
 	 * 1 for deleting the orphan
 	 */
-	trans = btrfs_start_transaction(root, 2);
+	trans = start_verity_cleanup_trans(root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		trans = NULL;

base-commit: 08df884136f1c1197bab2a27814404fd329d9aac
-- 
2.55.0

