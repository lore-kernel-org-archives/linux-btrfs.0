Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1440409128
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 17:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781545309; cv=none; b=hWokVCvboD+fO+MggTShkx2FuYRnHk7uPCgOwB37sGztvTR5jj92NUWTSRT77wwAZL/+hdsMJaJjqzHyeFiTASkN17om8GPkm+ZYwlTwcUMOtYmuRB5uJSxhAmKBpdDuP4H6e1qF2GmVOizq3G6br+pvhYjGXc/SqK35KQosb5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781545309; c=relaxed/simple;
	bh=Ax9P0kQAclkSkVnMTh75wODcAn2FO381dFdBC1Wbmhs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WdAAAgdOLu1SQvG18pF3namXKIdOZNpBxVnOTqOId7dUul3wcVm6w8MyFumEmTC5yUhO36xC1c9IVFKL1i+cPpZWPyVrGMA+qvICtr0ebHp8NB8yG/FbE4L9XuuuFL3bUog+Yq566n0m2lUXAdvjzMstfZf6dVc9C8F+rpMV2dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=QnOKgLQ7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RrJAA2h/; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="QnOKgLQ7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RrJAA2h/"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 24868EC0120;
	Mon, 15 Jun 2026 13:41:47 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 15 Jun 2026 13:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1781545307; x=1781631707; bh=7/ab26w8bKuBnAihTtVB/
	Cb+EP0A5XTS0KWby+n73lQ=; b=QnOKgLQ7S522Eptmt3UpiQ37EUqyIacg2OgP1
	Eyx5J3IlGycjnkq6U1gst0hKEiqgYvQNAvS01OVn8ui3DZbOOStr0AAiPS1s6YFd
	z0VA7ySvDGBB6B0at1n4LqZQJy5C8yVel9/Ya6FCP/aK0op7J0NriSRitldTIlR/
	LUgwGzzhAy7CKyw/mjElPdmix1kUj0KtgsQmnQvYxuz9gdwZVeHZI49WhS/BPeEq
	S0hB3r8TDei2O+75ZG663TX5jZt1Mp2aW7Ojg3GtFa34RsObaltbyW4/KMV2lCNZ
	2sTTof5Zyey6ldAxYur9vqrqTzEcf3o6OyQyQfyZQYEwYfpAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1781545307; x=1781631707; bh=7/ab26w8bKuBnAihTtVB/Cb+EP0A5XTS0KW
	by+n73lQ=; b=RrJAA2h/xpOUx0o9FbWDpEFLhg+DQ3aFAn/9gkHzncK3SlVio7O
	2x4FKLITy/TsSraVnbGOqpG/FYbqQm6xizUvn8vPzMwm9DIiWqNDyoN/3YznGBjj
	nk+Vz7/BFrcmRJf6641sODrja+vufxoCiuQPb128OzeaMaZd34sgTWsmdIKoI5SQ
	DLHJGyno1rpQ2MffvK0HlNUCrKrbvtLAbv1Hrp11TvTvWK31aKRdq+TgOKIVWoqA
	o/X3MfT/Jk1qQSUsuxsa2zs9Ry8FcOTk+prWD28aMTUyjdlY98C3ul3lK3L8MmgT
	SYddnQ/s0Yui0Cvnqmb+l7cpbHQo70agY4w==
X-ME-Sender: <xms:Wjkwav_eYrZF5MSF27FOB4_ey8-AYLXSCrLhZC-uwHiIp56_KRPLfA>
    <xme:WjkwahusGQoFekQe6XQ5QpPy5RW9WsIAmFc0OrR9hkqzlM__w4xvoaFxIZqx27fG4
    ZSuAVbEovX1Rlr-H7Y8fKKJTJtZdjH6qYCHK-hMAq8gZPMuEoSWsQ>
X-ME-Received: <xmr:Wjkwaqp_u6QeRSLvfqYl1T1NDuA7Wh9stj8uy6GBkt-8LhOIHYGgNhI57HdJjk_9d42dJiE6Xxq_sBDzAXdktGI4YHQ>
X-ME-Proxy-Cause: dmFkZTE/Kr45y3IvMUb0zfrZ/6AXkHB5SeOtTYB+b6orQWzuZ9kpnlhDgc+PtbyC7uxb93
    4ckTgXcCRamERA3AzIDHisW8bM4wEiuxTHd3TdwUC/DHKVoDNHNBaOe4FJLouiNY4DavEf
    gRce/0vEHtjmQZSIFDtyYbklXWNnqpnkVn2Rr4kAHrXHrCY9aOuOB4h7WjSGShQb8fVI4z
    erT9MjCS9S+DvI+9LHSRV0Coc+XKmHVUBYU1/HXjyCTnpZkpzKB1Gcliz2I0zkpXEACA1A
    i9P8iN6wdawhhcMBC2Bvkc4OMHVU4Z56w8Kk9QbnaG2Qe+MtdBIddOwuYoADhiqtoD1ARL
    +tD/nU8R0I1FdFdae+l8rqRkqGHBSydsL1s2IZaE3XRRcVFpssCt0YGrBNLsa0V+4LDrqe
    9l2HJNkxg9vc6ih9wfEaitTatSSH6C8gv65VlcMGf9lE37MpNR9EDlGBs7jHfUh7z859ck
    g1gJc1pyTLJ+Ak3sIIuiP4YWgWlWYC87P/426Ec0DYU8+EKtprH8MF5buatkOQJfaULSQ5
    X+EyHpxzkJKuxRmSYw+q6vBhlzN4QTpGacPVsvkuZ7mFu1i9A9xxE/xpjlHDh05kX332q7
    9g2GDkuvAGvjfJXkkCj5J/QCj5zcf6aAcrE+0zTvTRROdadSecU49Tz+TbrA
