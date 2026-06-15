Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AE73F4840
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781540154; cv=none; b=PciccZa1vC4thyPy+7bGaIY1y/pkCRlaj7PcvrCPKW6HyiL+dmns8+CxCiMCzc7OIIuGeAGS1Qhb+gm0sqKBl23CsYIxCG/vCloP22grb61zft5/frr3mQnuEYpi6KF2EijNQZn/nsRtLBbUjvVKs+F6QuWfF28U23kiafLU3e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781540154; c=relaxed/simple;
	bh=7mzkMOqLij5SVCfAYqCN5JXb+N5bDbiGYbppNLgGLWE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=P0qYgGJ0D5AaN1YWoMIapiUxKxp7GRiSFAFjIRT0yvfxENY+Dmb7oYsRVb4JG8GGhPi3GlIxy2vASLe3dfZ3g2GC7su6N52PPeWuiOJandRZm+9OtaceGYwVcV1TVYPZyt7RpY67nd20mv0Dk1/lEqMNcwHc9nTmk497PAUIAFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=pG4zy1ih; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=aYjoTidm; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="pG4zy1ih";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aYjoTidm"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 44614EC0139;
	Mon, 15 Jun 2026 12:15:52 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 15 Jun 2026 12:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1781540152; x=1781626552; bh=EUe12VmnhlSDEbNc8/LYr
	qFhzbnEIyoQDeV9pRE9n0Y=; b=pG4zy1ihD9ldgylQsmXoY6kF5BenYMXePbNvy
	ITctVRZZZGtiIudc+hz57NT5qmglmmUlvs9oneHnrEcv2wj0W88ev6orq+McxrwJ
	l+PDTr0nCnPPnvkDoz/iHLAzqU9Bb99mNzYKyBg6q2Ublvlm2xgJE6Lnd8HPos+p
	83ovxmiMUHgneA8+AxQRiShDL6EXdyIChiMqX3eDqxMD8+PARy6+aN3YpRqdsIUn
	/MjwtDpr52+H2phWbbC5h5wptVoaovWoytjUJIj/gdMqduMO1O1L9ZQMBhfw1iT1
	O895JD0g3W7iD/sUpikYK6Xz8b9N/LRMY3iRtecraSb6Pw2Eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1781540152; x=1781626552; bh=EUe12VmnhlSDEbNc8/LYrqFhzbnEIyoQDeV
	9pRE9n0Y=; b=aYjoTidmDyhTD+yptLHH0KdIikzd9WhpSvxXCk0yXTmnNn8CUhc
	pT0OjD/MbSei/ns6aE8y33xlNcFVaE0lTK4N9GMhkSGSqN6ijFTQ4yg1BSxlLvUu
	XEAYqkAofOZZ5vR+UB8tsIlX820H3rdluHqPWx4sZfmnSN1IR4QAt77iYJJA7XVu
	dg0LeKDHc5N1O3voL5EkBaifYvdxPgQFoDeksCiksmP1xVk7t/CB/v9V2cACM8T2
	oo3balTxsZOZl1O3OpD37vyMR6TB3GWDVRi5EOcTakBlVQqYbcsDG0KF1ARYHHnD
	et6wGNapK7YsFPqcSXj5WhI+3XAzPEpuoEA==
X-ME-Sender: <xms:OCUwas3y261FJ0Ezy07e-9KfdLHEqjlrKfUB8-2rLfHmtpAK7YWwiA>
    <xme:OCUwatEuWhZ_lanlyTcn_JTl3Nq0cv2TZxnIgBaky71D6bmloFmxfjS7tl0HLrMnY
    lud6X6XDmqAKRJMwP_Ri3im7XkySk0DeADMToaiarOUJ7Zfu3MhGg>
X-ME-Received: <xmr:OCUwaiiraiXR63LO5c4pBDPXB3ZnwiQ0Gb3C90i1VBRNYFtZ34r0eXdNkL3ZfO4Djg-dliU_Vx3KL4UEafSbqMHZtk8>
X-ME-Proxy-Cause: dmFkZTG2GowlDI2p+W/0JZDp7JffZO7foVBlUnA5wovdbtr3seKQHEFEs4zppki8ME02fU
    DdtLOOGGetJAa7U0kzTyuJtv7ynDdRkXm3lfrQHpaj/bPuc/zjZz1VuO9rkdsdxZk/LI3R
    OP1F97yLJUFcmKi0bHvAPcoifYDBGFpaTQlRi2j5bEiqCLe3Oit88aez2DVW2hs9TK2EL9
    5ZoZNfj2MbL6VreT/viQ3f194cclwb/CEr7z/oP6rTZPuMQB5g3doSfnx47cO28zxDnsqX
    8rHGK1FmNg/VCCdUDkrTsv4OSPAmkVh+GgN3Jtugd60tI3Q3t8DMYwUmXmEQIjVy+xbAM2
    IsCPxWVXBytSygAHTktZ8GKV4pi0PaajXC8p8xuitiFgFebM4sEz9kzgvXlQF/PzFFz78q
    Zg+n21SzojqrxTzw/teIf3V6UY3iSX1fSwQcX2yxohqm6Vs/G0EbMH++N1cObyPYH6/3T2
    180LdGpftMi5MqUIjkjoCi/7CdxK+XZwaqcUHTnisrfPfw73HX6Ldy0JpY90UG9Iai4o7B
    MKJKi0+LZV05LrM2gcIW7gv3T6bKV+JJoS8UpEp2M8vivC9cBDdFXYLqW7OyLf+jLf+1U8
    dPdJBLoDcBgm8dCsLBBr93OVvwgc8gNxuGTCha3JscjmssZ1+u8iiX/OIg8g
X-ME-Proxy: <xmx:OCUwag8Z62RGEselaTb7hie1j71ufcyPnyYQTWt04DgdGCLAStejDA>
    <xmx:OCUwahqjNzYnNNay_hES5HMvSPyz_DXUujquIxJ-1L6A7CR39NXwhQ>
    <xmx:OCUwan-5yZfaNbqYHHqILFS-SrPBz6eUed-ewpQYbIzl_LYJHEHb9g>
    <xmx:OCUwatXHNNy5SBrzja4acH85eqjL8vdoY67jLjGoe0L7foGzNyt2dA>
    <xmx:OCUwamaA705dA4tXP_we8RUMF3bJHupXnFUtYdk2tCvi6JLpu3Knn3Zk>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Jun 2026 12:15:51 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2] btrfs: release extent lock per folio in readahead
Date: Mon, 15 Jun 2026 09:15:00 -0700
Message-ID: <1ebca8b7936fb1191b03071f81faae0424d9ee93.1781540038.git.boris@bur.io>
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

To bring this behavior back to the old model, we should unlock the
extent at each loop of the readahead loop rather than in one shot at the
end. This allows such overlapping reads to proceed as they should.
Writes are fine because either the page has already been read and has an
appropriate state in the page cache to be invalidated (or not uptodate)
or it is still-to-be-read and the extent lock is still held protecting
it.

Signed-off-by: Boris Burkov <boris@bur.io>
---
Changelog:
v2:
- fixed the bug of unlocking readahead expansion extents that we did not
  ourselves lock.

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

