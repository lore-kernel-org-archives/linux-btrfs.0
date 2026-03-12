Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F673282F37
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 00:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773274493; cv=none; b=teJk8yOzbaEtl7++IIT7vssn3J4qN66g42xAWazzoTvSP7FaHOUhENpWyXSm3xRpa33TUqNPMRCO75i0hk6Lk0UMsQVFSX4Q29LlTf5QBrOTaIW4jv/UhcaEWWzu7Hf/hubKYedU2Y8NknsIHKHJ+dWbbrJTQ2uJ0xYb9lkc1aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773274493; c=relaxed/simple;
	bh=VU9hS4DshrqjC9KyJtG7jj7YVnllYQOO9wjLpFxgylA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C0CAcoIKy/7amSCfTfG50vGwajJ1T6hhFLEDEmaIvdBJDX0qwFciEy/47U6CULGnA8P6WzNdThWhvZJO3fD3nkF7WSaCtinuYKCm6UgN3u9PER1I9gCjZGBnbVecYQH90fJTi7tQlusnOIeuT/0qNsh9ZmNMvyVuRTtsFr9aqXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e4rGmvrl; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e4rGmvrl"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ae8979dbb2so3512955ad.3
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 17:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773274491; x=1773879291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KGcYYewbh7c7rM4xdHWS6lIG0/xScOPJj7plS5pDbyU=;
        b=e4rGmvrl93bdeF5oLhBinfUWAL/b3rcPQCtTBSFIcOzxxfKDBxT45bmFCoplzdWG2F
         8L4sEUG7dLIRpyDFOhi5/ozMYyIFLnj1MV0tHblvmtJrmdv0mU22E4FK14QTGsBc5USG
         JbT4Wynsqxer8t826NexplNlLt2S7rC6z6Jc1dHrWygrVLHzEouC4P6zD0/oMhqs0PQi
         kvaHrOPFbFmt3aAtTMMkmT70ulsmYdTc0Og2IHfeUG3IKgcaG08h8SPme2R9g4LNSRs8
         TO4+4AG6TFU2pBgKhGuAl+5ilgqtDCQ08RWQdgHHX3WQfpmdpZr42zs3vXMQK0lv1zz8
         4LMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773274491; x=1773879291;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGcYYewbh7c7rM4xdHWS6lIG0/xScOPJj7plS5pDbyU=;
        b=L1SCv7EpjOseadppqospVXXnZNjzN++LFsmraqNKf7B0Pek3hMlbLKsGwfmUKFXLNf
         LqcaDKujuL2GylqAyF5BWttpJnAou1mqyTYONAfZulKmDgZsAMIU9p9VnxGNLKVgdQOc
         xCb1cKYFWhqprASgO+a4cCbTbQVi5LqKPjvmNK1+HPWH3quPV6WI9NMhOM+381JuYMNe
         O/LWYyczr6On6lemkKaXctcv3QILhf6Jjd1BgZX/JQXSK5Cn7bZ6cZ3+/pNcdY5EUwMU
         IMyGp4zLZAqOzszg/JADLDcTfIq9o/AQt4FaTT+3sb1zJYG8z5Hd+ZVgxfdy8dHqnwUI
         pO+g==
X-Gm-Message-State: AOJu0YyTqWpBWpYsWrjQQV9VWpZ/ROV7AlOkxXWy6Ckdoqn11wb226Xb
	ArzbpNLezIYDqTcb68R1SL2n43XAXffnbeBjbJJ4nfnfZr0hg72Z5PyZ
X-Gm-Gg: ATEYQzyoItlT8iYNoLvdj5CJIYSchqpLsmm4sLwbmpVMoKKqUexGmSPUy3jqq239y6O
	OaFXoJSu5/JVeBOj+YHTg5yqvU5qymjFHl47ma/09+w3XohTY/HCqYiAZwdf2Ml+0TNzwUpo9iU
	CfYQtW4ikGdyQ+CrYbh6NUPSyfbhIzIJsHTFrPfDXng/8Ph6gvrZY9lyd23wfBUeJQZQd5UIu58
	MhXGwCVef3ahs7hYtVsmI6sVBVtHWxmO6WYg3gFwAwFbHbbDsEl8oZwjl2sanl7fung3OXyEgNM
	qqe1UOJfsN+UQa9KyapASr16wCtUbKwBkaA4IIOHi3LNuOlA/5b/S2TBip5WGcx1IQ7tPkCn82Y
	EHCJGU0ZgNEFYjm7cKHd4BtJXStzBsJsidHzS3hT5U7PsqFICzhHme8iVYfoeqf0cPsUkMfrlNE
	piVehKrmxvS2pL7A9Zt9voTU+LwuiVLGSq/Gfe7l3I1y1l4KNod/b79VrOVANifau/+s4fXg==
X-Received: by 2002:a17:903:8c4:b0:2ae:4dce:7e92 with SMTP id d9443c01a7336-2aeae7cb944mr44962445ad.14.1773274491119;
        Wed, 11 Mar 2026 17:14:51 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae35f0dbsm34835275ad.69.2026.03.11.17.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 17:14:50 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	wqu@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] btrfs: reject root items with drop_progress and zero drop_level
