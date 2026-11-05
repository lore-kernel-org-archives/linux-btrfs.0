Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793909278;
	b=OsiFZ5e2L1j9JXLKV1bWO/px72epydKl7U9w8w6FExoftapQbu8+ylwr6jbX3AQPKLPc
	 wGVVekRV4kAV0YITZHJH1oqzpyjjdZIH8Au1holrXp42DCZNusVVE7JFhSZK03tAhcLl5
	 grm1xYEskIpQSOr2SZCXUZHN0ZRyf0r7QiaPqwfr/HD2fd61k/u1wcb+n03Xjw4iQT9I1
	 IUqHSrw4wtkomST5cD+HCyqeSCcyhficQOBv6ef6c3Vr9synEPQgpiGSSXY2Pu1tOBPto
	 D9Di3Z2rw2EOgDTmVxqqaE80pWy2lKE1WzitjhtUJuBoBS0D5x7GRsNnzhDQARicUrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909278;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=p5iUCz1isRC2GW6gapgK/ddSgOzDGue9jEHMxCwoytQ=;
	b=PZ+yLopBjlTg1eZqZH+0Z7MWNnXiR/Tc7aAgdjIUYpKz/VJ95mFYiA7aZEZxocsS7H4v
	 E7yUq2U94PUEodFrT8oZSlgrg67zPDAwFTGv7jsnsdGTbeRVlTYfqyepoaI+zBhIeEWpc
	 +svoyPYLQ/DvPOtrI1DfK7ECVwHaMsLkO32JQqxDNerznrg79QtV1qqippbHngj9Jjt10
	 a/mQ+I7eTj1SACGpdT5jxBpqSBuugkrfw7KrKYaXk5cy0nFUQTIPwUV/YnXWeP7ej6HnM
	 MzY01WsraMDhbSshtPHljz+AHhcj++QGj+CdRS38SuAMYZhx/R6h/ImASjhHKutwtVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QbMuHhoh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642656082BEE;
	Thu,  5 Nov 2026 20:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QbMuHhoh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1401F0089F;
	Thu,  5 Nov 2026 20:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793909278;
	bh=p5iUCz1isRC2GW6gapgK/ddSgOzDGue9jEHMxCwoytQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QbMuHhohnD+qtBNZzSYzYY8mYPJVyVTafS4cb5xx6O4Spn/vJL2i+459ZiLDp7U0d
	 QLORD8Rc2L3OATvMztvkhDqitC9f6xCh7Bz0x1Hnqk71TJ0/kNv416PsVFlmAj2odS
	 HWAt4Ee74+fP0vylQxaMeqwZBvXDU6t6GTsEmilZnlN8nzswokccYLCvK28E+MT+bV
	 oRkW9x+j01oHbvbS7jiyUQU8HXQ5SKm8CfQA2fPHh+bbfow174GFegFJCwH2H3ixo/
	 DYz9XmYHiNnby7pebwMKZtX2eSDB2t8Ayjncbi2IxWyW8XzNjoIgJvquo/2IXDBpsq
	 vZfwrMnc9kn1Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 05 Nov 2026 15:07:45 -0500
