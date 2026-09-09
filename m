Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760EB37B021
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 17:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788974895; cv=none; b=cR8pMliEVnKP17pnpKCHI+E2X2HFDowIvMDrSTkvxanx+4F1y3aPxHrxzlP+fJVNbsHSj8A9lVMewlpAJ0EPcu3MWlOhPMgGnFS9erMCTvCoOv904Qn7QK9Vl7/B/nIwI9KgjaAGtFxrZDIjskjfyrmn4IqdY4R+jenUNA+0eUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788974895; c=relaxed/simple;
	bh=QrbEbgPSG0z47v2bXa6SPYsNvX3MgFOZpNHRMM9iCN8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=h4hm18SbQSkTtFElUeIXn+p2vtRJQLldh39Uj79EyjZ/HoxiO8n6WKQJBEnNkues7j/9Fx70c1+0JP2Q7E6ckmmLIWufXLb6SGSiypW9w2TnuqngsHHiEwy5dc1vbTG97HalajougYdoqEFhba5WJchrccZkpdq89i9qphFMIPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=fhZt67Ap; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DfrCGvjD; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="fhZt67Ap";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DfrCGvjD"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 4A058EC021F;
	Wed,  9 Sep 2026 13:28:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 09 Sep 2026 13:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1788974892; x=1789061292; bh=6NzV+WYxuux3UD7jdcZge
	AsWkzyRfb2X1ticK6UU2vs=; b=fhZt67Apw9E+oH1PVYQbxRRpCq2Yzxy4G7nBn
	kDbv34efOGw3delPpkQsQkHIggZhu349M2f0iILo0UvljXuK2rSVpbOPl5DLTx5E
	y83UQPXywEMUfmsysce/8VfywrOj4KJ+vfBdtIbRlmqG64lMM3Q+Lv6uzMKyDcHm
	tK9Pn21uyFK57TqbKXNNbfp6FvPalmp/6qmFo3XJ90h1eOlCC6us9CYmKDRURBkh
	a9ru4BtiLGT8G0rsn9ex336GrohiSgcofi3UAiv89UksIxTRfdGMObD7LDr13/Oy
	/kdLoePsJDdX7Sy4uRkFbw7XLtZNHXP3QfhpN5PDrrjAENfiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788974892; x=1789061292; bh=6NzV+WYxuux3UD7jdcZgeAsWkzyRfb2X1ti
	cK6UU2vs=; b=DfrCGvjDMAwc+v8fH6ovKGMYAXh8/hYmky0yCIoTxEAZHs+q0KW
	E8U6EtCGoYyUITV9jEW40056f0voAXcECMZZK2BFzuiaUJ7sMGibUsrYdqyu+XIP
	HMNwVpLsJExy1ZH7WbtALVOWnsuljcOtqRfLWFezwbxpELfv1dU/wz1kVRTmze3I
	iSxEBXIfogNEO9prP0dY7KiBsM0o2IL80UvwKr8T7y2iOggU838Bc9RaEt5gzt0p
	P7k6trxJ8/Ky0Kk7Lwe2HM9A+YN09ePFuXMcpKH6oy98J3rnKe8nFxLuDjaJ94Yd
	Sx+Xw0LPeugoy5WE+em+JMPpFtDMM7db20A==
X-ME-Sender: <xms:K5ehaoD11Kqe0x2N7EP7qC9xTmzsuGMFKY0y8JZ_uWrwL4PUEHiJUg>
    <xme:K5ehaggn0Tv8YkrPYnD7dSVlOAVPtLNzdc48EXEw5nX97mWoUxBbiIbSgk0nWcrTw
    CAjNX9bzTkH4nYNAEmu6oUWLKgQhFkwYuEyMC5JvZV3krU51OlJX3zJ>
X-ME-Received: <xmr:K5ehapPEx4BuqX6wcpOThIX_RTGdP9tSRvv18C03LlvZpMAaxSN2s3g>
X-ME-Proxy-Cause: dmFkZTFodWKmvLuxRxx8uhczVkuEuCJc/0SuVtKVgTR51BsHz0wN2Zj6Rh57asgN4Mi/bJ
    xiBbF9mB6k/56HZOi1Fz4WE1cIYEPYb25u1/i1Zh6jhN92LXvGBY2dYA+rt2+nXxm05PjZ
    rL+zwgoiCBgatqWOKq4ECYofmylq142aIbioEstb4A+PFPV4+rLxcCtruMNiBlgtatuIxb
    1y81yELVRZLweM0TwfUVHMPdJBbQ+zc70qZmYApSYTOMOPXuLF28hrvwuSnVfc+E/HKG9W
    pD+RuinFYfjIZT62ekXQJ+ogcWT7edG0ocI8HCvqy2N9DHwbRgEWq8etyVJSxDk/tyvFXb
    OJ5Nzlh+mbBKnGb5XendbwpAgOXNEGyOd1jvcfUM2ZN7bWqX6IdMHBiDWO/viqxgv27EN4
    Rnh8r6IIMticqB50MYSLV7XOOj2jUSbARRNs2OZgfg7D9PW+zTJ8dhV5rY7AR0h5CzT1We
    Vh0MYIscqf0bdfsL9JtGo5EkwsXwIOIrr5rBPq/dQwvOyEoBgk2Q5E/TvTbilhPNGIuF+T
    e89GGDTOBDuiI/+MU8gLF8EYo5PsmUpTzJz9xIuvUg/BvKzZO/VX0s2yTqZRYLW+6HZQXv
    5nGgkTRyw10gqxtD12UJtxLtpTOZ2t+B87Woslau7O83ja29pH5dsPTyxR4Q
