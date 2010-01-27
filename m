From: Liuwenyi <qingshenlwy@gmail.com>
Subject: [PATCH]btrfs: avoid comparing with NULL pointer
Date: Wed, 27 Jan 2010 14:27:29 +0800
Message-ID: <4B5FDCD1.8060806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: chris.mason@oracle.com, zheng.yan@oracle.com, jbacik@redhat.com,
	jens.axboe@oracle.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel@vger.kernel.org, strongzgy@gmail.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753939Ab0A0G1i@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In this patch, I adjust the seqence of if-conditions.
It will assess the page->private situation.
First, we make sure the page->private is not null.
And then, we can do some with this page->private.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Yan Zheng <zheng.yan@oracle.com>
Cc: Josef Bacik <jbacik@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
fs/btrfs/disk-io.c | 4 ++--
1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 009e3bd..a300dca 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1407,11 +1407,11 @@ static int bio_ready_for_csum(struct bio *bio)

bio_for_each_segment(bvec, bio, i) {
page = bvec->bv_page;
- if (page->private == EXTENT_PAGE_PRIVATE) {
+ if (!page->private) {
length += bvec->bv_len;
continue;
}
- if (!page->private) {
+ if (page->private == EXTENT_PAGE_PRIVATE) {
length += bvec->bv_len;
continue;
}
-- 
1.6.6


---
Best Regards,
Liuwenyi
2010-01-277
