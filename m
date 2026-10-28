Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793205236;
	b=SSVcVumai2R4obuR+lFDSF8voVsVUeSKJ10wdVMHbzKu9TM/C4TDaJInKs+4WnSD3N4P
	 msmXfbH5QlybCQNixmfq2cKRHD+wSX6kYNGNA92QNFHCUlkLgiaEP3EaHHyR4jyoDl1na
	 bc7CXPccRL1doorcnvAy79bA7BYewqlRmKN2wZLVR/j/NoGi8nf7gWRQh5LZbyOJPUjSN
	 QxGJF2So+/IDmjvjwSCl9TWEU0bFx4yh6TGUraQWgq9pNunqv2ermuWnqzK/R3Rl671+4
	 hp19lrWsuNjO0/18+JEU9bWutui/5FQ0wS1TrUDHzAlMXvo35BY7cqYaEe8MJ9nLX8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793205236;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R3pHmk7yRNSq/per3YJcPMikR6YjOjuW5hNlQfgKsFI=;
	b=UsJ44xejAeb+aGmYx+5gWszaGEagSSMM7VdFNL1l4GSsQI24uOfFknqI9v34UW/MYZZs
	 b16orNk2xgSJeRb1c+8mxgLZNk+ExM+OKydL6cpcT2C68wYcr+vwycoN+9p6ryUsJHoZN
	 FYM7eeJl3AOGz4l1fhvxyZPWj4Bq0+/Uqloi+Zo/avzPWwzDny2w9kNfD3yW0VUWMk+wB
	 fSaIQfTJqWRbsu+PMACwTyVUpSPR7Ji2iOlU1Y/RlwzMEkgvRlnKzs3L1C6nlm4EkEKZO
	 j04UJwfGizetfSYLEvsc1ODweA0l0lPmsXp3XNFGdZwvifpDmthBOm9JXWvQsR1F+GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aCA0Fea8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FCC606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 16:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aCA0Fea8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADCF1F01825
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793205235;
	bh=R3pHmk7yRNSq/per3YJcPMikR6YjOjuW5hNlQfgKsFI=;
	h=From:To:Subject:Date;
	b=aCA0Fea8mlG5rEPO4Pal31FaTPum1s2BOyjrHYpuV8NlyJAa3n191CGkhjBfHoEIe
	 ryitZ8laEANU58FRDvBMYKZX4+IiRchZ9D5R6JKT9kQjMq08pUGrfNobRwBUdFtswP
	 jl0hh1wbyBRrHwUHNgt+UtSjiHOc++1q2eA2bCG2hy9gQW97pgZeQPKopAlq+e4rui
	 Ohve7csZhvPvTpdIJCxTZIFsQZuZ4tDdn6ljZZDvuQXqYo+/Q6I5tl4A3P2xNLGQ2K
	 4QoWbOCHccywozqW6B2cnW+dvezkuq5tTrJDsWZLaESBsP+oAlLZAcDynMk2geLQ8n
	 mnHx4rQ41lZvw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: zstd: pass fs_info to btrfs_warn() on failure to allocate workspace manager
Date: Wed, 28 Oct 2026 16:33:53 +0000
Message-ID: <10b9e2d858daf0143a1b7f200989a59857272389.1793205219.git.fdmanana@suse.com>
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

The workspace manager is per filesystem and we have access to the fs_info
structure of the filesystem in zstd_alloc_workspace_manager(), so pass it
to the btrfs_warn() call so that we get a better log message (including
the device, state, etc).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/zstd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index cc92d0b1b948..9235aa7b922e 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -200,7 +200,7 @@ int zstd_alloc_workspace_manager(struct btrfs_fs_info *fs_info)
 
 	ws = zstd_alloc_workspace(fs_info, ZSTD_BTRFS_MAX_LEVEL);
 	if (IS_ERR(ws)) {
-		btrfs_warn(NULL, "cannot preallocate zstd compression workspace");
+		btrfs_warn(fs_info, "cannot preallocate zstd compression workspace");
 	} else {
 		set_bit(ZSTD_BTRFS_MAX_LEVEL - 1, &zwsm->active_map);
 		list_add(ws, &zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1]);
-- 
2.53.0

