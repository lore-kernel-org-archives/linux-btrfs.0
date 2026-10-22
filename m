Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792688793;
	b=x3UcZFZRF1tQvpuIyGGGXJQwRGbcqcemkVjn9R8YRmv964CKVt1S8exC2KgZcy+NuCWg
	 Xo3Xb2lJUZXAt7BYpoxfHtqdDHjFI/zyJFJL66ROlLZCGXFSEm6gn/QKxYlePUa1TDNvD
	 EXSdZlZV2Wdlawp37t3zSq5lwsKhBF+ahIgDpBk2RIbgy9c1Xtfna255xcrQm9+yt7YLW
	 GOQEsyVe01BrXppnIdb9mVdJBxmFaIiDeZRvT7DP2cPWHHSSaYXMMz3I3PDfzfOMPcIgl
	 g8sIf86QYKrHa+YQzWisAvzW7yBqNaTp1JVxX/gjRSP82eLTB035SJ4pNtx2kTIYHRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688793;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=jMrT9fE2EOsFUcVod1CubWQTy25M2QjaHK5za//8/v0=;
	b=Cbem19IOpUCZkHj7xNWWqE/ALgYRAyI+54LBbdiqn+3n6m2dkdt5xKcvimxGPkYxDqca
	 GoqT7sMycvg/k7iDNsoCxSJWaFwfjxWZR9QVo178Zmn7ky2BH0sGApjCQYsVydlP+9MLd
	 LgpzPW+OH/x0tm6Oubjnc6s6lJna9w+uWf/+U/oEUyd2RXV2I+eSCgfUSGuWAiMSFwuAz
	 yH3/jnB4/kY+nvAryTRIGkSV2a5xrcBmYaymELPgIPsiwBfXLvGOSYlLadSeYqNrr6zRw
	 e5q4DQc080HERMpfnG+3AI+QeL9cFt/gg/snH8UV2EUYOyjHP4pRgq2BGGUW5Bm6RlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=puPj60if;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=lGOrchtO;
	arc=none smtp.remote-ip=103.168.172.156
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44931606A31A
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 17:06:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44931606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=puPj60if;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=lGOrchtO
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 6926A14000EB
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 13:06:32 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 22 Oct 2026 13:06:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1792688792; x=
	1792775192; bh=jMrT9fE2EOsFUcVod1CubWQTy25M2QjaHK5za//8/v0=; b=p
	uPj60ifzgTFwErUxlQhouRWB/nRIdliE0xN8HREmjObGDZH20HJGwtQGgCkOUXiV
	Cx/zKqf4N3THzjxiBImVWXkh97zWoa2cT3mxG5rWToxk5FuB88cnCFhvRE1pZWSR
	8GF7jA8NZ4upwSzxzFHBxCvF3lj7U5z+dYNCgkEaz7qiplsppsAmqRnyxH6mEVQE
	VW1/4NkFtmj8Kz8Gq9NHKAMM+pJDTLEtDs5OhJRTB2cRKsO+vwwmTjjoMrsrExyn
	xvjvVjoCQ6P7GsplmWVxYMcHdte40W6VQWM+jUWbAqSbTAYaNTMnF0SdDWHSy0sv
	4/40NLCIG2daZHI7toi3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1792688792; x=1792775192; bh=jMrT9fE2EOsFUcVod1CubWQTy25M
	2QjaHK5za//8/v0=; b=lGOrchtOn8fUqqxbDf6fCgjATTIMHBYxNrpnFepRYfPO
	X/YI14YVHId+f9uy1jfeKLN3QPE0CUpmKt6va6z5MkruTw3agyf73MdkjVp8E9t8
	fNHM+YuP2GV9Wwjk9TXuiXENQpeAFr9w2veEtf+FgPYTyL7GfMZ4abeKAM67dM7z
	IzJDTlRcy8cGQ/jx92jYQvYhJD9HgJl1GTrivLmC67j7nVWU8bGcQpJb48rw2sBa
	RJMUWMqN+JXC6Kfip7a8e1dj7vCLInc9y5Ulb09BrwEZJb5Ko5UvfNCPy7XR9WQ2
	+Wdr/T54EI32aTmp/1CgufCrzJRsIxUty6mzYG+WAQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792688792; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm3:rsa-sha256:VEHsYbqn/kBA7QFgi4KsqNEYk5khoPXA3BNh17sGy+HEeoP
	8eHSCKLBYjQlmC+LRMZlG2iXodagtZ2jV1sinjScZjx92woOA6cLSf4YijvL7Wvg
	gQ4Kodm5ArZcDwKMPrI3gFLQYDHsiXMBbFRlxbzqGaxjK07DdSa09lOdNeH+oHis
	L+Nx6+01lRTlDv9TvEWPv+V4yraHX4iW18+EVkPdisVBtg9roOmc8QJvSAQzXmpd
	aK+fIg3D8qoTVF5jNHLKdRANd8oaiUW3fEI+WbB05E8CtUVYikizT4V0MD28Gb9k
	fr4U6MlAELuvPH3/liRuc1riB3ZLiWVCPWuR5gg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=content-transfer-encoding,date,feedback-id,from,in-reply-to,
	message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:hMAeKuINwwBKEP+1PC/zYCPBxe4yaQJF6ZYQO3iHusk=:rD79ULO2CT01peBpAgqIJSP/X4XlWOSE3amJfH8EHFs=;
