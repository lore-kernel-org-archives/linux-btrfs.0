Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207918;
	b=zN6e2hf0uiYiAtnfpeQ66IAkf2pIlg2Nc4FrjZt9MpKlAxpkKh5mDFygEyLoS3kfjsKS
	 XEwCsjyvQnR9U+3Llw0LpSsVkUw3XY+h4aGAU64Z3MYBJX8pBW/RQ9mNL3SHwYBEnkLk9
	 JJsKsxvwHCDtAponpXp+fprufoiI6DE70imO6xQDoHDtYHG8JykRGCQBUIadiMy+LAWhA
	 jGcKeEq0463Xz21oSfTfxuVG4hTdnvXgETow68T2iSjn60GPAP4UZpUiDhH5RLa47W6T6
	 p9SxG+XuZilc6QHtQ6xS6nEHA5JDofjDF+ChD+osrLSiwUVntpdDoz/fqT4voQnHV8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207918;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=KIKK398ilfo+vt1JEKAhnf8Yt2T9QcIWNWPp4UNSxb4=;
	b=PzFFAvoT/Vq0xq1BMU0FZPehAMOhkSMHHH/FRH1yTBM6RIbi2egcNAS/qXpTrCtF9cVP
	 6L7ABjwoC42SR+WA7N/ehlT1AGbVx5nBO1jPAWrQqhUApFOpk23OvDJ/WLUaz5NQIfLGb
	 2hjCxP7Hqb/0uXk1OJKR2hn71j2PMudfDdvHieO2fscfFMoY3zP1CNCtYZ9uyxnC/kV35
	 kIQR2CwELVTtJUCmJhfmYgKFCSiK6cqd3OoufXNbPZG9EreBfaF1lVxrqvxGPJmUiJvSn
	 z+Bwlo2jT79uVZGCTQIL6nf86hEUjky8n6GrwHtUy11P6BvmWoWoIGy9nHaYII75/8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=QjHDcX+4;
	arc=none smtp.remote-ip=209.85.222.182
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31519606A69C
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 20:51:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31519606A69C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=QjHDcX+4
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-9496317b730so162087185a.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 12:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795207910; x=1795812710; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KIKK398ilfo+vt1JEKAhnf8Yt2T9QcIWNWPp4UNSxb4=;
        b=QjHDcX+4QmElXaG2zWR1LLmrWCgEc7SwMod6WXnv1rJ7ZMDOtfN0QVUNkrq3RE1Mf+
         y0whmkc25AtWEbyA6YfMxpkEl1Y+9dB/fZjdCrvmXw4p8sR+iH38ncf3qsFkW7TERRYC
         h3kOTAZNZBUJ/CjyfF8oy97nJz9EctJACQLyqF9613DjCONf91vJ020p3nO9W90b5Vpx
         iOdHdEmS8lzOSYnB2xLei1MF0EA/dcjn3WBeP/It92PCc5cqUtPCLvM+N9N8fHyqdjbF
         wWlcbv1cmxEPwI7waFe2eQCUBrpLvg5znwBJK3sWsgInksplaoyhLdxGri9MhABRdrl4
         IPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795207910; x=1795812710;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KIKK398ilfo+vt1JEKAhnf8Yt2T9QcIWNWPp4UNSxb4=;
        b=0SBpEol9VfGCAnM55aa2f6QKvnFW4S/vI7bSLr+mv/LY3gSdyG0q/n2mSRenPW21Di
         eT4ESlkCPD1E+gJYTEOcJpuxRsgxITQJAa234HG2d/upZdYhTnMtYsJxe1nJBdf3ND2l
         HAE8cr94Zsn8kXMTUMXxQBm8b6o2uOo5r4Qb9kpLI12K/wcF3aLtqHkWlUND99vtM92V
         xVe0dnsiOqX11ix1LKrWyi1yKKanXN7mKeVM9KPY1PPcMtf8D8ym7iE2lUc5OrVLFkMv
         andFeROmo4xC5SpgI+4zwo1BDjHQM8AAouA/5VzbxN2NMdDYxD/QB/tuJKHYX80s5kWf
         BQRw==
X-Gm-Message-State: APuU4Z+ZrtZ5gW85d6pMFtECGQ4a5f4uxuUnnDz5f7nr7BnW/yAbGUEd
	eDJ00aFwq0EPQZ1WxP44GEzy/Bk1giCvbsMP/Yx1ABoNI1cEyYW4FPw4trFz8XgEII8=
