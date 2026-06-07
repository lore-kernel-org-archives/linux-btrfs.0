Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F4D1A08AF
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 05:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780809962; cv=none; b=dr41WQ03OPQ/DcGbP+r+go2PYBjSdESQjaYAyZDQh9L5a/fUhNjgtv+F99psgGVWXrF5VyUxLDf1vaqmeArS384LpxPGqyxaRNWSiBSYbJK7adMR63Rj8UuiXYdAU+9Vhqo2PnbYUAnU7rX58LoG7mMqsKZEi92PO5/t5sitonI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780809962; c=relaxed/simple;
	bh=Yfuz+hVs6SbvRvsDZG+siIcstu1+iOAM5KMiMmTt8bg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nGpeL1Tv0hdcVR4N8VkPGTZcU4cDS6PKe/qwe3zvX8M+pPIm5Z8pDTOsXHaX5I3a+dqdm7oFhJ3ynfQnxGB5ht+ABocRpc4RfxTyfsKFVKk54KNAzelxgZlyxhAAII0Eph5wBW6nTaO0+U4CbEa49gLMe4VFNz3qiaqmTQO/y64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qWQEkMKe; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qWQEkMKe"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-304fb780deaso3260316eec.1
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Jun 2026 22:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780809960; x=1781414760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6+r/NEq3Jk7MhYa+FPtly9s4frz2VRLUWpO470tm3tA=;
        b=qWQEkMKeThop9XTfyJGnkwMiEKM4u7r6nehwxJ4+fvHd2Z3Umw1FwnXYM3w3KsNO2g
         9fyW1v+6bPT0xuqIwYFPOqh9EQOQH7MChMvgA8Lq0zUU+oTzNVNuzpVMi1jdtooLGZR9
         GbrCjc/6BcY9TBqcVyioixrrNXCEWOpZjwa2m3RPixFIaiPDGI5LB+5IyYvp470mhYu9
         w5woD65PxdqPY7x9oIJgGhA13q0WYhWzpYoG7JMupwYX26cr0u4572TGAPWrvZMWZnYp
         rBx/g9QrqjidF2PSjIYp8orw2B07/Ei8wFiIySGU6RSto34H54iQD0cUClHBo2p9oKB2
         Ao6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780809960; x=1781414760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6+r/NEq3Jk7MhYa+FPtly9s4frz2VRLUWpO470tm3tA=;
        b=cRn5r+j8+rkn4W85R2kJr9X8ZRF7So5GC19BgxwngcPayxXoegA+zWpcsFPe7jvol/
         wmr6imJrIoiaNsyrzT2UC2wFt3MA/g9SkFbQfQdgiFvGd9P36AptNc2SLmQZqHaqRaHZ
         pWUkloNZeL8X5Xf/nr7oSAH8ZUq18WGkNaMAZSF/zTtMoAkrhpr/FqrUIBK5035aPdrT
         k/EuUvVgvunRjNTMdBW4oaIQNdJOETo6PBqb+UWFKfPCJpYQs3oAzhIGm/7zIo4hFDHv
         LVO79wvZ6W2UqBdvaktb6TmwcQNbYjrUW5ol+2WHo78yzIUVPAhj1iCzUoFmciHABI4J
         EAdw==
X-Forwarded-Encrypted: i=1; AFNElJ/ZNhafDpq6MZ3sSPQvame9bqHUhQ0wb9oomd74Bd0uRNFd0f3FtZhFFIU/T+XcwbAzZxTqXTtDow2dpg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMuoWtbwcUtttvbYtMwSGMBnRbrprUl2bX32QzJD97Atq3ukHf
	YfQTZJmczizg6qbAvQ5IccAlCHs9jAi6ehgTryxQUBVAWeclui20QcJaFTK+eoWPsfw=
