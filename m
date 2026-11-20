Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207916;
	b=ofogHnh7TMtcaDjf8AAbik+tEr6tQjwy+kpndGdQlvqZQ+GR4bpPnCiyfLlJO1pMED6P
	 hrGfS1Eov4e1jzq2tLdzd9A+obfcx+3Y6pb+txCHeuinTa+jNxq/Pnm5O8mVM7qxs/X5K
	 JhsCpCh/8/ZZ8Gr9Ppuy0uzawx0qw7jgx96Q4+2/5DIf09UBzeBYOoXW0E0Us8GfNcqcx
	 QupxwX1ldVVT/Thn0Ck0xAff/JquZlKpksndz3FpsdHF9gSerxVJ886jc4e+M6UtqrqHR
	 9EAMQnBDb7YNOTpkM6/TAgPJKpYD3e/i9wFu3cqfauGfUk/purlZxYn9vG/3/zNlT9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207916;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=xlD/TPZK3GVSb3pT9G1ZjoackSpe0ETwbU/adFdgNuE=;
	b=hOVp47b3FZPZ6KWrYHk1CQKxji8O1N3ZVrUikFM52kGvCIS4ZWLm7TZ81Rpf93KTcBI7
	 6uTyrHoXuLoR9S0Ow3nTIwZIC5d4lwQrjedVf4NuZ7ZuVXGNpL6c/LMderBz0mOUErSGV
	 P+6bSz+nqKstmpJONOLAdx0AWu8Z2vQk1YdZv10mLX9LDVenhVf/rL7bFgau0INb3N1ni
	 Wfj2M9ceWJTjyd0mMzCICDwMM3dmR1X7KANPZsr2ZR5yPrdTjKrxPjZ5x3TzOOZOg4tkJ
	 UmauTmZbtiG9pIJCKkmEFjN9eAJMy+/ZJwEUA2wXcp5mZSEqz4yzBsbyWpumfe5Ns6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=oGaVCIXd;
	arc=none smtp.remote-ip=209.85.160.169
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C7A60A2606
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 20:51:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06C7A60A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=oGaVCIXd
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-55d6deecef6so13451361cf.2
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 12:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795207909; x=1795812709; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xlD/TPZK3GVSb3pT9G1ZjoackSpe0ETwbU/adFdgNuE=;
        b=oGaVCIXd7mQGNeJVeFCayHxXgfIP4B+H2jxSlPD+n5wN9TF1OeX49fPSj8OiJp1FIq
         jdvyM4gpExzny5CgmWNk4hLIQyaUNN3oxEas+/F3aU+F7OjSPOmey3IVVb62/1PighBP
         iD2efI/Cfd0XII5SqfF30Xfnkm9v5E5kBNSCKXkwdYaB4IsaYUZLy1EdF9VZQcy59zKB
         bs4tkuBbx/zGHFNdR4p6QAqgJF+alrNug2XSIrUDsvjmHIg5Bwp15Z+xxAKOJbXwC2Iq
         gJVho6VZ/IRoQC0xhNCmGIfqMfBRxoOjJKuc8/q3oMtV7aMIGKREaoKoYalyr2+iQXNl
         iJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795207909; x=1795812709;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xlD/TPZK3GVSb3pT9G1ZjoackSpe0ETwbU/adFdgNuE=;
        b=pv4uK6P/oNQ9ucNpgwAmGHP99IoU7ljLdoZ9ak0TpHoI3UsZVvR30JKRFey3/ATTAZ
         hXfUDX9Noc0SJTGNpnYmULhN5zTiqRvwfZoHByxamLnZWHQD/6YjXynAWQgIsjau+dCE
         WrmsuKz9wsQ6divdCFhmaBjL2iFtZR7AOzn9C0IrONsMxk7XzRByadq3LSvvlZUa8h5N
         Ex+ubJsxFjnjOmlm2/0fJE4wbchxzRjmBerAMqfWeTVtB29AQdBulJRD2p5KJEMcOS6T
         uE+HgWUe6YSoTiMz/6vY3uNMiGfrERmDfPThjJtaCE2dtZQUpk3glVj6ZFbypXmn532i
         6HsA==
