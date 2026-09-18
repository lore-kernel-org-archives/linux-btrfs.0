Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996634EDCB9
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 12:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789734503; cv=none; b=pyyFwj0skt2Lxtj5IOzMRp37TvLQBepYV/KSlRPj8OSN0mLo9AoSRiXjeqLezO1TxPH98jpAIpqNHvvDJefF/RsZ6xnqFqSw5DXuxMlNgX2lGX6Hcu4B1YXBIAPyeXWVSpYYGuiJCkl7/EMzT8uxpmxiC5yBAPovpDTHKd/qQUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789734503; c=relaxed/simple;
	bh=wwU1HKhZuVWMJTs7TDT1UWalHSCydsA/yR6g+Z9AL/k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZOc3qdTFlWuoyx2Fqw7CwaP/sDF/PjWVtxteT2SmdFX0oUyzaWHby43tp8nlEbPr3N1YkU3p3gukIaCG2Zdn624z6n5+kG2t5dO/xAe9I0E9gNpiGP7HTZi/19v69aCCmfeYbDdDY9Jp4MbV9H7O25nsbMaXjlbV5p1SUsvcHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8xMopYd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8xMopYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FEF1F00899
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 12:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789734501;
	bh=P5SR+IGF3UVyGTiENb8pSMWC3PtbbVeRcviYDducobM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=X8xMopYdIAL5pGYxATJ+iXpvofWOeMUHdTtVIBXEOMHq1YWs3C6XUaePevgtivjlL
	 DS5Z7M4865jk3ddZWnXnG9bHQ7GW6xYRBJ99pb5dCg8U6860fmO+6Uy0BqC566PgsV
	 BLixo9jQZ/vHPXqrNbzZb4Eftrl21hn403qP/A/WE7rT//Lu6WkKhGdIpjVXb9cjtq
	 lSvbmpyX31O9YZ3nnhWlQKRIqxbLqQicz3i43/yLQIk4C0i2zDr4jDJ4+HEJFeXXzd
	 LlWmZLXXsZ5zLLzyN3g0xupH2xzkEiGX9gO7cHQ3l+qX05th3PnVCZ2uxUuFNhQlfz
	 1Q60UPiBdiG4Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: fix barrier usage in btrfs_record_root_in_trans()
Date: Fri, 18 Sep 2026 13:28:10 +0100
Message-ID: <ded35d39b9858ee6f20ee3358a8e592a36e8e33c.1789734246.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1789734239.git.fdmanana@suse.com>
References: <cover.1789734239.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The barrier usage in btrfs_record_root_in_trans() is wrong, as the writer
side, in record_root_in_trans(), sets BTRFS_ROOT_IN_TRANS_SETUP, does a
write barrier and then sets the root's last transaction. This means the
reader side must check the root's last transaction, issue a read barrier
and then check for BTRFS_ROOT_IN_TRANS_SETUP. However, currently we issue
a read barrier and then check the root's last transaction and the bit
BTRFS_ROOT_IN_TRANS_SETUP, which can be problematic because the CPU is
free to reorder the checks and the following can happen:

1) Before reading the root's last_trans, it checks that
   BTRFS_ROOT_IN_TRANS_SETUP is not set.

2) A writer sets BTRFS_ROOT_IN_TRANS_SETUP, does smp_wmb() and updates
   the root's last_trans.

3) The reader then sees the root's last_trans matches the current
   transaction and falsely concludes the root setup is completes and
   returns without waiting for the writer task to complete the setup
   (calling btrfs_init_reloc_root()).

So fix the reading ordered as previously described: check the root's
last_trans, issue read barrier and then check BTRFS_ROOT_IN_TRANS_SETUP
(the reverse of what the writer side does).

Assisted-by: LLM
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c1555621ae4e..13203ea9e116 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -511,10 +511,11 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 	 * see record_root_in_trans for comments about IN_TRANS_SETUP usage
 	 * and barriers
 	 */
-	smp_rmb();
-	if (btrfs_get_root_last_trans(root) == trans->transid &&
-	    !test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
-		return 0;
+	if (btrfs_get_root_last_trans(root) == trans->transid) {
+		smp_rmb();
+		if (!test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
+			return 0;
+	}
 
 	mutex_lock(&fs_info->reloc_mutex);
 	ret = record_root_in_trans(trans, root, false);
-- 
2.47.2

