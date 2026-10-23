Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792747622;
	b=05/jZoci5cZOtekl45kDQs18AdPuCVylCp1QfR8EkjVbh4BmIJFTMbm8aXoQKWPnN/60
	 RhZ2wAX/qKBfcEirXKfynwq+tL7YJPInofB6IDHgY/7ECBgm39G6IAArEiC6tvcpaCxWl
	 bi328fDwISq9FaYbE3ppH8EF+1G7dfsQEJmynalTfgE3fGstLkLZKaEc+AIsKXg/Ve4JT
	 XOnvrq5ZHND3EUH0VNBmrUpqhcqoTrPYR8HzVWSCSvT7rRbUg3/4lKejKSmcrnlpXeAJ6
	 PeOq6B+BrqgJ29/OfyaKgXG6f2rJwDLmA6vtlMK69Qrbngeq23A+W460qo0Hz853tBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792747622;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qfo+YzzlCdo0c5Qe0bPdqDdaKgSHhie09//HzIqEaJs=;
	b=cWYFH+ZS0hEDz7s9e8UlmaWek7jAsk7fjxZJRX8yx6LgQtzQDtrgGC+ZNtG7lRvtATGl
	 JYPn7iMf0zg3Bnz+NgEjSqCxZuRse1huQVntxHjJUSDmPfi1aGSejm84V2P5lRT8AtnAT
	 tyxX8Oe7wRwAe3n6WEZU2TdLz6OlOU4QsTqanTtbFmd4/npQ7ywUxUc0zEG0E+KX1UGTz
	 xaeQ2ZIvMrOYZR/quFGE5x4Meh61UQJBRAfrwSeMznhV52YW5BbdHLbH38KS/R3S4n0ms
	 cllp3hvDfcM5z+waQUDxuot2wN9PJPL9ur/rSknzmgQ7T6+qqVwyje6/lc7k3KDEF/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bsIkoMTb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E7E606A31A
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 09:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bsIkoMTb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4BC1F01825
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 09:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792747621;
	bh=qfo+YzzlCdo0c5Qe0bPdqDdaKgSHhie09//HzIqEaJs=;
	h=From:To:Subject:Date;
	b=bsIkoMTbsNE1Katr/ldJm3tHOYgVrnWU9iADUlyX5vDCbwy0hI/vAchadD5zIzm1I
	 LQGvqZqcNLG6C7viDHbHNjbdXErG31mDI4giDnUXGAxjCKsAA5nxWJggma695+jYrR
	 NEpUBvotbWJVp4iys9yRJSxq1O1RR6WlKcLZqJJFgW/22BESmnI9q/S/IdMQQRF1mC
	 Z/7MfzJQXDNCrIQqyJmuXdPb/vjt8MFWIxYZlqFWdoZqgMzoyLUnUITx9cSOuleteH
	 6lQ79dKa+SHiuIvYYZhzNnKQavi4RH+RqlSPBClYewKIoyqE13bPfAC1HbRpsDGObV
	 2nizc30jBotOA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove fs_info argument from btrfs_add_bg_to_space_info()
Date: Fri, 23 Oct 2026 10:26:58 +0100
Message-ID: <a852cbdadd074819ee4649ab7eddc239ddd046f0.1792747602.git.fdmanana@suse.com>
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

It's not used, so remove it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.c | 6 +++---
 fs/btrfs/space-info.c  | 3 +--
 fs/btrfs/space-info.h  | 3 +--
 fs/btrfs/zoned.c       | 2 +-
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index f2b55ffbdaef..559b2f52d834 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2585,7 +2585,7 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	}
 
 	trace_btrfs_add_block_group(info, cache, 0);
-	btrfs_add_bg_to_space_info(info, cache);
+	btrfs_add_bg_to_space_info(cache);
 
 	set_avail_alloc_bits(info, cache->flags);
 	if (btrfs_chunk_writeable(info, cache->start)) {
@@ -2645,7 +2645,7 @@ static int fill_dummy_bgs(struct btrfs_fs_info *fs_info)
 			break;
 		}
 
-		btrfs_add_bg_to_space_info(fs_info, bg);
+		btrfs_add_bg_to_space_info(bg);
 
 		set_avail_alloc_bits(fs_info, bg->flags);
 	}
@@ -3090,7 +3090,7 @@ struct btrfs_block_group *btrfs_make_block_group(struct btrfs_trans_handle *tran
 	 * the rbtree, update the space info's counters.
 	 */
 	trace_btrfs_add_block_group(fs_info, cache, 1);
-	btrfs_add_bg_to_space_info(fs_info, cache);
+	btrfs_add_bg_to_space_info(cache);
 	btrfs_update_global_block_rsv(fs_info);
 
 #ifdef CONFIG_BTRFS_DEBUG
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 4a19ffef5ea7..d5a84fa97462 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -379,8 +379,7 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
-void btrfs_add_bg_to_space_info(struct btrfs_fs_info *info,
-				struct btrfs_block_group *block_group)
+void btrfs_add_bg_to_space_info(struct btrfs_block_group *block_group)
 {
 	struct btrfs_space_info *space_info = block_group->space_info;
 	int factor, index;
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index d0130c8ba3dd..0456b0d2d1b4 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -295,8 +295,7 @@ static inline u64 btrfs_space_info_used(const struct btrfs_space_info *s_info,
 }
 
 int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
-void btrfs_add_bg_to_space_info(struct btrfs_fs_info *info,
-				struct btrfs_block_group *block_group);
+void btrfs_add_bg_to_space_info(struct btrfs_block_group *block_group);
 void btrfs_update_space_info_chunk_size(struct btrfs_space_info *space_info,
 					u64 chunk_size);
 struct btrfs_space_info *btrfs_find_space_info(const struct btrfs_fs_info *info,
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1cda88332284..e6f88229ff6f 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2839,7 +2839,7 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 			if (reloc_sinfo->block_group_kobjs[index] == NULL)
 				btrfs_sysfs_add_block_group_type(bg);
 
-			btrfs_add_bg_to_space_info(fs_info, bg);
+			btrfs_add_bg_to_space_info(bg);
 		}
 
 		fs_info->data_reloc_bg = bg->start;
-- 
2.53.0