X-Gm-Message-State: APuU4Z8s6TTqs0Vj6qx33kcLuuljXeYsEKKFB3DbL1oIev3iMRjn3+cS
	TjvWSXgoF9/DH+aneQtxoXo0vr2e6bZHzZv4xIjGufoqIH1eT9gw3GQTX+wQeFTn6J4=
X-Gm-Gg: AYBFou3aHI90OCSchXaTiOE4+xN56Y4x5wWMBjz9keEZ/JxZRaAGQElEUNpomfFmptB
	aPE59uxBf66BfA3JF4sEjGgr06Pep2xOiff1vP8Gg2ZfAZ4rb8G3IJ4P9fQ1mqonU3n7MwWtZql
	WOYCTezK4tx+XEZzmGbiPBRkzDPfPcprfVg9hukpdMVs2xmyF2xPwk9iUEJWu3vPzAwjhqDP48b
	4VEziX4IGU1GTiG2IatAOSY7/WVzXpKQ2j/TRK1V73Wz8VeDW/hmoeq7RYW5f/Rymv7DAocExhp
	VNxG+jEapdpuN+2Uhj9BaItwYbJiFgrtQwHfXaAQ7qpsCVjaB/phw1xs0HVv9qLirsxQhv4VPGG
	upc/DhzJt2+xtPBzhT7mqKWUOsUbL9jjobE0/UtIyVWp2LQMm+37jmYS9Myh+er82mNg4nfJBgO
	aBq1l4/O1Mo1awDOk6b1LmMqr2V3+Fq3EwMqZQT49UiJie2uE3jt5pI6S+d+AwabifVt/JY88Fi
	BvErV+qZqk8P/7tfwGksRRpOr/QZf4OvGFZ12YsEKj5m1pMnr/DZyRryWEpYeDQmtud0c6KEl+B
	5NhThkTfu6UbtR00ax1Hp+1X73a5rNoArtytMEGhbQp1Yg==
X-Received: by 2002:ac8:5707:0:b0:55d:2c25:9c79 with SMTP id d75a77b69052e-55d76a87794mr77691931cf.50.1795207908840;
        Fri, 20 Nov 2026 12:51:48 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7882e2c6sm33343821cf.12.2026.11.20.12.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 12:51:48 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 20 Nov 2026 20:51:31 +0000
Subject: [PATCH v3 3/6] btrfs: make fsync wait for all incomplete COW
 writes
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
Message-Id: <20261120-b4-btrfs-data-integrity-v3-3-4de4b91b826e@toxicpanda.com>
References: <20261120-b4-btrfs-data-integrity-v3-0-4de4b91b826e@toxicpanda.com>
In-Reply-To: <20261120-b4-btrfs-data-integrity-v3-0-4de4b91b826e@toxicpanda.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795207902; l=9746;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=E6uisj6tO/3aggVe0W3bMwa2kxvzfjeO95jBnvVyGfs=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QEil8l6R8SnBpF6DgcAAq1C9fjJGVz0ZRBrpijlxXghcSYS3OkcLu2A2VFJrFUezUm72jD2X5dR
 G/NgAAPDkkgE=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

If a COW write fails, or its ordered extent is truncated, the extent
maps of the part that was not written still point to the newly
allocated extent until the ordered extent completes. If a fast fsync
logs those extent maps first, replaying the log after a crash replaces
the file's old data with an extent that was never written.

