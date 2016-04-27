Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34231 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbcD0Dvl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 23:51:41 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-btrfs@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
	infrastructure))
Subject: [PATCH v2 1/3] fs: direct-io: handle error in dio_end_io()
Date: Wed, 27 Apr 2016 11:51:34 +0800
Message-Id: <1461729094-22898-1-git-send-email-ming.lei@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1461729047-22837-1-git-send-email-ming.lei@canonical.com>

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

