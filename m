Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793682880;
	b=2so3d/nqCsQOGip0gOYcs8oQHKnQrgHZgv/r46+Uo8rmJD+O27sLUi/m9SuxPyf1IeKm
	 Lb/Oo1fuSMQK0Pf2LfDShkqP9uB3IVf8P+GH0cVSHdNl7MtLVHHPlIUCXn/eq2H6P41C/
	 L/MxT6MDM3PW87BuI67ECzpraIGNAuF0+IhaUaXWKWoU+HFgDx3IFrs1d5i6ReIWWYQbD
	 8dRWP67pbRL2I8PmuyyCLYSXC3BR0sYYE4cOjp4hfYD0UdTeajarmchdQu7zxgov4GngU
	 wLFWmLcQkNEyeqqqdS6/Kkg5KnzJ0VG7ZIyfb1U9KdjpZrW3+DILOu8OAWvlW2TDyIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793682880;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=QFqJZfxI68OJ74Q2mAhNTH5lVX7J+d76iJkBttk3GVM=;
	b=yx44gBt07jk0TAM3rKwwZfjNx3Kxgxt37G1Hdn/z6iClCMCiTLvA+VzWQlRCx5azi9bA
	 QhEwSJzGjymByywaaMtAD3/srIGie/BYceODyJXQSFjjvcPE27RsC7VUapQTt/vudy5Ex
	 ajETM/BMYd1QMk+2PCgcTC//MsdSQAV77CNauU7yt5Rb1ZapJfLBDE8QjH0f3ENL4N6y7
	 34WyE+SO4JJ1fbqJ7/uZ78zQwOw+M2onfyE+vpUdjzhZFapreeJTLz8TCRKRdoX/MVUHC
	 V38CXvXEsTQsgnyHqA41YXAEgxKBHkPxQpqUQ6oIX+we29qyANo0yAONb5dB8TcKIQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NzW6lGcZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202AD606A324;
	Tue,  3 Nov 2026 05:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NzW6lGcZ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793682880;
	b=yOQPKS62hKKUpKlHYj93syhW2sil+5Leb4XMajdkb9Bwx8dftQNTSGls40Yjp4eb7oGA
	 wM5r/i6LjdEyQ2ZU1F+8Cayy2ZmVkwJAs5j1HnW8Zjv7T+gz1k8tnxLkddqxogQ6vUt8z
	 DELkct4WorIoFiw1r0k9IoL3lByOtuNA/7djfP4sHguYtT98a0zEEcfED2LbCBT7QTTrw
	 aAqCyGFrU/cas3cuzXZ/9f03d3oGFWjUGtNKskwWCItHRxjOCbr+YwaX1Q/WifcgpNCEs
	 hk4U1oKjCXzrVIPsr0iPkVQudvZK7JRZOj2SgM9DH2fMGVxeb/7UxxHBnPMUdF/BoIg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793682880;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=QFqJZfxI68OJ74Q2mAhNTH5lVX7J+d76iJkBttk3GVM=;
	b=wnrkJqWtUJiLKQrCyTAg9Fxz0uTJ2oXUVZT0rMBJKijgy81EYpn/WzgkeitqE7ElLF4l
	 qL6nuiQ1Vn03XEcMUpALxvm/uVumixi5oCFSdVUqm/f0OjsDvaQp5FNX+tVo2YUxlSc4h
	 EHydOVY5b+PPmVzETaWt0Y1bLzw6s9QVp7SRsLCx1ZdBoW17g1HN69KXqkBcoI+aBvNvN
	 D75vHtA+a1vsYmjyXJ53Jvvwz7TAIEZLmknNUq1wGq+wA33aPpncEajo6BuvUtHScXXb9
	 6vl4ydAe2vXuiHEiFSYmqW+4FsfuIFAS8qFJq66b0QJexM2yL8z/nDPBA8n3U2Aqjzg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 759ED1F000C1;
	Tue,  3 Nov 2026 05:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793682879;
	bh=QFqJZfxI68OJ74Q2mAhNTH5lVX7J+d76iJkBttk3GVM=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=NzW6lGcZO6fH16atg8BayGYBiv9L+RwJqbXOMiUdoqYygM1zjEesIBbqVMEDg+TVB
	 Rak1fyPGP7K5i5Tm6iFgb0+6aGXVTRVRwNf7gJqodtfH0QdJWObCtS9YukgHjHjWwU
	 OWwYfvj75m47Dm1MY07nEx48GMJMnbaodwF7AIjd4EmTGIRbbeNacqX26HK8O4FBo9
	 D0Zyk/Ado3H28FKPiV0SZzbYXicgbzuU+9se2fDX+cwCrwC1dNcFbFw6fZa88whcbn
	 zY3SpK6p1K+sOyoKUjVbzDD2pht+LTMwRHJ59E8EV3iFPCEKIZZmhKVZptGMxkcz53
	 ezj01l934U2Zg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E24D4467B0;
	Tue,  3 Nov 2026 05:14:38 +0000 (UTC)
