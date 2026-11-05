Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793909276;
	b=gOOl9tymUtIoykf2Qnz+gEjjE5xx73c79HDHP4E/q6LDNIVjWnLnxi6un1PgP24BtZm2
	 XdVov2tD2Rgoez24SMhNJwOVX15rD2v2SQ9SkkCrHflmuJ2tm0echs329klhFGNQV0C8p
	 g7g9N8OMKQ6ecfJg76VUkQqNKBBGCHnB6VXVe/Wa70aojv6qxxyfQsA0qi4UKig75MhH3
	 ZN+0tS21gf1GZe+8hFzSIQULTuCNvP2J4A7e1fkBjT0uLbyJqzV4HkqUWC+TguaOGgkb4
	 xASdvlm6BnROrfRq7P0gHF+RyDszVFyXgNZVaPAsFKFTIp1WKj8e5mI96RK6Cr5tqlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909276;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=T/2PAL7hUGJebSowYu23xGWuD/WJk7TmHCUF8nszkHg=;
	b=l/rrlrm2g5zYmDx4r8yFtIskzlu1qZ2I9YJQDdYcZibyAMue2Np3HrpB6rmQLan3QIax
	 k+4whFwv0a3pGkthBo+w3XhI57Qx2TxedgT84n/UcKAWYdRmS9dxnWYX6M7WxibIVX23l
	 FDil68AdlHiIiWUrHI0jI42MNczhBefbrLH3DckdvgpMx4rNgxw+slGX0gbeVDzc2n+3R
	 t5GY/3NQ9Thw/YFrRp6hPTrwOBm9HjSGRVnRc6eBJaN1GsNH7gpBswpjvSlsn01hogSn/
	 iEufrKN5zVGaqVnR1/ghXr79Vm5VcDqgV3tENrnEisVdqQ/OwwZZn3QuAx6qB2/skTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MDqapQsV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1D0606EE87;
	Thu,  5 Nov 2026 20:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MDqapQsV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A6C1F0089F;
	Thu,  5 Nov 2026 20:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793909275;
	bh=T/2PAL7hUGJebSowYu23xGWuD/WJk7TmHCUF8nszkHg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MDqapQsVuCaw7b0dy4vIpwXLiBZinSIZN5991E9cVyEv55eHytCZaO1p47nGafgtV
	 hb9cqAm0LvvmCsJYxTIUuseC+7EMDcOYfAVN8UXivW9IOLyCUnCkSl/1BWKwDIZcRb
	 rSZnFoZigbifaqvCoflEutxNhpEp5EBxWowMDnbfEwYVGec+5ZvOYIPFUFuHQQVXEl
	 xzz/o9jf6I+yjFLlF1+EzeVNjfQVnHdko+Fxualfcu8KBjX564inlYvB4jjQBm8Vpy
	 cTUwdq/3wnD9N5wVYTLs63XorvkfiT43XkrVBQ9i8r0fIERqStIpvfpQ7Y9xIEPnq4
	 ZIsGgp4Pk4ILA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 05 Nov 2026 15:07:42 -0500
Subject: [PATCH 1/4] btrfs: honor FMODE_NOCMTIME in btrfs_write_check()
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
Message-Id: <20261105-delegts-btrfs-v1-1-a42a2b93cdc2@kernel.org>
References: <20261105-delegts-btrfs-v1-0-a42a2b93cdc2@kernel.org>
In-Reply-To: <20261105-delegts-btrfs-v1-0-a42a2b93cdc2@kernel.org>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chuck Lever <cel@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1400; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=wTJQtHb1orW+Db9PDHKojgtAGA66pfaColtLfHUr7/w=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq7OIZ53rtYIkQ4JNIn+bB3tgcNNewHJWWtyxQ3
 xnPmOsZQX2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCauziGQAKCRAADmhBGVaC
 FSrVD/sGmTnOWSj89XwtbyteD965qibdu8rqzAYtNeY+rnyzUXZPjVNQhgH+pjFnXNbn1Hvm9VQ
 8dLBUVZMWvN4saZpqoKhdDNFWDs7fuLD0XOxrZEY2Yy54uQXWywS7q2MFbz0GA95fMXfrqt4TNz
 RxOXj9rDfg5uCtybGiaIRmups4Lw8TRChgpWtEjJ8frf+CPJZghDaudfnnWMausZmsZA0K7bot8
 RKIF9w0+ggQ2k3qU+Xu8u6E3BcMacVKyVIvmNkXg2bSKiLOgC8OcGpOPA4lZKfWNnfr7FifTzaf
 uq1uq01cml8pHLqwsghNM2IvuZuDKqcq1NMbmC+SDCbVdepCf/0M0zlZKwV8F2cYHan8fFL+lja
 aQc8I7metHJL9Hee8IhIp3NJQAXmxaqUhBqK7OnXiL4lR0o9kCCEkFYBUJLrHZ4Vjhkvr7V/IZA
 JdA3lV8xz5YrZs0ocYyXq48NsLtx0WKwC5nX6KGN/3ZGXEJdhIkADA/iGPA+6VPIZ/kIt85cYah
 YBXbECs3A5hqUpTChPYO8LQZ53Lq85amcYxsnwEREBaUrG0chTxF3KbuhnBlccKeht4/PBRC2bB
 S3VzuEJdt/7LLbFLA3ZKd0X1D4tDz1Ybs994bnZVC6lq/GxcSZOPhbwI1u1FsUMawXxUcFkMhr/
 BxcAPGIZI8Ed3jQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

btrfs_write_check() open-codes the c/mtime update and checks only
IS_NOCMTIME(inode). file_update_time() also skips the update when the
file has FMODE_NOCMTIME. nfsd sets this flag on files that have a
delegation with delegated timestamps.

Thus, on a btrfs export, WRITEs from the delegation holder update the
server's c/mtime. When the holder returns its times, nfsd restores the
mtime. nfsd cannot move ctime backward, so ctime stays newer than the
time that the holder reported. Over NFSv4.2, git test t1092 finds a
stat-dirty file.

Skip the update for FMODE_NOCMTIME files too.

Fixes: e5e9b24ab8fa ("nfsd: freeze c/mtime updates with outstanding WRITE_ATTRS delegation")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f978c6524aa0..94475976d8cf 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1053,7 +1053,7 @@ int btrfs_write_check(struct kiocb *iocb, size_t count)
 	 * need to start yet another transaction to update the inode as we will
 	 * update the inode when we finish writing whatever data we write.
 	 */
-	if (!IS_NOCMTIME(inode)) {
+	if (!IS_NOCMTIME(inode) && !(file->f_mode & FMODE_NOCMTIME)) {
 		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 		inode_inc_iversion(inode);
 	}

-- 
2.56.0

