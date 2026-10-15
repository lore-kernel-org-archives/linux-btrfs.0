Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBD23B893C
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075426; cv=none; b=uPjRIuvgQWTyRiRhtLrQjA5WWrAW1qhnePMFcmQGqkESY1ya3HB9tz3OfL0PLVX7Toyvyc16S1TI/7aPqzd56V/qNOCANp2X3oMlkKskPOu2z/LMWHh2ZgREYIDqpBlt4/2fzg5X0EBPFPUj48R0AP5rOPKUk+O7+89N9IgjITI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075426; c=relaxed/simple;
	bh=2buwMDL5kf6z78JNYFsDXCbPdMBoIsuCCot0yETfycY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bxS4IkPlr1n/GYj9AVGi/8gX2VqMGtAHihAl/iph6I84RFn7jlimQcauRjZJAYc20J7ZfzOCLzvdxlNmq6MBdjB9qlCnwBLTpC3wAG/ehGpXcfcRefal8dnp1HvtXSDes6rHtKl+sv+67W/4jeGsNNC1fdQTWUY7YNHMd3W47vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=n7EOw9lz; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=L4X7SVn8; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="n7EOw9lz";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="L4X7SVn8"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEYJch1419595
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=uE3/
	TOAFB06SUBimg+BTZk5+YQFbgSFBkZzfhuWzDKU=; b=n7EOw9lz6pfxiO84sQJJ
	YASIOXT3QVb9u6po8HYzEcMNtWtUnyNy1CCYV5PatgZuZcxykzg53YBZAMlg0OmM
	fAHIKCnD5929U6h64fm4YGbBbSbQO7CgMSCq7+2ilBxOq73Wpwbdbh++6kJDxXpL
	7/dA/mKyG0oUIQ2oBkXu7xGlyWXlpH++Bn/yJglHAvlk+qR29t6ZPyWi6AWlZVyg
	mGpuOELIiEHyvQAgL638z9V4X3iqh4gkDDOf5w15HppNkzXhMuRo/1sqkBIIrlaK
	rguTw/YYyPQEmcGCvuoSgNyaELzPHMujvQpVnEgIS7qFxFZaTOJXL44h4gOhbw28
	Pg==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hagkhn7tc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:41 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91b8306ba68so33026156d6.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075421; x=1792680221; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uE3/TOAFB06SUBimg+BTZk5+YQFbgSFBkZzfhuWzDKU=;
        b=L4X7SVn8aDiv6mmGOWjJQ5kzHz0D7La0+VZ9SSDkIBOEYrIjjYyH7tBhDE7OTCZeji
         qFjV4mmL8XCtIDYioOfckBOSMmE7shxhZmPd0UjzZbTYJFyOYPAFeh5uReYewhYF4tP0
         KUSTtS9i05CMIigoW32H1xLOFHZi1OoRJ88UI45EjmwS9ntJa6woMztbMpib0jyZw9Vo
         mszqNJoA9Qdl57xeWMbvS3LkNg6X/V4hvK0eok74jtLi4exslvpmQ79TXUmOcJ6lrLHc
         BVzQblYkRAAL3UBYvV8JdNrl1fbgMYoOq3hRbBuMHiN3BDtIy+LPBHfXOiwYSDJTL7/7
         UUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075421; x=1792680221;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uE3/TOAFB06SUBimg+BTZk5+YQFbgSFBkZzfhuWzDKU=;
        b=PEugqLCsGaiQ+O4S/mtWJuCAymgc5+E70rH50kSQ+BQoo8iR/66ExcSfnpW0BPkTmQ
         HJ45XzzvIUeYqmNwLnwdIiQutL3Ik+yqm0p+wNAqRD2+NOm/KdKhnJ42bP6N8r1nGYez
         NmLMX4MyxPYH+aXHi7h1uTdnUPy5vstVJgslBsvQfDoJDV5Wzar2jRsNaVVl/tij6TcO
         fx0ItSx/9vNMru8YbdZZBVsXGNI5/yFum06/IMhu+YNbarKch8KhZSnVcNCbQr1Jai0r
         wCHe9SP9wUsiHaMZUza/zBtYNBN1kv/18sokOm24lDKTxbvuDtHx+t814bO1Ge5QIZ3H
         J/tg==
