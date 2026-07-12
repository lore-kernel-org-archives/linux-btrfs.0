Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFB73603C7;
	Sun, 12 Jul 2026 03:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783825992; cv=none; b=k6E1w4T1msnHfA6A08LjIg0QIO40udDWSXp4J13XNTepIroXed4Kr/JTuxEsMOaCkSNbDoadQ34yzj1hsa52jYf7V62bxFdWPeE95VmWk8t/O+E7SMmjZ8tdnW5u4rGGUR2CYNTXinsS5W1+H/EHPYGtTQ2dv49t6TSfFUVKeqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783825992; c=relaxed/simple;
	bh=yGktTK0x2UtIBGxjVkpIi2ZqHMtiUdKXXpl3AtPz60I=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=YEL7kXHKQo4fJk92OwmmDni1QNvJPTpiqrBs65dd8/VbZWnB1eYZZ7DlGX6WFnRT8Ai3jNSckWuI5ruvY4UagWJ4sbRtoP4iWucFhQJ4kn/b5p+wqq/DJBJ/4i97zH0nFJhRe6o8R1lQQVinj4/NQAjJqjUaXobZj+3Un4oXuh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=sDcKK5uP; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="sDcKK5uP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1783825975; bh=SdNWpuryue/SUm0h/v11nfUAhB9C52OKJqMi6OSF0VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sDcKK5uPjy9bhbPWS9XN8IeJXbu70tq9UKL3+mJmdy+9Gn3HhUcPRl3sftOVMbJrB
	 tl9C/Aid4lATdmwqvw4WGlIxvvvqAMJjPf0nvz5BAQHGaf99fUe20hq0hWnFLMa1LM
	 cjSy0pBt+jasjxVP/kRONtzq3uLv7AKGnc5sPaZM=
Received: from ubuntu.. ([218.196.207.7])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 2DC3F2A1; Sun, 12 Jul 2026 11:11:28 +0800
X-QQ-mid: xmsmtpt1783825888tsl81ynxp
Message-ID: <tencent_19048AD99E6321356E0F10A131F254603C08@qq.com>
X-QQ-XMAILINFO: N/WmRbclY25GRqBOdTRBTfYM/6LE4yuhZFijENdHQnpv1PdH906zFt4nLfoBYG
	 FaAXzsB6NWrWHQxUrvh2LOXFhKWBGG2GP7sDTWyTUjLX433BTnVIC9dFmvfaqdeVE0EdccFGZZLE
	 QkvbgECMlUNCEg0hOZ+pufGokwtPZZbanhKwwdAKontM8z9tpA3jU6ERu3Tytco2C77dx5xlKF84
	 L+nPNzjXMDpVH6LjCF6SdMOmKDv45yCtfNJPw6TcQtXUhkAl0Zh6aC7E0D6eiQd0/zjaa8ee5o6R
	 QM3vCDzhTNkW/QL3jeuPu7hEquGf4ULUNUD6jVuz63HauDk2r7LerFVpQerbQg8hvV0zD8gK2nhL
	 xGBCtQfP71PDUciRowgQPJKMkmCOfFeUdvNMR7cLmTvBcIg4tLc3Nt77AXf9ST6CsTozUq4dtJpG
	 vI0tttWrwEf15W1sCI2lAVJtxqTRVQ3x3Tuzf2LilRvynqulKrsgmn9xX4Ck9FqFdvewVDykkxJ1
	 TRnYvDGrAA+vaKGmIQ3+3cVByID/SC61YYnLe1Ao5BuuWZ48TyztSS77FnwgAM9H7tfZwjJSqR4p
	 n2H+4yV21U0zeeNx6zCC7mf375j72FLeMUrd0I51LD0RB3NBtYgx4/Z+FcOOiDy0TrKfku+9u7QQ
	 5wU6XCuxDcOlpiSel1lQIo+7Us9VP9qRldktCkR04u5hMMcIF6Be3jMR93nYbQSXd+AV38EsGiRd
	 og/9ymPBqjh9uImbxQkAoidN142xChtB00g/p2FVhiTP8RquSLCKBpo1xWtNWdkgTE8uOaJxYTTx
	 exqN4zmMAP396yJ4cWPnN8+q77bpKqZMZ1/xRaozwYXYHGNLZ8uhQfmx9rU24DazKQoooF+Y0lpC
	 UF2/QWVFYRUPvEYRUDHMum1mpfRWnqOhRhYrP9e9Otpdo+NQI9SEDNLYyU3ARJ26fZOIjvF0H+zR
	 XPDEwDoc5qFJqtQEK73ltHh5pdVcq0l7fKCOfUYRYf5/16WxTq0s2aVrLnxsgZZ9lTZRE4JPCIGV
	 BT8prlKv/sxUjb+olt977BbvICzMY=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Guanghui Yang <3497809730@qq.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] ext4: propagate errors from fast commit range replay