BTRFS_INODE_COW_WRITE_ERROR is meant to make a fast fsync wait for the
ordered extents to complete in that case, but only
btrfs_finish_ordered_extent() sets it. A write that fails before a bio
is submitted, in writepage_delalloc() or submit_write_sector(), finishes
its ordered extent through btrfs_mark_ordered_io_finished(), which does
not set the flag. And since commit 66ff4d366e7e ("btrfs: fix false IO
failure after falling back to buffered write"), a direct IO write that
stops short truncates the rest of its ordered extent and finishes it as
uptodate, so the flag is not set either.

Fix this by setting the flag, renamed to
BTRFS_INODE_INCOMPLETE_COW_WRITE, in can_finish_ordered_extent() when a
write fails, and in btrfs_mark_ordered_extent_truncated(). Convert the
open-coded truncation in extent_writepage_io() to that helper, so that
every truncation sets the flag. Both places hold the inode's
ordered_tree_lock and run before BTRFS_ORDERED_IO_DONE is set.

The flag stays set until a fast fsync clears it, and that fsync then
waits for all ordered extents to complete, even if the failed or
truncated one completed long before. A direct IO write that stops short
because its buffer was not faulted in costs the next fast fsync one
such wait.

Fixes: f13e01b89daf ("btrfs: ensure fast fsync waits for ordered extents after a write failure")
Fixes: 66ff4d366e7e ("btrfs: fix false IO failure after falling back to buffered write")
CC: stable@vger.kernel.org # 6.10+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/btrfs_inode.h  | 24 ++++++++++++++++--------
 fs/btrfs/extent_io.c    |  7 ++-----
 fs/btrfs/file.c         | 17 ++++++++---------
 fs/btrfs/ordered-data.c | 46 ++++++++++++++--------------------------------
 4 files changed, 40 insertions(+), 54 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index fbcf8ca05fb7..cd75c1a17e45 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -90,15 +90,23 @@ enum {
 	/* Set when there are no capabilities in XATTs for the inode. */
 	BTRFS_INODE_NO_CAP_XATTR,
 	/*
-	 * Set if an error happened when doing a COW write before submitting a
-	 * bio or during writeback. Used for both buffered writes and direct IO
-	 * writes. This is to signal a fast fsync that it has to wait for
-	 * ordered extents to complete and therefore not log extent maps that
-	 * point to unwritten extents (when an ordered extent completes and it
-	 * has the BTRFS_ORDERED_IOERR flag set, it drops extent maps in its
-	 * range).
+	 * Set when a COW write failed, before submitting a bio or during
+	 * writeback, or when a COW ordered extent was truncated. Used for both
+	 * buffered writes and direct IO writes.
+	 *
+	 * The extent maps of what was not written point to blocks that won't be
+	 * written until the ordered extent completes and
+	 * btrfs_finish_one_ordered() drops them. Completion runs in a work
+	 * queue, queued once the IO of the write is finished, and a fast fsync
+	 * does not wait for it, to reduce latency. If a fast fsync logged
+	 * those extent maps, replaying the log would put unwritten extents in
+	 * place of the file's data, so this tells it to wait for the ordered
+	 * extents to complete.
+	 *
+	 * It is set under the inode's ordered_tree_lock, before
+	 * BTRFS_ORDERED_IO_DONE is set.
 	 */
-	BTRFS_INODE_COW_WRITE_ERROR,
+	BTRFS_INODE_INCOMPLETE_COW_WRITE,
 	/*
 	 * Set by reflink while it holds the source's VFS inode lock shared.
 	 * Direct IO writes also take that lock shared; one that finds this bit
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 036d8c0f04ae..58951a89bfc6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1963,11 +1963,8 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 			 * there must be an ordered extent.
 			 */
 			ASSERT(ordered != NULL);
-			spin_lock(&inode->ordered_tree_lock);
-			set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
-			ordered->truncated_len = min(ordered->truncated_len,
-						     cur - ordered->file_offset);
-			spin_unlock(&inode->ordered_tree_lock);
+			btrfs_mark_ordered_extent_truncated(ordered,
+							    cur - ordered->file_offset);
 			btrfs_put_ordered_extent(ordered);
 
 			btrfs_mark_ordered_io_finished(inode, cur, fs_info->sectorsize, true);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 6f525ce42a2d..4208587abff1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1638,7 +1638,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	if (full_sync || btrfs_is_zoned(fs_info)) {
 		ret = btrfs_wait_ordered_range(inode, start, len);
-		clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
+		clear_bit(BTRFS_INODE_INCOMPLETE_COW_WRITE, &inode->runtime_flags);
 	} else {
 		/*
 		 * Get our ordered extents as soon as possible to avoid doing
@@ -1651,15 +1651,14 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 			goto out_release_extents;
 
 		/*
-		 * Check and clear the BTRFS_INODE_COW_WRITE_ERROR now after
-		 * starting and waiting for writeback, because for buffered IO
-		 * it may have been set during the end IO callback
-		 * (end_bbio_data_write() -> btrfs_finish_ordered_extent()) in
-		 * case an error happened and we need to wait for ordered
-		 * extents to complete so that any extent maps that point to
-		 * unwritten locations are dropped and we don't log them.
+		 * Check and clear BTRFS_INODE_INCOMPLETE_COW_WRITE now after
+		 * starting and waiting for writeback, because it may have been
+		 * set while we waited, and if a write failed or was truncated
+		 * we need to wait for ordered extents to complete so that any
+		 * extent maps that point to unwritten locations are dropped and
+		 * we don't log them.
 		 */
-		if (test_and_clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags))
+		if (test_and_clear_bit(BTRFS_INODE_INCOMPLETE_COW_WRITE, &inode->runtime_flags))
 			ret = btrfs_wait_ordered_range(inode, start, len);
 	}
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index df74c75d6c29..1a4e3e34ec11 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -367,6 +367,9 @@ void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
 	spin_lock(&inode->ordered_tree_lock);
 	set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
 	ordered->truncated_len = min(ordered->truncated_len, truncate_len);
+	/* As for a failed write, see can_finish_ordered_extent(). */
+	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
+		set_bit(BTRFS_INODE_INCOMPLETE_COW_WRITE, &inode->runtime_flags);
 	spin_unlock(&inode->ordered_tree_lock);
 }
 
