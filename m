Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FCF364927
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 00:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641699; cv=none; b=N/bk6tyIkij2/taITs7MYLG2RRqE98hsV0c+5uDsJGscFlG966cGsQUUQNOH7EZtV3NoHy8xWyqDkAnoHn5qHaOLnLL/k2urW46XKdr5itlzJ8ERM3o5t4WPCnXqW4r7jvgc7ge7+PQTXRWHM7TmQ0vqth/Bm9w6u8PIYgJFrXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641699; c=relaxed/simple;
	bh=rwwE2ypl54eM+rs0qX83bA3qNvrv4kPfyxQehVQgWqk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6dDcNuvvJrp3UaJrIwDC8esy3XXUdgC40XBmGbPYXsFdP7+95BsjYmfZxNnIbo0Rr7UKIGA7fdqCvvC55vXrX5x+xmc3JGl6opN0IGL9j1otPpBjN0XI+FJ8JJWNeUdlF+ptI1DtkMRZIDZXaK382N0QJ0YLaPS/E7kj8Ra8H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=WUhjlGZP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tQ7fhh/D; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="WUhjlGZP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tQ7fhh/D"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4406614000A2;
	Mon, 28 Sep 2026 20:28:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 28 Sep 2026 20:28:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1790641697; x=
	1790728097; bh=mwOVs1hrU+zCT5qL3m4GybsnfylYRKMMFM47djA7CKA=; b=W
	UhjlGZP0DDte9tFietPBq6cr0x0hy7eCNF4hxB3GRrVJ2oPk0nuv+YjuJPiYqP2L
	NdmZzazhas0EK3h031XKHGe0WZCZAX/hA92E1D6GHcScPcR3jhoVggjII1cKN1/W
	CT/jBkkWgEGkhWPHJi1jYcSs1gwcxTdjKkwJWb2h19G2NihqGgEGCu87zC3QaxFD
	x1IO6KyJRx/OfWMs/xbczUuGElamCGB4G17bbiF/mnp/krCJympLe2hK90pHSwXg
	651lBX4wtaC3efy2pXEX28DGCcEwuh6JawTH7cl+Y7tE9gRvI8+p1wbsH+5IMaca
	jasgoilCJBVWn3Y10WxnA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790641697; x=1790728097; bh=mwOVs1hrU+zCT5qL3m4GybsnfylY
	RKMMFM47djA7CKA=; b=tQ7fhh/Dnt2PrxR4Boq3EmkEi9dR6F9zmzoLMSrME2f/
	qLPr4wYkjVDHorPEX7aGzy10MzQNEwX6ZTnkqK7NkYP5aRh3f2lQdjGuMT/xSHQG
	l287kMAOUY56RLJ03zBojQz2A6mUMcfpInr/11Q2ZCpRJzjaKDvc48Md6AG3tmAu
	BETItuuvIQ+v1qxbVpUm5WTtJMB5lGpa5fUess5BhFxphMFMtrqTM2GLVCPlYObl
	15DeaFP8pdQC1PjzML/Z2ZO3+mBExYfDfCEPXTHrpwqsYnBmyzen0AJE8I6AeB+I
	R5B2rhdhNp9fBnywi/10ZBan+In2jHu07j1ahOA9Gw==
X-ME-Sender: <xms:IQa7au1t85jrNQAzenwCW9rE1uhbCV3S4kDzzEBhaNMlEN1c2mvetQ>
    <xme:IQa7anFbeInEoLWqVbq1Qgjy5a69N6vMHZSM1Muw3jqPHuYTfyZRBcI8pkNbRsQ2r
    PurN3U4XLQ9UON9N3pG5BzljQuOUcsLvCf4-cpTrpgoH3visSl67FXv>
X-ME-Received: <xmr:IQa7akhr2yhWY5_0M1ucDfr_s6i3FreyX9ApkkVQc6qmsIxVbfHFiXs>
X-ME-Proxy-Cause: dmFkZTEofP8WGqf2EtdVMzKPCCLwEu0pfHaE1w4A8JANlNiIYKsml1WMqn4tMt4LPPFwt2
    2/ICfQw+EmKsZYICPJM7nzFgFGIkO2TYDk/1PP3A98HHKWRMqzFlfBLEWvGq+Tqbkd4Rqu
    5cZUMPPPKRoDepRicY7ztA3brMLqflRCdaXL0p8bPfXuGkO4U2M8M9I30xHRxbtVp83aBu
    V9HW/0C67w85Xghbbsq+ISxT57sOdwZgM+H5yfUsAPQyCmPag+aqyboItYF1E2rz5KLc25
    J7rW9fDDzor0dd/AQxap+nc+R8mHht2xKyj4WXV/ooL8A0HbB0VsmhTsE2Twae4EAFK9EV
    hFTIo1xvUizpk3zf080g+QVp+YJru7psK/tNfENkyoDacPUdQhI3I2oLCf3g0YDe1f1WMZ
    nWm/z7S+cK1XPk5zVgxPXr+q7y6GBj5grlp7m+9qPmvqyChB39AhIauIPOEc8woZZTIsu4
    fi9SmvfP3Fl2UHxqB8gSsdBLlZ6W5yBn4JqlBHRYg9ceIAgZDNA4G3V4XIkQjevfyY0pZc
    ZYZFm8KMoCJAZQ36u6KOD+DqKHzSYecTeyDDyZRk0rqATfcgt+hsddjIY0BB/AWix7lN4p
    QRwvLT/w0ICSUd863tl2Ly30L/+pUau/OF8BftQiXHX9WD4BRAJmVJGvwe6g
