Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D144E208D0
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 00:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641701; cv=none; b=p5BDwI+9tTzlhw/YjEyroj73oh9kfz2DT9cIRIMtfq+O59Zn5n9lHWvApdMkY+yfJ/oMZ0CNE1F4VFeaJ3NKoTg+LXGj/Qk+iyWI4I9NBIZq5+ITHctVmxhJMCGwu0XTcv2P2OBEhughAs7BVnCKIpBQp7mw1Mkjczm5AqQoziQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641701; c=relaxed/simple;
	bh=MUa1C5oruo0kTU/OvHycDPbIl6tHxt9jAIY8juFFmf0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsz55Z9reOY0tcrcjCR7YcsFkh8L7PP8ZCKagwZXuODHnKfyWzNzZb3Ay/+Gw4kWo6ACcpGHxA3tDqCq8H2XM5gHB5PAL4ILlwpFljfa9jcDOBtvE0fNWVNPDskwJ3/N7boAcEEXcceOL3Q+vCSclq9A8qmuArApX8RuaK0mC0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=AKTxiDmQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=qkdcE5Rt; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="AKTxiDmQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="qkdcE5Rt"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id DAE55EC01C6;
	Mon, 28 Sep 2026 20:28:18 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 28 Sep 2026 20:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1790641698; x=
	1790728098; bh=39uTRKK6ULdXSMWDUDmcEypgl9AUpV6d3ooofBZGigc=; b=A
	KTxiDmQgDbuFnwZAxk1dhZLB9OFwTEF4Bw1PP+d4XZ16bLhyb1LrUqWBm2Q6GJbi
	mJQfx7fhKepi5LuKGfaYEkfsYQbVReGSIn5pcl0c9UISKgUvq1fMPqRxBkig3vJz
	BDNOZMaLj9syAYn05KkgcStlb6M4ffqZwx1+z2kVGmERP/NEuXSqwrgmRDjpKDMs
	UBvNBUBYbVEh2NA/AY74s1TyMNjzhmHhtrmB1w5ta0xjA1xPHkgyPQ+ntJruFwEY
	EePJmsw9Mp6r/LLPpJRVw2tnAQzTBXNzHRXCYdlf2FkkKFqGR0/X0LFW+PIZ86mV
	nqv1hNCloJqryoC9FRT5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790641698; x=1790728098; bh=39uTRKK6ULdXSMWDUDmcEypgl9AU
	pV6d3ooofBZGigc=; b=qkdcE5RteZAGJVOvLIjCSJjV/rIUvlAh4ks+USa0BEdK
	CWAu5cNfiUmf9uA++NvhGUtpjTOqbROpSYKPPYtrQe+oCjJmgohnUGwhuOJqcre2
	Vak2/qLTZthtH9zO0IEbntjmvOhqJm7e2khDh2VXYrXCdTcFTS4QDUklaAyN2FpR
	hXfy8/bB4hhqBX35t3TXg/W51L7cHwtQU9/CRgFnjf3qm3jbp3rVc7ZNT6rnE4Ac
	Jz6F0+JDp0ZEV17yGjenNI9ZkSJW6imtDgDMxFI9f5H71TUgGyjryPkSnII5JpxR
	f+/CAn0aIEzGA+opsQ6hwkpO+ksqNf/HGiXEoop93Q==
X-ME-Sender: <xms:Iga7arMMyLRBHG4ZFglibYqE_vuZSZGECdi3LFksayGuMbwUyRtKqQ>
    <xme:Iga7ar_ZLXx7IvaMX2G3AEn4rnGAWysWY3W8s89zeJqCuzXYduu68uqk4566D1mvp
    B2R2pgG9pETPDYciSccK82mT0NKAn9YtU-hZYiUozj-pofYYxXz7y5X>