@@ -398,8 +401,18 @@ static bool can_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
 		ordered->bytes_left -= len;
 	}
 
-	if (!uptodate)
+	if (!uptodate) {
 		btrfs_mark_ordered_extent_error(ordered);
+		/*
+		 * The extent maps of a failed COW write point to blocks that
+		 * won't be written until the ordered extent completes and
+		 * drops them. Make a fast fsync wait for that, before
+		 * BTRFS_ORDERED_IO_DONE is set.
+		 */
+		if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
+			set_bit(BTRFS_INODE_INCOMPLETE_COW_WRITE,
+				&inode->runtime_flags);
+	}
 
 	if (ordered->bytes_left)
 		return false;
@@ -436,37 +449,6 @@ void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
 					uptodate);
 	spin_unlock(&inode->ordered_tree_lock);
 
-	/*
-	 * If this is a COW write it means we created new extent maps for the
-	 * range and they point to unwritten locations if we got an error either
-	 * before submitting a bio or during IO.
-	 *
-	 * We have marked the ordered extent with BTRFS_ORDERED_IOERR, and we
-	 * are queuing its completion below. During completion, at
-	 * btrfs_finish_one_ordered(), we will drop the extent maps for the
-	 * unwritten extents.
-	 *
-	 * However because completion runs in a work queue we can end up having
-	 * a fast fsync running before that. In the case of direct IO, once we
-	 * unlock the inode the fsync might start, and we queue the completion
-	 * before unlocking the inode. In the case of buffered IO when writeback
-	 * finishes (end_bbio_data_write()) we queue the completion, so if the
-	 * writeback was triggered by a fast fsync, the fsync might start
-	 * logging before ordered extent completion runs in the work queue.
-	 *
-	 * The fast fsync will log file extent items based on the extent maps it
-	 * finds, so if by the time it collects extent maps the ordered extent
-	 * completion didn't happen yet, it will log file extent items that
-	 * point to unwritten extents, resulting in a corruption if a crash
-	 * happens and the log tree is replayed. Note that a fast fsync does not
-	 * wait for completion of ordered extents in order to reduce latency.
-	 *
-	 * Set a flag in the inode so that the next fast fsync will wait for
-	 * ordered extents to complete before starting to log.
-	 */
-	if (!uptodate && !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
-		set_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
-
 	if (ret)
 		btrfs_queue_ordered_fn(ordered);
 }

-- 
2.55.0

