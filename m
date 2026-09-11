Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322F627FD4F
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 00:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789086365; cv=none; b=BECoSwDgyOOrUbR+OqRlfSTW5qEEBFXa/TlBi6uFyYse7s9TkDcBKoLKOQx01KvAYIv9DA6LX167mS1MuZdpKLjhYC3USzNpwCwhB5FhZ8uDOlPsvy63rRniGg20Mb41YKs/FNm480tzXdvmXktchg3LTc1VLLDB7AWMIDaezRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789086365; c=relaxed/simple;
	bh=6VsOAQMwPT1oFBBsa18yKrzNuFANc4LBZAW0VkXCiIw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5/Wizr58HwSu1GssJv+WePcy4VWjVAmYURAbeFtGxX2hwatlFNEEKHLFR1tH5+wcdM5s2R6sP/qA7Y972E3CJUWE9R/yMqkHKEIjeDloRd4pUq5V2KVXux1Iobwip+xm7nV+bzsgnrXLDkEX9RJLmvegKafDgXX2RlJ4v2b6iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=DsjM7G/J; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Ul6DGiyO; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="DsjM7G/J";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ul6DGiyO"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4F1947A00FF;
	Thu, 10 Sep 2026 20:26:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 10 Sep 2026 20:26:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789086362; x=
	1789172762; bh=yn7ymOzByMS/lv4mJYWNCHdRJyH7NKRETdW1S/5Qs5Q=; b=D
	sjM7G/Ju9sYfyA6IabnmnekACt8HCWigtfAp4bYVLNV2LkxVQwNa83On7DkODLwl
	MP7gtVi7pVOfSN6yLIP7gENTqwjTc2seebP6zlCGG+vZnXzr8dR8Hz2pWT+Uj8JH
	Q8juFEVzCWL9yxpGtiFuM1ODfR9P7ehwqkjm/yzRq7Gc7Hd+jiasiem3bQieLkHQ
	lHB7aE5OfbySSdksWP/GlJxIke9zQ3Sre9eQUGYBpOFdV+KaM2Vfkibb6F1VivYf
	E94uEslNgexlT3WTupiPW69w/ULE0xerZIa34sX8LcFT42wPD57Ybk4vPOuRDni/
	Tdhz5pYsh7L2Z1oxZajcQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1789086362; x=1789172762; bh=yn7ymOzByMS/lv4mJYWNCHdRJyH7
	NKRETdW1S/5Qs5Q=; b=Ul6DGiyOww0ap6r08I1wCYjONOIliF3CgDu8vXZDf0zk
	mgwWOwmDFoHYa++cyFWeN6hL7aQ+gZgGOn7rrhoFKfsAdoTjwzfDOeSD9Nw3KOaO
	Q4zeyF3FBLXHX7u6tTzbwQrl2sT7dkUroUQbg49Q9mN9z876Ps763dtbG4n9sbI0
	gdvkmBdstcwH9USnWGiBskZwKiEw7WUG/fKrD2LG9SlUihxb9AEE6WYSOVdsyWjl
	gJEuwTvRbcqRZPSiYJNA7R5A9znTVA0t1i3gL94jbVr00AtZpacHBjn5nLCOLd05
	g4peh9HuB4ZUZo6740S+pMF0+4SQBj5BDKu+wVzPtA==
X-ME-Sender: <xms:mkqjaq2fFD8-Y4TtEVk8v-FiMHaTblbG66dG1OBmllDrb3aTJI6qVg>
    <xme:mkqjajEKTXWy__d34BbuCim0EM0M2BbQUixrRQHiHg2MYdFxJ0p7eaRxNqP6ItCkd
    eW23SP7oSQ-j2Y6WAO9n841kt4fm9E_TqDEiw44lwbz4UQ9DLFM_32F>
X-ME-Received: <xmr:mkqjaghTakC3xQ6gnw_X7Be0XTDhH-6rrIBgrZ-oueKx6V8YarTJkiU>
X-ME-Proxy-Cause: dmFkZTG0Q3B5PBW5Xp+1KKG6/++KrTpZKC6wtfqmOinzqQW+KAbeF+f7Hw3YY7gpCmUjUH
    aBuHVCUK+s+glbMAv1F527tdaKEkxcKuyeSKWYgTJfpIv5GaLLWKigXrUO7ZSBTBAHkXAF
    7x6+Nse5eNCnkEuijA6Ms27XjDTKY4urvwcNSBmS8G6wPM4qNmpZurV8pSa1vlnX+ZfdOR
    1VGcUaB1OgM4rlWevV1laUVfSeRtko8tmooAbRxFf4Fbr8GANx2MmQgNyYGg6ODov5TWJg
    +AIdHF2armVU0mPtRAlm5KDPLIWL/IPeIofvBZvSs2IFVp3IKllhKE3+8UtzDcFLyJQYpc
    INAppx4B2FHWTv5b2DtwTTcLpS4dXoMmy7vy47gfAUB8Q9rH19yNAAKFiA6h0RmA3KXaPM
    ljW2PxKPuq3mLgMiHVBsdWLMdC23dMsmNfi8b5wX5JQpQi6rol7q35TLKlrC9KDXmO84Db
    CqX5pegA1p+s6PVB7CQU/1t9/nQljlgNJ4IgJpl1TUPWv59OxFbZgvK6fhfee3NdlkxGTk
    1O1JlMKAivJiyLlsLUVe0rEnDi+z8BnDq604CdYzLd9lsrQSZ3wNcN36SsV9DgkoK4PxkE
    RunPdui7ftudBRQ96X3ym1Vio8Ef6u2ARcyrooipJi+nC8ZLOePDlCh2G1Qw