From: Dhruva Gole via B4 Relay <devnull+goledhruva.gmail.com@kernel.org>
Date: Tue, 03 Nov 2026 05:14:23 +0000
Subject: [PATCH] btrfs: do not extend a remapped range in btrfs_map_block()
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
Message-Id: <20261103-btrfs-remap-tree-read-boundary-v1-1-3617ae3406d1@gmail.com>
X-B4-Tracking: v=1; b=H4sIAK5t6WoC/zWNQQrCMBAAv1L27ELSaFG/Ij1smq0N6LZsUomU/
 t0oeJu5zGyQWCMnuDYbKL9iirNUsYcGhonkzhhDdWhN21lrHPqsY0LlJy2YlbkiBfTzKoH0jSf
 jvAuhc+fjBWpkUR5j+Q1ufXVPidEryTB9s48oa0HhkvF/gH3/AEFVaQSWAAAA
X-Change-ID: 20261103-btrfs-remap-tree-read-boundary-503b3dd63849
To: goledhruva@gmail.com, David Sterba <dsterba@suse.com>, 
 Chris Mason <mason@kernel.org>, Mark Harmstone <mark@harmstone.com>
Cc: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793682878; l=2983;
 i=goledhruva@gmail.com; s=remote-20261025; h=from:subject:message-id;
 bh=JkaXyO8vlkKPkq+yRGR+UNE45KtSSvFP9N/KdcZj144=;
 b=hG6XIN2PD7T88uha7j57W4vKiXvLFHAr7EoqNOD2ZhSXqH7hLejNB5U+ELqzula0pIAshQ/HN
 4pEblv1T1ziDKXpwz4udpZKWz6ts6MvGlRODAb1r8Pz+KIUcmz96pIq
X-Developer-Key: i=goledhruva@gmail.com; a=ed25519;
 pk=OBz78Vw5K+/+HyXjxg9mNOV2Bq087eJgHL749H+Xe/k=
X-Endpoint-Received: by B4 Relay for goledhruva@gmail.com/remote-20261025
 with auth_id=1318
X-Original-From: Dhruva Gole <goledhruva@gmail.com>
Reply-To: goledhruva@gmail.com
Content-Transfer-Encoding: 7bit

From: Dhruva Gole <goledhruva@gmail.com>

For a logical address in a remapped block group, btrfs_map_block() calls
btrfs_translate_remap() to find the address the data was moved to. That
function sets *length to the size that is contiguous in the destination,
which is at most the end of the remap item that was found.

btrfs_map_block() then overwrites *length with the minimum between what is
left in the destination chunk and the maximum I/O length for it, which
discards the limit set by btrfs_translate_remap(). The caller, such as
btrfs_submit_chunk(), assumes the whole length is mapped contiguously from
the returned address and only splits the bio at that length, so if the
bio spans more than one remap item, its tail is read from the destination
of the first item instead of from the destination of the item it belongs
to.

This happens after relocating a block group with the remap-tree feature
into fragmented free space, where a single extent ends up split in many
remap items. Reading such a file results in:

 - for files with checksums, csum errors that bump the corruption device
   stats and failed O_DIRECT reads;

 - for NOCOW files or files without checksums, silently returning data
   from unrelated locations on the device, which can be the content of
   other files or stale data.

Fix this by saving the length returned by btrfs_translate_remap() and
using it as an additional upper bound for *length.

Fixes: 18ba64992871 ("btrfs: redirect I/O for remapped block groups")
Assisted-by: Claude
Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
---
 fs/btrfs/volumes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3d4ef6725de0..e512d33f1bc4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7311,6 +7311,7 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 	bool dev_replace_is_ongoing = false;
 	u16 num_alloc_stripes;
 	u64 max_len;
+	u64 remap_len = U64_MAX;
 
 	ASSERT(bioc_ret);
 
@@ -7329,6 +7330,7 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		ret = btrfs_translate_remap(fs_info, &new_logical, length);
 		if (ret)
 			goto out;
+		remap_len = *length;
 
 		if (new_logical != logical) {
 			btrfs_free_chunk_map(map);
@@ -7350,7 +7352,7 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 	map_offset = logical - map->start;
 	io_geom.raid56_full_stripe_start = (u64)-1;
 	max_len = btrfs_max_io_len(map, map_offset, &io_geom);
-	*length = min_t(u64, map->chunk_len - map_offset, max_len);
+	*length = min3(map->chunk_len - map_offset, max_len, remap_len);
 	io_geom.use_rst = btrfs_need_stripe_tree_update(fs_info, map->type);
 
 	if (dev_replace->replace_task != current)

---
base-commit: 2637bdec0535a2044cd830eba9a79363651d9043
change-id: 20261103-btrfs-remap-tree-read-boundary-503b3dd63849

Best regards,
--  
Dhruva Gole <goledhruva@gmail.com>


