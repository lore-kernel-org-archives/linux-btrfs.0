Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7989B3A0E8E
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 16:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058107; cv=none; b=LfRFfuPgbCzTHaBoKIKEzCvNl0LQZ+kD3gYiGwLB4dMQWTi3BDt0feS1btmL0C5LBz0THzuf+RDY0manwEl6vgB4Rotni6+zLNCF5ksfhZWFVZtne+qpcEEzPkg30b6GpapMkpSCqTAsXZlfffMz+cP5H0sXs31UCHtfxGcKvq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058107; c=relaxed/simple;
	bh=i6/pO0AbZsj0xZb/fRwmxi9bkzNXRm/z6MM+q5iP+7Q=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Hh6ovaKMFjtkkUInTJjBGcyeYuQfzuSgYDrcaXN686sQ0zzSyoserf7R/GdYhrN5L09zJif3/89SNqlFgSlbDeaerH37OSPIOCLbAjBIdLpzCaQ+CWkiyjGZpr4OhFsy2Erro4GsVd7ZhLrJviAelzFGxz+drjKsm6CSaP+6tdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K16I4eh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K16I4eh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8721F000FF
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 16:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789058106;
	bh=0zbvgAzWxWWvGvKWQiqV13uqRAOo+2P/8Y/dp9LCXJY=;
	h=From:To:Subject:Date;
	b=K16I4eh/M7uuyfzKa1JPG/YPjHQ1WheJ4hKxK/5B/f/8G5wsp94DVXp9O4ywGMOkD
	 gb6deSnEWJwkP6c2ocfRDSy1AXZjN0HOLZnH+DPw7+bT8mw0clc52aeVe8vC2xsvoy
	 XtscsQShgCYWVR9elNNNeoyGN59/o+DtTigatdtj++EiohVSmxwRkSJz9lYa+inK1h
	 uAiDn4I9ZjW+Odq45IIA/z4W18qfkvo7IpwOLU12+9m97Y8/xkeM/Ep47lI75YU4BX
	 AuIBZgWZH7Qbc6xuSxZydLprDZcNESAW46GzD6bDIkjwIGHI5Ai97c6aVOh0lhjaM/
	 16KVL8u7CQ5TA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: increment extent count once when logging extents during fast fsync
Date: Thu, 10 Sep 2026 17:35:02 +0100
Message-ID: <8f8353e08021070f6d5667386705d6b0d0dbbc47.1789057819.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

In btrfs_log_changed_extents() we increment the extent count twice, and
we then fallback to a transaction commit if the count reaches a threshold
of 32K. However we increment the count twice, which is confusing and
pointless. So increment the count only once and reduce the threshold to
half (16K).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a00094604e54..6c6b362d7f4c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5350,7 +5350,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		 * have a bunch of extents we just want to commit since it will
 		 * be faster.
 		 */
-		if (++num > 32768) {
+		if (++num > SZ_16K) {
 			list_del_init(&tree->modified_extents);
 			ret = -EFBIG;
 			goto process;
@@ -5368,7 +5368,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		refcount_inc(&em->refs);
 		em->flags |= EXTENT_FLAG_LOGGING;
 		list_add_tail(&em->list, &extents);
-		num++;
 	}
 
 	list_sort(NULL, &extents, extent_cmp);
-- 
2.47.2

