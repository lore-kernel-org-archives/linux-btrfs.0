Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC0D3E7BA4
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 09:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784106322; cv=none; b=FTqSSfEA1nC7SK8PTu3itP4Q9ih/NmxI76I3MD4/sgyLSF1v3DkrlAdN0HG/wTk7WLWkHnCQ5x0WS8pD9MeXRpOUa5sn/7fmFFxIVKoPrjQbSQHuV7WMkCcsQtyd2v474DlPtMlUbLWXzyLlxseR9f7DV8RK2Jpbwn5425ZfrMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784106322; c=relaxed/simple;
	bh=nsDvvDqBROSj9wugf55dAdBWPwtjUGQ4NFvFqQ68ewo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dBhge3jQkl8kaOP+M5bKFh7qlIZLf7tnLhfPB+TvHBDhNti3EvBjr9469iuJZbtHoh6VFqoDLe0K4S68G88hzgmtgFYEtWpFH1QRsz/BwaKYTYN28ogD9N3qIjqVpyvRgGxYq7a5kXWZtTIpMInk4vhWigq9LXpKBH8YG2Cx414=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=CJQj8vs/; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="CJQj8vs/"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e7c6ec9dbso221205085a.0
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 02:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1784106319; x=1784711119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=089eDpthIT2HjjrbB9W67LaNgfnrjDuNPRAcNI9k8R4=;
        b=CJQj8vs/H6D0iGXj2sQCsMtTFEOCa1bFac6DVvkBx0hHkjdJ08EBr2jZaFAwlHIPlR
         r4PhELjdN5dVQsvQxu/HTirPMwXnK9l7ou5WUvdHziayXVRLegGpMOv8PX4Axu6jzTGo
         wn5kGEwqCvZRdI3NSH0U63uGCmumg7qAmjIYrse5aqsvViumGOL6kAyIz4fn5beX7mak
         hz3FdZuWMzPICA3alZv3py+O5cHvwaBiJRQTvB3a/w2MMjjnkvMwJ+HfGxzSAx1Aj7Fl
         FL51RBCvFcEc/Fr7vOd+vi0YOkwy1qKR5nL6GsUQ0wdYg98Vax2cm6zPcn5VFz010UG8
         zOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784106319; x=1784711119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=089eDpthIT2HjjrbB9W67LaNgfnrjDuNPRAcNI9k8R4=;
        b=kmzi6/6UEAwnpYJ4qgXU7Sp3veLl2nefQgHQ2Z6DTlCm+tcSUVjhvEcjuUXe0Hek62
         gNw/QPCRJZXDMqKzozvw+/jOYOlpHiKhC3Ucich4WEOwrO4KJBKoFV33lWyA+TM/S6R1
         5qNdzV/4yWSqivyf5cHjcYcT+uKPfojStIsT7CFRx8w8h+IH1xY8DK/P+3jLAojLmckH
         hNNyZkmuzDRWs+VD6ykTVUDCU7u9uxdFyELzudw9cfcTSHJfDVkpU4Afz1ArndHI33QQ
         25ouBKGRAcJ83BPlknTGebFUfU6wvYhDmkjrxfEjxJf7FkmHyjmSAcOj6PKht7lIRhRh
         SEqQ==
X-Forwarded-Encrypted: i=1; AHgh+RrxdufhMmCFlWqKiJgV7XemEvPW9EAnKv/EbDdVBLYNpxNIozHXeUDZy4UDGzg7Cwcy6//ExY2j/inBTw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg9nqj5u9MNFfPeSloVcIlabvst+ROys6Ts3FNYyELG88TaV8d
	q3+7XKhc5pj/JT3dfV/v4/vnHt2ofI0l2Ds8X6Nu5kSGp0HnH6SyW1lH7pHAwUMBzP8=
X-Gm-Gg: AfdE7cnte2xI2izMMZqQArDjuG5WkPrrTLpRWdnuknHLbwm+HT4KDLoQAAAf0iOFwdH
	VwJHFUlN7YXaUOF4Fb0Ei25HQHSm9yx+Mo886++OCN6zU1uN4Jg5bcIdN+eECRbrQfRh9dXpHO/
	CA+KuUDuCWq3cDPOkZSaFjK2dh58isMjUcT4HZ2In3Q/6CBfLmT94BnENh2jDtSinl9ZV5O07aW
	e2VdEz/RFijT74dmITHZpIAM87K6RAqZcsCe7M09h0hBiwPUxRkzxmO3xRx26SqkterPSXXXt0o
	f8y5GHkvs8OxJwItEac+ptaWCFEt3cMIV6eFF5IFrXOX6F2HKLco57j2TwHtPFSxB3B1r9+r57j
	RGPIMte/PMLBT92Fs6OlcjID07MjCjpVS776/1Y6RKHgxrS6i18QuWlQ8bH0/6S7y2Lcxo91HHD
	n7TPE/eRoU3nOxDi0X+w==
X-Received: by 2002:a05:620a:408c:b0:92e:9cb3:3f71 with SMTP id af79cd13be357-93086a5a11emr593970485a.36.1784106319079;
        Wed, 15 Jul 2026 02:05:19 -0700 (PDT)
