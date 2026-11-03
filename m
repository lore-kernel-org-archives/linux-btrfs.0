Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718349;
	b=b1n60HbgP47FVYPQtAD0V6+zz59+fX6MZjqvaDNi2QTa5jg/SgkFEoulMQQMwS4mUsjO
	 YIND0sD5cPsAHH8TFO0pHg3E0pQ+zmiVAvUhjfw/oWnqOK5/3qK/xzZA64eCdutDhQuZF
	 93rm6iTE2nzryhj5UK5BBD9EaJnji87Q66hnkZE/R8asbifsshg3gqugJS5ITPqbR1fg+
	 SgnVKwJO2e+J5dBOwsWF+hKTLJ2I/eZYeJaVi/EB0Vz0pkIF0qa6qibCImeZEiV96hFtB
	 O2Z4H7VMatoUTepUlNbr5Hmz9GxOV/I6kCrx10VMT1pTVaPLzHwSpMwnDrS074L9ptw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=uXxBks8KZk7Rcu77ECS3x/abhL8rzE0h579OcJvEe6g=;
	b=zl+ZDV1S5svaYAoJm7y2pKsCowrtHxjrqhV+JC/0MeJY5yooA+SUbyo4bO+VVu+MP/LM
	 31CZXdqAa8lA3JEgHFaNb8iusv9OA8lDWXFGeL8ujOFaI6c7d9SGE41DW1DeY98jicwdl
	 Ecu36kzzyD+37jrNqpRjakfAz7lqQh3wwYOe9JsD09wzdY3dkr36eI92xK3cKZ2AXvgmp
	 gr2tCD8BxKSZjZSLrdEJc0TdEPVRC2cqOB825q2VzRGeXcYofk7BLqO84UznCgVliNoHQ
	 5x61bRFX5C3gm/CykwdYytZ1hXrIP1ISTnTQhgrwozBfBu2tOxVpRbTqcRrYraufUDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=XyYkbyLJ;
	arc=none smtp.remote-ip=209.85.222.47
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7324C606D2F2
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 15:05:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7324C606D2F2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=XyYkbyLJ
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-998749fe872so97062241.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 07:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793718347; x=1794323147; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uXxBks8KZk7Rcu77ECS3x/abhL8rzE0h579OcJvEe6g=;
        b=XyYkbyLJyn/LH1k4mFJKoaOtwxHxbLNxGW3lGsih03wQf/4N9/miJV1SjDdPlYHLoB
         BkzPq1qFzkfm2rrmCKz20BF6uwSscmImShav3s3a9PiYlmvq+d3YeHmeJZ6FauaK99bV
         mL/DR5+EVCCblITl5PgEwVGrabcupeABKHhEuQ5gS9RwKVx5hEaAGQBw43LlJTMTCr18
         8bqyENYTNCOPmX0eLAWoWNBeRzY3tFshZ/kWktZZm4L337bL7hKiM5GkZtv2Yc0pzy2z
         r6TDO98MWJRPooJa6NhFyMQIy2NmekK+tkqIlsAGD8RxFMbZcAdMjyKgGtuFmgim16k6
         xg5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718347; x=1794323147;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uXxBks8KZk7Rcu77ECS3x/abhL8rzE0h579OcJvEe6g=;
        b=OCDH+d2Jal2R+Tb39hFE537f/HUMe4okFv1YhuTYMJrO873CVKSSxk7pAHCfzgMokK
         RJip4u9TkhQ4JANEIzL2mlDwnC8l6ETkdsn7otr8mKrXEEgiqivIkaoz+JzAxOwcwPDN
         e/n8qHadYSfPO6z4mkzSyL1dIVhmUzJzn8CmfF40U0DczWJXSTTIgR8i1hL5l/3P9gJZ
         6yDB3znZWUfzCdua8M0CRhaiqBIBveCX4pkN51kQpBGcX8YcU/cc+K/G3d+NjhpVb1lk
         Fw5+pLwYhUl7lIyfRtA/xHG+iaJ7WlXQHORBPmRLY91AkxictdEOQeWpxZRICEadU9Jh
         MkiA==
X-Gm-Message-State: APuU4Z+IlBvLI9QlBu1+vEy3fboyR7kI/WP4Os4j1dIYSVOj6mvNiJus
	AGZVgAVm8BT/NgrtHxuV85xbSAfkVquHpuosk9HgvCiVhdfL2nJO53HdTHik3+tWe64=
