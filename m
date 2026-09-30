Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E4E353A71
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790778355; cv=none; b=ihmxIDHWA/kLJnNBcEv26inoi1svqm6+8GPYV17nU1NK09pSGULD2zZxhmCw5cLQ5Hds3/gCupHWx6gdNcupB7GQu7mXMEpqZ2SR2E8NDx2yOQKtuwEtOoLvdAOfGQBxS3lmQrCItv3gnoDl1oJQOmlIWEEREmBZBvaf0OBT2pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790778355; c=relaxed/simple;
	bh=HR9ARooNkkvwSekWk7ArbTiqG+hz0vm84f9DKVm79eM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nM9/niZfaMJ4v3zjsPYjL7RipdXCU41VMWUmSGwU6/W+/k5BFYX32vnk5YR32b9LmlCu7Dt5Sz/AzXrrSDFtEuQ9hwXg9h1DMC1KKu86ff/uniHzqz02TbMMIDRFhsc6oRrtXhQsKFZ3g5tt9wZYHmgmzb1uN8iDoz59EC8mreM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfQhasSU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfQhasSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BC91F00893
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790778344;
	bh=CERmpiHDvES3OBPctN/aP1rdbQrdW+K7enkZ+el62ac=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=YfQhasSUET8PU4OJKzu8fzxTUMu/72ZcVjQdO9xBHxo9Mxlx9Ph8PTBFa6nx912zS
	 B5fCONXsPNhNcfCiHEcDhD88byUMkZNhtO55NgLKUlHLrukDaIsGYhrk26hiG8s9SZ
	 AWgX0gd+iJL3jCV9Or6679nUZn9XyMPLEmjN0QC97iwGzoiJ/dvpMOCZMR/JGxKBad
	 sA09BYBHu0s+kxLM5aRP9axzsILVo7SaELsebZOR5HfSqqxVVtFZ3ydOMNTX0SVSTc
	 CKpXodXJV9r9/FNQMoTXVMah6UMWTVip1t7QM28FH0qDdi2Pg1cOK7EEEumLCgPTbk
	 OGdeiROTQZb+Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] btrfs: fix incomplete iteration over fs state when logging messages
Date: Wed, 30 Sep 2026 15:25:34 +0100
Message-ID: <f2339c779d0dc4f5e3b4e81636b0010acb475a43.1790772326.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1790772326.git.fdmanana@suse.com>
References: <cover.1790772326.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

In btrfs_state_to_string() we iterate over all the bits set in
fs_info->fs_state using for_each_set_bit(), which requires its third
argument to match the number of bits, but we pass it the number of bytes
of the type used by fs_info->fs_state, an unsigned long, which is 8 on
64 bits platforms and 4 on 32 bits platforms. This means we are not
iterating over bits in the ranges [8, 63] or [4, 31].

Fix this by passing BTRFS_FS_STATE_COUNT instead of sizeof(fs_state).
Note that we could pass BITS_PER_TYPE(fs_state), but since
BTRFS_FS_STATE_COUNT is 11 and we have no bits beyond that, it would
cause pointless iterations over fs_state.

This also makes pointless the checks for the bit being inside the limit
of BTRFS_FS_STATE_COUNT inside the loop.

Fixes: c067da878156 ("btrfs: add filesystems state details to error messages")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/messages.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 198d1747c80a..6debf0d4acad 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -42,9 +42,8 @@ static void btrfs_state_to_string(const struct btrfs_fs_info *info, char *buf)
 		states_printed = true;
 	}
 
-	for_each_set_bit(bit, &fs_state, sizeof(fs_state)) {
-		WARN_ON_ONCE(bit >= BTRFS_FS_STATE_COUNT);
-		if ((bit < BTRFS_FS_STATE_COUNT) && fs_state_chars[bit]) {
+	for_each_set_bit(bit, &fs_state, BTRFS_FS_STATE_COUNT) {
+		if (fs_state_chars[bit]) {
 			*curr++ = fs_state_chars[bit];
 			states_printed = true;
 		}
-- 
2.47.2

