Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35250 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbcD1BKF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 21:10:05 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-btrfs@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
	infrastructure))
Subject: [PATCH v3 2/3] fs: direct-io: call .bi_end_io via bio_endio()
Date: Thu, 28 Apr 2016 09:09:48 +0800
Message-Id: <1461805789-3632-2-git-send-email-ming.lei@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1461805743-3559-1-git-send-email-ming.lei@canonical.com>

bio_endio() is the graceful way to complete one bio.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 fs/direct-io.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index a8dd60a..0a35e51 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -350,15 +350,10 @@ static void dio_bio_end_io(struct bio *bio)
  */
 void dio_end_io(struct bio *bio, int error)
 {
-	struct dio *dio = bio->bi_private;
-
 	if (!bio->bi_error)
 		bio->bi_error = error;
 
-	if (dio->is_async)
-		dio_bio_end_aio(bio);
-	else
-		dio_bio_end_io(bio);
+	bio_endio(bio);
 }
 EXPORT_SYMBOL_GPL(dio_end_io);
 
-- 
1.9.1

