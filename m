Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794504095;
	b=Q3Hhw54Em11bd/maTddVrzWX2aISF+vTZGdKCJQB713qcHLlFhPCnFFGk8OVuZvHS6Vf
	 0mG+aiHcSvdIGO4pZhyWEhAAHyyjLeKDJVjNwF8IVkr0zTIZL86uUraHFD/K5CQOa8Aou
	 i62u2pUOGMJB3Jr1OLEvfBEWI9FUqFSjHUppB7jwEDGo/EqqAePJUAgwrD1qTvWMsY3pJ
	 F/0m4/N8Vvu1nWbIQldZ/9tLLZ2OtTHRBx2fybPv0mK2lfWGUmcrNGlzwFtEdMYi2lE4t
	 jadnHgREJmXow4c2FdxilNE8K/BDfLa+SBpwIc3VRz9GW9h8oKqMDDnJpxxY2k1QFXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794504095;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oit/BrokSHfFLk93O/z101RO6La0fA3uthdktksR/tI=;
	b=v9sHNHMyNMfjLLu6AaYIC5WJONbNiCUesfU7EkvZVU6aSFORbzG94QB9zbt7WcIp/ljR
	 I+VxP0ojME1rjIRqKdTFcmnEhxfZs/9eKhChriIhgO6aR2EExCMB5bO+IwSUxlkzy3NGH
	 xbfm/NY4tS0VHtEn2WIPptpBmzr0FH5nKfnoembipQU23Rwr+VWePhfYvUG6kAk/kpGiL
	 uH0hhUgiZj5uVGwyjQc7KJMfFVS6J5ZejD/IN9b2LjBEJHD3EvKMtXoWby+O5ErqibnFn
	 u0yR8B+UOV+SI780BgwEa6kxRG46RyIAwkA6fbEjBbkff3qJbe2+bLU+PkJb0iquo1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eYIWP4Af;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB86B606A33F
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eYIWP4Af
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497631F000C4
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794504095;
	bh=Oit/BrokSHfFLk93O/z101RO6La0fA3uthdktksR/tI=;
	h=From:To:Subject:Date;
	b=eYIWP4AffLSk338GKzI1NVEnK45niVFfh2/UhthcrujA31kuU/+rgx3POrUTYxocH
	 1lb6+JbN8D4vvpv0X4fkQ5SH2yNCVobaTC70ajIpQbWUM9BDB64EKKvQfIz2Ow4mRw
	 zw+fPZhr2BsvMxvj6t4s6SkMe7FI1NXUXxB6lGRvY3D+XEpnChjygI+NWNAcvcftBe
	 P8lr3ZMbDaOwX0ARZrXVpDhpN7Qbfc76F5Mekdfi4SsBK76zmybkRsTaSYhyTqUXGz
	 i5KNuHd/Xm8X9lNc3f3fVg5AqBVQD87INOJWczjUt+uEvIugf7+AtmGCa6yySnTRtQ
	 f5h8BuEgBYBmg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: send: fix invalid access to inline extents in clone_range()
Date: Thu, 12 Nov 2026 17:21:33 +0000
Message-ID: <a8f80de0fd18699ffc6f9fbbdfa794e80e9a1fe1.1794504038.git.fdmanana@suse.com>
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

We can't access the disk_bytenr and offset fields of a file extent item
that represents an inline extent, since the extent's data starts at the
offset of the disk_bytenr field and the offset field is after that, so
both fields point either to inline data or beyond the file extent item
in case the data is too small.

Fix this by not reading the disk_bytenr and offset fields if we are
dealing with an inline extent.

Link: https://sashiko.dev/#/bug/linux-b662b951-0491-465b-a262-f01a108d8146
Fixes: 040ee6120cb6 ("Btrfs: send, improve clone range")
Fixes: d906d49fc5f4 ("Btrfs: send, fix file corruption due to incorrect cloning operations")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/send.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 1b903e75cec0..d0b9429f14aa 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5842,7 +5842,7 @@ static int clone_range(struct send_ctx *sctx, struct btrfs_path *dst_path,
 		u8 type;
 		u64 ext_len;
 		u64 clone_len;
-		u64 clone_data_offset;
+		u64 clone_data_offset = 0;
 		bool crossed_src_i_size = false;
 
 		if (slot >= btrfs_header_nritems(leaf)) {
@@ -5907,7 +5907,8 @@ static int clone_range(struct send_ctx *sctx, struct btrfs_path *dst_path,
 		}
 
 		clone_data_offset = btrfs_file_extent_offset(leaf, ei);
-		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte) {
+		if (type != BTRFS_FILE_EXTENT_INLINE &&
+		    btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte) {
 			clone_root->offset = key.offset;
 			if (clone_data_offset < data_offset &&
 				clone_data_offset + ext_len > data_offset) {
@@ -5922,7 +5923,8 @@ static int clone_range(struct send_ctx *sctx, struct btrfs_path *dst_path,
 
 		clone_len = min_t(u64, ext_len, len);
 
-		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte &&
+		if (type != BTRFS_FILE_EXTENT_INLINE &&
+		    btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte &&
 		    clone_data_offset == data_offset) {
 			const u64 src_end = clone_root->offset + clone_len;
 			const u64 sectorsize = SZ_64K;
-- 
2.53.0

