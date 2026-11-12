Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794505177;
	b=tNpCzqklMp1Wy3wDuYFDhM/qTPCTaVAuRNF22ZwXIKLQcFbnEvEBeeGlJ2iZU1rQXlOI
	 P0SXo1mHe+ryaSxIl2lA6N3alJsV4bOK1NRCg6hJ3O3TakdC0AuHPMTMsBFTBXFyuWFD2
	 Qi9J8Kb5ChVU9ncm8aUqZJhgiErQsrz/jVr187z4UJ/ep2RJb5h1Xuqhji6I+Hz6e/JHV
	 xByhxj/wCSHYPlbWIdl/OOhPyKWwSy3J5LER9X2TeZGgTYWjQ7DbAMmt4YzYsUPmiECEq
	 pLKkwlAeziHLc/26kubXQaCSvAV5j7rfXorGX/O/KIemh6oQSB+2TwH1CXiUKhz99iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794505177;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SOzQObsU9mKRLCKDYOycNTXWczNDCseu98qT3H7uVmk=;
	b=B/QCqh2XgvmGftAefQSW23jDDzvqU20mz7Whj/AhUphI9dguLvxdK2YyRLaw1stC2W2g
	 HMSHc3kkLWopJZe+r2YR8RNd61elFDP0pc3EodkktR7AeR6ErL+EhGd1fgB8bPPxyRvKL
	 XMP2FTgAzPTbtFyQozylzlGgCUomokuv81wvn2iq01FyyrdTIX63DQltAL7P5ogYdh4GP
	 VQ0UrkFHFETS+SJlhfhWOhCF6KSl3ZwgtI4JOXXe4PChFcgzPckxjygPf47qGj7gVcKkf
	 EyXrDOBumhItw8c14jXsoDM8rjIRGNGoc9mw0DoGER2/hZZ+suUdQZtSa7sPT0+gdRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ihdYFzmI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E93606A8A3
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 17:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ihdYFzmI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77621F000C7
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 17:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794505177;
	bh=SOzQObsU9mKRLCKDYOycNTXWczNDCseu98qT3H7uVmk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ihdYFzmIyZpcTihe5m9v6KBVNc5jpCgZcEms/2Qd0wxri+jhXPJZ7Hx71RqUryXoL
	 VUvPv2/KVNAC7g5B//ZW6i7dYMpw+JYqOe11k9NLbKhEjP9X9Fjyn1w+sD/FZi7rNw
	 aJwKBDs+t+r6hbTBJDdT6hMNeBwvNJlBypQGGyjs/m74Tufn8y+XZBSCV5OuHHlrMe
	 eEBd9nOswT+oVfoRG1Di05pJadrrSKqBXfGy3ada84DMC8SPBDkOtKjee6k/BMg/JV
	 DfxswDWlXskweW6hUj5DBlNcNRW8RMPCiixJgixe8+C+YyKtdVf1ryzjDc4G92ZPQ7
	 /0YMvBxyzjrnQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: send: fix invalid access to inline extents in clone_range()
Date: Thu, 12 Nov 2026 17:39:34 +0000
Message-ID: <3a9994c5325a0d6687798909f9d02688420aad83.1794505101.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a8f80de0fd18699ffc6f9fbbdfa794e80e9a1fe1.1794504038.git.fdmanana@suse.com>
References: <a8f80de0fd18699ffc6f9fbbdfa794e80e9a1fe1.1794504038.git.fdmanana@suse.com>
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

V2: Fix a missing extent item offset access.

 fs/btrfs/send.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 1b903e75cec0..3cc7749f0452 100644
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
@@ -5906,23 +5906,26 @@ static int clone_range(struct send_ctx *sctx, struct btrfs_path *dst_path,
 			crossed_src_i_size = true;
 		}
 
-		clone_data_offset = btrfs_file_extent_offset(leaf, ei);
-		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte) {
-			clone_root->offset = key.offset;
-			if (clone_data_offset < data_offset &&
-				clone_data_offset + ext_len > data_offset) {
-				u64 extent_offset;
-
-				extent_offset = data_offset - clone_data_offset;
-				ext_len -= extent_offset;
-				clone_data_offset += extent_offset;
-				clone_root->offset += extent_offset;
+		if (type != BTRFS_FILE_EXTENT_INLINE) {
+			clone_data_offset = btrfs_file_extent_offset(leaf, ei);
+			if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte) {
+				clone_root->offset = key.offset;
+				if (clone_data_offset < data_offset &&
+				    clone_data_offset + ext_len > data_offset) {
+					u64 extent_offset;
+
+					extent_offset = data_offset - clone_data_offset;
+					ext_len -= extent_offset;
+					clone_data_offset += extent_offset;
+					clone_root->offset += extent_offset;
+				}
 			}
 		}
 
 		clone_len = min_t(u64, ext_len, len);
 
-		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte &&
+		if (type != BTRFS_FILE_EXTENT_INLINE &&
+		    btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte &&
 		    clone_data_offset == data_offset) {
 			const u64 src_end = clone_root->offset + clone_len;
 			const u64 sectorsize = SZ_64K;
-- 
2.53.0