Subject: [PATCH 4/4] btrfs: honor FMODE_NOCMTIME when cloning
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-delegts-btrfs-v1-4-a42a2b93cdc2@kernel.org>
References: <20261105-delegts-btrfs-v1-0-a42a2b93cdc2@kernel.org>
In-Reply-To: <20261105-delegts-btrfs-v1-0-a42a2b93cdc2@kernel.org>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chuck Lever <cel@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2751; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=pRgnTpK2u35+xto2eNfxwBrEofeM59hEloMF22A3KMA=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq7OIaK1qGurRJlRp/ln9yb29af7xGDB4TuK7Y1
 pnaQnXmGhmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCauziGgAKCRAADmhBGVaC
 FWCYD/wIalWhnzKE+u69X1Yo81OFVva9nJYOwOFS3MNNix9hb+kujO9YTkQmedg8jynVt7GjYJq
 8oAJK2hX6f4KA33mhy4LBh+FXSDMjFeJMUVn7uQa1gn/WQYzmoWRXMyyzW9UMrHcTgkbBpddjwQ
 cKmq4gYyb+mp69U6ayCshXfxFSktT/DZ6fA/lxPhs9kQ0UMIF1JY0ohKcQX4gWHHP+xQONsTs5f
 XoZEotb6jDyucYDAWHY5zDsC+btuul8vEMhIJWIZSYgE6ZTZqKHu1uqhyjppkmXixz8lXjd/bk/
 kcIJaCfZGjXPjlmHfiNbqF/jJToYP3eLvabssAvAptQL9Jyajk9eu0pXs1Hgx4xZNonoqpE71Hu
 uCC+/rBeAQ5madD7Jpr+DB/Bq+CiD+hZDYil6GhjdcBAY8rpUF4YFbmn9/ttbp0H2tdQ5JEPWH0
 F7uwJrANA7yeKKhJk/vzTLd61KunEoxrXSL6lrroU3Uhc7eeHmRW+IUFeFe9W6mJnS4iSi8jz3v
 zpwoEckTba39S69BM9wGn5jJ3scTld2F1yJah/phQAwNiH9DIhkivSsl2lKa1K3a7IHFuPccJkj
 N5dGWaHqrPesOt3MP4q/fG2SYyDVMgc1A12cnTTPDj859LesG7CaK2XLHN0QFiEkC0bUJE9XCMd
 h0nqJstLwTTcvlg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

btrfs_remap_file_range() calls generic_remap_file_range_prep() through
btrfs_remap_file_range_prep(). The file_modified() call in
generic_remap_file_range_prep() skips the c/mtime update for
FMODE_NOCMTIME files, but btrfs_clone_files() then always tells
btrfs_clone() to update the c/mtime of the destination.

nfsd sets FMODE_NOCMTIME while a client holds delegated timestamps. Thus
a CLONE from the holder advances the server's ctime, and the times that
the holder returns cannot move it back.

Pass no_time_update for FMODE_NOCMTIME destinations, as dedupe already
does. Make btrfs_should_update_cmtime() available to reflink.c.

Fixes: e5e9b24ab8fa ("nfsd: freeze c/mtime updates with outstanding WRITE_ATTRS delegation")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/file.c    | 2 +-
 fs/btrfs/file.h    | 1 +
 fs/btrfs/reflink.c | 3 ++-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 6ff494846aea..6f525ce42a2d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1030,7 +1030,7 @@ void btrfs_check_nocow_unlock(struct btrfs_inode *inode)
  * with FMODE_NOCMTIME (e.g. by nfsd while a client holds delegated
  * timestamps).
  */
-static bool btrfs_should_update_cmtime(const struct file *file)
+bool btrfs_should_update_cmtime(const struct file *file)
 {
 	return !IS_NOCMTIME(file_inode(file)) && !(file->f_mode & FMODE_NOCMTIME);
 }
diff --git a/fs/btrfs/file.h b/fs/btrfs/file.h
index 18ebc8c2d6d2..9e35db3f4466 100644
--- a/fs/btrfs/file.h
+++ b/fs/btrfs/file.h
@@ -43,6 +43,7 @@ int btrfs_fdatawrite_range(struct btrfs_inode *inode, loff_t start, loff_t end);
 int btrfs_check_nocow_lock(struct btrfs_inode *inode, loff_t pos,
 			   size_t *write_bytes, bool nowait);
 void btrfs_check_nocow_unlock(struct btrfs_inode *inode);
+bool btrfs_should_update_cmtime(const struct file *file);
 bool btrfs_find_delalloc_in_range(struct btrfs_inode *inode, u64 start, u64 end,
 				  struct extent_state **cached_state,
 				  u64 *delalloc_start_ret, u64 *delalloc_end_ret);
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index f67350bba9b9..5154db82ef3e 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -801,7 +801,8 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	 */
 	end = round_up(destoff + len, bs) - 1;
 	btrfs_lock_extent(&inode->io_tree, destoff, end, &cached_state);
-	ret = btrfs_clone(src, inode, off, olen, len, destoff, false);
+	ret = btrfs_clone(src, inode, off, olen, len, destoff,
+			  !btrfs_should_update_cmtime(file));
 	btrfs_unlock_extent(&inode->io_tree, destoff, end, &cached_state);
 	if (ret < 0)
 		return ret;

-- 
2.56.0

