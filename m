Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794228483;
	b=c6i4FjXvU+HXwpJyVoEokr5YyTvfLk4sNtpAywN8HFJ3XVXH+giG/3fVfIWQCmWtqNW2
	 +x79ITMKgpxMbGbIIvce6oDlFxa8bMAC7XZwZdugsEPqjpg/RIwvVRCCLVGfeEM4Gkxp4
	 GlJJKzQ9Y8LHJ1ezdmC4K+IEB9K8bq1YL8mtyskSOLSxdUS14vgAqvZCFZ/uou4QlRxoq
	 RUI6UIemvlrnsl0YhTnQolosiBbr0ydYoqlXiCHBDP3SlPqpwDK62RJ7EP2cxXhB9OluV
	 KU3wGfaijL26IKTEvAQ4VoeAXFKjgFFVt4mOkixE8Nzojzv7HU+Y3DcJLNnYjlp4wbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794228483;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=N/mOy7lW3l4hL8+zQEQuOXv6mkK9QO8yU2VnRL8Y1/E=;
	b=WSvygW/onLsP9tg8z43eKu70rEnlXlVGrurRSyNPJWaoq9lIx+hnUp+sStbAX9b7D8h1
	 i9+/ZFj5Mvh0spKABj50Mxtp99fmI6UBQ8OU8fzx4f032xa1cFmYwVU0AOr8m40c5Ab8Y
	 5roeuGeUzWO730EAmeneZ+cxt1VM9XEVeUhtjLYUyK5LYYJv/sBgHtlKq3KdXYf11pfAn
	 GKYewkjqqWX3GJJ57f3WS21YhWtvcPsoWKl6Uc4+gzocMHHA1iJnORPFg5BKtH8B1UzpF
	 n7l+L1PlEeZmD20lnsmpDMXsInhz8H1BUVhYAHeYHOYCXw6ndtceKvRfTEK8uhnUT3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TRoCU+5z;
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1EC606D821;
	Mon,  9 Nov 2026 12:47:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B1EC606D821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TRoCU+5z
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794228477; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=N/mOy7lW3l4hL8+zQEQuOXv6mkK9QO8yU2VnRL8Y1/E=;
	b=TRoCU+5zrJ3ASE1iGbRcpfXn542ic5V2vCtWaVnvWMObgKTv2Om0WjQ5+CdeBYQztXLyVRNFCvBI0fQGGxv5OG07rmAitc9buQ7hOhKuy9gbFCS3THS2Vi32vPZEqHLld0q+7c4NnGBixaBg7Oth89EiQVGLYBvU0m0bndcpNRs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEP8iIg_1794228476;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEP8iIg_1794228476 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:47:56 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Sasha Levin <sashal@kernel.org>,
	David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	stable@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 6.6.y] btrfs: fix unfinished ordered extent when cow_file_range() fails
Date: Mon,  9 Nov 2026 20:47:50 +0800
Message-Id: <20261109124750.64205-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 4ace6fb49c8b ("btrfs: do proper folio cleanup when cow_file_range()
failed") moved the extent and folio unlock out of the allocation loop.
The per-iteration PAGE_SET_ORDERED went with it, and the replacement
after the loop only runs on success, so the range that already has
ordered extents is now cleaned up with PAGE_UNLOCK, PAGE_START_WRITEBACK
and PAGE_END_WRITEBACK only.

Upstream can do that because btrfs_run_delalloc_range() passes NULL to
btrfs_cleanup_ordered_extents(), which then accounts the whole range
without consulting any page bit.  Where that function still takes
@locked_page it skips it instead, leaving its share of the ordered
extent to the caller, which finishes it through
btrfs_mark_ordered_io_finished() with the page argument.
can_finish_ordered_extent() returns early when the Ordered bit is not
set, so that share is never accounted and bytes_left never reaches zero.
btrfs_wait_ordered_range() then waits forever, and a later write to the
same offset can reach the -EEXIST btrfs_panic() in
insert_ordered_extent().

Both callers that rely on this are affected: __extent_writepage(), and
submit_uncompressed_range(), the compression fallback, which reaches
cow_file_range() through run_delalloc_cow().

Set PAGE_SET_ORDERED again for that range.  The cleanup still skips
@locked_page and accounts the rest with a NULL page, so the two ranges
do not overlap and nothing is accounted twice.

Upstream fixed this differently, in "btrfs: fix double accounting race
when btrfs_run_delalloc_range() failed", which is earlier in the same
series.  That commit depends on the writepage_delalloc() rework and the
folio conversion of extent_io.c, so restore the flag here instead.

Fixes: 4ace6fb49c8b ("btrfs: do proper folio cleanup when cow_file_range() failed")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/btrfs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c8034d86f844f..a40201596b80f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1532,10 +1532,16 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	 *
 	 * So here we only clear EXTENT_LOCKED and EXTENT_DELALLOC flag, and
 	 * finish the writeback of the involved folios, which will be never submitted.
+	 *
+	 * PAGE_SET_ORDERED is still needed here:
+	 * btrfs_cleanup_ordered_extents() skips @locked_page and leaves
+	 * its share of the ordered extent to the caller, which can only
+	 * account for it while the Ordered bit is set.
 	 */
 	if (orig_start < start) {
 		clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC;
-		page_ops = PAGE_UNLOCK | PAGE_START_WRITEBACK | PAGE_END_WRITEBACK;
+		page_ops = PAGE_UNLOCK | PAGE_SET_ORDERED |
+			   PAGE_START_WRITEBACK | PAGE_END_WRITEBACK;
 
 		if (!locked_page)
 			mapping_set_error(inode->vfs_inode.i_mapping, ret);
-- 
2.39.3