X-ME-Proxy: <xmx:K5ehap4NCSkohKFGh1B1_RbdInnJzQsoafcJJ6ETbOMsIs4ojgJJtw>
    <xmx:K5ehav09hRaR3k95HMckKtLgUyjiaxUuUVHvY5ps92aVir0G3cx_NQ>
    <xmx:K5ehaiaeQHW6k2617JcsOB4hchcrAphgwPjysKI6Ljy3qRkbKAajqw>
    <xmx:K5ehavAsNpWb6H4zj3xSjgsNms6dfCZ3XLa8iyNfl77ou8qujpA17A>
    <xmx:LJehahE9nJ_enFwVjvI6kexNHjcCCiRR7wplc-Ml-1cv6m4fIeJsqxRB>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Sep 2026 13:28:11 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH] btrfs: downgrade the reflink source inode lock
Date: Wed,  9 Sep 2026 10:28:39 -0700
Message-ID: <65fa79581e1d29d6d6fabae71d23e741bff0ddf9.1788974902.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
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

One sort of counter-intuitive exception is that dio writes that come in
under EOF try to take inode->i_rwsem shared, which would result in
messed up views of the extents in the reflinked file. Therefore, add
"being used as a reflink src" as another inode flag exception for the
dio write shared tests that already exist to check for other dangerous
conditions. In order to ensure that this flag is visible to the dio
writer, reflink must first take i_rwsem exclusive, then set the flag,
then downgrade to shared.

I tested this with a concurrent reader on a 4G dirty source file
concurrent with a reflink and saw the read operation go from a ~1s
latency to milliseconds.

Note: if a writer arrives mid-clone it queues on the rwsem and later
readers will block behind it due to the rwsem fairness implementation.
Therefore this change does not rule out all possible reader blocking.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/btrfs_inode.h |  9 +++++++++
 fs/btrfs/direct-io.c   |  7 +++++++
 fs/btrfs/reflink.c     | 15 +++++++++++++--
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 46c62f980c24..fd137a466c9d 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -99,6 +99,15 @@ enum {
 	 * range).
 	 */
 	BTRFS_INODE_COW_WRITE_ERROR,
+	/*
+	 * DIO writes take the VFS inode lock in shared mode rather than
+	 * exclusive like other writing operations. We want to hold the lock on
+	 * the src inode shared for reflink, but that does still need to be
+	 * exclusive with DIO writes. Therefore, note such reflink src holders
+	 * on the inode. If a DIO write sees this bit set, it should take the
+	 * VFS inode lock exclusive.
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
index d2a4101912bd..e33926243030 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -943,6 +943,16 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	} else {
 		lock_two_nondirectories(&src_inode->vfs_inode, &dst_inode->vfs_inode);
 		btrfs_double_mmap_lock(src_inode, dst_inode);
+
+		/*
+		 * Reflink is a read operation on the src inode and a write on
+		 * the dst, so lock them accordingly. One wrinkle is that direct
+		 * writes try to take inode->i_rwsem shared so we must do an
+		 * acquire exclusive; set bit; downgrade to shared dance to
+		 * synchronize with that one weird writer.
+		 */
+		set_bit(BTRFS_INODE_REFLINK_SRC, &src_inode->runtime_flags);
+		downgrade_write(&src_inode->vfs_inode.i_rwsem);
 	}
 
 	ret = btrfs_remap_file_range_prep(src_file, off, dst_file, destoff,
@@ -960,8 +970,9 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 		btrfs_inode_unlock(src_inode, BTRFS_ILOCK_MMAP);
 	} else {
 		btrfs_double_mmap_unlock(src_inode, dst_inode);
-		unlock_two_nondirectories(&src_inode->vfs_inode,
-					  &dst_inode->vfs_inode);
+		clear_bit(BTRFS_INODE_REFLINK_SRC, &src_inode->runtime_flags);
+		inode_unlock_shared(&src_inode->vfs_inode);
+		inode_unlock(&dst_inode->vfs_inode);
 	}
 
 	/*
-- 
2.55.0