X-Gm-Gg: AYBFou3dlxcuLc4I1/CtfCv+Oq3kN0wCG/r0RvhgMRdYghnQMLzyGf1pW8FFIREJ4fU
	yf04sZAP5g8t18pQXUVQFPZ8fOi61k2M3JOExJRJZO3uOgw6Klem0pBafnkHL6o7imPm/Xnlfom
	ENe3JKttIO35iPkZvApsRWQWE0Ar8qrQO+wdfLSFKRm2T+PNrbJ8zncorvmZqR5Q8MinHtRnanR
	48KNHpopgFDJlsumTyQgUMkXPdr+DpCaWGuf2jx1ep8UwpqV6q/yqshK4VhLgseC139aW5PoULg
	nn78YhKm/lL/3D1cohoWKI7G9A7LiYLtusv+a2VFbCeGaImesobV1rGb07jr9Mfor4OFDOnIX6N
	rVYgjKwk3YYmg8xn2OfwfVkEEgiZt+ngR2VdtdvbHaWKOSYn3ilDU6/SURQwbfHpYetvWd1+1wf
	G5JVyTfhQ9WMgXVBFxwKoq43DaLULKGRMkqLVSR6ygq/WZ4In+aYWFQnTiIH87tujLbw9Qq1i8w
	N7HWWCwA3Gnur7qn8Qdxo3uttsrqUlrQozFGrgvFKJK2nnKDM6tz/eW8rE+oJoqbvi/I678GGcm
	bCE16rqBrySazHBtzE2eJm7eqJ56Z3Rk9sralTWbzQ5YJ2k=
X-Received: by 2002:a05:620a:462a:b0:949:7472:b845 with SMTP id af79cd13be357-949bab0dc11mr704003585a.55.1795207909936;
        Fri, 20 Nov 2026 12:51:49 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.251])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921366d853esm29054896d6.27.2026.11.20.12.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 12:51:49 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 20 Nov 2026 20:51:32 +0000
Subject: [PATCH v3 4/6] btrfs: wait for ordered extent IO in fast fsync
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-b4-btrfs-data-integrity-v3-4-4de4b91b826e@toxicpanda.com>
References: <20261120-b4-btrfs-data-integrity-v3-0-4de4b91b826e@toxicpanda.com>
In-Reply-To: <20261120-b4-btrfs-data-integrity-v3-0-4de4b91b826e@toxicpanda.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795207902; l=7841;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=DvaL+jXaouqbVXZ9jHJEFWKWThs3+WNc07wy0Wopgvk=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QCmRl9TNd2voJjkZoD9F7iNn1qbOnHltKXg9NRP+iyT9sZlitqL6yoOkKheOyQEZUQFW4k1Z+iJ
 H0YafGBmuRQc=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

A fast fsync waits for writeback and then checks whether a write failed
or was truncated, in which case it waits for the ordered extents to
complete. The check can come too early, because end_bbio_data_write()
clears writeback before it finishes the ordered extent, which is where
a failure is recorded:

  end_bbio_data_write()            fsync

  btrfs_folio_clear_writeback()
                                   filemap_fdatawait_range()
                                   BTRFS_INODE_INCOMPLETE_COW_WRITE clear
                                   btrfs_log_changed_extents()
  btrfs_finish_ordered_extent()
    set BTRFS_INODE_INCOMPLETE_COW_WRITE

A direct IO write has no writeback for the fsync to wait for at all, so
the failure of an asynchronous direct IO write still in flight is missed
too.

