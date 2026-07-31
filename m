Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BA634D916
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 20:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785528489; cv=none; b=M/KkRR4dUPIEQV9KOLxyqQ9PXvU5t2ara/tkC8ZaqJ8/SMhyaOY50tK5wVo6YvBpG/aOXiEAWauRrTKINM/EhDUq/8urruvZfcXlsIvs6iguu7/9wJEKxAEp1K+6+r6JrJdQazPPXjbtCF6RkGzLKyX580RICp+oK9cNUvajrWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785528489; c=relaxed/simple;
	bh=3pyi4cyF55KZEhtZ9FN8A02G2ErjRkynWzqLnqgl4A4=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=u+xZqRgkxyWGVwngb14xAPgHpEkuZVjBKG95rtPBPYK7dZdif+Y3yrKdQMAxa1ymzIL8bSa8Y+vBf6dok8Z0I/1HT6JVD0pwLcUfdTDETYu0+d9fRNpSJh66wZC3ve5mBrHJI3QwHmXSgVo7VpSbo9AnY/lWkHYRoznC1lE/eKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=GyfG8V9O; arc=none smtp.client-ip=109.224.244.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="GyfG8V9O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1785528483; x=1785787683;
	bh=5deJwqeZ/boejxKg2KpO7perGULhpFRPmq9bPZmnqiU=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=GyfG8V9OkubsMTZU1Ekp/c/6HS8n760JchZmtjoHqRbTWk+wVaYaqNBjUbN0uB9IZ
	 LR7BpddHA+smnm2Oe6oOyqjbAkcvUxusWltId1KvaS43AecK38td15EQWIhtUoCHyF
	 32lIORnhZpiJxS75V68YG2yHBCjYTrAPX1MXFYHHU45C7UJ7JkJAv4FaxzWnVNZ8Am
	 /1Wi/5PhGCAaR3Hrtu4Xt3jCBkKgm5LnOn+xc6dd2j9D54b7he+gvFDDJFhjBo6sXC
	 OW01TPM0mhK4zFDagwPPd6QWJsp6hhs+LKrrlwZYeJLZWjOw01B8MwodSV2uBj4tia
	 66UM6KJkjihJA==
Date: Fri, 31 Jul 2026 20:07:59 +0000
To: =?utf-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>, Tom Rini <trini@konsulko.com>
From: Cole Munz <Munzzyy1@proton.me>
Cc: Qu Wenruo <wqu@suse.com>, Simon Glass <sjg@chromium.org>, u-boot@lists.denx.de, linux-btrfs@vger.kernel.org
Subject: [PATCH] fs: btrfs: fix zstd decompression of sector-padded extents
Message-ID: <9acf406b5e73fa83001e1951e883143e2afb8b2d.1785528314.git.Munzzyy1@proton.me>
Feedback-ID: 209578162:user:proton
X-Pm-Message-ID: 489277cc8b32bd96ba4b078068c52bf3d942620d
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Btrfs pads compressed extents up to a sector boundary, so a file whose
size isn't sector-aligned still gets compressed as a frame whose
declared content size is the sector-rounded length, larger than the
extent's ram_bytes. zstd_decompress_dctx()'s one-shot API requires the
destination buffer to cover the whole frame and fails with
ZSTD_error_dstSize_tooSmall otherwise, even though
btrfs_read_extent_reg() and btrfs_read_extent_inline() already
zero-fill any short tail. The file then reads back truncated or the
read fails outright, which is what breaks fdt apply on zstd-compressed
overlays.

Decompress into a bounce buffer sized to the frame when the declared
content size exceeds ram_bytes, and copy out only what the caller
asked for. Also trim the input with zstd_find_frame_compressed_size()
first, since the on-disk extent may carry trailing sector padding
after the frame.

