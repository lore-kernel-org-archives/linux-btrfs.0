Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794593962;
	b=vVCEhPIz7lqgDwzYyeUMnF+Ke7ITguc84/XHMlZVpl2dTXM9E6AqfLqvqdERghrfnL3+
	 /1BnmIiB1r3htC8UHDzrRkTa4vFkQQ385zaEO5DMXNtSMbURrEgJZI4QJJmJix5GYXvCU
	 N9SSrsTxYKZ5XRUN2a3tsXWg0gLMjogaBL5a3X/1oCaDzAB56CPWsUaz3jnTtUCqV+xdY
	 GZl9lgAQPbA0zachAaXC3bHeO8H6aYTIHuDj0WJO54zEuEwg6bdGFAjgdDwsX8iK4B2mu
	 IUVP3odx1LiIzwWWdVtyKuFxJbIwda5B5RUdWNdKwm8/QgN+Zpl3CRjB1965+7vtCSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794593962;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=AqWuJgPAom7PiFNQrP/DlJzB2dAr04+Sy5qptyA1gSE=;
	b=BPF7aXWW7TsDJw6D9iHI6rpAT1RUIX0cYOLdGMaj1HTCdW4PFZmbTLM4rNeRVKm3e26B
	 IQhlO1zQmopC/iQ9sVLlDCow8OL+sdwK2JWVxXcWdWkcMHDqRZu0Xq/SL2WO9Fg54E3VX
	 boepiNXv/MsxfLE7/YB06gJt96AhS/Q1e3G6mhnMAEPizXFYR0CuSvFB6MwJ1k59mCo3C
	 7YlOT4iSR79ss00TlYEKqheP5i9DPVn2w/Ss3T/Eg8TBCuAkdI7cUeXXj30GXhbgri2K0
	 jpswNjTjX+VURqqKgYXiVcASGfRSHqUMHciaLaOMp+MwHIWBFOSr2EXZsyQXIFvi1/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ifHRZDLA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB7E606A32E
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 18:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ifHRZDLA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC161F000C4
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 18:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794593962;
	bh=AqWuJgPAom7PiFNQrP/DlJzB2dAr04+Sy5qptyA1gSE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ifHRZDLAce3JQ0x/TyyutJB1PoCbvkL2PyX3dEKV7VzTQtF9J7Ub57vgCVtApenB3
	 Zax06kb9xLW5vmN+Il1KNJJBID3YlM8lQXJzUrniozrW8IPYbVwNw7lSF3UAKhk8rA
	 DnpAQuDromZ4wv3WAP7kPqc3fX11ys53mRWepGWSvXqxcVgTTNh3GEi3Ms4Jd1Zce+
	 cFa+IiDPFKuOL2+brgIKhDoYPu8QFQjHswhm63iHMVVOcNxks3+zGmSBCedwZu1iCr
	 c9dsvSG/Kl/qY9GzBMtCbD4pr1dRtkciaQPjzFSq4rLsW2IAM7oFgrAe3TqjJsBgES
	 0t7/wE8J7crwg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: improve the algorithmic efficiency of btrfs_check_rw_degradable()
Date: Fri, 13 Nov 2026 18:19:17 +0000
Message-ID: <4985458289decdf18db45d0f7b6db8b79a44f4df.1794593883.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <33b22f1310f84ccf116f1beeb1c2ccfbe50bca9d.1794592972.git.fdmanana@suse.com>
References: <33b22f1310f84ccf116f1beeb1c2ccfbe50bca9d.1794592972.git.fdmanana@suse.com>
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

V2: Fix a chunk map leak pointed by Sashiko.

 fs/btrfs/volumes.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 590d9bd4130c..a8e381565eb2 100644
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
@@ -8206,15 +8211,32 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
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
+			/*
+			 * We got the chunk map while holding the lock so it's
+			 * in the tree and we don't need to keep a ref on it.
+			 * When we don't resched we keep getting chunk maps
+			 * without taking refs on them, since we are holding
+			 * the tree lock.
+			 */
+			btrfs_free_chunk_map(map);
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