X-Gm-Gg: Acq92OH0/wZ2GatIWqK9pbbUplpKDwD2vroVZp1MhDD4Jo3tnbJUfTFsDlefeLmG7OV
	AltqWk5Q8sji+k3fKW+ol1p62xxDbFRAHN9eJQK46QY9Sk9gp9MpbuIev2pXizIG2SuvPJeFdPy
	sxTgG/PLtmtkrt0x+ey7DM600JW0RMluHvua1aEIGs0OxgYP85RDyKL6IhujDDUQ+H8HDR7be0l
	kW4r79eJaYBkCzC4/rmQubp8duLh944urpb9QbnSKHbI9RnCP70wGTzSIQRWfhnAPIjIE37l2xT
	S6eBlYsrTIhyy1jSmH8aUd4FDR5ds7FhurHewJcH6TeDfpTxACIZrZ/REIZdXhEJ0rkek5SyHq7
	hAhQQ5qrBuvRuKL6cZ13Z0fCgs3JXJkUNkk/oKqqg4jlxXxaWq5afaaf23os0rfrRGaidRnD22H
	HpVvf6msdLu3J/nzn0qXpUqFwdAWWQZysJIx6/emeX+Cwqqw7DalTt1B+P14g0mPHLSah4kMZsE
	DKwo99QCCfCiRP7rA==
X-Received: by 2002:a05:7300:5721:b0:304:e6f8:7cc6 with SMTP id 5a478bee46e88-3077b1cc946mr6100480eec.19.1780809959776;
        Sat, 06 Jun 2026 22:25:59 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db55f60sm16663808eec.6.2026.06.06.22.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 22:25:59 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <clm@fb.com>,
	Qu Wenruo <wqu@suse.com>
Cc: Xiang Mei <xmei5@asu.edu>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH v2] btrfs: lzo: reject compressed segment that overflows the compressed input
Date: Sat,  6 Jun 2026 22:25:13 -0700
Message-ID: <20260607052511.4131138-3-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

lzo_decompress_bio() validates each on-disk segment length seg_len only
against the workspace cbuf size, not against the compressed input size
(compressed_len, the total folio bytes of the bio).  A crafted extent can
carry a segment whose seg_len passes the cbuf check but runs past the end
of the bio, so copy_compressed_segment() walks off the last folio:
get_current_folio() then returns the NULL folio from bio_next_folio(), and
with CONFIG_BTRFS_ASSERT disabled (default) folio_size(NULL) faults.

 BUG: KASAN: null-ptr-deref in lzo_decompress_bio (fs/btrfs/lzo.c:383)
 Read of size 8 at addr 0000000000000000 by task kworker/u8:1/29
 Workqueue: btrfs-endio simple_end_io_work
  kasan_report (mm/kasan/report.c:590)
  lzo_decompress_bio (fs/btrfs/lzo.c:383)
  end_bbio_compressed_read (fs/btrfs/compression.c:1065)
  btrfs_bio_end_io (fs/btrfs/bio.c:135)
  btrfs_check_read_bio (fs/btrfs/bio.c:180 fs/btrfs/bio.c:285)
  simple_end_io_work
  process_one_work
  worker_thread

Reject any segment whose payload would extend beyond compressed_len before
copying it, treating it as corruption like the other on-disk validation
failures in this function.

Fixes: a6e66e6f8c1b ("btrfs: rework lzo_decompress_bio() to make it subpage compatible")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
v2:
  - Return -EUCLEAN instead of -EIO to match lzo_decompress() (Qu Wenruo).
  - Emit a btrfs_err() message when rejecting the segment (Qu Wenruo).

 fs/btrfs/lzo.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 2de18c7b5..6e4aa2285 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -491,6 +491,17 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 			return -EIO;
 		}
 
+		/* The segment must not extend beyond the compressed input. */
+		if (unlikely(cur_in + seg_len > compressed_len)) {
+			struct btrfs_inode *inode = cb->bbio.inode;
+
+			btrfs_err(fs_info,
+			"lzo segment overflows compressed input, root %llu inode %llu offset %llu cur_in %u len %u compressed len %u",
+				  btrfs_root_id(inode->root), btrfs_ino(inode),
+				  cb->start, cur_in, seg_len, compressed_len);
+			return -EUCLEAN;
+		}
+
 		/* Copy the compressed segment payload into workspace */
 		copy_compressed_segment(cb, &fi, &cur_folio_index, workspace->cbuf,
 					seg_len, &cur_in);
-- 
2.43.0