The fix lives here rather than in the shared lib/zstd/zstd.c wrapper
on purpose: for FIT images, ximg and ubifs an undersized destination
really does mean a corrupt input and should keep failing hard. Armbian
carries the same caller-side fix for this exact failure on RK3399 and
ODROID-N2 boards (armbian/build#9651, #10208), where it showed up as
"zstd_decompress: failed to decompress: 70".

Fixes: 918adf8e0733 ("btrfs: Use U-Boot API for decompression")
Signed-off-by: Cole Munz <Munzzyy1@proton.me>
---
 fs/btrfs/compression.c | 76 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c69524d38ecc..017e61242a68 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -6,7 +6,7 @@
  */
=20
 #include "btrfs.h"
-#include <abuf.h>
+#include <limits.h>
 #include <log.h>
 #include <malloc.h>
 #include <linux/lzo.h>
@@ -137,12 +137,78 @@ static u32 decompress_zlib(const u8 *_cbuf, u32 clen,=
 u8 *dbuf, u32 dlen)
=20
 static u32 decompress_zstd(const u8 *cbuf, u32 clen, u8 *dbuf, u32 dlen)
 {
-=09struct abuf in, out;
+=09zstd_dctx *ctx;
+=09zstd_frame_header fh;
+=09size_t wsize, len, dst_capacity =3D dlen;
+=09void *workspace;
+=09u8 *dst =3D dbuf, *bounce =3D NULL;
+=09u32 ret;
+
+=09wsize =3D zstd_dctx_workspace_bound();
+=09workspace =3D malloc(wsize);
+=09if (!workspace)
+=09=09return -1;
+
+=09ctx =3D zstd_init_dctx(workspace, wsize);
+=09if (!ctx) {
+=09=09ret =3D -1;
+=09=09goto out;
+=09}
=20
-=09abuf_init_set(&in, (u8 *)cbuf, clen);
-=09abuf_init_set(&out, dbuf, dlen);
+=09/*
+=09 * Compressed extents are padded up to a sector boundary, so clen may
+=09 * include trailing junk after the actual zstd frame.
+=09 */
+=09len =3D zstd_find_frame_compressed_size(cbuf, clen);
+=09if (zstd_is_error(len)) {
+=09=09ret =3D -1;
+=09=09goto out;
+=09}
=20
-=09return zstd_decompress(&in, &out);
+=09/*
+=09 * Btrfs compresses whole sectors, so a file whose size is not a
+=09 * multiple of the sector size still yields a frame whose content
+=09 * size is the sector-rounded length, which can be larger than dlen
+=09 * (ram_bytes from the extent item). zstd_decompress_dctx() requires
+=09 * its output buffer to cover the whole frame and would otherwise
+=09 * fail with ZSTD_error_dstSize_tooSmall, even though the extra bytes
+=09 * are just padding the caller is going to discard: both
+=09 * btrfs_read_extent_reg() and btrfs_read_extent_inline() already
+=09 * zero-fill any tail beyond what we return here. Decompress into a
+=09 * bounce buffer sized to the frame when that happens.
+=09 */
+=09if (!zstd_get_frame_header(&fh, cbuf, len) &&
+=09    fh.frameContentSize !=3D ZSTD_CONTENTSIZE_UNKNOWN &&
+=09    fh.frameContentSize > dlen) {
+=09=09if (fh.frameContentSize > SIZE_MAX) {
+=09=09=09ret =3D -1;
+=09=09=09goto out;
+=09=09}
+=09=09bounce =3D malloc(fh.frameContentSize);
+=09=09if (!bounce) {
+=09=09=09ret =3D -1;
+=09=09=09goto out;
+=09=09}
+=09=09dst =3D bounce;
+=09=09dst_capacity =3D fh.frameContentSize;
+=09}
+
+=09len =3D zstd_decompress_dctx(ctx, dst, dst_capacity, cbuf, len);
+=09if (zstd_is_error(len)) {
+=09=09ret =3D -1;
+=09=09goto out;
+=09}
+
+=09if (bounce) {
+=09=09memcpy(dbuf, bounce, dlen);
+=09=09ret =3D dlen;
+=09} else {
+=09=09ret =3D len;
+=09}
+out:
+=09free(bounce);
+=09free(workspace);
+=09return ret;
 }
=20
 u32 btrfs_decompress(u8 type, const char *c, u32 clen, char *d, u32 dlen)
--=20
2.55.0


