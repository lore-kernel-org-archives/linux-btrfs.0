Received: from mail-10630.protonmail.ch (mail-10630.protonmail.ch [79.135.106.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3949A395ACB
	for <linux-btrfs@vger.kernel.org>; Sat,  1 Aug 2026 00:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785545733; cv=none; b=nhhlEV5EFVQpnRH1AYOOo+gsbai7X1k4au3f9VFFypOas/3LCQDhCvg3oiJuTuTr2n3y71vXIjUFRSnWtPv1dewVDagk1BnPxk5hU+znYatgVSEYLCS4hBykJXMf1vS18rztVNeYnZetW1Eib1D9d3NrY4XmFyJ0qqsYcb+tZ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785545733; c=relaxed/simple;
	bh=QMISE5Wq7QFTdK1Rjs6MUHXWIPyshzgLqE9JvjnhBjI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jzCLn0hGxSYmJtlLurshZgH69kFPf+Koy0eJkSPX5mWhZs3OsP4XEMmpmvO9Ve8EON5m1nwTQAzx30xKGxFhCRVNKYne1v74neeEYAMp1T2jnpEZxAl99KeEPZ2mDEhi2eHZUesOWOEKwyjG4YZ1kvkIUf0BtFFJkIJyYhyylBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=AcTjr2za; arc=none smtp.client-ip=79.135.106.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="AcTjr2za"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1785545723; x=1785804923;
	bh=pkHMFKmNJnJUddebBPqPaq+HQK9yaG/nhCavMmztCvs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=AcTjr2za/pchPvTnAnocdjJkpO2ec7IRsPaMG64qwRCWFvz8+II4C0FBrcX4Wjhd6
	 WnvjOkFveWnszm23wbmsB5RLxFo5SEuoOHQC51PgZWrfTRuee6oir+a/u1p/L+KLJI
	 k90bLRzwSYWOzpl7a+dBv+V6LFJTOWdFDdq/361BHKMGDdWnj36S4kx8VSw8DDcHYZ
	 gUtF9CD6pJhE4DaqMZVJOHfs/nFyIlCL2yC4eGqsOrsG2Je8YxXZ75vCor893UYZfS
	 G+F7FbQADF2cpLQ7Djp3vjrL8lrKd04mF3Ep5KMiFZ4cbGKhTxXvY3d7TpPRMakcCy
	 dDr9U+frJnpAA==
Date: Sat, 01 Aug 2026 00:55:20 +0000
To: kabel@kernel.org, trini@konsulko.com
From: Cole Munz <Munzzyy1@proton.me>
Cc: quwenruo.btrfs@gmx.com, sjg@chromium.org, u-boot@lists.denx.de, linux-btrfs@vger.kernel.org
Subject: [PATCH v2] fs: btrfs: fix zstd decompression of compressed inline extents
Message-ID: <f6ac2bbdb9b559041cb0c82efccf89ea7262cb43.1785545440.git.Munzzyy1@proton.me>
In-Reply-To: <9acf406b5e73fa83001e1951e883143e2afb8b2d.1785528314.git.Munzzyy1@proton.me>
References: <9acf406b5e73fa83001e1951e883143e2afb8b2d.1785528314.git.Munzzyy1@proton.me>
Feedback-ID: 209578162:user:proton
X-Pm-Message-ID: 35b1dcb1d958db46f6d16eb7b27bedfbc33e538f
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The kernel compresses an inline extent as a whole block:
run_delalloc_inline() calls btrfs_compress_bio(inode, 0, blocksize, ...),
so the data is zero-filled past EOF and the resulting zstd frame declares
a content size of one block. The extent item records the unaligned file
size though - __cow_file_range_inline() passes i_size down to
insert_inline_extent(), which stores it as ram_bytes.

btrfs_read_extent_inline() sizes its decompression buffer from ram_bytes,
so for a 1900-byte file the destination is 1900 bytes while the frame
decodes to 4096. Since commit 918adf8e0733 ("btrfs: Use U-Boot API for
decompression") btrfs decompresses through the common U-Boot helper,
which uses the one-shot zstd_decompress_dctx(). That API requires the
destination to cover the whole frame and fails with dstSize_tooSmall,
error 70, otherwise. The streaming ZSTD_decompressStream() path it
replaced stopped once the output buffer was full, so it never hit this.

The kernel side does not notice because fs/btrfs/zstd.c streams into its
own buffer and copies out at most destlen.

Allocate a full block for the decompression buffer and copy only
ram_bytes back to the caller. An inline extent never spans more than one
block, which bounds the allocation.

This shows up on RK3399 and ODROID-N2 as "zstd_decompress: failed to
decompress: 70" (armbian/build#9651, #10208), where it breaks fdt apply
on zstd-compressed overlays. Images built with mkfs.btrfs --rootdir
--compress zstd do not reproduce it, since btrfs-progs writes a frame
whose content size already equals ram_bytes. Only files written at
runtime through the kernel trip it.

Fixes: 918adf8e0733 ("btrfs: Use U-Boot API for decompression")
Signed-off-by: Cole Munz <Munzzyy1@proton.me>
---
v2:
 - Move the fix into btrfs_read_extent_inline() and size the decompression
   buffer to a full block, as Qu suggested. decompress_zstd() is left alone=
.
 - Rewrite the commit message. The failing case is compressed inline
   extents, not sector-padded regular extents: Qu pointed out that
   ram_bytes is always block aligned for regular extents.
 - Drop the zstd_find_frame_compressed_size() input trimming from v1. The
   inline item length is already exact, so it was doing nothing.

v1: https://lore.kernel.org/u-boot/9acf406b5e73fa83001e1951e883143e2afb8b2d=
.1785528314.git.Munzzyy1@proton.me/

 fs/btrfs/inode.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3998ffc2c819..53f1059e1ef8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -362,9 +362,11 @@ int btrfs_read_extent_inline(struct btrfs_path *path,
 =09=09=09     struct btrfs_file_extent_item *fi, char *dest)
 {
 =09struct extent_buffer *leaf =3D path->nodes[0];
+=09struct btrfs_fs_info *fs_info =3D leaf->fs_info;
 =09int slot =3D path->slots[0];
 =09char *cbuf =3D NULL;
 =09char *dbuf =3D NULL;
+=09u32 dbuf_size;
 =09u32 csize;
 =09u32 dsize;
 =09int ret;
@@ -380,8 +382,17 @@ int btrfs_read_extent_inline(struct btrfs_path *path,
=20
 =09/* Compressed extent, prepare the compressed and data buffer */
 =09dsize =3D btrfs_file_extent_ram_bytes(leaf, fi);
+=09/*
+=09 * The kernel compresses an inline extent as a whole block, zero-fillin=
g
+=09 * the tail past EOF, so the stream can decompress to more than
+=09 * ram_bytes.  zstd's one-shot API rejects a destination that cannot
+=09 * hold the entire frame, so give the decompressor a full block and cop=
y
+=09 * only ram_bytes back out.  An inline extent never spans more than one
+=09 * block, which bounds the allocation.
+=09 */
+=09dbuf_size =3D max_t(u32, dsize, fs_info->sectorsize);
 =09cbuf =3D malloc(csize);
-=09dbuf =3D malloc(dsize);
+=09dbuf =3D malloc(dbuf_size);
 =09if (!cbuf || !dbuf) {
 =09=09ret =3D -ENOMEM;
 =09=09goto out;
@@ -389,7 +400,7 @@ int btrfs_read_extent_inline(struct btrfs_path *path,
 =09read_extent_buffer(leaf, cbuf, btrfs_file_extent_inline_start(fi),
 =09=09=09   csize);
 =09ret =3D btrfs_decompress(btrfs_file_extent_compression(leaf, fi),
-=09=09=09       cbuf, csize, dbuf, dsize);
+=09=09=09       cbuf, csize, dbuf, dbuf_size);
 =09if (ret < 0) {
 =09=09ret =3D -EIO;
 =09=09goto out;
--=20
2.55.0


