Received: from outbound.ms.icloud.com (ms-2002f-snip4-5.eps.apple.com [57.103.74.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6505243F4C6
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 05:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.74.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451489; cv=none; b=Km87euEnx8vhumxcx5FtnVtjapCT4VUzE3xx80bpV7YHL/OWhjHPVe4tunjIhRVBCLzpeX8l9sbamFMNrlvJf4GEq23tI3qNoO6NfmnoeOvfeqW5hso5ZI5CDmR0uzWez0mvjwDptUrRlUCBG2BOigBV2p2GKf4OrroKSTBkkOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451489; c=relaxed/simple;
	bh=GosjDa+aWNTVNHBk7jWrJ0E3dvmD6NnNslRI8KHXCeY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uFaGajGaTP6oDu7ylpCpznUMXnYU/QiZR2m8PG2ltJhL8Th3xC1KiLb1VAtxyzGXYQZv0kEkdldKQY2ez2BL7W7/NIwzmE52l3KK2SSYq/yLSj/29KBCtDJk7dYe96EEaLLPmIpZZPLRPSEiGDhrtFzVmxwYkqJBbtz7UNnGslU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com; spf=pass smtp.mailfrom=dev.linjama.com; dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b=YE4KXlGX; arc=none smtp.client-ip=57.103.74.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b="YE4KXlGX"
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-3 (Postfix) with ESMTPS id 27B0618000E7;
	Tue, 15 Sep 2026 05:51:21 +0000 (UTC)
X-ICL-RepId: 01a0a39e-b00e-7d38-a371-2f93ee041d6f
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQ9KHVwHXRxBDFYCXgRLVxQEHFIDXg5eMF0dRUNbAlwaWBVSQ1QEX1BfHA4JUh0cHFAWWQxaChwTVhUTH1RWBFBRHV8CCgRHBFsXRgNTRV8DFxFQAVgeVl5aF15NRx9ATWJJAVoZWxxAF0puTVMPDxRcDh0BXgVYEVQZHQ5YBhIdUBwOUQVbAEYJQQJYB14HQQlBHV4GWgpDAFUCQFMKXBlcFHMJUh0cHFAWWQxaChwTVhUNTUMSQhUEG0YeQwRfL10XXgxeBQ==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev.linjama.com; s=sig1; t=1789451486; x=1792043486; bh=5PmhG4SEYu8aXgW3Njr9QPn446ZmFHsjOJ4OX0Jighk=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=YE4KXlGXqv/karD4ruPgRiuMysEEg3Bx2Od6Q0BGi6QgYWuzYi/eMik9xqSRIb3zgNueshmmI9mgTUmlmfh4vqJLrAUtQNC1uEeZzvpoEX29qoglayLi7YnRhvX04q/kScqUsYUUVUpFqFJ3Ixa6BBkS4LNJWtA5EyOfsKyz+3r03W7L37jqY91VZs6VDAcOt0eP7AAtCDSJOfQtBTH8HuXna+sDPFDuTS7b2NANdOnt2xtjEDEbXOfUK/BL7smWORc7uA1/33gCqullXCp52oAJ9fIFM0aqpjthOm1CPsdMa4ZU666E0kcU3ckuSE7LWYynmwjWt2MZklZKc4hOvQ==
mail-alias-created-date: 1690913137769
Received: from dev.linjama.com (unknown [17.156.208.39])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-3 (Postfix) with ESMTPSA id 4DDBA18000D1;
	Tue, 15 Sep 2026 05:51:19 +0000 (UTC)
From: Daniel Linjama <daniel@dev.linjama.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-kernel@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Daniel Linjama <daniel@dev.linjama.com>
Subject: [PATCH v2] btrfs: handle lack of space when cleaning up verity items
Date: Tue, 15 Sep 2026 08:51:09 +0300
Message-ID: <20260915055109.311839-1-daniel@dev.linjama.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=EJoLElZC c=1 sm=1 tr=0 ts=6aa8dcdc
 cx=c_apl:c_pps:t_out a=kRaGL2Q7qLiahLf3O6OaIA==:117
 a=kRaGL2Q7qLiahLf3O6OaIA==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=olXNNK5aAAAA:8 a=7YfXLusrAAAA:8 a=bKtKrkIbznRyHLuInHoA:9
 a=U4UmX7kblY_o6ZOM_jyP:22 a=SLz71HocmBbuEhFRYD3r:22
X-Proofpoint-GUID: oRxtibKSBbLZXRzAYXvr4CICI9ivJUMM
X-Proofpoint-ORIG-GUID: oRxtibKSBbLZXRzAYXvr4CICI9ivJUMM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDA4MiBTYWx0ZWRfXw79BMRNMYtu6
 NI00Ef+hF2RYjC7GpYDekz18pM+cGYqdI9LCeuLGczTxJPC4Xxv+xGGWqxTDc7yvij8tBMwpJT7
 dsDJVFMxkHkC7IvLLlDfCQgdwRel9KGQsUv/VXD5FTGOVjC7ibcS5qQoctn+5v5TrP2BUVKZ9aQ
 nRtw/A0LTldpSi+9l0UW/pMLhkx2IBTuS+MSdQ+gZf7cPJIL1V2BA8MoK97cQVwMQWDIBe7Mtzv
 4LacSvjQTVPkkruXCdcUJe/3SoaM1UnUPVTdM10QuU3Wn3UDJ/hZ/QI/h+rl2hMtqId4BU1Z6Eg
 Cl6Upb/TnjGEjWF9ivmDd0DqESv5xn77fzF7sFn+3T5k1t/9eR/gkiHznOYF50=
X-JNJ: AAAAAAABmU0S8vhH1osebWphTeAfy/85CT8jOWu4Sn4F/GSvfRhssBZ2Dz2AzSp30rXy0/YLcNiLE+yxxHomCjDHqs7pw7HY3d/E97QIbn60u6QvUo0ZSpnpOg7UCeTzAT7QKO8MILgGVrMpDSm80eYQjZpaiUUPF1j/UBR1QZZlR1Nt1j84DWLnJ2yJr68zBBoOWSzlO9CO3dKON7Rbg4mlgjX46VvTejGyvXC0yJuhaOi30noaHiSF/gcYyOgOZEmglrtxT8opCTN5WU7LynYGu/WVOISl0ow4A4CegZRXiW+S9CTdrYF/DCGWsgSmVeKRvV+yCCLn11Tya3oevsx/t2zddbtjwboCZeOMEHSTtOGUDkRCmniaG9q71IzQ8a55eRjoGqs5NXYAIBCVIWA0B3FNaFmR9PuV6N975W7NmFbrRUnJa0wPTxh7bsdYxMT36UkvVI0omtxOOJLGH3dbEpuukjOw/w2VvBRY7fXR62/o+VIu0iJBYa/lRRUTsUmSC8V+imsy1N4+e+0ppe5bVHCUvHYtsORCYwZ4JlNx80I8QPBPtWyXlK8hE+b7F4szfDxn8K8Lnhqk93Y6iFfsHe9rJXebIbGZ6qo0P3lwyzbaSusXHhXhY75V880XJzw3RFS4TL8ckOHdiNWJJiNzm84/dUzDXxSy8dMpQL3FwHcX0NVbM5/cihdZR6fkFY4UYzs4hR71L89DQLTPxCQ1I6VQ1Q7AO4r+9tN7cf8tI/uCh+2QdQkCjBck6xpi1gnknY8kpMeB1KD3KORhVLdODyQvdZpInIE/1buy6i3ZN7bD3SP+/ki98ra+1MfqSBFpCs1Xnxw7EAageUmB+qtjXbIHj9UtELjZa9a2nvQzTJUaNM5nQCxphj2k62dZrIFccjFfNU4I0g204yxIIqgJ8MCeSuf2B6JICfM9TX6V5abJwCJlU6n4xVKa6/YK35UAvnW7BoAJqCG9JMQNelBx/1j32Zw
 EaSvCPaIQpoxU2X5jIyfiK+5F7nBrAzCRGw2G8hiY59q5b8xuXV6zqMHuX3eagQll2mLxmd3l2QhOIYDbN7xdYUmjBuzZAf30tb5fygsOLioz6OQowwZY3gYaDpqvGepjsQ443UE37P8hNQXf+++9anRtbH1kp3icRTT+FWOFl5dyiv4y8dMOvdVWhCC5xCcn/RR+la1BbyhFbJyqKZ2nD3Mq3KmdqbN2odzHclA6F+S+rl3R4aQwMipTAa0EgQDhoGsgmuVdX/bXzDmBBww=

When enable_verity() hits the qgroup limit, rollback_verity() needs its
own metadata reservation. When the qgroup limit or lack of space refuses
the rollback, the whole filesystem is forced read-only even though the
qgroup limit was for one subvolume only. Also orphan cleanup at the next
mount fails the same way, so the leftover items are never removed: with
-EDQUOT the subvolume stays unreachable, and with -ENOSPC on a full
filesystem the next read-write mount fails.

Start transactions with btrfs_start_transaction_fallback_global_rsv() in
btrfs_orphan_cleanup(), drop_verity_items() and rollback_verity() to
resolve the situation.

Fixes: 146054090b08 ("btrfs: initial fsverity support")
Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
---
Changes since v1:
- Revert the v1 change and fix the reservations on the cleanup path
  instead, as Qu suggested. Sashiko was right that v1 left the orphan
  for the next mount.
- Cover the three transactions on the rollback and cleanup path to
  handle -EDQUOT and -ENOSPC correctly.
- fstests: btrfs/354 (qgroup at its limit) and btrfs/355 (full
  filesystem), sent separately to fstests@vger.kernel.org:
  https://lore.kernel.org/fstests/20260915053815.307674-1-daniel@dev.linjama.com/

v1: https://lore.kernel.org/linux-btrfs/af99a1d5-25b0-4e39-9f66-a2dd8e1425c5@gmx.com/T/#t

 fs/btrfs/inode.c  | 3 ++-
 fs/btrfs/verity.c | 9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 93ef3cec191e..d377f4ca5207 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3877,7 +3877,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				if (ret)
 					goto out;
 			}
-			trans = btrfs_start_transaction(root, 1);
+			/* Only deletes the orphan, must not fail on a full qgroup */
+			trans = btrfs_start_transaction_fallback_global_rsv(root, 1);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
 				goto out;
diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 4e0ab5842274..189b36e5fc29 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -119,8 +119,8 @@ static int drop_verity_items(struct btrfs_inode *inode, u8 key_type)
 		return -ENOMEM;
 
 	while (1) {
-		/* 1 for the item being dropped */
-		trans = btrfs_start_transaction(root, 1);
+		/* 1 for the item being dropped, must not fail on a full qgroup */
+		trans = btrfs_start_transaction_fallback_global_rsv(root, 1);
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
 
@@ -465,8 +465,11 @@ static int rollback_verity(struct btrfs_inode *inode)
 	/*
 	 * 1 for updating the inode flag
 	 * 1 for deleting the orphan
+	 *
+	 * Must not fail on a full qgroup either: the reservations for the
+	 * items dropped above are only released at commit.
 	 */
-	trans = btrfs_start_transaction(root, 2);
+	trans = btrfs_start_transaction_fallback_global_rsv(root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		trans = NULL;

base-commit: 08df884136f1c1197bab2a27814404fd329d9aac
-- 
2.55.0

