Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794606305;
	b=TtwElxn8unPIzTP2+uw+hk2lq+hTmFWyBZthFsARwzDrEctxi6OgSOQ0Pl7YNrGcYgBp
	 AZ1hJ/OuxP91yh9Gyv5yz/VsqO9Gjv+EcM0KdGXVr8A8iVBnsxCVPgHukfGfleWpwXHwK
	 z9d5MzJNo9l9lmtxA1v2p8HgxSjz1IKaCdZ+fuLBOpnvbPuMGo1QMsoBf5jjjaDsxebUf
	 L98zxZbSKRYpvhBED6drcOtyLhJziS/SlnzeYH/lb4lZ1IqyeSdzcysGxUWs5QpWibJsf
	 Vz1A76hdNedJHDlwRvkbBfHIEY5SCtz+eCkbAXo7Mh2qnMXyN5z1qbXPm0IhRxjbFPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794606305;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LPUOZmzVUBtrcbTyvMkmB2bh5X2sOYoTQAseSgDruWc=;
	b=F53fAMq4aqYjrNc07y+3Bm4ZJPlcLVtybRgbCw5h7DldBd0uJvD+8uvSsXGIfjAC1ujS
	 N/i6bkymRS97IAnrevBdkhXfUx/MC/+45MRlBfTMcfxDK/pXe4JVSDJuxtUwY6h8u13P+
	 clkCMrJtQqIyQpy0HD+L4JMT5t6aQD+PZmBuKFHx6AQZu7oowFnsoLKbsjfWr35V5/qpi
	 0vJt6+bnONQCg9fU7UXB1xwm5eZx8+dXsBoIhv9/YCzJY3GN/QlfYehCfYlfm4e8hBkVw
	 L3y1txIcw4O5UUOGFqe0ayEvhajDO4OiTRz2VnS4jPOtqpCdy1vdAkXtpVRvyiqFn9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L84k4hUs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CD2606A883
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 21:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L84k4hUs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5351F000CA
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 21:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606304;
	bh=LPUOZmzVUBtrcbTyvMkmB2bh5X2sOYoTQAseSgDruWc=;
	h=From:To:Subject:Date;
	b=L84k4hUsahJ0fjetS8hWB8583o7gjZouQA2RS+MGh6fp2M4tPI7TPlr1tVZyu42VD
	 +Hq8DStjjriXT87/Y4a9RtoRwnt/3q5N7C/CwPIEF7httN0nOMwH90MkxSXbMNevv/
	 uGz0r7FHmnWUZxtSPq0vRvILfh9Jfw4/Go8pXN86Kxuzy/gnNSvetszBk+8QhXXUi1
	 8vxd1cKXuriHu8TgdBo9SPdWsoVeWz/8lBepIzbFPO/eRlByVt8y6jigCkqYPi5d4Y
	 vqcmpvp6oqN2Dnv4gyQfpVqsbcJZ8IdE/NkhFZbU0SB+bqaq1WHjwYTCY5/qyBfBjS
	 9Sve14wHn7dsQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tracepoints: fix wrong order when printing extent map type
Date: Fri, 13 Nov 2026 21:44:59 +0000
Message-ID: <3ee0089580dc34794dc85f9d9850a31038407c6f.1794606255.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
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

From: Filipe Manana <fdmanana@suse.com>

If the type is >= EXTENT_MAP_LAST_BYTE we have to print a symbolic string
defined by __show_map_type(), otherwise we should print "-", however the
logic is inverted in the show_map_type() macro, so fix the order.

Fixes: 1abe9b8a138c ("Btrfs: add initial tracepoint support for btrfs")
Link: https://sashiko.dev/#/bug/linux-3be22632-2176-447b-b5bc-5906fba873a8
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 include/trace/events/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 6ecfab97c1a9..dd862d1f2a2c 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -336,7 +336,7 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
 		{ EXTENT_MAP_INLINE,	"INLINE"	})
 
 #define show_map_type(type)			\
-	type, (type >= EXTENT_MAP_LAST_BYTE) ? "-" :  __show_map_type(type)
+	type, (type >= EXTENT_MAP_LAST_BYTE) ? __show_map_type(type) : "-"
 
 #define show_map_flags(flag)						\
 	__print_flags(flag, "|",					\
-- 
2.53.0

