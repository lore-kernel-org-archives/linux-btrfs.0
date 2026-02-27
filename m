Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD670364046
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 07:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772178780; cv=none; b=KBEd+EBFZF1J2H/4E9URRYZm2eggCEh9F5oepy9+x8pLjIrL2wPcsRFkeS2+ZoF2FV5zuEp6uDeEeoT1NCczsrerl7EZ+rCQeBO47+qryGoA0zw4ZEXboxPwqy5fuM73qT9W9lIvQ2dISRzhD8ToCo09bJrs8J9JRTwuE19LQkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772178780; c=relaxed/simple;
	bh=EK9KNMzHwm/R/cTS5Sun58lrs3tNVlHHrxvcWnwDSyo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T19DzMjVsCQAUK3obUNOLkNc6kCLPvkdU58TZF6txth2emkVpC6I/20l+9jksgKB3l11y/tpKBtau6IRxnVTYU8mG+JcENKOpY1UgZT2Am3RiiASew8EIqJTCDtHuOFIXP9XFedFmwOyddvjNelHYibsGeowDgKmC0YS5rAZW6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=AZoPzIoQ; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="AZoPzIoQ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PRc9ukZtwVwtHbO04bCb0JrPDsA4ylgs9/y+sacRlgs=;
	b=AZoPzIoQ74Y4QXOw8XWe1d6yYqHPv8nhnETX+S7/JHLZitWjuaHFltNvfsrA9NpgtPPTiY3uG
	CRM9Y/q4G9AjVkMKZhBx9ZBDtmGuKM8a/VKZvqd6ybAPNH8vd2i9SA/6lhm1m5JW4sUQ2tSPQCx
	OcXmzYPW3uhYYpXsC0u4iWM=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4fMgRM533FzLlV6;
	Fri, 27 Feb 2026 15:47:59 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id 983C340562;
	Fri, 27 Feb 2026 15:52:47 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemr500015.china.huawei.com
 (7.202.195.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 27 Feb
 2026 15:52:47 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <clm@fb.com>, <dsterba@suse.com>, <josef@toxicpanda.com>, <wqu@suse.com>
CC: <lihongbo22@huawei.com>, <fdmanana@suse.com>,
	<linux-btrfs@vger.kernel.org>, <sashal@kernel.org>
Subject: [PATCH 6.6 v2] btrfs: free path if inline extents in range_is_hole_in_parent()
Date: Fri, 27 Feb 2026 15:52:19 +0800
Message-ID: <20260227075219.2594937-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227064414.2314529-1-lihongbo22@huawei.com>
References: <20260227064414.2314529-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500015.china.huawei.com (7.202.195.162)

Commit f2dc6ab3a14c ("btrfs: send: check for inline extents in
range_is_hole_in_parent()") is a patch backported directly from
mainline to 6.6, it does not free the path in the inline extents case.

The original patch in mainline does not have this problem because
the former commit 4ca6f24a52c4 ("btrfs: more trivial BTRFS_PATH_AUTO_FREE
conversions") in 6.18-rc1 introduced scope-based auto-cleanup which
avoids this issue. Since some dependencies are missing and cannot
be directly backported, we choose to use a goto statement to avoid
the memory leak in inline extents case.

Fixes: f2dc6ab3a14c ("btrfs: send: check for inline extents in range_is_hole_in_parent()")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
Changes since v1:
  - Update commit message as Wenruo pointed out.
  - Link to v1: https://lore.kernel.org/all/20260227064414.2314529-1-lihongbo22@huawei.com/
---
 fs/btrfs/send.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6768e2231d61..b107a33dfd4d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6545,8 +6545,10 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
 		extent_end = btrfs_file_extent_end(path);
 		if (extent_end <= start)
 			goto next;
-		if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE)
-			return 0;
+		if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
+			ret = 0;
+			goto out;
+		}
 		if (btrfs_file_extent_disk_bytenr(leaf, fi) == 0) {
 			search_start = extent_end;
 			goto next;
-- 
2.34.1