X-Gm-Message-State: AFq9FYJg5g3AiRLOc9byk5a7NJFsrvcdIIvV/FLjWeSz1vleF/YYHlMm
	JVyey6ASgn6fo/THZtovupmK5vJ7JAlX4PX87e69E/EtZetuLgz4aqJosKWRSd2mV3+bjJkPpma
	A6rPmhKbMU8Ds/0mHAW6zRy9mK7pLCrrxRRZc4kusya3ol0/KtxUCUSruwsg5
X-Gm-Gg: AYBFou0G5u62fsLAnNnOC06aqwRkMio3RZtqoLaX6N9ylC+opi/FSnFFS4Yn69NgUiK
	iZ/kRSQZdrKwM6bI5mAvpvvdtM2MD3zJ4PCXSwFa/Gml5C0n9fLJ80t//GbEpeqmQKyWkx8ujG1
	2XRrmvFm6q5qQphDWwzU08wBbBWgkPGZrSfD8AaMxzUMOtsGU7cVymY72P0wYIP1VCMYtlT43Wz
	13cYMPVLaa5k0qPTSrpAPgIoegma5Zyd/riWNJIpZYesrgWdWaXT9qXeihk1AKM8imFLdn4TC+Z
	LuGKDStLtZ5XKUNEj2yUxkShS7MB0SXpKhw4po8U6kaqZEXgCnrqaMp6a0LIC+e5X0UN7QhPvhQ
	7Fo8FjU/7foVMKyG0LDB9lyP7Stf/JMzKIw3ti9tPBozg
X-Received: by 2002:a05:6214:2389:b0:91b:549c:562c with SMTP id 6a1803df08f44-91b55335531mr332247426d6.6.1792075420783;
        Thu, 15 Oct 2026 07:43:40 -0700 (PDT)
X-Received: by 2002:a05:6214:2389:b0:91b:549c:562c with SMTP id 6a1803df08f44-91b55335531mr332247006d6.6.1792075420143;
        Thu, 15 Oct 2026 07:43:40 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:39 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:22 -0400
Subject: [PATCH v5 09/19] btrfs: remove the v1 space cache load path
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-9-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=20001;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=2buwMDL5kf6z78JNYFsDXCbPdMBoIsuCCot0yETfycY=;
 b=YtQxjP0BCPEtQuIOUMwP9qY5UzvkaXkhk7dzmWyL3lMWVYfKfagOru3fckIfX3WyyA39pGUvS
 /RhdMHXp6PGDh2WUKhY7YliD/Ggcy5pYyPX35AFdJ0Hv1UryJjRMXEl
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Upr2pOwB c=1 sm=1 tr=0 ts=6ad0e69d cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=P5Dk6VCOSKDVTHAqsQAA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-ORIG-GUID: G32nnJqOdR_5sfe87xCcwVynSxwoOPX8
X-Proofpoint-GUID: G32nnJqOdR_5sfe87xCcwVynSxwoOPX8
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX6IUmWv3JUA59
 QUxYGESE83zuuPgZqsgqeGJL1xm5hu8KjPzseXqCx97k6a4mmsJYjJMAF1yLuT1wtjaCVNkcN1A
 CpQPPX8qbwgDEXK7XQdMQ+h9LEPQZKVVzTICuUMSnbyo0j69qGpe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX2dJAGSDtX5gw
 +9fRlv4PtXylO6+tuMTGyHLOV4YmBLpTSEi6RqAPpKXfV2OkKiAa38q60ML9wGnGdX9woHbTqyR
 ydIR1urgregq7UJLrBbvwwkwde+QTi7DH/bat1GouDfT8Cjlxw1fT/kNmrEVtrnlSRVeafPX6Rc
 Z8PERaiSOPlsebNfBgLe14E1Ojincer4Vgz8y3pKQCJVF1W5PxN3qOZsc2yI/Q+DSTdyipuSMGF
 5aePbYq8eZkRw5AvWB1d+HxJNwoCAnVBkhgYjnxpZcbxbXdCORHAu9n31YDuDrq1+yVb03AGHLj
 yJqDjChFkvwkhmAyi8JozTAlu30OF4aykDcychTR5GlA6sFgucKYgqqnMd9P8NODJpYAtpoDHg8
 OsvzyynlrifgZjk/V4Brq32IK9sb1xrxgweiHHUUd/JITmkT1feAihYPkFh4WiXMqXaUcAin7aw
 5gByZhOG0qvjSF4opJQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 bulkscore=10
 impostorscore=10 clxscore=1015 malwarescore=0 lowpriorityscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150057

