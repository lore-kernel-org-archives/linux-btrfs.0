Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94CD39184F
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 16:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781282557; cv=none; b=gQVXfQZfQeXuXOxkLNRVmQm6BIfnyVAwVaM8bS7MFu7JR9+7lAFfbl2Iy+9FmF0eSMYQCy3rIH5/n47GCZ2mt2GRj7Guk7H3ZuZwGCzFldtPt+onDQNf0p60Q7HvHM0T3EYVTXPNZpFjYvZWj4hCuQ3xfd54UVLGhiQFG2IB70M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781282557; c=relaxed/simple;
	bh=ExYLFNHVBdKYoXXdUHh1OW2cv94TimMINMIIg37Ilmc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GVcdzYSoOYGCRHsN9SiWICIWtVt8qvvCzyGRlZr2SWhuoCPCjikNXJnG/qTiILwxlCcgnJ0PhgOnlesX/8iRgU9WDY+DgGEVYpo7tDphai/AdTbx5UiSkS2WpK8aeYvPEjgq7FAYlbCLX7WhVmK/1oqGXHyQrlW7BGJaq3j333g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ipRY3u8Z; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dLt3VSgp; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ipRY3u8Z";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dLt3VSgp"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 17B457A0119;
	Fri, 12 Jun 2026 12:42:35 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Fri, 12 Jun 2026 12:42:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1781282554; x=1781368954; bh=nzd9n7MGZLPH4wJvQHjY0
	bY2LqFYP/Bu4R0W4lhen04=; b=ipRY3u8Zd31RuMQ8TmsxuHaT1LT8GkJkzPsTd
	eh67XRkRQHypr/HTz1o0rPi+G4YCOLvhimpwASoNelRrPckSraKyNpMxNavEUfln
	z9Lm6mMqSr7JQiIZdSjXxJj3/+AZ+4Lwd7EnbN9xOn42n4sc+KuAjcPXtJSOh6CP
	M1DXli+NJau3vn0BBuAdRE6dTmcjOnRzVsqUlL+Udr6uxP0kPa8Bxgg8ArtZTeVX
	kKfE9sRUL5jS/IuaKjMmNJq1sjQW4NDLOI0YmnJUNXKTbC0gcePPhwThhFovTPb7
	fEiddQmwT3SqTUsjdDmvTSDi2NyWytjlyRk+28Op6GIKpHL9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1781282554; x=1781368954; bh=nzd9n7MGZLPH4wJvQHjY0bY2LqFYP/Bu4R0
	W4lhen04=; b=dLt3VSgpli3ck0TvjPm43T2FFfTCT02bHBGHJO2EYOiHaU/m937
	7eHDC17UJNgGABv0evomu0PfGjNZg1p99MG1OolWDgq1avtiw/V1lNSrieuoG14U
	URCwBClBdO/WziYVIliA/ZR6EVfbW/4WrAarnAnal0HK74zG5HdkdTpGyZhXndXA
	4963t5wDRQpsqmJ3y+BZBeSAVWnKsczfNpJzdqunyUeI230jh0TMkqVMhkQUHSlD
	PB3mmG26hSpQZ7KWF2gCDY9X6QZIfNe9D88xOkjYzr9OwwT7xwCNbJbVAxeRcI2H
	bP7Z+vQxAmbfbiBU0aBD5G1cBKs5fvSniKA==
X-ME-Sender: <xms:-jYsaoSa3MwqA_Ujclx8DOR5tmxUq8MPmbKp6SY5SE3-kAI4WWQ5gw>
    <xme:-jYsarwBBC_qJlttO4Ogf6NBeWtFAYqPxTsoMRgKpUrsb_jSorNCWQCheSod10Yrh
    2ZXbtF8OmQOLq7ijS7LnhECrJ91r4oqrfKdlJBAGJu2orkbLKHFmk4>
X-ME-Received: <xmr:-jYsajeb3HMMG1gpwkT2YLvAGYiZIved8J6DeWI9YsIG29MGsgFW0MuiZc0>
X-ME-Proxy-Cause: dmFkZTGMSmqI/CPAUK50fBJWsY1QjWengjwBigf4IjBs8xDPdgRfwCcuVb+vnLnuIcaBhT
    n2K6SvDKGowacVJVMfbyBgFoD5kJuF+49KvzNDwhfHH3hht6tPDPtXphQKshq2wb/P9zp3
    nH55fiILy1GtC1Wct2Pj1hrRPGHFFXyqLegTdKRfthIsEP86ZMZRCJI8BKe1j+B6zNcXOI
    m0gaYQkZZtf4HEuiO/dZGnOCyn/c03biWat1guciQ1MI+1wOcXDIIHy1ChHUpXYnrnWh6L
    fivoJOH1bc0f7FCCHvqHuwmWUUCZxFOmOamuk4HaY30j695KYk4yDOQJVguzQIHtoGykY0
    9lITwYX75wN8606p9wPDrXJ7MOttwplU2/hdFRstVj/Q9AM9EJt9qAaMKixhR4GEaFn5KW
    Uf6oaoUWsX3ELRxDXU9uJZ/5J+mepwv3gm8Qv321OeZCP9IRI6jWAEx7PMP3nvHZyI7b7s
    uSPqU6R8D1OO4vDz1OhAUGdzxgDyxFeS0qXaaY0xTmmDd/ASLsEBrn0BcH81GMivtJa5rl
    lPdlnDkT2IsZ3ypa3Yrg8WN2Akfo9dLY5u6uRZJDWMqlY2Wlsl3G+RrOQZRNbwLd8ncyfs
    Y3/IRBX+ry8Y1YCrSJid7Hg7dDo6kxHW3E+NxR3J79n7tn+sAAc7FUSc5MJw
X-ME-Proxy: <xmx:-jYsanLJ73gt_pjMr8c4dG_mbUnfnDxAh4fbYFHLO5kjAVHoR9k1pQ>
    <xmx:-jYsakGv82db_f6OYZGxYGN1EHN7YqufXi4vcABkDgLusZkES6sAiQ>
    <xmx:-jYsahrwub29RvMwIeoOEqVNXbeV1Ry4PACClZzY4lRajsy7H9dyxg>
    <xmx:-jYsatRJb5XwkRVJQbAN4-U5wstRKU9TJJ-9otE1_21D9hSXA404rQ>
    <xmx:-jYsag2svxUssYf7uyLOD0-fOFJgnuvTqdh7-o_-UbLI6pViV5mkoDC9>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Jun 2026 12:42:34 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH] btrfs: release extent lock per folio in readahead
Date: Fri, 12 Jun 2026 09:42:31 -0700
Message-ID: <1c59582ab8eba7fabda0422856514019be95dfac.1781282522.git.boris@bur.io>
X-Mailer: git-send-email 2.52.0
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
 fs/btrfs/extent_io.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7d604524e83c3..a9517b8cdd601 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2745,12 +2745,21 @@ void btrfs_readahead(struct readahead_control *rac)
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
+		btrfs_unlock_extent(&inode->io_tree, folio_start, folio_end, NULL);
+	}
 
 	if (em_cached)
 		btrfs_free_extent_map(em_cached);
-- 
2.52.0