The buffered case comes from commit a11d6912fdd9 ("btrfs: remove folio
parameter from ordered io related functions"), which moved the call to
btrfs_finish_ordered_extent() after the loop that clears writeback. The
direct IO case has been there since commit f13e01b89daf ("btrfs: ensure
fast fsync waits for ordered extents after a write failure") added the
flag.

Fix by having a fast fsync wait for BTRFS_ORDERED_IO_DONE on the ordered
extents it collected for logging before it checks. Since "btrfs: make
fsync wait for all incomplete COW writes", a failure or truncation is
recorded before that bit is set, and a barrier in
can_finish_ordered_extent() now orders the two, pairing with the fully
ordered test_and_clear_bit() of the flag in fsync. For a buffered write
the bit is set right after writeback is cleared. The writeback of a
buffered write that is not done yet is started first, and fsync returns
the error if that fails, since the rest of the ordered extent may then
not be submitted.

This depends on "btrfs: make fsync wait for all incomplete COW writes".

Fixes: a11d6912fdd9 ("btrfs: remove folio parameter from ordered io related functions")
Fixes: f13e01b89daf ("btrfs: ensure fast fsync waits for ordered extents after a write failure")
CC: stable@vger.kernel.org # 6.10+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/file.c         | 67 ++++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/ordered-data.c |  6 +++++
 2 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 4208587abff1..ee09c4ecbd4c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1512,8 +1512,8 @@ static inline bool skip_inode_logging(const struct btrfs_log_ctx *ctx)
 	 * If we are doing a fast fsync we can not bail out if the inode's
 	 * last_trans is <= then the last committed transaction, because we only
 	 * update the last_trans of the inode during ordered extent completion,
-	 * and for a fast fsync we don't wait for that, we only wait for the
-	 * writeback to complete.
+	 * and for a fast fsync we don't wait for that, we only wait for the IO
+	 * of the writes to complete.
 	 */
 	if (inode->last_trans <= btrfs_get_last_trans_committed(fs_info) &&
 	    (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags) ||
@@ -1523,6 +1523,41 @@ static inline bool skip_inode_logging(const struct btrfs_log_ctx *ctx)
 	return false;
 }
 
+/*
+ * Wait for the IO of the ordered extents collected for logging to be accounted,
+ * starting IO on the dirty folios of a buffered write that is not done yet.
+ *
+ * Waiting for writeback is not enough: the end IO handler clears writeback
+ * before it finishes the ordered extent, and a direct IO write has no
+ * writeback. A failed or truncated write sets BTRFS_INODE_INCOMPLETE_COW_WRITE
+ * before BTRFS_ORDERED_IO_DONE is set, see can_finish_ordered_extent().
+ *
+ * If starting IO fails, the rest of the ordered extent may never be submitted,
+ * so return the error instead of waiting.
+ */
+static int wait_ordered_io_done(struct btrfs_inode *inode,
+				struct list_head *ordered_extents)
+{
+	struct btrfs_ordered_extent *ordered;
+	int ret;
+
+	list_for_each_entry(ordered, ordered_extents, log_list) {
+		if (test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags))
+			continue;
+		if (!test_bit(BTRFS_ORDERED_DIRECT, &ordered->flags)) {
+			ret = btrfs_fdatawrite_range(inode, ordered->file_offset,
+						     ordered->file_offset +
+						     ordered->num_bytes - 1);
+			if (ret)
+				return ret;
+		}
+		wait_event(ordered->wait,
+			   test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags));
+	}
+
+	return 0;
+}
+
 /*
  * fsync call for both files and directories.  This logs the inode into
  * the tree log instead of forcing full commits whenever possible.
@@ -1626,11 +1661,11 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * IO of a lower priority task while holding a transaction open.
 	 *
 	 * For a full fsync we wait for the ordered extents to complete while
-	 * for a fast fsync we wait just for writeback to complete, and then
-	 * attach the ordered extents to the transaction so that a transaction
-	 * commit waits for their completion, to avoid data loss if we fsync,
-	 * the current transaction commits before the ordered extents complete
-	 * and a power failure happens right after that.
+	 * for a fast fsync we wait just for the IO of the writes to complete,
+	 * and then attach the ordered extents to the transaction so that a
+	 * transaction commit waits for their completion, to avoid data loss if
+	 * we fsync, the current transaction commits before the ordered extents
+	 * complete and a power failure happens right after that.
 	 *
 	 * For zoned filesystem, if a write IO uses a ZONE_APPEND command, the
 	 * logical address recorded in the ordered extent may change. We need
@@ -1650,13 +1685,21 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		if (ret)
 			goto out_release_extents;
 
+		ret = wait_ordered_io_done(inode, &ctx.ordered_extents);
+		if (ret)
+			goto out_release_extents;
+
 		/*
 		 * Check and clear BTRFS_INODE_INCOMPLETE_COW_WRITE now after
-		 * starting and waiting for writeback, because it may have been
-		 * set while we waited, and if a write failed or was truncated
-		 * we need to wait for ordered extents to complete so that any
-		 * extent maps that point to unwritten locations are dropped and
-		 * we don't log them.
+		 * waiting for the IO of the ordered extents, because it may
+		 * have been set while we waited, and if a write failed or was
+		 * truncated we need to wait for ordered extents to complete so
+		 * that any extent maps that point to unwritten locations are
+		 * dropped and we don't log them.
+		 *
+		 * test_and_clear_bit() is fully ordered, which pairs with the
+		 * barrier before BTRFS_ORDERED_IO_DONE is set in
+		 * can_finish_ordered_extent().
 		 */
 		if (test_and_clear_bit(BTRFS_INODE_INCOMPLETE_COW_WRITE, &inode->runtime_flags))
 			ret = btrfs_wait_ordered_range(inode, start, len);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 1a4e3e34ec11..728e73baf15e 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -420,7 +420,13 @@ static bool can_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
 	/*
 	 * All the IO of the ordered extent is finished, we need to queue
 	 * the finish_func to be executed.
+	 *
+	 * Order BTRFS_INODE_INCOMPLETE_COW_WRITE, if set above, before
+	 * BTRFS_ORDERED_IO_DONE, as a fast fsync tests the latter without
+	 * the ordered_tree_lock. Pairs with the test_and_clear_bit() in
+	 * btrfs_sync_file().
 	 */
+	smp_mb__before_atomic();
 	set_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags);
 	cond_wake_up(&ordered->wait);
 	refcount_inc(&ordered->refs);

-- 
2.55.0

