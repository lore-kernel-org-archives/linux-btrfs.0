Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794805770;
	b=Z2KDnlT6fUlctOcb3wEwOBgp/7nhoKxMSWZpoOSVpxh6KK9Cg76GvbDR2RhfAsnqQpqP
	 i0ZeQO8+y9Llf5WCkLYSDTOSQTBwDT8KB5BBNrv8ledQX5JjAqs8ACMdJCPjMExsQyvk4
	 6tHk2GLJ7E+npfBixI5BS1mItZJjzRug4SwpAsx5rKkRtCCbk6noSPxRHiKbJLPWf8edU
	 tCeac4CUzSlm3I0hN/1YqE3Nukx2dYmtuQZGlB8gEesLxtfeqZpcxYX8Ivb/cZF/IB65X
	 jrsiapmI1opBBwncJupRu5p9z9zAYEUBpiuHnH05eDwi44xXLHze7H4q/qTkLjmv2Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794805770;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=apEooVHM/zxyQP3G0X4cdeJmjPk5PeY1HsG+4/IToxQ=;
	b=qHVZYgSNRrYTlH52wCtk+gQpr5VmZAbNvAk6jwbKnU68/v9ljy2A2rYIWnV+GW7dc+j2
	 YVbfxEpgKwmqply29FjCeGgXoXti9Njcdmhxy99CnJ6Hrkc+Lnq3vTUT8AGF1kQqnZ6b7
	 ERCfm0Li/vOBY7vq22ANI/PopfA+Q5qAhsJfqek+nR5S5WpGgib0c9hoOsklk5qSYZinU
	 pLnTGwSKYVma8t/rXYewq/K1pinAwhmg47ckmo6C7l672/1s7WkiJygv0WBl+BE542r/r
	 NmcZA0iUgTCr7VSMdZN7mcBLOoGtz5iV1QG0wx4xUMO/jG+DFLkAxNfom/CfW6qiGTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="jBqQv1/l";
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D88F606A32A
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 05:09:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D88F606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jBqQv1/l
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-37628596783so5072164eec.1
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2026 21:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794805769; x=1795410569; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=apEooVHM/zxyQP3G0X4cdeJmjPk5PeY1HsG+4/IToxQ=;
        b=jBqQv1/lxHMtL6SbibPfS0foHq4tzG7BNYDeNaSz1p0OHGeFxEoIPom1AKOIddGWuW
         U3q0TzRRgUsNpEDeRbrRUT6EroV7pKqlSNdH2RN71HSDHaTHPu1EvalXwOYJ22GuSoxo
         55fMfYfuntsxGX0B29uBAFO6FbER1e6suYUtJjlaw256eG6myI2xOvSoMcUlQseVnAjK
         Us3Jep/rLxGkKtTVj3RjQGvUbvHwvLweANrCoM4wwTTO7vITp5iSqaJ9lMionzkntPJm
         YbsUEGLNP1ne0amhgueWXq0NLaJyfTLDt4ytS5HANOjsRwpwyQ7csP5jeilDgFDPegcZ
         /RuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794805769; x=1795410569;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=apEooVHM/zxyQP3G0X4cdeJmjPk5PeY1HsG+4/IToxQ=;
        b=IMYO/ppDHytVLarLctTFwpIi6QHSHOWWr17q1hItMBmvpJS6uOMhdvXr3qCfDFC5uu
         kKyQoyrP9h7EVxCx5A7MAeDFltPHay4O8aB3cgJcOTtoN14D7u84YwhOVBPVa7I0FNyy
         2Z2Q+JI7CA/9mM5zCYDYgk7g8Cb+C6ie6ivfRgtJu6fo5Ez6OKmxsHRSyxrEyXYclJaS
         i+dlx9cShpPT/MR8bjVWvTMc7IU54h9jdygVOyM7fBy+TifeGXL0KyYDCdHe8mIe2BMb
         4/j9J+9ppzLWV8fnKjnzeLEITOVQ3VxY7fsovuka6LhmmD2q+iUAT9f0apEnIEOn/bY8
         N9EA==
X-Forwarded-Encrypted: i=1; AL+hErGNtfde+kfm7yYUUdwPvXxinDJDIYGzU7FuJPXm4aecSRi/XEQGJVKTqAOlDNnsAUqsE1cclMP7LoGQLQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/vhnRTBAp4R9y0Qm5A2fuIbqqAZ8a1woGgEAUu4CikpccVmaHQ
	geIEi/fWrgdCka/ZAzdZskEkm01zaaxXSF3LyXUNmu5QFGL8cdDuFW+rzvUODmRmRXM=
