Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33329 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbcD1BJ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 21:09:57 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-btrfs@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
	infrastructure))
Subject: [PATCH v3 1/3] fs: direct-io: handle error in dio_end_io()
Date: Thu, 28 Apr 2016 09:09:47 +0800
Message-Id: <1461805789-3632-1-git-send-email-ming.lei@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1461805743-3559-1-git-send-email-ming.lei@canonical.com>

If error is passed to dio_end_io(), it should have been
dealt with. Unfortunately current code just ignores that
silently.

Only btrfs uses dio_end_io().

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 fs/direct-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 4720377..a8dd60a 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -352,6 +352,9 @@ void dio_end_io(struct bio *bio, int error)
 {
 	struct dio *dio = bio->bi_private;
 
+	if (!bio->bi_error)
+		bio->bi_error = error;
+
 	if (dio->is_async)
 		dio_bio_end_aio(bio);
 	else
-- 
1.9.1