X-ME-Received: <xmr:Iga7an5GhKNZFI9dbFk4h0nuNlKj2cS2y_ICM4x0hdmHUWv2Z1gdsnc>
X-ME-Proxy-Cause: dmFkZTEofP8WGqf2EtdVMzKPCCLwEu0pfHaE1w4A8JANlNiIYKsml1WMqn4tMt4LPPFwt2
    2/ICfQw+EmKsZYICPJM7nzFgFGIkO2TYDk/1PP3A98HHKWRMqzFlfBLEWvGq+Tqbkd4Rqu
    5cZUMPPPKRoDepRicY7ztA3brMLqflRCdaXL0p8bPfXuGkO4U2M8M9I30xHRxbtVp83aBu
    V9HW/0C67w85Xghbbsq+ISxT57sOdwZgM+H5yfUsAPQyCmPag+aqyboItYF1E2rz5KLc25
    J7rW9fDDzor0dd/AQxap+nc+R8mHht2xKyj4WXV/ooL8A0HbB0VsmhTsE2Twae4EAFK9E4
    Lt8e2+Bl7szJ4Az4XXyBKa9s1HsIqgAA1cG3IHPM3GIxI3o924eX8kCRE8v/SdCVPOhwJC
    SAxrtqRPPLbWvEsVBj9G4K+ZhPxxp40HK6hdrRMoh4xL2WOYvaakXmEmplVNGmGQ3BCdsS
    tZ/rX0D5xggK0nCAFolevcIhCLUhU6udmeES15OMWv1wTyVkFTvPr83MAZIzbq+prY3nZ/
    vOXcaI9xM1mceC9bnoGlZbpprBxQ5MxabUV99nKpcoJKS2s0QH/jXSFrZ2jAw0sIXsYtjj
    ugny6bNzWqZBYeU1NmGz9/2+yz8rDMwEPCGGQ1shh26t4v9NyxfxwB2Llgcw
X-ME-Proxy: <xmx:Iga7aq2Aqd4C1wTJ9AJDNViUawdJHFJn42FXSKgkbmv1PHeLHDucZA>
    <xmx:Iga7amC1CadPwp_dbUEwkWBLUJZ8wxyqxKw2SagjKBTFPL6xGdShjg>
    <xmx:Iga7ak1lLurr1tcAoNsSfUVLJ8AJOIyt4YeDdnOJFWzAcPGjNk_4Cw>
    <xmx:Iga7aosCVWkA_VnQ1gM6OB04Qm_EACz4Iht_tc4YSZPMLZeCG47G2w>
    <xmx:Iga7ahOaXF4WnsinbNyC72l4aM7ESGyiM3ZJlV8-WPZtqFBVJcxuo_qd>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 20:28:18 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 3/6] btrfs: remove redundant checks in find_free_extent() hint path
Date: Mon, 28 Sep 2026 17:28:04 -0700
Message-ID: <6781c085110bdd49202e91f36b9ca8d80dae9d4e.1790641462.git.boris@bur.io>
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

The hint is a long lasting loose reference to a block group which can
outlast the block group or race its destruction. Therefore, using it
from the hint must check that it is still attached to the list of block
groups. However, the other checks are not special to hints and can be
shared with block groups reached normally. So make the hint path check
only the thing that is truly relevant to hints.

Assisted-by: LLM
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent-tree.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3f4d970cf3ca..c4f46d361b0b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4644,12 +4644,10 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		    block_group->space_info == space_info &&
 		    block_group->cached != BTRFS_CACHE_NO) {
 			down_read(&space_info->groups_sem);
-			if (list_empty(&block_group->list) ||
-			    block_group->ro ||
-			    (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)) {
+			if (list_empty(&block_group->list)) {
 				/*
 				 * someone is removing this block group,
-				 * we can't jump into the have_block_group
+				 * we can't jump into the check_block_group
 				 * target because our list pointers are not
 				 * valid
 				 */
@@ -4659,10 +4657,8 @@ static noinline int find_free_extent(struct btrfs_root *root,
 				ffe_ctl->index = btrfs_bg_flags_to_raid_index(
 							block_group->flags);
 				btrfs_put_block_group(block_group);
-				btrfs_lock_block_group(block_group,
-						       ffe_ctl->delalloc);
 				ffe_ctl->hinted = true;
-				goto have_block_group;
+				goto check_block_group;
 			}
 		} else if (block_group) {
 			btrfs_put_block_group(block_group);
@@ -4680,6 +4676,8 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		struct btrfs_block_group *bg_ret;
 
 		ffe_ctl->hinted = false;
+		ffe_ctl->search_start = block_group->start;
+check_block_group:
 		/* If the block group is read-only, we can skip it entirely. */
 		if (unlikely(block_group->ro ||
 			     (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED))) {
@@ -4691,7 +4689,6 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		}
 
 		btrfs_lock_block_group(block_group, ffe_ctl->delalloc);
-		ffe_ctl->search_start = block_group->start;
 
 		/*
 		 * this can happen if we end up cycling through all the
-- 
2.55.0