Nothing writes a v1 space cache any more, and since commit 545e560a5b0f
("btrfs: disable v1 space cache") the mount option can't be enabled to
read one either. Remove load_free_space_cache(), its io_ctl helpers and
struct btrfs_io_ctl. Drop the gfp constraint on the inode mapping as
well, it only covered the cache's page cache allocations.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/block-group.c      |  18 +-
 fs/btrfs/free-space-cache.c | 565 --------------------------------------------
 fs/btrfs/free-space-cache.h |  15 --
 3 files changed, 1 insertion(+), 597 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index d812fda5eee8..a11685440e3c 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -904,22 +904,6 @@ static noinline void caching_thread(struct btrfs_work *work)
 	down_read(&fs_info->commit_root_sem);
 
 	load_block_group_size_class(caching_ctl);
-	if (btrfs_test_opt(fs_info, SPACE_CACHE)) {
-		ret = load_free_space_cache(block_group);
-		if (ret == 1) {
-			ret = 0;
-			goto done;
-		}
-
-		/*
-		 * We failed to load the space cache, set ourselves to
-		 * CACHE_STARTED and carry on.
-		 */
-		spin_lock(&block_group->lock);
-		block_group->cached = BTRFS_CACHE_STARTED;
-		spin_unlock(&block_group->lock);
-		wake_up(&caching_ctl->wait);
-	}
 
 	/*
 	 * If we are in the transaction that populated the free space tree we
@@ -933,7 +917,7 @@ static noinline void caching_thread(struct btrfs_work *work)
 		ret = btrfs_load_free_space_tree(caching_ctl);
 	else
 		ret = load_extent_tree_free(caching_ctl);
-done:
+
 	spin_lock(&block_group->lock);
 	block_group->caching_ctl = NULL;
 	block_group->cached = ret ? BTRFS_CACHE_ERROR : BTRFS_CACHE_FINISHED;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 87db711278a7..1e2fc2884d07 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -9,7 +9,6 @@
 #include <linux/slab.h>
 #include <linux/math64.h>
 #include <linux/ratelimit.h>
-#include <linux/error-injection.h>
 #include <linux/sched/mm.h>
 #include <linux/string_choices.h>
 #include "extent-tree.h"
@@ -23,7 +22,6 @@
 #include "space-info.h"
 #include "block-group.h"
 #include "discard.h"
-#include "subpage.h"
 #include "inode-item.h"
 #include "accessors.h"
 #include "file-item.h"
@@ -57,11 +55,6 @@ static void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *info, u64 offset,
 			      u64 bytes, bool update_stats);
 
-static void btrfs_crc32c_final(u32 crc, u8 *result)
-{
-	put_unaligned_le32(~crc, result);
-}
-
 static void __btrfs_remove_free_space_cache(struct btrfs_free_space_ctl *ctl)
 {
 	struct btrfs_free_space *info;
@@ -123,10 +116,6 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
-	mapping_set_gfp_mask(inode->vfs_inode.i_mapping,
-			mapping_gfp_constraint(inode->vfs_inode.i_mapping,
-			~(__GFP_FS | __GFP_HIGHMEM)));
-
 	return &inode->vfs_inode;
 }
 
@@ -272,226 +261,6 @@ int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void readahead_cache(struct inode *inode)
-{
-	struct file_ra_state ra;
-	pgoff_t last_index;
-
-	file_ra_state_init(&ra, inode->i_mapping);
-	last_index = (i_size_read(inode) - 1) >> PAGE_SHIFT;
-
-	page_cache_sync_readahead(inode->i_mapping, &ra, NULL, 0, last_index);
-}
-
-static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
-		       int write)
-{
-	int num_pages;
-
-	num_pages = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
-
-	/* Make sure we can fit our crcs and generation into the first page */
-	if (write && (num_pages * sizeof(u32) + sizeof(u64)) > PAGE_SIZE)
-		return -ENOSPC;
-
-	memset(io_ctl, 0, sizeof(struct btrfs_io_ctl));
-
-	io_ctl->pages = kzalloc_objs(struct page *, num_pages, GFP_NOFS);
-	if (!io_ctl->pages)
-		return -ENOMEM;
-
-	io_ctl->num_pages = num_pages;
-	io_ctl->fs_info = inode_to_fs_info(inode);
-	io_ctl->inode = inode;
-
-	return 0;
-}
-ALLOW_ERROR_INJECTION(io_ctl_init, ERRNO);
-
-static void io_ctl_free(struct btrfs_io_ctl *io_ctl)
-{
-	kfree(io_ctl->pages);
-	io_ctl->pages = NULL;
-}
-
-static void io_ctl_unmap_page(struct btrfs_io_ctl *io_ctl)
-{
-	if (io_ctl->cur) {
-		io_ctl->cur = NULL;
-		io_ctl->orig = NULL;
-	}
-}
-
-static void io_ctl_map_page(struct btrfs_io_ctl *io_ctl, int clear)
-{
-	ASSERT(io_ctl->index < io_ctl->num_pages);
-	io_ctl->page = io_ctl->pages[io_ctl->index++];
-	io_ctl->cur = page_address(io_ctl->page);
-	io_ctl->orig = io_ctl->cur;
-	io_ctl->size = PAGE_SIZE;
-	if (clear)
-		clear_page(io_ctl->cur);
-}
-
-static void io_ctl_drop_pages(struct btrfs_io_ctl *io_ctl)
-{
-	int i;
-
-	io_ctl_unmap_page(io_ctl);
-
-	for (i = 0; i < io_ctl->num_pages; i++) {
-		if (io_ctl->pages[i]) {
-			unlock_page(io_ctl->pages[i]);
-			put_page(io_ctl->pages[i]);
-		}
-	}
-}
-
-static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptodate)
-{
-	struct folio *folio;
-	struct inode *inode = io_ctl->inode;
-	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
-	int i;
-
-	for (i = 0; i < io_ctl->num_pages; i++) {
-		int ret;
-
-		folio = __filemap_get_folio(inode->i_mapping, i,
-					    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
-					    mask);
-		if (IS_ERR(folio)) {
-			io_ctl_drop_pages(io_ctl);
-			return PTR_ERR(folio);
-		}
-
-		ret = set_folio_extent_mapped(folio);
-		if (ret < 0) {
-			folio_unlock(folio);
-			folio_put(folio);
-			io_ctl_drop_pages(io_ctl);
-			return ret;
-		}
-
-		io_ctl->pages[i] = &folio->page;
-		if (uptodate && !folio_test_uptodate(folio)) {
-			btrfs_read_folio(NULL, folio);
-			folio_lock(folio);
-			if (folio->mapping != inode->i_mapping) {
-				btrfs_err(BTRFS_I(inode)->root->fs_info,
-					  "free space cache page truncated");
-				io_ctl_drop_pages(io_ctl);
-				return -EIO;
-			}
-			if (!folio_test_uptodate(folio)) {
-				btrfs_err(BTRFS_I(inode)->root->fs_info,
-					   "error reading free space cache");
-				io_ctl_drop_pages(io_ctl);
-				return -EIO;
-			}
-		}
-	}
-
-	for (i = 0; i < io_ctl->num_pages; i++)
-		clear_page_dirty_for_io(io_ctl->pages[i]);
-
-	return 0;
-}
-
-static int io_ctl_check_generation(struct btrfs_io_ctl *io_ctl, u64 generation)
-{
-	u64 cache_gen;
-
-	/*
-	 * Skip the crc area.  If we don't check crcs then we just have a 64bit
-	 * chunk at the front of the first page.
-	 */
-	io_ctl->cur += sizeof(u32) * io_ctl->num_pages;
-	io_ctl->size -= sizeof(u64) + (sizeof(u32) * io_ctl->num_pages);
-
-	cache_gen = get_unaligned_le64(io_ctl->cur);
-	if (cache_gen != generation) {
-		btrfs_err_rl(io_ctl->fs_info,
-			"space cache generation (%llu) does not match inode (%llu)",
-				cache_gen, generation);
-		io_ctl_unmap_page(io_ctl);
-		return -EIO;
-	}
-	io_ctl->cur += sizeof(u64);
-	return 0;
-}
-
-static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
-{
-	u32 *tmp, val;
-	u32 crc = ~(u32)0;
-	unsigned offset = 0;
-
-	if (index >= io_ctl->num_pages)
-		return -EIO;
-
-	if (index == 0)
-		offset = sizeof(u32) * io_ctl->num_pages;
-
-	tmp = page_address(io_ctl->pages[0]);
-	tmp += index;
-	val = *tmp;
-
-	io_ctl_map_page(io_ctl, 0);
-	crc = crc32c(crc, io_ctl->orig + offset, PAGE_SIZE - offset);
-	btrfs_crc32c_final(crc, (u8 *)&crc);
-	if (val != crc) {
-		btrfs_err_rl(io_ctl->fs_info,
-			"csum mismatch on free space cache");
-		io_ctl_unmap_page(io_ctl);
-		return -EIO;
-	}
-
-	return 0;
-}
-
-static int io_ctl_read_entry(struct btrfs_io_ctl *io_ctl,
-			    struct btrfs_free_space *entry, u8 *type)
-{
-	struct btrfs_free_space_entry *e;
-	int ret;
-
-	if (!io_ctl->cur) {
-		ret = io_ctl_check_crc(io_ctl, io_ctl->index);
-		if (ret)
-			return ret;
-	}
-
-	e = io_ctl->cur;
-	entry->offset = get_unaligned_le64(&e->offset);
-	entry->bytes = get_unaligned_le64(&e->bytes);
-	*type = e->type;
-	io_ctl->cur += sizeof(struct btrfs_free_space_entry);
-	io_ctl->size -= sizeof(struct btrfs_free_space_entry);
-
-	if (io_ctl->size >= sizeof(struct btrfs_free_space_entry))
-		return 0;
-
-	io_ctl_unmap_page(io_ctl);
-
-	return 0;
-}
-
-static int io_ctl_read_bitmap(struct btrfs_io_ctl *io_ctl,
-			      struct btrfs_free_space *entry)
-{
-	int ret;
-
-	ret = io_ctl_check_crc(io_ctl, io_ctl->index);
-	if (ret)
-		return ret;
-
-	copy_page(entry->bitmap, io_ctl->cur);
-	io_ctl_unmap_page(io_ctl);
-
-	return 0;
-}
-
 static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 {
 	struct btrfs_block_group *block_group = ctl->block_group;
@@ -537,340 +306,6 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 		div_u64(extent_bytes, sizeof(struct btrfs_free_space));
 }
 