X-Gm-Gg: AYBFou2/Yz3S5Fs9xMStxZSlOxPkaomvI6gS7YaVjSfL9beDqB8JxBbl1hJyaFqoFb8
	xxIG4FYmVyV80i8jxgraQ5wxfgtW0VroWDlHqFp91sVK87i4gL4eFZWWd6s/F4IXnKcsMEmpIrb
	CS/3GfTLVPnA5xXxSQXGmnQWK7ZliM9O8W6+pxpVFMFGC2+RQLGeCQOmEy0XH+EiZzxVBh2yyYe
	eEiyJT8XKNW93IIevC8F/yi/RDCfA0u7iXouBEtLBnDKp/3Wu4EUCdO+ZWOdp/3EHpLcnqPAryd
	1lAfzRIKLA7PjVo3S4t/DqQxQ3ZOPFtqSMg3YvyzhrFKRg3j/nAH+S2ca/e8f1oJmfNsxdZAsuY
	EW4TNLfp3Q9AtnfCos6QflRIkut5liUNeJca+q4jqbS155OYNwl/W/aHOxZU9lpQPDMvgRCzs2c
	iMoMxa4GdpmoTkSgMXd15qIJ94Cqi9f3+n2qwcRlaYXD5wCXzZVfvymVhxjUlEBV5Zztpxs41g2
	uwtC6ZuVjj3B1ZEuKO18Xdg+fhnVu0+OcOxgpVh45pksIjkRHsM9bH7L6JbvCGxXs3PXwOfqjIf
	M6FqgvEVl/BWBu3YObBvO+11fAlz/T5qMvZKuxcBaiZdeOikv+ItX6EVWK/ADgBSyt+A
X-Received: by 2002:a05:693c:820d:b0:36b:d3dd:2e85 with SMTP id 5a478bee46e88-379676f8641mr9410862eec.36.1794805769280;
        Sun, 15 Nov 2026 21:09:29 -0800 (PST)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379553316fdsm30962114eec.5.2026.11.15.21.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 21:09:28 -0800 (PST)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] btrfs: tree-checker: reject file extents with oversized disk_num_bytes
Date: Sun, 15 Nov 2026 21:09:22 -0800
Message-Id: <20261116050922.310476-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
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

check_extent_data_item() only checks that disk_num_bytes of a regular or
preallocated file extent is sector aligned. A crafted image can have a
compressed extent far larger than anything btrfs writes, and reading it
goes wrong in different ways:

- With disk_num_bytes == 4GiB, btrfs_submit_compressed_read() truncates
  it to a zero compressed_len and submits an empty bio:

    assertion failed: IS_ALIGNED(logical, blocksize) &&
    IS_ALIGNED(length, blocksize) && length != 0, in fs/btrfs/bio.c:895

- With a 4MiB zlib extent whose num_bytes and ram_bytes are above 4GiB,
  bvec_offset + bv_len wraps in btrfs_decompress_buf2page() and memcpy()
  reads past the zlib workspace buffer:

    BUG: KASAN: slab-out-of-bounds in btrfs_decompress_buf2page+0x3e0/0x650

Compression and encoded writes never create a compressed extent larger
than BTRFS_MAX_COMPRESSED. An uncompressed extent is at most
BTRFS_MAX_EXTENT_SIZE for a regular write and 256MiB for preallocation.

Reject a file extent whose disk_num_bytes is above BTRFS_MAX_COMPRESSED
if it is compressed, or above 256MiB otherwise.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
---
Changes in v2:
- Use SZ_256M directly instead of adding a new macro, and leave
  inode.c alone.
- Shorten the comment.

Note that kernels before v3.9, without 24542bf7ea5e ("btrfs: limit
fallocate extent reservation to 256MB"), could create preallocated
extents larger than 256MiB. If such old extents should still be
accepted, the uncompressed limit needs to be looser.

v1: https://lore.kernel.org/linux-btrfs/20261116044543.282187-1-teel4res@gmail.com/

 fs/btrfs/tree-checker.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index f021ac14babf..6bd1dfc58e7d 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -244,6 +244,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	struct btrfs_file_extent_item *fi;
 	u32 sectorsize = fs_info->sectorsize;
 	u32 item_size = btrfs_item_size(leaf, slot);
+	u32 max_disk_num_bytes;
 	u64 extent_end;
 	u8 fi_type;
 
@@ -377,6 +378,19 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 		     CHECK_FE_ALIGNED(leaf, slot, fi, num_bytes, sectorsize)))
 		return -EUCLEAN;
 
+	/* Compressed extents are at most 128K on disk, preallocated ones 256M. */
+	if (btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE)
+		max_disk_num_bytes = BTRFS_MAX_COMPRESSED;
+	else
+		max_disk_num_bytes = SZ_256M;
+	if (unlikely(btrfs_file_extent_disk_num_bytes(leaf, fi) > max_disk_num_bytes)) {
+		file_extent_err(leaf, slot,
+		"invalid disk_num_bytes for file extent, have %llu expect <= %u",
+				btrfs_file_extent_disk_num_bytes(leaf, fi),
+				max_disk_num_bytes);
+		return -EUCLEAN;
+	}
+
 	/* Catch extent end overflow */
 	if (unlikely(check_add_overflow(btrfs_file_extent_num_bytes(leaf, fi),
 					key->offset, &extent_end))) {

base-commit: 3aefd67f08f8ed59ed0fa90619b25856df415031
-- 
2.34.1

