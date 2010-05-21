From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 3/6] direct-io: do not merge logically non-contiguous requests
Date: Fri, 21 May 2010 13:03:39 -0400
Message-ID: <1274461422-18433-3-git-send-email-josef@redhat.com>
References: <1274461422-18433-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1274461422-18433-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs cannot handle having logically non-contiguous requests submitted.  For
example if you have

Logical:  [0-4095][HOLE][8192-12287]
Physical: [0-4095]      [4096-8191]

Normally the DIO code would put these into the same BIO's.  The problem is we
need to know exactly what offset is associated with what BIO so we can do our
checksumming and unlocking properly, so putting them in the same BIO doesn't
work.  So add another check where we submit the current BIO if the physical
blocks are not contigous OR the logical blocks are not contiguous.

Signed-off-by: Josef Bacik <josef@redhat.com>
---

V1->V2
-Be more verbose in the in-code comment

 fs/direct-io.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 5949947..da111aa 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -632,10 +632,26 @@ static int dio_send_cur_page(struct dio *dio)
 	int ret = 0;
 
 	if (dio->bio) {
+		loff_t cur_offset = dio->block_in_file << dio->blkbits;
+		loff_t bio_next_offset = dio->logical_offset_in_bio +
+			dio->bio->bi_size;
+
 		/*
-		 * See whether this new request is contiguous with the old
+		 * See whether this new request is contiguous with the old.
+		 *
+		 * Btrfs cannot handl having logically non-contiguous requests
+		 * submitted.  For exmple if you have
+		 *
+		 * Logical:  [0-4095][HOLE][8192-12287]
+		 * Phyiscal: [0-4095]      [4096-8181]
+		 *
+		 * We cannot submit those pages together as one BIO.  So if our
+		 * current logical offset in the file does not equal what would
+		 * be the next logical offset in the bio, submit the bio we
+		 * have.
 		 */
-		if (dio->final_block_in_bio != dio->cur_page_block)
+		if (dio->final_block_in_bio != dio->cur_page_block ||
+		    cur_offset != bio_next_offset)
 			dio_bio_submit(dio);
 		/*
 		 * Submit now if the underlying fs is about to perform a
-- 
1.6.6.1