-static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
-				   struct btrfs_free_space_ctl *ctl,
-				   struct btrfs_path *path, u64 offset)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_free_space_header *header;
-	struct extent_buffer *leaf;
-	struct btrfs_io_ctl io_ctl;
-	struct btrfs_key key;
-	struct btrfs_free_space *e, *n;
-	LIST_HEAD(bitmaps);
-	u64 num_entries;
-	u64 num_bitmaps;
-	u64 generation;
-	u8 type;
-	int ret = 0;
-
-	/* Nothing in the space cache, goodbye */
-	if (!i_size_read(inode))
-		return 0;
-
-	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
-	key.type = 0;
-	key.offset = offset;
-
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret < 0)
-		return 0;
-	else if (ret > 0) {
-		btrfs_release_path(path);
-		return 0;
-	}
-
-	ret = -1;
-
-	leaf = path->nodes[0];
-	header = btrfs_item_ptr(leaf, path->slots[0],
-				struct btrfs_free_space_header);
-	num_entries = btrfs_free_space_entries(leaf, header);
-	num_bitmaps = btrfs_free_space_bitmaps(leaf, header);
-	generation = btrfs_free_space_generation(leaf, header);
-	btrfs_release_path(path);
-
-	if (!BTRFS_I(inode)->generation) {
-		btrfs_info(fs_info,
-			   "the free space cache file (%llu) is invalid, skip it",
-			   offset);
-		return 0;
-	}
-
-	if (BTRFS_I(inode)->generation != generation) {
-		btrfs_err(fs_info,
-			  "free space inode generation (%llu) did not match free space cache generation (%llu)",
-			  BTRFS_I(inode)->generation, generation);
-		return 0;
-	}
-
-	if (!num_entries)
-		return 0;
-
-	ret = io_ctl_init(&io_ctl, inode, 0);
-	if (ret)
-		return ret;
-
-	readahead_cache(inode);
-
-	ret = io_ctl_prepare_pages(&io_ctl, true);
-	if (ret)
-		goto out;
-
-	ret = io_ctl_check_crc(&io_ctl, 0);
-	if (ret)
-		goto free_cache;
-
-	ret = io_ctl_check_generation(&io_ctl, generation);
-	if (ret)
-		goto free_cache;
-
-	while (num_entries) {
-		e = kmem_cache_zalloc(btrfs_free_space_cachep,
-				      GFP_NOFS);
-		if (!e) {
-			ret = -ENOMEM;
-			goto free_cache;
-		}
-
-		ret = io_ctl_read_entry(&io_ctl, e, &type);
-		if (ret) {
-			kmem_cache_free(btrfs_free_space_cachep, e);
-			goto free_cache;
-		}
-
-		if (!e->bytes) {
-			ret = -1;
-			kmem_cache_free(btrfs_free_space_cachep, e);
-			goto free_cache;
-		}
-
-		if (type == BTRFS_FREE_SPACE_EXTENT) {
-			spin_lock(&ctl->tree_lock);
-			ret = link_free_space(ctl, e);
-			spin_unlock(&ctl->tree_lock);
-			if (ret) {
-				btrfs_err(fs_info,
-					"Duplicate entries in free space cache, dumping");
-				kmem_cache_free(btrfs_free_space_cachep, e);
-				goto free_cache;
-			}
-		} else {
-			ASSERT(num_bitmaps);
-			num_bitmaps--;
-			e->bitmap = kmem_cache_zalloc(
-					btrfs_free_space_bitmap_cachep, GFP_NOFS);
-			if (!e->bitmap) {
-				ret = -ENOMEM;
-				kmem_cache_free(
-					btrfs_free_space_cachep, e);
-				goto free_cache;
-			}
-			spin_lock(&ctl->tree_lock);
-			ret = link_free_space(ctl, e);
-			if (ret) {
-				spin_unlock(&ctl->tree_lock);
-				btrfs_err(fs_info,
-					"Duplicate entries in free space cache, dumping");
-				kmem_cache_free(btrfs_free_space_bitmap_cachep, e->bitmap);
-				kmem_cache_free(btrfs_free_space_cachep, e);
-				goto free_cache;
-			}
-			ctl->total_bitmaps++;
-			recalculate_thresholds(ctl);
-			spin_unlock(&ctl->tree_lock);
-			list_add_tail(&e->list, &bitmaps);
-		}
-
-		num_entries--;
-	}
-
-	io_ctl_unmap_page(&io_ctl);
-
-	/*
-	 * We add the bitmaps at the end of the entries in order that
-	 * the bitmap entries are added to the cache.
-	 */
-	list_for_each_entry_safe(e, n, &bitmaps, list) {
-		list_del_init(&e->list);
-		ret = io_ctl_read_bitmap(&io_ctl, e);
-		if (ret)
-			goto free_cache;
-	}
-
-	io_ctl_drop_pages(&io_ctl);
-	ret = 1;
-out:
-	io_ctl_free(&io_ctl);
-	return ret;
-free_cache:
-	io_ctl_drop_pages(&io_ctl);
-
-	spin_lock(&ctl->tree_lock);
-	__btrfs_remove_free_space_cache(ctl);
-	spin_unlock(&ctl->tree_lock);
-	goto out;
-}
-
-static int copy_free_space_cache(struct btrfs_free_space_ctl *ctl)
-{
-	struct btrfs_free_space *info;
-	struct rb_node *n;
-	int ret = 0;
-
-	while (!ret && (n = rb_first(&ctl->free_space_offset)) != NULL) {
-		info = rb_entry(n, struct btrfs_free_space, offset_index);
-		if (!info->bitmap) {
-			const u64 offset = info->offset;
-			const u64 bytes = info->bytes;
-
-			unlink_free_space(ctl, info, true);
-			spin_unlock(&ctl->tree_lock);
-			kmem_cache_free(btrfs_free_space_cachep, info);
-			ret = btrfs_add_free_space(ctl->block_group, offset, bytes);
-			spin_lock(&ctl->tree_lock);
-		} else {
-			u64 offset = info->offset;
-			u64 bytes = ctl->block_group->fs_info->sectorsize;
-
-			ret = search_bitmap(ctl, info, &offset, &bytes, false);
-			if (ret == 0) {
-				bitmap_clear_bits(ctl, info, offset, bytes, true);
-				spin_unlock(&ctl->tree_lock);
-				ret = btrfs_add_free_space(ctl->block_group, offset,
-							   bytes);
-				spin_lock(&ctl->tree_lock);
-			} else {
-				free_bitmap(ctl, info);
-				ret = 0;
-			}
-		}
-		cond_resched_lock(&ctl->tree_lock);
-	}
-	return ret;
-}
-
-static struct lock_class_key btrfs_free_space_inode_key;
-
-int load_free_space_cache(struct btrfs_block_group *block_group)
-{
-	struct btrfs_fs_info *fs_info = block_group->fs_info;
-	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
-	struct btrfs_free_space_ctl tmp_ctl = {};
-	struct inode *inode;
-	struct btrfs_path *path;
-	int ret = 0;
-	bool matched;
-	u64 used = block_group->used;
-
-	/*
-	 * Because we could potentially discard our loaded free space, we want
-	 * to load everything into a temporary structure first, and then if it's
-	 * valid copy it all into the actual free space ctl.
-	 */
-	btrfs_init_free_space_ctl(block_group, &tmp_ctl);
-
-	/*
-	 * If this block group has been marked to be cleared for one reason or
-	 * another then we can't trust the on disk cache, so just return.
-	 */
-	spin_lock(&block_group->lock);
-	if (block_group->disk_cache_state != BTRFS_DC_WRITTEN) {
-		spin_unlock(&block_group->lock);
-		return 0;
-	}
-	spin_unlock(&block_group->lock);
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return 0;
-	path->search_commit_root = true;
-	path->skip_locking = true;
-
-	/*
-	 * We must pass a path with search_commit_root set to btrfs_iget in
-	 * order to avoid a deadlock when allocating extents for the tree root.
-	 *
-	 * When we are COWing an extent buffer from the tree root, when looking
-	 * for a free extent, at extent-tree.c:find_free_extent(), we can find
-	 * block group without its free space cache loaded. When we find one
-	 * we must load its space cache which requires reading its free space
-	 * cache's inode item from the root tree. If this inode item is located
-	 * in the same leaf that we started COWing before, then we end up in
-	 * deadlock on the extent buffer (trying to read lock it when we
-	 * previously write locked it).
-	 *
-	 * It's safe to read the inode item using the commit root because
-	 * block groups, once loaded, stay in memory forever (until they are
-	 * removed) as well as their space caches once loaded. New block groups
-	 * once created get their ->cached field set to BTRFS_CACHE_FINISHED so
-	 * we will never try to read their inode item while the fs is mounted.
-	 */
-	inode = lookup_free_space_inode(block_group, path);
-	if (IS_ERR(inode)) {
-		btrfs_free_path(path);
-		return 0;
-	}
-
-	/* We may have converted the inode and made the cache invalid. */
-	spin_lock(&block_group->lock);
-	if (block_group->disk_cache_state != BTRFS_DC_WRITTEN) {
-		spin_unlock(&block_group->lock);
-		btrfs_free_path(path);
-		goto out;
-	}
-	spin_unlock(&block_group->lock);
-
-	/*
-	 * Reinitialize the class of struct inode's mapping->invalidate_lock for
-	 * free space inodes to prevent false positives related to locks for normal
-	 * inodes.
-	 */
-	lockdep_set_class(&(&inode->i_data)->invalidate_lock,
-			  &btrfs_free_space_inode_key);
-
-	ret = __load_free_space_cache(fs_info->tree_root, inode, &tmp_ctl,
-				      path, block_group->start);
-	btrfs_free_path(path);
-	if (ret <= 0)
-		goto out;
-
-	matched = (tmp_ctl.free_space == (block_group->length - used -
-					  block_group->bytes_super));
-
-	if (matched) {
-		spin_lock(&tmp_ctl.tree_lock);
-		ret = copy_free_space_cache(&tmp_ctl);
-		spin_unlock(&tmp_ctl.tree_lock);
-		/*
-		 * ret == 1 means we successfully loaded the free space cache,
-		 * so we need to re-set it here.
-		 */
-		if (ret == 0)
-			ret = 1;
-	} else {
-		/*
-		 * We need to call the _locked variant so we don't try to update
-		 * the discard counters.
-		 */
-		spin_lock(&tmp_ctl.tree_lock);
-		__btrfs_remove_free_space_cache(&tmp_ctl);
-		spin_unlock(&tmp_ctl.tree_lock);
-		btrfs_warn(fs_info,
-			   "block group %llu has wrong amount of free space",
-			   block_group->start);
-		ret = -1;
-	}
-out:
-	if (ret < 0) {
-		/* This cache is bogus, make sure it gets cleared */
-		spin_lock(&block_group->lock);
-		block_group->disk_cache_state = BTRFS_DC_CLEAR;
-		spin_unlock(&block_group->lock);
-		ret = 0;
-
-		btrfs_warn(fs_info,
-			   "failed to load free space cache for block group %llu, rebuilding it now",
-			   block_group->start);
-	}
-
-	spin_lock(&ctl->tree_lock);
-	btrfs_discard_update_discardable(block_group);
-	spin_unlock(&ctl->tree_lock);
-	iput(inode);
-	return ret;
-}
-
 static inline unsigned long offset_to_bit(u64 bitmap_start, u32 unit,
 					  u64 offset)
 {
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 2432f1783f47..29166cc09b90 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -14,7 +14,6 @@
 #include "fs.h"
 
 struct inode;
-struct page;
 struct btrfs_fs_info;
 struct btrfs_path;
 struct btrfs_trans_handle;
@@ -88,19 +87,6 @@ struct btrfs_free_space_ctl {
 	struct list_head trimming_ranges;
 };
 
-struct btrfs_io_ctl {
-	void *cur, *orig;
-	struct page *page;
-	struct page **pages;
-	struct btrfs_fs_info *fs_info;
-	struct inode *inode;
-	unsigned long size;
-	int index;
-	int num_pages;
-	int entries;
-	int bitmaps;
-};
-
 int __init btrfs_free_space_init(void);
 void __cold btrfs_free_space_exit(void);
 struct inode *lookup_free_space_inode(struct btrfs_block_group *block_group,
@@ -111,7 +97,6 @@ int btrfs_remove_free_space_inode(struct btrfs_trans_handle *trans,
 
 int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
 				    struct inode *inode);
-int load_free_space_cache(struct btrfs_block_group *block_group);
 
 void btrfs_init_free_space_ctl(struct btrfs_block_group *block_group,
 			       struct btrfs_free_space_ctl *ctl);

-- 
2.39.5

