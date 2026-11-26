Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795653845;
	b=hb9+72cDErZn4wM2rXj3ejKhExSChbpTPs4Lclz6Qp4Qhi2pjqqX3URbSAxlZArCRQ4V
	 5Y17z0Iq26Sl+BInAMaqtl7QhwS8Y7tdBJMaXZJTGeC+O8tgrD532d7OdwCrxhRi/GyQz
	 ysctiUVgjS1p7npqztkAq3g8ZXKbJCCFmYbh2tGBZxdgWvQzjACbhTOS7+7LbtYAzHNJe
	 TO781TgUDZ/8NLHA+xQxXgYsyrtwCqzIz158u5tnJBUVrJ4riTmP4q+S9Rhy8p6bUi2dT
	 JiZN3QzGgXj+wB6bdHHLoSuV5z7mfNr5VgjjQ8uNgksXutWxrEfOEeVi1qZB2g60jqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795653845;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=kntvEAl8c9UlNNjGZIvxtVFbdMIQt57S01N2AkNPnUM=;
	b=NjtU4yjWC3z5gLB6kY2497G/6sGXkxnitm1YuUZO7JbSCdYuSo/UjyanLm0kgGorAocv
	 B16xRcUpkUz/C3EMsp5XDei0jg6c5cO3bELWOhQvBDnfsbPrA/6R4K5FVd+H4n9oczvZL
	 1G9K+E/aNxC+FsxDmVpDmfX61oGIyCq89QG86SSbqNn4ExyzMNKH6BMQ+wt0jEcIaDSpk
	 23Qk+c3yVkD97PgEeORZs4Z7PavH5Fclcr+0oHuHudwJyaeGx8+3Wm7ZZE68VkOVli3qL
	 7bYN+f7g/1/OVFCX12YQHBH+qlHFXbsozcCY8Gwt+VheAxgajv0ZoJ8V5jh+PJQjpAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--elkin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BoNrw4dc;
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41760606A321
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 00:44:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41760606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elkin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BoNrw4dc
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3846d5f54c1so7431816eec.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 16:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795653843; x=1796258643; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kntvEAl8c9UlNNjGZIvxtVFbdMIQt57S01N2AkNPnUM=;
        b=BoNrw4dc0wesVjDd+co6oCGosrNKKDLwVcayt+Uq4JDCQ4k8wM2BaT2HXHXtW0y9yY
         4yB/olIQXKxP1SsOqKpKrjbsIb/X/tl52QhyzAgZeTIDME93CS0Ueyn2l4A57Hln3+fN
         xhG5/T3R4cR3Sk7Tr2VpUgisHB7nWyTnsc0DNzUomU4P55P2qw3ldNwZ1c/miXqHOZli
         g3MFFfT8Wz4gV3zJ9VHmLqnuViABWwA5Kf0bN+FiOMQQLN5PsFHIfFRTyiseo7gaXn1H
         LgUQQ3aeqG5JTHfVQPQoCIbGX2ZK/8906aAadolKVC8Jpps6NkYFE+DIgrPhygb5dkYU
         42ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795653843; x=1796258643;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kntvEAl8c9UlNNjGZIvxtVFbdMIQt57S01N2AkNPnUM=;
        b=2qDd2TR77iYYBYXEEVnEG9bIv8sWtw+eHtHgB/brh9IoSuGU9A22MZzWy5rA/wPJMB
         vUBGSQCAWXYkngFMdxZEcdMAmM9pBRuY/z4x0Jub58fpfniHRlpRxJuwITLwKaCHI3m5
         n6goUmpT0fUUwVxbFlOPW59I2srgPHGYg5Tkzd4fxtcRR8xk0dp3EEe0DJak9E8EwAmX
         TaIU2aGkbkIOTrGLFE2EJ747i4BLVuil0gqir8sQL7F6TdPgvhHWYt3PhEYW6EUEbyEu
         GwgJdDEmGnakdFRUnr4/b3EAusr9KjXIkmXFhslhB0pOIPJSFVXvtwLJwpIBGtTu7PdX
         8l0w==
X-Forwarded-Encrypted: i=1; AL+hErGgHVdmyVHuG7IfREXUULxcdw0FKdoW+KrHTnUkeGXB//YVgRWW9SxV6YzE4y7ctZ/KYOs1c7ZEmP8yEw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+RU72yVCZ7PM8p0mXq8I86vTXzZFRaraMQ6JRVKGvJc5dXTWQ9
	6QEvYvawh4i5g3CuMC1Ujeaxl6VB7ztdJ049OPcBoZ1hg1fsEJ08OysTpD64NqmsIusVw8LYvuE
	VWA==
X-Received: from dybgk2.prod.google.com ([2002:a05:7301:182:b0:385:e49a:dd09])
 (user=elkin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:693c:8084:b0:36f:4981:da16
 with SMTP id 5a478bee46e88-3857073f5ebmr18632806eec.25.1795653842992; Wed, 25
 Nov 2026 16:44:02 -0800 (PST)
Date: Thu, 26 Nov 2026 00:43:32 +0000
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261126004332.1712403-1-elkin@google.com>
Subject: [PATCH v2] btrfs: tree-checker: verify tree_block_info bounds in check_extent_item()
From: Elkin Cruz <elkin@google.com>
To: David Sterba <dsterba@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, irogers@google.com, 
	Elkin Cruz <elkin@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

check_extent_item() only verifies item_size >= sizeof(*ei) before
reading struct btrfs_tree_block_info on non-skinny tree block extent
items (BTRFS_EXTENT_ITEM_KEY with BTRFS_EXTENT_FLAG_TREE_BLOCK). A
crafted filesystem image with 24 <= item_size < 42 causes
btrfs_tree_block_level() to read past the item and potentially past the
extent buffer's populated folios.

Verify ptr + sizeof(*info) <= end before accessing
btrfs_tree_block_info, matching the inline ref bounds checks below.

Fixes: f82d1c7ca8ae ("btrfs: tree-checker: Add EXTENT_ITEM and METADATA_ITEM check")
Cc: stable@vger.kernel.org
Signed-off-by: Elkin Cruz <elkin@google.com>
---

Changes in v2:
- Use (ptr + sizeof(*info) > end) with matching extent_err() format to
  follow the existing pattern in check_extent_item(), thanks to Qu
  Wenruo for the review.

v1: https://lore.kernel.org/r/20261125221849.1424464-1-elkin@google.com

I am trying out new Clang static analysis checks for kernel bug
classes, and they flagged this code as possibly buggy. The findings
were triaged/fixed and commit descriptions were drafted with help of AI,
then checked against linux-next (not runtime-tested on hardware).

Thanks,
Elkin

 fs/btrfs/tree-checker.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index d2bf21c7b848..40f2355cbb1d 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1665,6 +1665,12 @@ static int check_extent_item(struct extent_buffer *leaf,
 	if (is_tree_block && key->type != BTRFS_METADATA_ITEM_KEY) {
 		struct btrfs_tree_block_info *info;
 
+		if (unlikely(ptr + sizeof(*info) > end)) {
+			extent_err(leaf, slot,
+				   "tree block info overflows extent item, ptr %lu info size %zu end %lu",
+				   ptr, sizeof(*info), end);
+			return -EUCLEAN;
+		}
 		info = (struct btrfs_tree_block_info *)ptr;
 		if (unlikely(btrfs_tree_block_level(leaf, info) >= BTRFS_MAX_LEVEL)) {
 			extent_err(leaf, slot,
-- 
2.56.1.839.g22a8290db9-goog