X-ME-Proxy: <xmx:WjkwamlgGt0d-1P995EDWTCMsn5rHvYNvaQ7p_3MnXk79PPq_O-RJw>
    <xmx:Wjkwamzga69G-xIz7GAiOM1_gqpCQrBY4FO8mj4OqICbFeIZ2f_W1w>
    <xmx:WjkwammBt8X3Wl8W9TDXiTR748yXGckMxA6enE1krsyvbST978FqJQ>
    <xmx:Wjkwancix0Mjzc6iLkoMo0bN4YTlNbd_Es4qsvPaZNoeeQjIbV3SyA>
    <xmx:WzkwarjO9u8SFup9ZuilvN9Ahq9U2oF2_Iy_AxwDJh7Hw4aZJmqaNp06>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Jun 2026 13:41:46 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v3] btrfs: release extent lock per folio in readahead
Date: Mon, 15 Jun 2026 10:40:59 -0700
Message-ID: <1cdab9f1329c31c69b3d9ef6ec19977004d1bc57.1781545249.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In Meta production, we have observed a large number of hosts running
kernels newer than 6.13 which hit hung tasks on
btrfs_read_folio()->lock_extents_for_read(). Looking through the history
in this codepath reveals an interesting history.

in 6.12, we merged
commit ac325fc2aad5 ("btrfs: do not hold the extent lock for entire read")
which holds the extent lock very narrowly while looking up the
extent_map. However, this proved to introduce a serious race with DIO
writes which was fixed in 6.14 with
commit acc18e1c1d8c0 ("btrfs: fix stale page cache after race between readahead and direct IO write")

That latter fix subtly changed the extent unlock point from the pre-6.12
regime. In 6.11, each read endio unlocked the extent it finished
reading, but in 6.14, the extent is locked/unlocked as a unit around the
entire readahead loop, while the individual folios are still unlocked as
the endios finish. This is mostly the same behavior, as all successful
reads will populate the page cache, so subsequent reads won't enter
btrfs and hit the extent lock. But in the case where the readahead
fails, perhaps because of a memory allocation failure doing compressed
reads, the page will not be brought up to date and a later read of an
overlapping range *will* block on the extent lock.

Why is this a problem?

On sufficiently large loaded systems, I have observed that direct
reclaim can run for minutes. Given that, consider two tasks on such a
system reading an overlapping range of a compressed file:

  Task 1 locks the whole range and starts to read. Some allocation for
  the compressed read for folio F fails and we carry on while holding the
  extent lock for the full range.

  Task 2 wants to read F, which is not uptodate and in page cache, so it
  blocks on the extent lock held by Task 1.

  Task 1 keeps getting stuck in direct reclaim (likely, we already
  supposed an allocation failure above)

  Task 2 stays blocked on the extent lock the whole time.

If you consider the effects of readahead_expand and imagine a file with
a 128k compressed extent followed by many smaller compressed extents,
you can imagine that the expanded window will result in subsequent reads
hitting many extents (128k/4k = 32) per lock window in the worst case.

The system likeley wouldn't be all that healthy anyway, so this is
likely not a critical improvement, but it does alleviate this one source
of stress and one thread's slowdown escalating to others.

To bring this behavior back to the old model, we should unlock the
extent at each loop of the readahead loop rather than in one shot at the
end. This allows such overlapping reads to proceed as they should.
Writes are fine because either the page has already been read and has an
appropriate state in the page cache to be invalidated (or not uptodate)
or it is still-to-be-read and the extent lock is still held protecting
it.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent_io.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ce9aa0f6bc35..e0d24e69441a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2745,12 +2745,23 @@ void btrfs_readahead(struct readahead_control *rac)
 	struct fsverity_info *vi = NULL;
 
 	lock_extents_for_read(inode, start, end, &cached_state);
+	/* We don't use cached state for a bulk unlock, just free it. */
+	btrfs_free_extent_state(cached_state);
 	if (start < i_size_read(vfs_inode))
 		vi = fsverity_get_info(vfs_inode);
-	while ((folio = readahead_folio(rac)) != NULL)
-		btrfs_do_readpage(folio, &em_cached, &bio_ctrl, vi);
+	while ((folio = readahead_folio(rac)) != NULL) {
+		/*
+		 * Read start and end before btrfs_do_readpage(). It unlocks the
+		 * folio, so our reference might not be valid after.
+		 */
+		const u64 folio_start = folio_pos(folio);
+		const u64 folio_end = folio_start + folio_size(folio) - 1;
 
-	btrfs_unlock_extent(&inode->io_tree, start, end, &cached_state);
+		btrfs_do_readpage(folio, &em_cached, &bio_ctrl, vi);
+		/* Only unlock the range we locked, even if readahead expands. */
+		if (folio_start >= start && folio_end <= end)
+			btrfs_unlock_extent(&inode->io_tree, folio_start, folio_end, NULL);
+	}
 
 	if (em_cached)
 		btrfs_free_extent_map(em_cached);
-- 
2.54.0

