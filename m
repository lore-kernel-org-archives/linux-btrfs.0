Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A713A9627;
	Wed, 16 Sep 2026 02:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789526354; cv=none; b=DzdNgbmvdYHxvyd9FMEEH5VoUYAeG20IM+YSOn/eeEb02Psf0zdSekZHBtBD+g5eAIp7UtOLZpEe9ogGXjkUN38eCU7hlxfLzrcDPTfZL9j+IgIVDCPm4iYKKHnkY+E4CW8+gYNa/gQnLOmS4wRNCtdKzybCEAoLqnkW/nSAyyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789526354; c=relaxed/simple;
	bh=VqnS13aNVfY8LA3BWlr9xk8shgeYtWmDWKNkAg4hmwU=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=RZ3OHaHSxDXzYxFgk9yGlp7kL7UKeYzdvN7vlB5VEQNx1bJbGgilMCiSPmR9MFZkKQiCjlot/DJIdQjF022cnEs3CdirWnqdS+etIrfFiQaH/f1c1iUIVS/ZuuxdzWrNUll94US+oAJHbD1Q/2Q63bppen3IiFhAkQHQQw7kljc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=tuSmS5f2; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="tuSmS5f2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789526337; bh=GfsLSrxjQLXcbeNbQxgHajKwYkkvuZ1OIYHFlEylIeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tuSmS5f2+P/xXLpUUsT0aUSexC1eTw8q4xgoQoYI6uRpOLBmYPHEA3voSRqKXwct7
	 BLfpxAPYmlaigy3aNvU5Q/MXZWvQNsZDZTVKXAygZgrCPIevefSTBubPOjYlORW2nw
	 ac/Rj8XDZ0t0a23aDQaYwRHYruenZxxWUfvRJoYA=
Received: from ubuntu.. ([218.196.207.16])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 9B6B6CE8; Wed, 16 Sep 2026 10:38:54 +0800
X-QQ-mid: xmsmtpt1789526334trw61qluc
Message-ID: <tencent_705010B6315454003C478AE79E1F215E6E08@qq.com>
X-QQ-XMAILINFO: MmPNY57tR1XnR2Uu41Cpv/l8mOrpdmWbQBdTYSMgo2bGpnQfAbRwCJVMkvkK1g
	 Qedex/JBl4tUNRuj4ocCC0CETZSQq8rn5ENXgvVTnxVjuRiHT4wVbk/i0RPZEp+3rdw5nw41qlHq
	 jgUpvppF1RxXT7b7+oLIpuhly87Y15AXAUJ2EoG0eQR/iW4z+QwFI1j2BDcQeVw2tCKNMToMPDxR
	 IblmqluIcD6gy31LQP25ZwUwzUptfrFqvwtDrB2aLrone1pzH52U+ZfM+U0dQGQtNFcWwgfMsUqg
	 +OMtPN8RtEZkC0Sm9SgkjI5U72ah938f7MsQVN7727bENUmerjAYInoYVf7AvEyKQnAwENkrPSKF
	 umM6mMprhTPpaIV5+57uxScZrVhl+KrwPNBffcGTTkqj2QHLAyT5lD7MRxpkMB9v3UTSo9btvLBy
	 9DFC/wqu9IKDZK/QpmfTrw7l09r6+QBv3G0ovsDXiKOMOKtK5gJF6ZP5ruVyrlpgAsuhHomm1UJL
	 FliAJjkA1/EsFHZpIJrvunT0b1IUN0yCAkhMS3neRfVCjVkKbUMFun3LURrtzARQ+ZU2699Brj2a
	 /LOEEJwHdI+X5PM/8Oj4TPqHMFC7H8nKqnXNr70DsaD9M7GrHrNe2M6RdJOISJ+m/UQdCCkafQR3
	 5VmJu7K00Whokpdm+FwDGutAiDYX2DG0xM7wGAehO1BaU5GhlFG3GIeyzIxKnWVsbEL0C9LbMCbF
	 JV+LWyniBPfepYSpJb37mtTBtToA2CCGNHgKUsbbu6OpPw3pOUu308014tKxIEoPOsxvORnVoTJG
	 dexQ7W8FyOTD6AkY5dGgrKIUBnpZhgo9B+gFzdW4UffkbkOCoVguWmsICSfPXm/WTS8BR9gqwIgA
	 JKlQqEsyBoeql6JJdRJvJXCvcV+b2ATXoBzROK49jkjzwxCjB8ihcnNxk/1BlwcIyCbKZFw3AnvI
	 rOIfzRkdL7MRASgqXYp9TEvbf1P95I+O0qfjq2QkpPQr/yo2cnYrbNkxx1SOa/UngITysYTrJzu7
	 Bkutax3t8PWqjowetYCfUxzrJYN+aK0pNAeH9QoDMr5HIk71ggy1EwZL4ikTc6AsL9gf/Mzo76qQ
	 D+M4xD
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: boris@bur.io,
	wqu@suse.com,
	dsterba@suse.com,
	mason@kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH v2] btrfs: clear free space tree creation state on rebuild failure
Date: Wed, 16 Sep 2026 02:38:43 +0000
X-OQ-MSGID: <20260916023843.70086-1-3497809730@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_F71ECF81628C274CC89FDB3304420C2D1506@qq.com>
References: <tencent_F71ECF81628C274CC89FDB3304420C2D1506@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_rebuild_free_space_tree() sets
BTRFS_FS_CREATING_FREE_SPACE_TREE before rebuilding the free space tree.
Several error paths return without clearing this flag.

The transaction restart failure path can leave the flag set on a live
filesystem, causing delayed reference processing to be skipped. Clear it
on all free space tree rebuild failure paths. Keep
BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED set, since a failed rebuild leaves the
free space tree untrusted. Callers must fall back to extent-tree caching.

Fixes: 882af9f13e83 ("btrfs: handle free space tree rebuild in multiple transactions")
Cc: stable@vger.kernel.org # 6.14+
Assisted-by: Codex:gpt-5
Tested: make -j$(nproc) fs/btrfs/free-space-tree.o
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/free-space-tree.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 1b3d82ae3de8..b7a4a6ade30f 100644
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
@@ -1390,6 +1392,10 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info)
 	ret = btrfs_commit_transaction(trans);
 	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
 	return ret;
+
+out_clear:
+	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	return ret;
 }
 
 static int __add_block_group_free_space(struct btrfs_trans_handle *trans,

base-commit: 587858367581b9c55c3690f4e63382ad622719d4
-- 
2.34.1