Date: Sun, 12 Jul 2026 03:11:25 +0000
X-OQ-MSGID: <20260712031125.1699521-1-3497809730@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_39D68A519E8921206E77105E313354703C08@qq.com>
References: <tencent_39D68A519E8921206E77105E313354703C08@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_fc_replay() stops replaying fast commit tags only when a tag
handler returns a negative error. However, ext4_fc_replay_add_range()
and ext4_fc_replay_del_range() currently return 0 from their common
exit paths even after internal failures.

This hides errors from ext4_fc_record_modified_inode(),
ext4_map_blocks(), ext4_find_extent(), ext4_ext_insert_extent(),
ext4_ext_replay_update_ex(), and ext4_ext_remove_space(). As a result,
a failed ADD_RANGE or DEL_RANGE replay can be treated as successful and
the replay code may continue with subsequent fast commit tags.

This is particularly problematic for DEL_RANGE because it may already
have marked blocks as free before ext4_ext_remove_space() fails. If the
error is swallowed, replay may continue from a partially applied range
operation.

Return the saved error from the common exit paths and make the
ERR_PTR() cases in ADD_RANGE store PTR_ERR() before jumping to out.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org
Fixes: 57a304cfd43b ("btrfs: do not panic in __add_reloc_root")
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
Changes in v2:
- Add Fixes tag for the commit that made the duplicate-insert error path reachable.

 fs/ext4/fast_commit.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 8e2259799614..fbb486d917b0 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2196,8 +2196,11 @@ static int ext4_fc_replay_add_range(struct super_block *sb, u8 *val)
 		if (ret == 0) {
 			/* Range is not mapped */
 			path = ext4_find_extent(inode, cur, path, 0);
-			if (IS_ERR(path))
+			if (IS_ERR(path)) {
+				ret = PTR_ERR(path);
+				path = NULL;
 				goto out;
+			}
 			memset(&newex, 0, sizeof(newex));
 			newex.ee_block = cpu_to_le32(cur);
 			ext4_ext_store_pblock(
@@ -2209,8 +2212,11 @@ static int ext4_fc_replay_add_range(struct super_block *sb, u8 *val)
 			path = ext4_ext_insert_extent(NULL, inode,
 						      path, &newex, 0);
 			up_write((&EXT4_I(inode)->i_data_sem));
-			if (IS_ERR(path))
+			if (IS_ERR(path)) {
+				ret = PTR_ERR(path);
+				path = NULL;
 				goto out;
+			}
 			goto next;
 		}
 
@@ -2257,10 +2263,11 @@ static int ext4_fc_replay_add_range(struct super_block *sb, u8 *val)
 	}
 	ext4_ext_replay_shrink_inode(inode, i_size_read(inode) >>
 					sb->s_blocksize_bits);
+	ret = 0;
 out:
 	ext4_free_ext_path(path);
 	iput(inode);
-	return 0;
+	return ret;
 }
 
 /* Replay DEL_RANGE tag */
@@ -2320,9 +2327,10 @@ ext4_fc_replay_del_range(struct super_block *sb, u8 *val)
 	ext4_ext_replay_shrink_inode(inode,
 		i_size_read(inode) >> sb->s_blocksize_bits);
 	ext4_mark_inode_dirty(NULL, inode);
+	ret = 0;
 out:
 	iput(inode);
-	return 0;
+	return ret;
 }
 
 static void ext4_fc_set_bitmaps_and_counters(struct super_block *sb)
-- 
2.34.1

