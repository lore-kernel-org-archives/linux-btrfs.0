Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7986B2D3EEB
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 01:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830412; cv=none; b=TXRc/SDzr/8+xr4xvTKFRduY8jno6EOSUmQi9Dxb42vrnWQIKaEtW2O7P8TSJVyPkHFdBWR210vZ/2SNJE6SQMhtlOw8HE9Jp5y8oxBruCsBISyNW9+Ilf6z14q/rcgLTBaPrvO9G0VKnd53dhXqjoBVboT3pFipdJNRZR2OusU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830412; c=relaxed/simple;
	bh=KFOg608BjpkD7O/zHWODlTzl6r5l91mwicQv0vSkL48=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HmSwehcBIAsevUhvM3TuRIdb7ZrUeRxU9tcyhCMJoXJ+GugsSSppxhhdVLg6hms6DDBPlAc0n7YIOt4o4DoXh/lfx0STjizgD2x4yIS2pGIk9Ke+WIFYYN70RWNLhrirkhY+Z7BqXBteNuRvrbSu7lVVKe1SeaPMUkVkF01DjV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=C7GxzJTX; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=AMeQKwIM; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="C7GxzJTX";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="AMeQKwIM"
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6880uUQ13743794
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 21:19:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=+tcO
	GZUZMy+QDFxpeC0pyUy0Od3br5EQafMTDc33pMc=; b=C7GxzJTXFyA6K3OxtiUS
	oykVdDRzKtApDKmaqLZeiBOYpJ/TBi/ZPO128UVpPQFoQw0K5OUQZrYkiI6m9AMm
	kZ6fGhTO2bjSgYZq4nu9Ivsf8SqoyVo+LREVuoGToFsmDhFXb/caDnx6p7u+j4Ke
	gGdPYNkz+tqfHa1UFLR0BOf3+xQGPQqK7rP6b7XU/agsFlyfoX7MtSeMkq3ZZhg7
	XvJG1+CNkn/8eMqW/OVegMFatRAb8xEmGJBKKBSEtyp4jXDFSu3fIxk7qBNuHouR
	uj26XGQdm7aCA/LN0csJOuBty05Y97tmzkTsdy82+UOV3rAJzqeDip1fe99BJTGy
	zA==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4b9959h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 21:19:56 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-90e8472ee1eso67802766d6.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 18:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788830396; x=1789435196; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+tcOGZUZMy+QDFxpeC0pyUy0Od3br5EQafMTDc33pMc=;
        b=AMeQKwIM/wbL9hllBfltVgzdV2CaNZEgaUcw9l/J2lL+lvmlwXSi46Xx8cAzFEKPZ8
         ADm7CvDxP/aBIGL1YmbD+IfxSV0GeMNgDCxdX4DzL653nEJDu6gmipdhxT5mRrdUV+tU
         L2Fhc0jYClPs1LZSEP1xLYqoiKJsI5npA8IafiZ8gPaTfUHMg6fGScf7T1sHiUa/1+d+
         4eBL4ueWLQ9KgG6Dq12RJZKe4cDXSHjW4ckzE8pl1CXtQzY5UiUdVSKez7e1B6tGM/38
         tJGUNUb8PjELwfq0alwq66TH+pvn7VcUeT9tAjd12W0s4pUVQh0diSOfnjWJP6SSDid0
         GzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830396; x=1789435196;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+tcOGZUZMy+QDFxpeC0pyUy0Od3br5EQafMTDc33pMc=;
        b=aciq6IlFFHTQZREPFWJYBi96MS0J77/x5qPMBetFm5onstS9Vana6C/YPgdMiQUqsh
         eAcM7gnMhlz5Ffcklwk9r22RD9Tt/5H105t6gjKlolVJW3SuRtp4cePZl65mKE7aGFoZ
         m9gS0VZK7fCPUpcHIwo07eMmMi6eoONdZoDA8Qm0q/ppN0s2khNuYrjGFHPe35cHKmtu
         k8HXHD/V9FpbWjhVf7/Lnh/+p+hy3HSt9peHSwc7REDpaNsMa+iZugHWgzmROInJuht4
         GS6XiTjtMluwX0oBqAjln4Vc/2Z3x7BRPg+kcmvFfuMH1inGDO2kU3VCMPy7hQW6T+yT
         fi1A==
X-Gm-Message-State: AFuF++mWd3qotojxXLjDJdvsgW64M9I8ZAItMNTRWtQ/+UKlAnD8HlOC
	8KJGiKiyLs0pMNcEllIIcW4o8+5ij/aQyMhmUr6GNwVP+b3L7NqVJKQlK7KVAy8HqC5ciUr+hTn
	Cf6me4wjDrfWCKcc19J3VtEJk2sSIuvAd21Z4U3SAXwv7W3SHreTlz9KaY3cf
