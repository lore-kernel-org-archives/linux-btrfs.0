Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A524D6C46
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789575075; cv=none; b=Yl+jD8EJunlspZ69+h0xbh8940iuQLBaXWFfsTVr5mOsja7hzd1udS75kroYEWZT4wJNOOY1GhN5rMQtYAobYvCNZilsZOlodWZgCJ60VO+Wh+Qf3KUhanrtRi/bc6cIaHw2grOxTO4XY4v2Zk8IxhkHWw8eyQmLATmeqGD4UDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789575075; c=relaxed/simple;
	bh=EdXoynblNoFxgjFU0gX5aWLFkTLHbaR2RHAR2IFJ1p4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Hl1n1K4kpeCVjgL23fpb3VAGfuqHh9jNaNubWVlpeo/dLNo6onnBcqCN+JTOTupLUMWBTbgeZnpL0iDci6Wt/veSxXnrYbnI0aSj0OOPfOMU/Ams7G3jG0ba4/SiIOlCGXbER9EgJjbYfeE4XJDv8s8/H6YpH1eBJsJkkvy0UG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f7A4wRu1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f7A4wRu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522A71F000FF
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789575073;
	bh=NvgVCAnvPTDbdd3dW0zFeboZQEyPUuba1nKBcX20RYQ=;
	h=From:To:Subject:Date;
	b=f7A4wRu1OYFq7Gy1Tzl8UprEl4fvDZP7hx3zi9AbQmgN10cXtFuhVNxRJUPgXyptB
	 CMW93tllctxW5j5fkwQ4WBfdvBCuzsyinF0Z9Jq/1M8L4IqVlGKD/I7Idmc+YRysOV
	 yLW9ozIqhdqehnwWcvAChRrKrA2KgxpHrCgpBrQ7UAmoKx7abDsM7/weMou6Wzy9Ve
	 hlVxPkMlBCBpD4/zenpzd5yduGJmb8IAvy8wR033NGPI7Jx7epSjEbD+wyBk/hCbE6
	 +tNoX1YueJjbku0b/Ni6OjysjhA8I8cJyly2UR0QKTsMreuId1WAQJRf6qs9y9qWrL
	 7lneyN81vRGZQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: check if there is space for chunk item when validating sys chunk array
Date: Wed, 16 Sep 2026 17:11:10 +0100
Message-ID: <1b84f9c06df52773d921c1b2e58e4d27414b5ac8.1789574998.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We checked if have enough remaining space for a key before dereferencing a
key, but we then dereference a chunk item, to get the number of stripes,
without checking if there is space for the item. So add a check to see if
there is enough space for a chunk item before dereferencing the item to
extract the stripe count.

Fixes: 2a9bb78cfd36 ("btrfs: validate system chunk array at btrfs_validate_super()")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a1d83ad9a4c0..94a7e9059a7b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2370,6 +2370,10 @@ static int validate_sys_chunk_array(const struct btrfs_fs_info *fs_info,
 				  key.type, cur);
 			return -EUCLEAN;
 		}
+
+		if (unlikely(cur + sizeof(*chunk) > sys_array_size))
+			goto short_read;
+
 		chunk = (struct btrfs_chunk *)(sb->sys_chunk_array + cur);
 		num_stripes = btrfs_stack_chunk_num_stripes(chunk);
 		if (unlikely(cur + btrfs_chunk_item_size(num_stripes) > sys_array_size))
-- 
2.47.2

