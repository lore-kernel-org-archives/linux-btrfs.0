Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDF322A7F0
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 18:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779473658; cv=none; b=SrAdmQO9fuBpyoCrE9ujdzrbUItBpzDFhkWz+q/fp6JSHMIlWpPDy6LXa38VK4zTMJiRdyEJzwVRAsxHjUfnuPtj1qIwYsKawkryG4DXDNasLC/HnXGuob7NigU9W1bmitzLwbBCpWfjZ5aoOaV/fkD1NEdbT0MZhk8jtsR2h0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779473658; c=relaxed/simple;
	bh=KE5dt2tqfPBIK5aNL8UDCg86G6+WTz5Uad3mj51VtSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFR8AY9g3TchTNskunThHPt8eAkc1anuweibE7xSQ3pVdrvOvB9Eo0lT83iRnLF89oqmlsNe/ySCEvnuNqvCjDTXu29LwqJovpvrXnnvXQJ7fuS7JYQxI8Av08ZUJhz8H3lzio3zRtExzxRUvDIGu+ikasZUMP01F9XQlTGXNZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OeQxYoVc; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OeQxYoVc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Ktwkp09gKmTeYOPwhjmFuvamcfEOC5A3cQ66sKj0zCk=; b=OeQxYoVc9G+h0bU7R5bnkuwXZC
	S1IUsnpssNrclX8F2nQfISyKpIqwfoc3t+FMU0SkLKn0vZ48IQj1Zu9l7MAmjmPCjxsvMLVSb5pmB
	7uTZf2bm+3R/qrtgial4NhEqIaxN2OJBbtwxTdqfjS9dmJn6ukW127FliPB15riD8pGRbMI6d13hi
	kZF2nE3UmbMcUDP7RJ+ccQGYzAQm+aGpkItk1B4/7XEzD2sVJVJtCRBA/ffpQGHK5N8BCUQFH0+P1
	78QlLQOImrRL/DLW3G2lzrTobm2urb8efORGDRd2Jl1SZN7+2V2GC/pYSjNep6vMKe8H4x7BPNyVd
	/FwvdwDA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQUNx-0000000ARAz-0MMy;
	Fri, 22 May 2026 18:14:13 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Chris Mason <clm@fb.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 2/3] btrfs: Use folio_put()
Date: Fri, 22 May 2026 19:14:08 +0100
Message-ID: <20260522181411.2487732-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522181411.2487732-1-willy@infradead.org>
References: <20260522181411.2487732-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling __free_page() on folio_page() happens to work today, but
won't always.  Besides, it's far simpler to call folio_put().

Fixes: 082d5bb9b336 (btrfs: migrate extent_buffer::pages[] to folio)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/btrfs/extent_io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2275189b7860..478b7d936aa4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3394,8 +3394,8 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
 finish:
 	spin_lock(&mapping->i_private_lock);
 	if (existing_folio && btrfs_meta_is_subpage(fs_info)) {
-		/* We're going to reuse the existing page, can drop our folio now. */
-		__free_page(folio_page(eb->folios[i], 0));
+		/* We're going to reuse the existing folio, can drop our folio now. */
+		folio_put(eb->folios[i]);
 		eb->folios[i] = existing_folio;
 	} else if (existing_folio) {
 		struct extent_buffer *existing_eb;
@@ -3410,7 +3410,7 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
 			return 1;
 		}
 		/* The extent buffer no longer exists, we can reuse the folio. */
-		__free_page(folio_page(eb->folios[i], 0));
+		folio_put(eb->folios[i]);
 		eb->folios[i] = existing_folio;
 	}
 	eb->folio_size = folio_size(eb->folios[i]);
-- 
2.47.3