X-ME-Proxy: <xmx:mkqjam_TGJcuyV25qa4F178mozE9cX5Zyhvt499e_XVHB5G-qtC4SQ>
    <xmx:mkqjavo9ormmahGG2IhiJAcN_yIyBrGLi-VRq5eIPkofpw2dp0_S9w>
    <xmx:mkqjat_q0lkdIREhW-dOFZm-peJfHDXZrHiJ6c9Crkd8Y9vHPaRhqQ>
    <xmx:mkqjarUN-4At4BRatWiOPx8tgBjhjG2cu9mL0IeIDtjhA4jAP39dcg>
    <xmx:mkqjavokFGCTu41z4iS5xPm9vyZPK40mzhH_ZNcjnhC0jlmlZeGaR23V>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 20:26:01 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 3/3] btrfs: downgrade the reflink source inode lock for tree walking
Date: Thu, 10 Sep 2026 17:26:19 -0700
Message-ID: <e3991ac1f46148967e6b76b6c1a39c79307ab949.1789085863.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789085863.git.boris@bur.io>
References: <cover.1789085863.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When doing a reflink, we are not writing to the src inode or modifying
it in any way, so it is counter-intuitive to have to lock it
exclusively. This has the cost of blocking other shared lock users of
the src file for the duration of all the writeback and reflinking.

There are two important gotchas to do with direct io that must be
addressed to make this idea work.

The first gotcha is that dio writes that come in under EOF try to take
inode->i_rwsem shared, which would result in messed up views of the
extents in the reflinked file. Therefore, add "being used as a reflink
src" as another inode flag exception for the dio write shared tests that
already exist to check for other dangerous conditions. In order to
ensure that this flag is visible to the dio writer, reflink must first
take i_rwsem exclusive, then set the flag, then downgrade to shared.

The second is that dio reads increment inode->i_dio_count which blocks
inode_dio_wait() in __generic_remap_file_range_prep(). Therefore, we
must remain exclusive to dio reads through finishing the prep or risk
starving the clone on a stream of dio readers. There is still O(extents)
work in btrfs_clone() which can be done without holding the lock
exclusive, so we should downgrade to shared and admit dio readers (and
other shared lock users like lseek) after we are finished with
inode_dio_wait().

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/btrfs_inode.h |  6 ++++++
 fs/btrfs/direct-io.c   |  7 +++++++
 fs/btrfs/reflink.c     | 17 +++++++++++++++--
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 46c62f980c24..03c00c99099d 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -99,6 +99,12 @@ enum {
 	 * range).
 	 */
 	BTRFS_INODE_COW_WRITE_ERROR,
+	/*
+	 * Set by reflink while it holds the source's VFS inode lock shared.
+	 * Direct IO writes also take that lock shared; one that finds this bit
+	 * set after acquiring it must retry with the exclusive lock.
+	 */
+	BTRFS_INODE_REFLINK_SRC,
 	/*
 	 * Indicate this is a directory that points to a subvolume for which
 	 * there is no root reference item. That's a case like the following:
diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 3075d7992713..ed3914257d39 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -913,6 +913,13 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 		goto relock;
 	}
 
+	if ((ilock_flags & BTRFS_ILOCK_SHARED) &&
+	    test_bit(BTRFS_INODE_REFLINK_SRC, &BTRFS_I(inode)->runtime_flags)) {
+		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
+		ilock_flags &= ~BTRFS_ILOCK_SHARED;
+		goto relock;
+	}
+
 	ret = generic_write_checks(iocb, from);
 	if (ret <= 0) {
 		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index abe44769179a..22c55633cfb4 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -970,6 +970,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	struct btrfs_inode *src_inode = BTRFS_I(file_inode(src_file));
 	struct btrfs_inode *dst_inode = BTRFS_I(file_inode(dst_file));
 	bool same_inode = dst_inode == src_inode;
+	bool src_downgraded = false;
 	int ret;
 
 	if (btrfs_is_shutdown(src_inode->root->fs_info))
@@ -1005,6 +1006,12 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	if (ret < 0 || len == 0)
 		goto out_unlock;
 
+	if (!same_inode) {
+		set_bit(BTRFS_INODE_REFLINK_SRC, &src_inode->runtime_flags);
+		downgrade_write(&src_inode->vfs_inode.i_rwsem);
+		src_downgraded = true;
+	}
+
 	if (remap_flags & REMAP_FILE_DEDUP)
 		ret = btrfs_extent_same(src_inode, off, len, dst_inode, destoff);
 	else
@@ -1015,8 +1022,14 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 		btrfs_inode_unlock(src_inode, BTRFS_ILOCK_MMAP);
 	} else {
 		btrfs_double_mmap_unlock(src_inode, dst_inode);
-		unlock_two_nondirectories(&src_inode->vfs_inode,
-					  &dst_inode->vfs_inode);
+		if (src_downgraded) {
+			clear_bit(BTRFS_INODE_REFLINK_SRC, &src_inode->runtime_flags);
+			inode_unlock_shared(&src_inode->vfs_inode);
+			inode_unlock(&dst_inode->vfs_inode);
+		} else {
+			unlock_two_nondirectories(&src_inode->vfs_inode,
+						  &dst_inode->vfs_inode);
+		}
 	}
 
 	/*
-- 
2.55.0