X-ME-Sender: <xms:mELaasMUhRKU6e1A5qOoLv6jXEDkn2gCKniNjukQM5RSs0AcXnL8hA>
    <xme:mELaao-oqIlkX-qfe-Vb24_JhbzPhTOnvcqEeLHL7Nm9vX6ZK-u5ss5fukLmGctkX
    2R9MJPuzC-rw_y2kezslXUXwyl1mSSEFbO7AFvin4qjKrDnKYZAa6IYlQ>
X-ME-Received: <xmr:mELaag41Xb5lpKzWfHC62FxLPRUm6kewI7CBx_wIAbTNKKnSA0tcA_2q>
X-ME-Proxy-Cause: dmFkZTEe4W4ijRj8LZWD4Lo9X8GUtUjJiOBEFgPoavKCOJyoNm0WKmUICZqjwAr1fZEtzN
    wX9psAuB6tGQcZKT04iwQ+nzS1nXqKBzO4k7TataXP7fQkA2HyVZ2udM8mwy84Ds+Oxk82
    /C5tnpFc/t9o1GhxCHWBjcvs0TX5V1ixUkXuiT5gcSJTdP1VU+IXQ7UmaSJRUsfJxTTgmk
    a0eZ4LANsWxq1NCnYhrjdh0JSaR2kq3OvXMAGUryItB1L+2jmIPVcVltxBrTsxaDNpZCxy
    iGE4xsxYB+SVoTBf5HYE6bbggKmUDOCKzyfNCMaar8wuusR9vJhsSaHMSh49K56q6PNmFZ
    m9n4y2ypMwFHzwbF8Tv7yD2/FdCJbzTgHw4zgntvWEq7RW2AvZmVjMF+MZ3YSbC3aYCEN6
    UC54kTytnaAiSRXxqIFmJEdttiVOjz/vj6YjBwZgV+8zhZWeYJkqSUQBBzG5DS/3jdKC8O
    xexOiATnE3BOorQZi7fUq2GOGIDzk7xAp4Cr5BuVIlQMWQQ/I2UtudqkmLKBZ50UTkeNVl
    aNAOww0V7npKEVDyenDJS57iRnxdZFoTFkylRVqRFzaBzev/p/KY8EgIhjdfikYHZZwKJv
    Xw3ijp0BJLmdTsWs7DNOFy/qbW7/uyKYs1ef3mgvCbdKC+L/y9/wwKTCwHoA
X-ME-Proxy: <xmx:mELaav1zHABRXOlbyoM81kY3yrHySOkrs86XoDjOC_HortGRcW_7Cw>
    <xmx:mELaanAuVdkidGrAYdbACvawDt74FvoLKrO3JPn3c4CL8qU7dffNcw>
    <xmx:mELaah1R1Z1HIyfusU6QnDd8TFbn-BnnZaQ8rP_UuKHLVPDV3aQcPw>
    <xmx:mELaahtKBKNJixBy_3kmrHYZfgjPEYdduhNdQJOmvTRCoS78UuXasQ>
    <xmx:mELaaiMOgw4ZA6WxrPiYGXlwzOzaeDqTFwsowjGKhXQZOYX2Cnf2fG6l>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 13:06:32 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 2/7] btrfs: don't take block group references in find_free_extent()
Date: Thu, 22 Oct 2026 10:07:00 -0700
Message-ID: <c74fc38210f9c97eb34578d701dbc4e35b76fd27.1792688736.git.boris@bur.io>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792688736.git.boris@bur.io>
References: <cover.1792688736.git.boris@bur.io>
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
index f6f4f1ce3f1f..2c06d3f17746 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3773,12 +3773,11 @@ btrfs_lock_block_group(struct btrfs_block_group *cache, bool delalloc)
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
@@ -4222,7 +4221,7 @@ static void release_block_group(struct btrfs_block_group *block_group,
 
 	BUG_ON(btrfs_bg_flags_to_raid_index(block_group->flags) !=
 	       ffe_ctl->index);
-	btrfs_release_block_group(block_group, delalloc);
+	btrfs_unlock_block_group(block_group, delalloc);
 }
 
 static void found_extent_clustered(struct find_free_extent_ctl *ffe_ctl,
@@ -4655,6 +4654,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			} else {
 				ffe_ctl->index = btrfs_bg_flags_to_raid_index(
 							block_group->flags);
+				btrfs_put_block_group(block_group);
 				btrfs_lock_block_group(block_group,
 						       ffe_ctl->delalloc);
 				ffe_ctl->hinted = true;
@@ -4686,7 +4686,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			continue;
 		}
 
-		btrfs_grab_block_group(block_group, ffe_ctl->delalloc);
+		btrfs_lock_block_group(block_group, ffe_ctl->delalloc);
 		ffe_ctl->search_start = block_group->start;
 
 		/*
@@ -4713,7 +4713,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			 * It's possible that we have MIXED_GROUP flag but no
 			 * block group is mixed.  Just skip such block group.
 			 */
-			btrfs_release_block_group(block_group, ffe_ctl->delalloc);
+			btrfs_unlock_block_group(block_group, ffe_ctl->delalloc);
 			continue;
 		}
 
@@ -4757,7 +4757,12 @@ static noinline int find_free_extent(struct btrfs_root *root,
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
 
@@ -4796,7 +4801,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		ins->offset = ffe_ctl->num_bytes;
 
 		trace_btrfs_reserve_extent(block_group, ffe_ctl);
-		btrfs_release_block_group(block_group, ffe_ctl->delalloc);
+		btrfs_unlock_block_group(block_group, ffe_ctl->delalloc);
 		break;
 loop:
 		if (!ffe_ctl->cached && ffe_ctl->loop > LOOP_CACHING_NOWAIT &&
-- 
2.56.0

