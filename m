Received: from out30-70.freemail.mail.aliyun.com (out30-70.freemail.mail.aliyun.com [115.124.30.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702C3325707;
	Fri, 17 Apr 2026 02:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776394321; cv=none; b=KTQUCuzin2H/qN4U9tLPIFklPkB+wi4mLEWd3H3hFOOWfaifronDxZRQ/Q94ExIPS2LroHVSuOwd6HpseBlNiNSraXGzUezVRcWGU8PxJVAQVHVDWXQZjsWufyhOT3f2SpnVxcrj27zlmqU0AwQ0UndMnCa5hiR+RTVQYPAKoxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776394321; c=relaxed/simple;
	bh=rFpZHN66KMcNGX8shvYHcLLatr+AqHi05sMg3zKX88o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/d7g9yxlhm2Z5T9D1PVaO755uQ2lbj/wcpRcC9f94TetCeTqdMuRo1n6VEgtIWTBp2nSdC8Gi0PRtIp2u7k0I8cHhIW6ekhhDjos5+Gdf2FbizN+OXCiVJ+8TSr9WCGf+pueYRqrp49UFJvOgKZq3v1mXdY9yynecMhUxXMG74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=aIFvUQwQ; arc=none smtp.client-ip=115.124.30.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="aIFvUQwQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1776394314; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=luHUKL8ErA2VYj3XUoHyLZOkPx/hNG/bbwHvQT5p1xg=;
	b=aIFvUQwQTHgjd8wCUr6CnBerVnxsSTDdk3uAaVuD/G+T+QXe9526hRoClm7CCDmCt40mKSK7bdanrhcsHnvmJRdCK/wNXHotE6f8xHGprXPKM4UIQt3f7mbzK3+7gOcqNuTwE5I9lBRlP3EpI4MGCq0WbcZXqaLUKXGQ3enoJ1Y=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07357609|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0237181-0.000102311-0.97618;FP=14458206372723049699|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ruohanlan@aliyun.com;NM=1;PH=DS;RN=10;RT=10;SR=0;TI=SMTPD_---0X19nFxm_1776394311;
Received: from China-team(mailfrom:ruohanlan@aliyun.com fp:SMTPD_---0X19nFxm_1776394311 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Apr 2026 10:51:53 +0800
From: Ruohan Lan <ruohanlan@aliyun.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	naohiro.aota@wdc.com,
	wqu@suse.com,
	dsterba@suse.com,
	ruohanlan@aliyun.com,
	hch@lst.de,
	johannes.thumshirn@wdc.com
Subject: [PATCH 6.6.y 1/2] btrfs: merge btrfs_orig_bbio_end_io() into btrfs_bio_end_io()
Date: Fri, 17 Apr 2026 10:51:15 +0800
Message-ID: <20260417025116.743-2-ruohanlan@aliyun.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260417025116.743-1-ruohanlan@aliyun.com>
References: <20260417025116.743-1-ruohanlan@aliyun.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 9ca0e58cb752b09816f56f7a3147a39773d5e831 ]

There are only two differences between the two functions:

- btrfs_orig_bbio_end_io() does extra error propagation
  This is mostly to allow tolerance for write errors.

- btrfs_orig_bbio_end_io() does extra pending_ios check
  This check can handle both the original bio, or the cloned one.
  (All accounting happens in the original one).

This makes btrfs_orig_bbio_end_io() a much safer call.
In fact we already had a double freeing error due to usage of
btrfs_bio_end_io() in the error path of btrfs_submit_chunk().

So just move the whole content of btrfs_orig_bbio_end_io() into
btrfs_bio_end_io().

For normal paths this brings no change, because they are already calling
btrfs_orig_bbio_end_io() in the first place.

For error paths (not only inside bio.c but also external callers), this
change will introduce extra checks, especially for external callers, as
they will error out without submitting the btrfs bio.

But considering it's already in the error path, such slower but much
safer checks are still an overall win.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ruohan Lan <ruohanlan@aliyun.com>
---
 fs/btrfs/bio.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 6fa13be15f30..36b5ec9701d2 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -122,12 +122,6 @@ static void __btrfs_bio_end_io(struct btrfs_bio *bbio)
 	}
 }
 
