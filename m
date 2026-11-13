Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794593027;
	b=KklkaB45fX3SfcuW2LrV7Fz28dDToZK9w7sahCuoI2IJe3iKSP5l5FJJNdjoBXgusjOK
	 DvAYK399uoP9HKzqOMAkZNpO7rYbIafBwMHwjPxd7VVevsuiOuNiMIdlxpo1eNPMdyFQB
	 R2uXW9soB9RxB9pV+Br9HD5AuCQ65XXrPirRS10qm/1WGICyXaDZd+5HuT1RoApcJ9QEy
	 ls51dNa9ohaBVrMM1nUftTNMFPKTsA3YK/VVf+L2YtlpGYmWhpWKcWKZLP5h/Iwwj0N3O
	 Px7LkECbHPlTsc4PjFm1ggAOC7UWbDS5/gDHh3jAwoItQSZ4fkgWWtH5aF0LCbeOwkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794593027;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=At1VtrXe7wmquf38mYlIQWIuQmqQopPkw8QkdYxlPTU=;
	b=dT7cHroqXBGATrJTYdy16S6oLDwGYlbhaK6r5EFILH6/2QQjl8qln0IdQMG6wukYuiFE
	 mJdeZpJFa+nL8WEg+I4z5s34Iiqh5FpsCApftR+rKgQHhoW4EtfuzVu+USAJeRW6GZw2K
	 C0v27LUFdy2P9ZN4Miv/VxzQzstpBpBqZCGmIkx8fU7uVVcJtwpMqpC36YNjKuGjKLaST
	 0jk0/AXHauMppjGehgAbXF2liLZ/3SgOFdhN7AnB5S6EQ4n4GIPfYgZhJmJ1P5S6Cqwpz
	 OHrRMZs4aws+jHrOMIAMsPXFTLAtxHKiQ/DKeYJaa1XgE9JrxXgc3JtFYFQo+k4tWYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TXMjNlL9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0273606A89B
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TXMjNlL9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123591F000C5
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794593026;
	bh=At1VtrXe7wmquf38mYlIQWIuQmqQopPkw8QkdYxlPTU=;
	h=From:To:Subject:Date;
	b=TXMjNlL9kV5s+aDmdLrwdFrJI70Y6q7+eudl3uUZME4zXgJQuy0U6yzgotp0+eUEK
	 s9D9Q13vjpfifS8bNFjZ4vciDbNXm12d/3kfdXcMs7eWAWTu2tq513iKiEMLPhC/Ld
	 0uNo4WGVM9IeLgS5x7t2hUsM0+WEuPJ12WkSV/fkd5w3ZNr8IBiCHY4JM8uKaxGyRy
	 hjeLyoob9B3X5Lmrlod9bMJZShLjsFyHLHd1b4ZlGi04J01qEd4qRGhgXnl9XV4/Bw
	 5gE7UgdsTS+U6ML3O3RMUsyiKtZH/GaKtFUccvMrpGifpPLBH5C0u3QKInOutz7ooq
	 NUXyuTSrHEd4A==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: improve the algorithmic efficiency of btrfs_check_rw_degradable()
Date: Fri, 13 Nov 2026 18:03:42 +0000
Message-ID: <33b22f1310f84ccf116f1beeb1c2ccfbe50bca9d.1794592972.git.fdmanana@suse.com>
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

The current algorithmic complexity is O(N log N) since we do a rbtree
search (O(log N)) for every chunk map (until we find one with too many
missing devices). If we have a large filesystem with many thousands of
chunks this can take some time.

Improve this by grabbing the first chunk map using rb_first_cached()
and then move on to the next with rb_next(), which is way more efficient
then doing a full rbtree search every time. Keep the read lock that
protects the chunk map rbtree and release it periodically if needed,
and when that happens do a regular rbtree search and keep using rb_next().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 590d9bd4130c..513936542645 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8174,16 +8174,21 @@ int btrfs_read_sys_array(struct btrfs_fs_info *fs_info)
 bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
 					struct btrfs_device *failing_dev)
 {
+	struct rb_node *node;
 	struct btrfs_chunk_map *map;
-	u64 next_start;
 	bool ret = true;
 
-	map = btrfs_find_chunk_map(fs_info, 0, U64_MAX);
+	read_lock(&fs_info->mapping_tree_lock);
+	node = rb_first_cached(&fs_info->mapping_tree);
 	/* No chunk at all? Return false anyway */
-	if (!map)
+	if (!node) {
+		read_unlock(&fs_info->mapping_tree_lock);
 		return false;
+	}
+	map = rb_entry(node, struct btrfs_chunk_map, rb_node);
 
 	while (map) {
+		const u64 next_start = map->start + map->chunk_len;
 		int missing = 0;
 		int max_tolerated;
 		int i;
@@ -8206,15 +8211,24 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
 				btrfs_warn(fs_info,
 	"chunk %llu missing %d devices, max tolerance is %d for writable mount",
 				   map->start, missing, max_tolerated);
-			btrfs_free_chunk_map(map);
-			return false;
+			ret = false;
+			break;
 		}
-		next_start = map->start + map->chunk_len;
-		btrfs_free_chunk_map(map);
 
-		map = btrfs_find_chunk_map(fs_info, next_start, U64_MAX - next_start);
+		if (cond_resched_rwlock_read(&fs_info->mapping_tree_lock)) {
+			map = btrfs_find_chunk_map_nolock(fs_info, next_start,
+							  U64_MAX - next_start);
+		} else {
+			node = rb_next(&map->rb_node);
+			if (node)
+				map = rb_entry(node, struct btrfs_chunk_map, rb_node);
+			else
+				map = NULL;
+		}
 	}
 
+	read_unlock(&fs_info->mapping_tree_lock);
+
 	return ret;
 }
 
-- 
2.53.0

