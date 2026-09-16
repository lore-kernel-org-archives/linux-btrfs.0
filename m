Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6BE352021;
	Wed, 16 Sep 2026 05:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789535816; cv=none; b=T4YMD42t4ykISh/GvXebBRq4g2ZjK1ewuI4iHgovg9beIjaDMrvX7DinR8+EJLzCStq69aFATa8e67b6EEMpPOvqxmiyEDbC6rV8Jd/V9i1f7Br0UGz53IvkMoLSTlarJW7WDQUML9VMX74Y5pbD5rqJCVxnQJccNOKcIZLrgl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789535816; c=relaxed/simple;
	bh=ZZ3gNLyt0OSmF1y+hffBPyCkPhdUi+kh9g0lgY5Iqrg=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=hfhdvDk10lo63MX3y1788WNnM9v27LXghsYUCTNKCuOjikyWx3lFe5tEhrCmfTprApd/abte+zpC3oNKo0pqksCWzLfxjNW7PvQEBFcQXieBH59D2BhFXDBEgVbTKmt1PXLCqPjbxqirRTsXz5A4bqX/2DPpLzzajayoGKkbOfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=WtNBAhD3; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="WtNBAhD3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789535805; bh=dCDMN4tIAKy5rSMRvJj9LYg8yQ6X6N8fomnvsEyzGLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WtNBAhD3BQnDBB2PZCEr0igPQy+UygHOwyuVjNGIp6zrnEIoZZN/8y5Zd4TW0rDhM
	 1UXe1g2bb4IQJIQZGmcJqoBFnwUiWqlYy4BpbMAmO/sKteYZTKIkRQpr5KT2ICl83F
	 uKobaKrZU3V+T5d9vrDwKNdVZaHqz7gwQgveoycY=
Received: from ubuntu.. ([123.52.25.101])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 42B28227; Wed, 16 Sep 2026 13:16:43 +0800
X-QQ-mid: xmsmtpt1789535803tcnad7rxv
Message-ID: <tencent_17320F87E281276888825B1844508C179506@qq.com>
X-QQ-XMAILINFO: ONRS4p13EOE4tl3RfVbjJ398uTcnpc9FB430l542518BMkpKiQOnkqKg+8taH8
	 /zEnPZKnLT/A0V+0d+HjnfjkYqRUosT4SL9FEyYNLjaOr+BGhbIacRPL7/ydiKfrKDTAU/zIWNWI
	 P/VRuURZI5kCSMhGqk6Em4nRRELKTXwYxWbzid0r70b89gv1iq6eetZt3yU8DkAAy/YUPoVO3Ykj
	 dmu6H2tX5daBFdNyRToMy7CzfrSoY19ZEmOWNIbfWYjGd9k68hjIX70Vi1nitACT2En8E7L76QSJ
	 rjnfB624UAzyj7GP7lxWxHQOPdDSppg4HLq7EuKlC0HnDbMTo0wh3V4c7J/lQJShwYKrfDba9rj5
	 ErJQ/x/tcxUH33woqgksVo+0rCaPDF30HP6e5KRBxKDzVVU8YU94qQqSk5Oi8F9t7u4oBExrsIdN
	 BWeJlOabSW/NnRwmfgoYvD17GD3Ohu6KzcEHQzzlkCTaqZ6Rd/A8ZsTa8gS6I/m+68hLUyY3J8LC
	 ubS+LKaIIGEzzIne8CHJ/YbBhne8FSsSUHwl1hA7RhQ5z3MMUupPUds83LDS7eS+uDv62K0GC65d
	 wwSmc1xW3udWF2WOHNgBMvN6ihnvZxTPQ45Ntucd9RcBoIFbLCR5VoGttdsJgyxtFKaRZE22k8cH
	 2vi/mE+w5x6V1rguVFBT6VbhT0+hiXW15+f+hkd/zOQYByHNnO2n4tCvg9TN5mPwhWlem5rHgDub
	 qBY5vm91X3x0TO7WSSp8XK/Oy9cu3mkVkpY29gtmXw3ygQmmjr8RaCxAgVpDYp0IhJwr//Ap2Hf2
	 DzdSjBLT9unAu/sTOr2VmM5Rf2wZeUVimjZzR+V7n04IFVtAsKQpmdzR4Do6Bh5rlIYbaOAws0Y6
	 Gk1FGy/aiug7TqL1jVFeoIn+VvLvDJBCmEXl8pv9x6FHBCkIoGjlzDduOA+1bWCZORIkqQYzeolP
	 0h9MDJfUlGF+h/HGAyZRxJ34Uf5fwPNggP3zIUXt+UBi+PeV6PX/Oe87Qe6TlkCKi9T0ACTns2CS
	 2ujnKBpYZmbGfHt/h12McP9PX1rD81mOUO+OyJOAfblV76t4f1ZQ2sgy6AuNPv7SQRW9/i2bQUm0
	 FCnkPFE6qruiJxkQuOESUk9Y3ZcCH39j0ZBlUx
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com,
	boris@bur.io,
	dsterba@suse.com,
	mason@kernel.org,
	fdmanana@suse.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH v3] btrfs: clear free space tree creation state on rebuild failure
Date: Wed, 16 Sep 2026 05:16:38 +0000
X-OQ-MSGID: <20260916051638.386366-1-3497809730@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_705010B6315454003C478AE79E1F215E6E08@qq.com>
References: <tencent_705010B6315454003C478AE79E1F215E6E08@qq.com>
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
Tested:
  xfstests btrfs/015 btrfs/032 btrfs/104 btrfs/131 btrfs/352 (pass)
  xfstests btrfs/quick: 261 passed, 30 failed, 90 not run on
  Ubuntu 5.15.0-60-generic
Assisted-by: LLM
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