X-ME-Proxy: <xmx:IQa7aq-mCQbDLZ_FT01e10AcVavpDOUhBdlle6SNew74pFnlhTJBTA>
    <xmx:IQa7ajqw95JIly7Sa8Ro6FvqlJLhaIrWxlEuhI1WWoFLI74s3APECQ>
    <xmx:IQa7ah8Q2no69U8ZDT5d1wCxYK5cFTytHpGzvbQ_qAnvHyoLb-9DnQ>
    <xmx:IQa7avVpfdMu62SNkkOrWaEBGUV3o7W_NtGaChQCs_o22Oi_Q-Zr0w>
    <xmx:IQa7as0ieWtfswu4JopbP9zoioQqy5vrQgYoyLpUZc-3saQFBrDTITQB>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 20:28:16 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 2/6] btrfs: don't take block group references in find_free_extent()
Date: Mon, 28 Sep 2026 17:28:03 -0700
Message-ID: <4c53dde7f736500612fe3a12987203f11bccc413.1790641462.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790641462.git.boris@bur.io>
References: <cover.1790641462.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The get/put pair inside the loop in find_free_extent() is pointless
because the loop is done while holding space_info->groups_sem which is
exclusive with any task deleting the block_group from the raid array,
which also holds a reference. So this can never be the last reference.

Therefore, we can skip the bother of inc/dec-ing the refcount which can
save a considerable amount of time on filesystems with a large number of
full block groups.

A little care must be taken to properly put the refcount for the hint
and bg cluster cases that pick a bg more directly.

Measured on a 30T single-device filesystem on a tmpfs-backed loop device:
  20k sequential 1G fallocates:                     40.1s -> 27.1s
  sync of 20k new 64K files after 20k full 1G bgs:  18.4s -> 13.0s

Assisted-by: LLM
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent-tree.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f43ee0ab24bc..3f4d970cf3ca 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3777,12 +3777,11 @@ btrfs_lock_block_group(struct btrfs_block_group *cache, bool delalloc)
 		down_read(&cache->data_rwsem);
 }
 
-static inline void btrfs_grab_block_group(struct btrfs_block_group *cache,
-					  bool delalloc)
+static inline void
+btrfs_unlock_block_group(struct btrfs_block_group *cache, bool delalloc)
 {
-	btrfs_get_block_group(cache);
 	if (delalloc)
-		down_read(&cache->data_rwsem);
+		up_read(&cache->data_rwsem);
 }
 
 static struct btrfs_block_group *btrfs_lock_cluster(
@@ -4226,7 +4225,7 @@ static void release_block_group(struct btrfs_block_group *block_group,
 
 	BUG_ON(btrfs_bg_flags_to_raid_index(block_group->flags) !=
 	       ffe_ctl->index);
-	btrfs_release_block_group(block_group, delalloc);
+	btrfs_unlock_block_group(block_group, delalloc);
 }
 
 static void found_extent_clustered(struct find_free_extent_ctl *ffe_ctl,
@@ -4659,6 +4658,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			} else {
 				ffe_ctl->index = btrfs_bg_flags_to_raid_index(
 							block_group->flags);
+				btrfs_put_block_group(block_group);
 				btrfs_lock_block_group(block_group,
 						       ffe_ctl->delalloc);
 				ffe_ctl->hinted = true;
@@ -4690,7 +4690,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			continue;
 		}
 
-		btrfs_grab_block_group(block_group, ffe_ctl->delalloc);
+		btrfs_lock_block_group(block_group, ffe_ctl->delalloc);
 		ffe_ctl->search_start = block_group->start;
 
 		/*
@@ -4717,7 +4717,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			 * It's possible that we have MIXED_GROUP flag but no
 			 * block group is mixed.  Just skip such block group.
 			 */
-			btrfs_release_block_group(block_group, ffe_ctl->delalloc);
+			btrfs_unlock_block_group(block_group, ffe_ctl->delalloc);
 			continue;
 		}
 
@@ -4761,7 +4761,12 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			goto loop;
 
 		if (bg_ret && bg_ret != block_group) {
-			btrfs_release_block_group(block_group, ffe_ctl->delalloc);
+			btrfs_unlock_block_group(block_group, ffe_ctl->delalloc);
+			/*
+			 * bg_ret is still on the list: btrfs_remove_block_group()
+			 * detaches it from the cluster before list_del_init().
+			 */
+			btrfs_put_block_group(bg_ret);
 			block_group = bg_ret;
 		}
 
@@ -4800,7 +4805,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		ins->offset = ffe_ctl->num_bytes;
 
 		trace_btrfs_reserve_extent(block_group, ffe_ctl);
-		btrfs_release_block_group(block_group, ffe_ctl->delalloc);
+		btrfs_unlock_block_group(block_group, ffe_ctl->delalloc);
 		break;
 loop:
 		if (!ffe_ctl->cached && ffe_ctl->loop > LOOP_CACHING_NOWAIT &&
-- 
2.55.0

