Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09BE3BED38;
	Tue, 15 Sep 2026 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789483740; cv=none; b=J0Zp28gLMnftUdT3068MUvcEpF203pFh0bAhGW9hXnPydqNiMR2ru8gPk6qXtZ2piHqNhzUVIY9zxhXyJiVhwhZZx1VFwfN5NPjyBYFZ3OxZoaG2h6Hb1/MJUezmC/AWdf8ISiKXyZh16rnHrcVQx1btITM+K+NiGhpqccYzrLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789483740; c=relaxed/simple;
	bh=qdD5Yzrojd0vl1wSe/x6p+b7r4cvyp5/SYtWtzNE0QU=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=Vix/xEAHLdSDV9thmOipPh2C2HRvv1HeIY48oLo+bJfM4eMZZW9ZIH7r0fx8BkB5waNPVfyN518sJmBGYoROEk8mkdezhbGdOugv2qxBFx4kR1h8a20sOX0/kA3E58n73j+hW64+vfd81LyfWqdsHggEVFgOKiOFEJYEfSKHxHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=ETy7SMUn; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="ETy7SMUn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789483732; bh=Lht73hi11bNHXUTXUYh5klEWOvOUp//sPRrm6eyzczo=;
	h=From:To:Cc:Subject:Date;
	b=ETy7SMUn0J4z0qxITuaBxxoSgT6z+/F8i3CadaaCNuDrV5MucoMtdA5sdLU4OGcOm
	 edwb4loLzObSlTz3F5ITDY59mrp2dizYgNeavyYcPM7yG09viWANNBRXqGRYPs7+Gb
	 l4SNew+vqCoHGA5x/IiwjTDrrQQrFYrw0oAKDqpM=
Received: from ubuntu.. ([123.52.25.101])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id C321125E; Tue, 15 Sep 2026 22:48:50 +0800
X-QQ-mid: xmsmtpt1789483730tkbuoj93k
Message-ID: <tencent_F71ECF81628C274CC89FDB3304420C2D1506@qq.com>
X-QQ-XMAILINFO: NT7dO8ok7FP2Wc42yilBvEL+1zBLeqkV0FXws0y5EWjJLdhaJ1zm7wUI+M1mTh
	 kKF569Mxy55jZBm7EDnuu8L1aQPht/ZnwgK/awyvTPquTxFtBG74slbBtAyTddHpSms+9Evi0R70
	 n5zBBbQ6p/Pi+UEIyp5GoPIym4+OdkABn25DF0wsX89VX8RekZcNVBXdsGPQJdqFuL2vUrpVRYhr
	 Ld3umQmLDNHxGQNpQbQbstnJVFz5DTPaWMRFbrRMjjjhvwWzj/T7wnv2UNddkX6pfhePQ4FkErZv
	 odysIaglT7wMt2hHppEcx/GFfli0tj1+TObieB05TdLNbkU9a44+JNt3qy2BCUPnLsfEdg0/kNRm
	 qZNACp2lUaFUvyIo28ZreKTkdJG+i/SmrN43qilYB5ES7EeCxQmKxvbBJqUm2aSMafyFhISkF9JM
	 6O0ktwhG5Sq1CjJOg9LvtodxYOHLnOPgvBN02XzS32hAzUWu1NfxAdNAr9qeZaQ3Hi543OwN7gR0
	 3hWdQU4VbI8l6StLH9tGun7lPyJ5+xxYuNO8be26BsPoyhdyIx6KYAv7etdTmEHuZeocR5P+so2J
	 3bV74XpdVP2EkzeLMc5SxXKybCBLZPpoOHQ5REzZUNtnVqAPMo+j93ki4u2aSLHdYmPNlmo4C1E6
	 SXT0fSd01WknarDbj9/MG551hs3izu0Vc2NtnlfiEaYxCtyihCoDlHkvIpQ2YYE1Upu7S/kN3H/U
	 jTGCrS64KQIW9f1WAOCWk9UpqLUADuxtIt2WX2xVDfY1jP98MeOpkWesoD18zYUnN8t2cY24jELX
	 OKgXYc1yWAQIusoshLJO+3Sq1ffSHiSH6ymVefb2s6bWSRTApIxkVThI6E9jultzqKlllpGD4NJ0
	 mPx38Hq7hQ5bq1Lfj58Q9cS5TQOh6O45EqZsQ6PhtN9STQ8wYvoje9p0dlszW4qgitROLXabV9Vz
	 zLIhIAw9wbUu9nNxq/tDJv8/U5c1lB7zIlqrlqhf1R/p/zhdzfK+yXgYp5nimaFDwns6LFUp7oV4
	 /8LtvsfeMx1czVAASz9rl62aPC3M7Mdg2FHN49rl496TN11IC7
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	mason@kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH] btrfs: clear free space tree state on rebuild failure
Date: Tue, 15 Sep 2026 14:48:45 +0000
X-OQ-MSGID: <20260915144845.60288-1-3497809730@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_rebuild_free_space_tree() sets
BTRFS_FS_CREATING_FREE_SPACE_TREE and
BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED before rebuilding the free space
tree. Several error paths return without clearing these flags.

This leaves the flags set on the live filesystem and affects delayed
reference processing and free-space caching. Clear both flags on all
free space tree rebuild failure paths.

Fixes: 1d6a4fc85717 ("btrfs: make clear_cache mount option to rebuild FST without disabling it")
Cc: stable@vger.kernel.org # 6.4+
Assisted-by: Codex:gpt-5
Tested: make -j$(nproc) fs/btrfs/free-space-tree.o
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/free-space-tree.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 1b3d82ae3de8..1410da2766a9 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1353,7 +1353,7 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info)
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
-		return ret;
+		goto out_clear;
 	}
 
 	node = rb_first_cached(&fs_info->block_group_cache_tree);
@@ -1371,14 +1371,16 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info)
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			btrfs_end_transaction(trans);
-			return ret;
+			goto out_clear;
 		}
 next:
 		if (btrfs_should_end_transaction(trans)) {
 			btrfs_end_transaction(trans);
 			trans = btrfs_start_transaction(free_space_root, 1);
-			if (IS_ERR(trans))
-				return PTR_ERR(trans);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				goto out_clear;
+			}
 		}
 		node = rb_next(node);
 	}
@@ -1390,6 +1392,11 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info)
 	ret = btrfs_commit_transaction(trans);
 	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
 	return ret;
+
+out_clear:
+	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
+	return ret;
 }
 
 static int __add_block_group_free_space(struct btrfs_trans_handle *trans,

base-commit: 587858367581b9c55c3690f4e63382ad622719d4
-- 
2.34.1