X-Gm-Gg: AYBFou1EMpPYG3K0m4tN4WwfSzsge5rNnRGkwQjEcZV0WQyiVAYtx8nMK/pOEWXbP4U
	T7a2ft7ZiQGdqW+GG6BrwGHJc7Jh1aqj8mHVETuBz7J+j5ds636csCayhecucbcdeSAOldHDQkE
	LPp/p9zFj198mHpkgm9YtQCd0O6cHAKJhEXfa+RtgrJlAMc8m0K+gQt7JkYvn5NNZ0NaNAELdLm
	2hys6H75ohsXt11h/XiJfkzDusDXRcn1CuhuGdMb2ZjSltDJLnUtH/SowrhVIO8geiME5pSVzj5
	mKVgz9jJhHjkulXrCD4UXIPa3BZ340gI2aoEay09lg2moZUdFaVxcG0FznFD6B1PcDyCKIEbx6P
	6670k1idGX5+PXTe9Q69Fiv+QgqV0o5QEBig6mdEp9S8j/M1METs=
X-Received: by 2002:a05:6214:1d2e:b0:90d:a536:1e33 with SMTP id 6a1803df08f44-9103eeb1cc4mr309717226d6.0.1788830395535;
        Mon, 07 Sep 2026 18:19:55 -0700 (PDT)
X-Received: by 2002:a05:6214:1d2e:b0:90d:a536:1e33 with SMTP id 6a1803df08f44-9103eeb1cc4mr309717006d6.0.1788830395004;
        Mon, 07 Sep 2026 18:19:55 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694543sm104322656d6.33.2026.09.07.18.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:19:54 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 21:19:21 -0400
Subject: [PATCH 06/15] btrfs: remove the v1 space cache load path
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-remove-v1-space-cache-v1-6-5f9a5ba352a7@columbia.edu>
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
In-Reply-To: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788830387; l=20021;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=KFOg608BjpkD7O/zHWODlTzl6r5l91mwicQv0vSkL48=;
 b=JjYt194IJ+o9YzNSz//VBp07xMIDqewUx7XymDejDStHRHUxoe/v0ejkEN3J7Ocp2nt9AkO30
 Cr336AAXBwKB4e91kAMda6Z02lUQ4Ls8pTCouma3VbWWWKC1AVRecF0
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAxMSBTYWx0ZWRfX0iuVOwX2v6aM
 fHSNHLG3lZhYXqraMfvQvXdTZoFK1vOOAx5tB4TwSwja0KRg9MK8Bei0tltsjsCFXiWqxCujuwF
 627gSFwhpFevr1U9Lz3apKuNvz+aMPFezU1kjxcoI3ZjE1KOLo9kLnSojHcUNZ1OliqhfHMkvT5
 A7/QLjXLuBkCQASpPwZJNBHi8mkD0qeMBTSjxwawzpG6JZVnr+obWlo4/KESgubDobZP3wngLgz
 clruV0WGYTDs6KxdSkw9aFg8QWAd313Z0BJa7NNNhPOUnszD4J4jtcBdHxXA4PSsw82h8on0aef
 9rIaAGXYoQDl35XGcqLodLZb2X1v0ka12o0tEpG+tZi8ns9CQyX6PxbATrAgG5tSDQXa7PC1Kvv
 +SN87EFVlyXKemQkusDrlLRnkHnxJuVMLGX+n9nFibgMoQbJODhrg6eSbouYJBrjkzIg0KgAaEp
 +Lnz7J+XQ/M4ofWmC8g==
X-Proofpoint-GUID: EHUuZum8m3AWrOn85ElpZc0l7JGKv4NT
X-Proofpoint-ORIG-GUID: EHUuZum8m3AWrOn85ElpZc0l7JGKv4NT
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAxMSBTYWx0ZWRfX5zt1beUC0QUV
 gHhlnEY7KFbuoxYSF6cSMpQlYoRab1kRxDF0dD9cQ9Am2KPAULEMN7tIygk5YTDOsjO1R+/bMRG
 HLhS4/hRPsF8XM3vElvXmUUfyc8hfeWNWmsPTrvWIEQEqHW02VW2
X-Authority-Analysis: v=2.4 cv=Yos/gYYX c=1 sm=1 tr=0 ts=6a9f62bc cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=P5Dk6VCOSKDVTHAqsQAA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 spamscore=0 phishscore=0 bulkscore=10 lowpriorityscore=10
 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080011

Nothing writes a v1 space cache any more, and since commit 545e560a5b0f
("btrfs: disable v1 space cache") the mount option can't be enabled to
read one either. Remove load_free_space_cache(), its io_ctl helpers and
struct btrfs_io_ctl. Drop the gfp constraint on the inode mapping as
well, it only covered the cache's page cache allocations.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/block-group.c      |  18 +-
 fs/btrfs/free-space-cache.c | 565 --------------------------------------------
 fs/btrfs/free-space-cache.h |  15 --
 3 files changed, 1 insertion(+), 597 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 5790396482db..47d48b4abf17 100644
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
index 336b546b0a94..a25c4db561b4 100644
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
 
@@ -262,226 +251,6 @@ int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
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
@@ -527,340 +296,6 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
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