Received: from localhost ([146.190.222.192])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9309adc5a98sm42751685a.4.2026.07.15.02.05.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 02:05:18 -0700 (PDT)
From: David Lee <david.lee@trailofbits.com>
To: Chris Mason <clm@fb.com>
Cc: David Lee <david.lee@trailofbits.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	David Sterba <dsterba@suse.com>,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] btrfs: lzo: reject inline extents without compressed data
Date: Wed, 15 Jul 2026 09:05:14 +0000
Message-ID: <20260715090516.512417-1-david.lee@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

inline Btrfs LZO payload shorter than two LZO headers.

Fix the validation or lifetime rule at the vulnerable boundary so malformed
or racing input cannot reach the faulting path.

A four-byte extent produced the following KASAN report on Linux 7.2-rc2:

  BUG: KASAN: slab-out-of-bounds in lzo_decompress+0x57d/0x700
  Read of size 4 at addr ffff888006f2e644 by task btrfs_lzo_inlin/77

  Call Trace:
   <TASK>
   dump_stack_lvl+0x5b/0x70
   print_report+0xd1/0x610
   ? _raw_spin_lock_irqsave+0x78/0xc0
   ? kasan_complete_mode_report_info+0x2a/0x200
   kasan_report+0xe0/0x110
   ? lzo_decompress+0x57d/0x700
   ? lzo_decompress+0x57d/0x700
   __asan_report_load_n_noabort+0x13/0x20
   lzo_decompress+0x57d/0x700
   ? lzo_decompress_bio+0x1e80/0x1e80
   btrfs_decompress+0x140/0x1c0
   uncompress_inline+0x147/0x1b0
   btrfs_get_extent+0xb23/0x10a0
   ? btrfs_rename2+0xb0/0xb0
   ? _raw_spin_lock+0x72/0xb0
   ? _raw_read_lock_irq+0x50/0x50
   ? __kasan_check_read+0x15/0x20
   ? btrfs_folio_test_uptodate+0xc8/0x140
   btrfs_do_readpage.constprop.0+0x538/0x1ac0
   ? btrfs_lookup_ordered_extent+0x2c0/0x2c0
   ? xa_load+0xb0/0x1e0
   btrfs_readahead+0x32f/0x5f0
   ? btrfs_writepages+0x180/0x180
   ? lruvec_stat_mod_folio+0x240/0x330
   ? write_one_eb+0xb30/0xb30
   read_pages+0x16f/0x850
   ? __kasan_check_read+0x15/0x20
   ? __folio_batch_add_and_move+0x134/0x1c0
   ? ractl_alloc_folio.constprop.0+0x90/0x90
   ? filemap_add_folio+0x1cd/0x4f0
   ? __folio_alloc_noprof+0x69/0xa0
   page_cache_ra_unbounded+0x296/0x490
   do_page_cache_ra+0xd9/0x130
   page_cache_sync_ra+0x3ee/0x6f0
   filemap_get_pages+0x306/0x15c0
   ? is_bpf_text_address+0x14/0x30
   ? kernel_text_address+0x89/0xf0
   ? filemap_add_folio+0x4f0/0x4f0
   ? putname+0x78/0xc0
   filemap_read+0x329/0xd00
   ? kasan_save_track+0x18/0x40
   ? __kasan_slab_free+0x44/0x60
   ? putname+0x78/0xc0
   ? entry_SYSCALL_64_after_hwframe+0x4b/0x53
   ? filemap_get_pages+0x15c0/0x15c0
   btrfs_file_read_iter+0x1f8/0x2b0
   vfs_read+0x4ef/0x720
   ? putname+0x78/0xc0
   ? __kasan_slab_free+0x56/0x60
   ? kernel_read+0x180/0x180
   ? putname+0x78/0xc0
   ? __kasan_check_read+0x15/0x20
   ksys_read+0xf8/0x1d0
   ? vfs_write+0xa30/0xa30
   ? __x64_sys_open+0x180/0x180
   __x64_sys_read+0x71/0xb0
   ? __kasan_check_read+0x15/0x20
   x64_sys_call+0x1ab0/0x1b70
   do_syscall_64+0x61/0x470
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>

Link: https://lore.kernel.org/all/20260714071054.1715464-1-david.lee@trailofbits.com/
Fixes: a6fa6fae40ec ("btrfs: Add lzo compression support")
Assisted-by: Codex:gpt-5.5
Signed-off-by: David Lee <david.lee@trailofbits.com>
---
Changes in v2:
- Reject an eight-byte extent containing headers but no compressed data.
- Rebase onto btrfs for-next and update the invalid-header diagnostic.
- Include the complete KASAN call trace.

Trail of Bits has a reproducer for this bug demonstrating Kernel Panic which can be shared further if needed.

 fs/btrfs/lzo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 1531adb117d1..2f0996692da0 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -552,9 +552,10 @@ int lzo_decompress(struct list_head *ws, const u8 *data_in,
 	size_t max_segment_len = workspace_buf_length(fs_info);
 	int ret;
 
-	if (unlikely(srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2)) {
+	if (unlikely(srclen <= LZO_LEN * 2 ||
+		     srclen > max_segment_len + LZO_LEN * 2)) {
 		btrfs_err(fs_info, "invalid lzo header length, has %zu expect (%u, %zu)",
-			  srclen, LZO_LEN, max_segment_len + LZO_LEN * 2);
+			  srclen, LZO_LEN * 2, max_segment_len + LZO_LEN * 2);
 		return -EUCLEAN;
 	}
 

-- 
2.43.0
