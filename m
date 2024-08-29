Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3E014F130;
	Thu, 29 Aug 2024 07:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724916601; cv=none; b=UT+akb/B4kykZxqXNAedSlvyLWXEI1ILNt0Sp8HgR0xb8PaWpNmLbvqNkwnbZ+l1zffyAtuF74oaA+bA5JQ4tapaUUx1aPlh1Ibj9yPvRlHW/vITLF3PNgFWufbQ61UIS0sPWJobauKuAV56+6ibL05EiOdgxkElHras3eV0QmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724916601; c=relaxed/simple;
	bh=MwzvsCBBO/J73f9ftdfflnSmWTHny91dW7mC2F6BA6g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oirjagg5kdAOVq/0yN9x8uuevFAEpGyVHFkn97hWUbSXbaX1yqbjLO5uTk/QUbZSn4xdIA5zMNfmeXlqBbmQLdmvT/CbyHIgviEyf17woTVkMm2JLnri0+CfdfM+6Cjx7qoK0YMkA678xDgzq0FTBGXrKoyo4d82wSbsDv9BuoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=omOnOwt8; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="omOnOwt8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724916597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZEy9xS7dNj4vpnGdHWcWIdTFyIUApKiXlohMlEXIJUE=;
	b=omOnOwt8G57nLzyqBc5nwf3TvI1/dc8hjbjF809LRwDQt3oeXNAkMNaVkGgY/f7QV0c0Pc
	cSrr2D4vA/mTEccZY5nnl8aHB33s0v2Wy6Z0eQ5fwnurepRc/I74CAsIray4sBjCT3ZRW+
	Hj1MbWdRqEHD1ScaTJrtS/DwUHnvB7s=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: clm@fb.com,
	josef@toxicpanda.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH] btrfs: Remove duplicate 'unlikely()' usage
Date: Thu, 29 Aug 2024 15:29:52 +0800
Message-ID: <20240829072952.35335-1-kunwu.chan@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Kunwu Chan <chentao@kylinos.cn>

nested unlikely() calls, IS_ERR already uses unlikely() internally

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4b58306e1ef1..cc07ba7313b7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -898,7 +898,7 @@ static int extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 e
 	for (unsigned long index = start >> PAGE_SHIFT;
 	     index <= end_index; index++) {
 		folio = __filemap_get_folio(inode->i_mapping, index, 0, 0);
-		if (unlikely(IS_ERR(folio))) {
+		if (IS_ERR(folio)) {
 			if (!ret)
 				ret = PTR_ERR(folio);
 			continue;
-- 
2.41.0