X-Gm-Gg: AYBFou1f4fDiDXAOlrfLXbB1LXQzm3JPC0nna1eUSICS0eqvDPxYi8YEiw0RO7BZFbM
	zUjINdLvgc/fLMokTdmyRIiDt93LnPGGqd2yO+s9lpXKVk3hIfZTrDY/kA2MACjsobiV33F578Q
	A4eEXC6HMIgTvrqM1MsippC10PKh1ftOZrPocPYyCOsOoHrinlTxMOSd3LyuskBg7RdX9NLRPmn
	29Tow0065GYqU0nHwzYO5uZfHeQXQg+xjQ+1WlnzKIWv5fiKh6Q+R4wDjyu3ku1z9aOVzdHV70P
	18C7NGNENAEFgs0O+W79RI9XuN7Lm+j/iAZpJBREXOm6LU3mA/9yAyET2b6uuSG0f2oNoEVodyn
	cDOroRV0AdholivbBKQasx9itmAH3Ido4ZHEOplqEbZa1Sl//bc9nn5Qzt2UdJzxuYw4P51s+nD
	vm7s9wIy30Y9EyfYvuK9mulK6L59QcGs0gADLJAtEersiVTk/iRnlyd5kb8+5IvSiwMfmlf4tLS
	U/vU6dJGLTAIYEf5C9fno18vOjjdmlUTaT9lEVc9A4ZiZRk924cPRijciblWLL71uCwb0hjrs6i
	mgfb6RKMzmZZbnA5JHGGQPLlodv2BvY9/XNIMykgVYcV
X-Received: by 2002:a05:6123:b2:b0:5c9:a60b:e5b8 with SMTP id 71dfb90a1353d-5ec6896e4b1mr5729474e0c.17.1793718347189;
        Tue, 03 Nov 2026 07:05:47 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.254])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec69bbf5easm12733794e0c.3.2026.11.03.07.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:05:44 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 03 Nov 2026 15:05:18 +0000
Subject: [PATCH v2 3/5] btrfs: wait for ordered extent IO in fast fsync
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
Message-Id: <20261103-b4-btrfs-data-integrity-v2-3-577dc2690061@toxicpanda.com>
References: <20261103-b4-btrfs-data-integrity-v2-0-577dc2690061@toxicpanda.com>
In-Reply-To: <20261103-b4-btrfs-data-integrity-v2-0-577dc2690061@toxicpanda.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793718330; l=8670;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=4ryXS5jTcnbGhuhQrkILiG6q2k8dkQZGIuPAC1puFyQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QOi9E3VUcsGcxi3HVC8uvUOL3MGOut/n8vcqFcC1lTVB9UDO0j4hZJCiqBJ3+qg4JW4hRhEIrE3
 QnXupr+gP0A0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

A fast fsync waits for writeback and then checks
BTRFS_INODE_COW_WRITE_ERROR to see whether a COW write failed. If one
did, it must wait for the ordered extents to complete before logging,
since until then the extent maps of the failed range point to extents
that were never written. Logging them puts unwritten extents in place
of the data that was there before when the log is replayed.

The flag can be set too late for that check. end_bbio_data_write()
clears writeback before it finishes the ordered extent:

  end_bbio_data_write()            fsync

  btrfs_folio_clear_writeback()
                                   filemap_fdatawait_range()
                                   BTRFS_INODE_COW_WRITE_ERROR clear
                                   btrfs_log_changed_extents()
  btrfs_finish_ordered_extent()
    set BTRFS_INODE_COW_WRITE_ERROR

The write paths that fail before submitting a bio, writepage_delalloc()
and submit_write_sector(), clear writeback and finish the ordered
extent through btrfs_mark_ordered_io_finished(), which never sets the
flag at all.

Fix by dropping the flag and having a fast fsync wait for
BTRFS_ORDERED_IO_DONE on the ordered extents it collected for logging.
can_finish_ordered_extent() sets it only after recording any error with
BTRFS_ORDERED_IOERR. The wait costs little, because IO_DONE is set
right after writeback is cleared, not when the ordered extent completes.

