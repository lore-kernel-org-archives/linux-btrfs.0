Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F6E284B37
	for <linux-btrfs@vger.kernel.org>; Sat,  6 Jun 2026 17:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780768119; cv=none; b=V1UO6/qGim+USzOfDh2GzP0H0rrjEFo/DC8qKUxbDcyS0nSQQDrVrlPEHkF85T+V3crWcHBWGZxaNJeFFikxtP2Z2MKAnXdX53GJT3SUx1yv2nwjS4m7jnkdWIWxaOQc7g98u+YAAGa/tP7/ALxbV994AUW6Oa4N08VldL5KHOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780768119; c=relaxed/simple;
	bh=esj0+me47Hpqa++zG/MN104DC7l42HDD5I8U95RWcrA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JK9pEqqX2q2WhE130eWU93ELta1kk2HhCoSX5TxLq59Z328PqyZoa8Etw9YGVfC8sudkiOlwkULvAKSi5/WahYVF8m3qBZKO2WhQMs1FaP87jcaTjrk0XYsnv+LxtoLlN7ehpVyEP8YFrId3ZL39VbM6JwdqLTmUZbwkA02MYL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g+tSjIKn; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+tSjIKn"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3045c195251so2664970eec.1
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Jun 2026 10:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780768117; x=1781372917; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KlxF/aKfahEbMb1MyGXmfzFGlckZB7QejV9z0bvjHDs=;
        b=g+tSjIKnTYWKc2sczw6j+FTSPYlZXxHUD2eRUUiZs7adM5BUFUI69cAj5ku2kaltlN
         5Lk+lgBOk3FbL2nqmWaVrrvAFDeCWhrLp/5TPKaWMY+379Uf9ygipCvTB6AMZzNaT3Lo
         yxX8LNwMqNV6GAGkMwEkV4627G6MpbKH80LuwN9leCVg1q4U2pBVFjeiDFroI7Qx5qF7
         6lF5GF8SQdnUKYOgemWlAJYT5XWk3XMxR031sj4p5ZsoGugyvhLuORPsjwMtyZr41Qw4
         xlpExRLBKs3HhxUfFFcmsHxE3/2lxbv4M5nofhSkeySYfstZ9LLd3UWk1VICxO0+WmEf
         czng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780768117; x=1781372917;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KlxF/aKfahEbMb1MyGXmfzFGlckZB7QejV9z0bvjHDs=;
        b=HlbZ/zDiOIGQ+2c+8zW2yJUjHfsrp8mawDEwvSAyjFg2wRJrVfxW95JC0zgalASsbB
         m9P9MwSBxUO6hjvsflWhpG+G7TKjXIMedHoVdNcktN8SHF2cilXKCpNsOKGfRA2+6sDf
         Q5CAB/lOLHYiyxTbK+BM/1aFYTr7sUrozCBGJlPB3VFZBkl/snohrhmSaeuiHKe3fjXg
         CLNIs7apKo+3rqbsAV4QoG9BVE1sUd4Ta+kf09acL6HsL7oTzqrVhkYXxbHnng6cD5um
         Yjt5VRNfy9hlcN9HVdqCK9m4Kk/UgxslCLUBxG/lsYmdx6UhepPVHE1G4Z6lV/a5eZpv
         /mgg==
X-Forwarded-Encrypted: i=1; AFNElJ/CoZIyHUG7LkmniZkjg67qoXRX8BxVV7roPdZGxCyxY1gnAPT0xNRgtxeJ6LQ9zqn2oY3LuccVDEC4MQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4elFvXBcwbX9MrAk8Oo7aNOibr37ltyEjNcRZjItgETI63css
	mVoPA4RwRCSxTZNeO0G6UZaIO5TOWv31QjRO8/rQE2rL6zSsJJZgj5Xf
X-Gm-Gg: Acq92OGn6DH58YaBmBjU1JgZhRZZtRScOAltfeS686gZduDBJd9nO3gKfp9+UhOlgMF
	ChvTnoSxTUzCV1S1rlCBBs7df9NwZGUQgsL0fc27ZqPUTiYJgo6Lrnxu+6kSZjLI+5bOrPwK+rG
	Qjt+6znoaiWpvB1Jb0a3cQk18R/EUrMiMmLin/WCmTJ2skCIKGEjZDIoGiNXI5CQTQCm4Ftlhu9
	DCw0TwQdWTkBinHH/XGDW3G6C0Qb9Qru4smeIfyT9FhB+BRkOJa6QLlXM9ma6L+jBkW0wgvjZvk
	bpRAnr1a/2Qg+hf1oYsCuGQ1iRKPrrnqQptdQ0SBj+CK+yT06sHBjGUzbvv8GNCUxO1z9CTKhQD
	M0ZNpF9lXtTFO9eSGGuoZWrkhYpNnHCsdYFPGrBz+HwE9b94Hh4ejetFvKij9FY1JObkipVwDq6
	VjQ1/L7b4ckEoMBoqlooU8Qn6O2vaWuLJTowZZzGTiOmev8xW2d3pOMrV94gOH6qhahCgMGeLyE
	9U3zbcCx/Pkp5xffw==
X-Received: by 2002:a05:693c:2c94:b0:304:b14:ec53 with SMTP id 5a478bee46e88-3077b30eb24mr5000374eec.27.1780768116531;
        Sat, 06 Jun 2026 10:48:36 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db528dcsm13474090eec.3.2026.06.06.10.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 10:48:35 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <clm@fb.com>,
	Qu Wenruo <wqu@suse.com>
Cc: Xiang Mei <xmei5@asu.edu>,
	linux-btrfs@vger.kernel.org,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH] btrfs: lzo: reject compressed segment that overflows the compressed input
Date: Sat,  6 Jun 2026 10:48:17 -0700
Message-ID: <20260606174816.723525-2-bestswngs@gmail.com>
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
copying it.

Fixes: a6e66e6f8c1b ("btrfs: rework lzo_decompress_bio() to make it subpage compatible")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/btrfs/lzo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 2de18c7b563a..887d740b27aa 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -491,6 +491,10 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 			return -EIO;
 		}
 
+		/* The segment must not extend beyond the compressed input. */
+		if (unlikely(cur_in + seg_len > compressed_len))
+			return -EIO;
+
 		/* Copy the compressed segment payload into workspace */
 		copy_compressed_segment(cb, &fi, &cur_folio_index, workspace->cbuf,
 					seg_len, &cur_in);
-- 
2.43.0

