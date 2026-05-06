Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C78946AF0F
	for <linux-btrfs@vger.kernel.org>; Wed,  6 May 2026 14:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778077264; cv=none; b=tMpcaWlq8Hv4VMcZALHufVzGozb7x3WTecf8zSmk+v9Zi5WqFBa9gXPXhqVKGeUsMnQMC1TBnf0JfGXWAYNDN4tJugdinlS8MQPPWj6EURcBkeQ7CgJNhAWq3YXuEZS9SWpP8T0hEdlFo27D88kqdkWgrPR/QPGxs7JH8tCaUzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778077264; c=relaxed/simple;
	bh=KjJKPwHwRAzvNotwsw343jDMtaJ1KPejTSMP/fPpWRc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ih8eqBc1HtViCeYZBA9MMXcPdBc7bLLfmfgNPSYIpmJr3okJHrc72heutp5V/P2DPgVs1HJNUiBC7mB9nvLbF+zAkQDrGc8oePUHwr/Uds+C+mgB9vLC8XEcOyD6w2vU9K15ab4bXKUdQbuJsTplhdRz8546f+hnyegHRLfQOXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NY2oUdT6; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NY2oUdT6"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8354461da74so1860404b3a.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2026 07:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778077262; x=1778682062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AMvU4rqK6ndGmpx4u6CTQmFryn91yq1yst8gCoaX7uM=;
        b=NY2oUdT6ykiOUi7ylOeEg6IQOZRvB3VJ33XRN5I4DjvzIbjtv+rqgOkWIPJHC0u6gf
         EwbYJBdSGDarx4M8ZnvwrhGB9YaEUmCLjzeA9EjCWDvs08gb5sdIEqfcMB5Sq5tMeURz
         cKDmgzSD+nahGDNhEvBKKid6G4L7vHqtBcU2IcRFDM1ipcpXztsnbtAxYv2FVlbRfaF9
         yHwT8N9ASOs+e28l135nF6LYEl0rcBydnjrqYmQZs3k2uapVvuIJqrYctO3N/yZJdGV+
         e6LG2GVoG5xY9T+XnLDSH2bs/4RNBSSb95NWetOOzNbPqUcn9L6HgmYlGSOWF7T/HWyl
         2GvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778077262; x=1778682062;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AMvU4rqK6ndGmpx4u6CTQmFryn91yq1yst8gCoaX7uM=;
        b=qhCdIdtjOyesBYAbF2Gkdi2cqGrrsevcoZaRDZqE28gHnlg9lX4+PxY5jZ20Zq1/MO
         9nWeibZi97r4ZczUhqgNn5gPfLLRi99EFm3B5IXg+bvP+KwgnOD1JFxJBL+8123cigeV
         oYl3Nrn3M7o8kKvsjjyjyz2QXwmtAZz3qUBX5jNR6MuWgQwHnOAGzXX27dOTPo867gZr
         +OBtpBRLjlHjGndByt3kqwC1QESGD4Akj2UcNCaHkr19GQ+hAurrOwdK4B4XAE64UlBn
         4r6cUdhN4/Fn3KuDB8EsjPtfCq/ZJl3UQRDxQPJYqij4ObSp5QGKsJbxYYTxUiCT6JJ1
         t0Cw==
X-Gm-Message-State: AOJu0YzwfZrqhUKADT841JaqTD/v0fK/Obalg+F0w8IKCOf4zr31AtGs
	mhi/GJr8I0ynQnZ7QXLH67ux/6bmeQ5rMpSsNHqN/CE41emuDzUkTIWE
X-Gm-Gg: AeBDievYSUV7zaQhiTmUCcrzm/NFwYT/posSha/9lNBL63eTEr59jQ8xWN3DrqxT3HG
	Dw/hguicdnaNnYB3KfxgSKqQvVblrtQd46t30/hXSZ5Tsacal3MYlpZnASaBDRvoHSJhfX+Xlkh
	Nq/c0XF09idIJ3hWlfn+EefRmsuMRRdjvl5+FzPcPMlqNthT3xQTbNcOMfVjiSWWqBz6rrFwpBN
	lzPQEXSgdRbveEIuNUaNC2wfigthx6qvY8qJ4iVTK6uaPf1auThF+nYTEzKhNQTm6oSkw+Asm0Z
	d5MTA8YptvVEG0ZWpF7b9Gtr9WExID7vJHpouQ8rz5fTpjlb1SmY+akyejtukyR+19lWQVPoGEf
	su25Ozdo2are8c+5TBEf7Zq6cPizkbtwdL0JiSXX2VZvoIUuH44FrV+6a/3Z4zs5/bYBe1dVCRe
	2ECn7N1hHA4wZC3Wdg88syRTbpTxnCjdkPPkM+eoY=
X-Received: by 2002:a05:6a00:2d9a:b0:82f:aae5:c7a9 with SMTP id d2e1a72fcca58-83a5db6577emr3029881b3a.27.1778077262316;
        Wed, 06 May 2026 07:21:02 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83967dbee14sm7285637b3a.48.2026.05.06.07.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 07:21:02 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>
Subject: [PATCH] btrfs: fix root-in-trans fast-path ordering
Date: Wed,  6 May 2026 22:20:46 +0800
Message-Id: <20260506142046.1170581-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_record_root_in_trans() has a lockless fast path for shareable
roots. It skips reloc_mutex when root->last_trans matches the current
transaction and BTRFS_ROOT_IN_TRANS_SETUP is clear.

The writer side publishes that state in two phases: it sets
IN_TRANS_SETUP before updating root->last_trans, then clears the bit
after btrfs_init_reloc_root() finishes. However, the reader-side
smp_rmb() is before both loads, so it does not order the last_trans load
against the later bit test. A reader can observe the new last_trans value
while missing the setup bit and return before the relocation-root setup
is complete.

Read root->last_trans first, then issue the read barrier before testing
IN_TRANS_SETUP. Also use clear_bit_unlock() for the writer's final clear
and test_bit_acquire() for the successful fast path, so the lockless
return observes the setup done before the bit was cleared.

Fixes: 7585717f304f ("Btrfs: fix relocation races")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/btrfs/transaction.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8dd77c4..ac9ffa8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -454,12 +454,12 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
 		 *
 		 * When this is zero, they can trust root->last_trans and fly
 		 * through btrfs_record_root_in_trans without having to take the
-		 * lock.  smp_wmb() makes sure that all the writes above are
-		 * done before we pop in the zero below
+		 * lock. smp_wmb() makes sure readers that see the last_trans
+		 * update also see IN_TRANS_SETUP set, and clear_bit_unlock()
+		 * publishes the relocation setup before we clear the bit.
 		 */
 		ret = btrfs_init_reloc_root(trans, root);
-		smp_mb__before_atomic();
-		clear_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state);
+		clear_bit_unlock(BTRFS_ROOT_IN_TRANS_SETUP, &root->state);
 	}
 	return ret;
 }
@@ -497,10 +497,12 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 	 * see record_root_in_trans for comments about IN_TRANS_SETUP usage
 	 * and barriers
 	 */
-	smp_rmb();
-	if (btrfs_get_root_last_trans(root) == trans->transid &&
-	    !test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
-		return 0;
+	if (btrfs_get_root_last_trans(root) == trans->transid) {
+		/* Order the last_trans load before testing IN_TRANS_SETUP. */
+		smp_rmb();
+		if (!test_bit_acquire(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
+			return 0;
+	}
 
 	mutex_lock(&fs_info->reloc_mutex);
 	ret = record_root_in_trans(trans, root, 0);
-- 
2.43.0