-void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
-{
-	bbio->bio.bi_status = status;
-	__btrfs_bio_end_io(bbio);
-}
-
 static void btrfs_orig_write_end_io(struct bio *bio);
 
 static void btrfs_bbio_propagate_error(struct btrfs_bio *bbio,
@@ -149,8 +143,9 @@ static void btrfs_bbio_propagate_error(struct btrfs_bio *bbio,
 	}
 }
 
-static void btrfs_orig_bbio_end_io(struct btrfs_bio *bbio)
+void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 {
+	bbio->bio.bi_status = status;
 	if (bbio->bio.bi_pool == &btrfs_clone_bioset) {
 		struct btrfs_bio *orig_bbio = bbio->private;
 
@@ -181,7 +176,7 @@ static int prev_repair_mirror(struct btrfs_failed_bio *fbio, int cur_mirror)
 static void btrfs_repair_done(struct btrfs_failed_bio *fbio)
 {
 	if (atomic_dec_and_test(&fbio->repair_count)) {
-		btrfs_orig_bbio_end_io(fbio->bbio);
+		btrfs_bio_end_io(fbio->bbio, fbio->bbio->bio.bi_status);
 		mempool_free(fbio, &btrfs_failed_bio_pool);
 	}
 }
@@ -322,7 +317,7 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
 	if (fbio)
 		btrfs_repair_done(fbio);
 	else
-		btrfs_orig_bbio_end_io(bbio);
+		btrfs_bio_end_io(bbio, bbio->bio.bi_status);
 }
 
 static void btrfs_log_dev_io_error(struct bio *bio, struct btrfs_device *dev)
@@ -356,7 +351,7 @@ static void btrfs_end_bio_work(struct work_struct *work)
 	if (is_data_bbio(bbio))
 		btrfs_check_read_bio(bbio, bbio->bio.bi_private);
 	else
-		btrfs_orig_bbio_end_io(bbio);
+		btrfs_bio_end_io(bbio, bbio->bio.bi_status);
 }
 
 static void btrfs_simple_end_io(struct bio *bio)
@@ -376,7 +371,7 @@ static void btrfs_simple_end_io(struct bio *bio)
 	} else {
 		if (bio_op(bio) == REQ_OP_ZONE_APPEND && !bio->bi_status)
 			btrfs_record_physical_zoned(bbio);
-		btrfs_orig_bbio_end_io(bbio);
+		btrfs_bio_end_io(bbio, bbio->bio.bi_status);
 	}
 }
 
@@ -390,7 +385,7 @@ static void btrfs_raid56_end_io(struct bio *bio)
 	if (bio_op(bio) == REQ_OP_READ && is_data_bbio(bbio))
 		btrfs_check_read_bio(bbio, NULL);
 	else
-		btrfs_orig_bbio_end_io(bbio);
+		btrfs_bio_end_io(bbio, bbio->bio.bi_status);
 
 	btrfs_put_bioc(bioc);
 }
@@ -420,7 +415,7 @@ static void btrfs_orig_write_end_io(struct bio *bio)
 	if (bio_op(bio) == REQ_OP_ZONE_APPEND && !bio->bi_status)
 		stripe->physical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 
-	btrfs_orig_bbio_end_io(bbio);
+	btrfs_bio_end_io(bbio, bbio->bio.bi_status);
 	btrfs_put_bioc(bioc);
 }
 
@@ -586,7 +581,7 @@ static void run_one_async_done(struct btrfs_work *work)
 
 	/* If an error occurred we just want to clean up the bio and move on. */
 	if (bio->bi_status) {
-		btrfs_orig_bbio_end_io(async->bbio);
+		btrfs_bio_end_io(async->bbio, async->bbio->bio.bi_status);
 		return;
 	}
 
@@ -750,11 +745,9 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 		ASSERT(bbio->bio.bi_pool == &btrfs_clone_bioset);
 		ASSERT(remaining);
 
-		remaining->bio.bi_status = ret;
-		btrfs_orig_bbio_end_io(remaining);
+		btrfs_bio_end_io(remaining, ret);
 	}
-	bbio->bio.bi_status = ret;
-	btrfs_orig_bbio_end_io(bbio);
+	btrfs_bio_end_io(bbio, ret);
 	/* Do not submit another chunk */
 	return true;
 }
-- 
2.43.0