Fixes: f13e01b89daf ("btrfs: ensure fast fsync waits for ordered extents after a write failure")
Fixes: a11d6912fdd9 ("btrfs: remove folio parameter from ordered io related functions")
CC: stable@vger.kernel.org # 6.10+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/btrfs_inode.h  | 10 ----------
 fs/btrfs/file.c         | 52 +++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/ordered-data.c | 31 -----------------------------
 3 files changed, 42 insertions(+), 51 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index f7aa0d145185..65ba8ec23258 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -89,16 +89,6 @@ enum {
 	BTRFS_INODE_FREE_SPACE_INODE,
 	/* Set when there are no capabilities in XATTs for the inode. */
 	BTRFS_INODE_NO_CAP_XATTR,
-	/*
-	 * Set if an error happened when doing a COW write before submitting a
-	 * bio or during writeback. Used for both buffered writes and direct IO
-	 * writes. This is to signal a fast fsync that it has to wait for
-	 * ordered extents to complete and therefore not log extent maps that
-	 * point to unwritten extents (when an ordered extent completes and it
-	 * has the BTRFS_ORDERED_IOERR flag set, it drops extent maps in its
-	 * range).
-	 */
-	BTRFS_INODE_COW_WRITE_ERROR,
 	/*
 	 * Set by reflink while it holds the source's VFS inode lock shared.
 	 * Direct IO writes also take that lock shared; one that finds this bit
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f978c6524aa0..4ae9aed8993f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1512,6 +1512,42 @@ static inline bool skip_inode_logging(const struct btrfs_log_ctx *ctx)
 	return false;
 }
 
+/*
+ * Wait for the IO of the ordered extents collected for logging to be done, and
+ * return true if a COW write among them failed.
+ *
+ * Waiting for writeback is not enough to know that: the end IO handlers clear
+ * writeback before they account the IO in the ordered extent. An ordered
+ * extent gets BTRFS_ORDERED_IO_DONE only once all of its IO is accounted, and
+ * can_finish_ordered_extent() sets BTRFS_ORDERED_IOERR before that.
+ */
+static bool cow_write_failed(struct btrfs_inode *inode,
+			     struct list_head *ordered_extents)
+{
+	struct btrfs_ordered_extent *ordered;
+	bool failed = false;
+
+	list_for_each_entry(ordered, ordered_extents, log_list)
+		wait_event(ordered->wait,
+			   test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags));
+
+	/*
+	 * can_finish_ordered_extent() records a write error before it sets
+	 * BTRFS_ORDERED_IO_DONE, both under this lock.
+	 */
+	spin_lock(&inode->ordered_tree_lock);
+	list_for_each_entry(ordered, ordered_extents, log_list) {
+		if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags) &&
+		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags)) {
+			failed = true;
+			break;
+		}
+	}
+	spin_unlock(&inode->ordered_tree_lock);
+
+	return failed;
+}
+
 /*
  * fsync call for both files and directories.  This logs the inode into
  * the tree log instead of forcing full commits whenever possible.
@@ -1615,7 +1651,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * IO of a lower priority task while holding a transaction open.
 	 *
 	 * For a full fsync we wait for the ordered extents to complete while
-	 * for a fast fsync we wait just for writeback to complete, and then
+	 * for a fast fsync we wait just for their IO to complete, and then
 	 * attach the ordered extents to the transaction so that a transaction
 	 * commit waits for their completion, to avoid data loss if we fsync,
 	 * the current transaction commits before the ordered extents complete
@@ -1627,7 +1663,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	if (full_sync || btrfs_is_zoned(fs_info)) {
 		ret = btrfs_wait_ordered_range(inode, start, len);
-		clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
 	} else {
 		/*
 		 * Get our ordered extents as soon as possible to avoid doing
@@ -1640,15 +1675,12 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 			goto out_release_extents;
 
 		/*
-		 * Check and clear the BTRFS_INODE_COW_WRITE_ERROR now after
-		 * starting and waiting for writeback, because for buffered IO
-		 * it may have been set during the end IO callback
-		 * (end_bbio_data_write() -> btrfs_finish_ordered_extent()) in
-		 * case an error happened and we need to wait for ordered
-		 * extents to complete so that any extent maps that point to
-		 * unwritten locations are dropped and we don't log them.
+		 * If a COW write failed, before submitting a bio or during IO,
+		 * the extent maps of its range point to unwritten locations
+		 * until the ordered extent completes and drops them. Wait for
+		 * that, so that we don't log them.
 		 */
-		if (test_and_clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags))
+		if (cow_write_failed(inode, &ctx.ordered_extents))
 			ret = btrfs_wait_ordered_range(inode, start, len);
 	}
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index df74c75d6c29..27aca31866fd 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -436,37 +436,6 @@ void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
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