Date: Thu, 12 Mar 2026 08:14:43 +0800
Message-ID: <20260312001443.3011961-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
When recovering relocation at mount time, merge_reloc_root() and
btrfs_drop_snapshot() both use BUG_ON(level == 0) to guard against
an impossible state: a non-zero drop_progress combined with a zero
drop_level in a root_item, which can be triggered:

------------[ cut here ]------------
kernel BUG at fs/btrfs/relocation.c:1545!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 283 ... Tainted: 6.18.0+ #16 PREEMPT(voluntary) 
Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
Hardware name: QEMU Ubuntu 24.04 PC v2, BIOS 1.16.3-debian-1.16.3-2
RIP: 0010:merge_reloc_root+0x1266/0x1650 fs/btrfs/relocation.c:1545
Code: ffff0000 00004589 d7e9acfa ffffe8a1 79bafebe 02000000
Call Trace:
 merge_reloc_roots+0x295/0x890 fs/btrfs/relocation.c:1861
 btrfs_recover_relocation+0xd6e/0x11d0 fs/btrfs/relocation.c:4195
 btrfs_start_pre_rw_mount+0xa4d/0x1810 fs/btrfs/disk-io.c:3130
 open_ctree+0x5824/0x5fe0 fs/btrfs/disk-io.c:3640
 btrfs_fill_super fs/btrfs/super.c:987 [inline]
 btrfs_get_tree_super fs/btrfs/super.c:1951 [inline]
 btrfs_get_tree_subvol fs/btrfs/super.c:2094 [inline]
 btrfs_get_tree+0x111c/0x2190 fs/btrfs/super.c:2128
 vfs_get_tree+0x9a/0x370 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount fs/namespace.c:3718 [inline]
 path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
 do_mount fs/namespace.c:4041 [inline]
 __do_sys_mount fs/namespace.c:4229 [inline]
 __se_sys_mount fs/namespace.c:4206 [inline]
 __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
 ...
RIP: 0033:0x7f969c9a8fde
Code: 0f1f4000 48c7c2b0 fffffff7 d8648902 b8ffffff ffc3660f
---[ end trace 0000000000000000 ]---

[CAUSE]
A non-zero drop_progress.objectid means an interrupted
btrfs_drop_snapshot() left a resume point on disk, and in that case
drop_level must be greater than 0 because the checkpoint is only
saved at internal node levels.

Although this invariant is enforced when the kernel writes the root
item, it is not validated when the root item is read back from disk.
That allows on-disk corruption to provide an invalid state with
drop_progress.objectid != 0 and drop_level == 0.

When relocation recovery later processes such a root item,
merge_reloc_root() reads drop_level and hits BUG_ON(level == 0). The
same invalid metadata can also trigger the corresponding BUG_ON() in
btrfs_drop_snapshot().

[FIX]
Fix this by validating the root_item invariant in tree-checker when
reading root items from disk: if drop_progress.objectid is non-zero,
drop_level must also be non-zero. Reject such malformed metadata with
-EUCLEAN before it reaches merge_reloc_root() or btrfs_drop_snapshot()
and triggers the BUG_ON.

The bug is reproducible on 7.0.0-rc2-next-20260310 with our dynamic
metadata fuzzing tool that corrupts btrfs metadata at runtime. After
the fix, the same corruption is correctly rejected by tree-checker
and the BUG_ON is no longer triggered.

Fixes: 259ee7754b67 ("btrfs: tree-checker: Add ROOT_ITEM check")
Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
[CHANGELOG]
v2:
- Split out the error message fix from the previous patch, as requested
  during review.
---
 fs/btrfs/tree-checker.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index dd274f67ad7f..1e052c3303b3 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1260,6 +1260,23 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 			    btrfs_root_drop_level(&ri), BTRFS_MAX_LEVEL - 1);
 		return -EUCLEAN;
 	}
+	/*
+	 * If drop_progress.objectid is non-zero, a btrfs_drop_snapshot() was
+	 * interrupted and the resume point was recorded in drop_progress and
+	 * drop_level.  In that case drop_level must be >= 1: level 0 is the
+	 * leaf level and drop_snapshot never saves a checkpoint there (it
+	 * only records checkpoints at internal node levels in DROP_REFERENCE
+	 * stage).  A zero drop_level combined with a non-zero drop_progress
+	 * objectid indicates on-disk corruption and would cause a BUG_ON in
+	 * merge_reloc_root() and btrfs_drop_snapshot() at mount time.
+	 */
+	if (unlikely(btrfs_disk_key_objectid(&ri.drop_progress) != 0 &&
+		     btrfs_root_drop_level(&ri) == 0)) {
+		generic_err(leaf, slot,
+			    "invalid root drop_level 0 with non-zero drop_progress objectid %llu",
+			    btrfs_disk_key_objectid(&ri.drop_progress));
+		return -EUCLEAN;
+	}
 
 	/* Flags check */
 	if (unlikely(btrfs_root_flags(&ri) & ~valid_root_flags)) {
-- 
2.43.0

