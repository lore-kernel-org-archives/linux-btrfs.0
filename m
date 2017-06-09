Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34887 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdFIPS6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 11:18:58 -0400
Date: Fri, 9 Jun 2017 11:18:55 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-btrfs@vger.kernel.org
Subject: Re: dedicated error codes for the block layer V3
Message-ID: <20170609151854.GA74154@redhat.com>
References: <20170603073806.2046-1-hch@lst.de>
 <d4840574-0fd2-4f12-b77c-bf7409a785e4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d4840574-0fd2-4f12-b77c-bf7409a785e4@kernel.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 08 2017 at 11:42am -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 06/03/2017 01:37 AM, Christoph Hellwig wrote:
> > This series introduces a new blk_status_t error code type for the block
> > layer so that we can have tigher control and explicit semantics for
> > block layer errors.
> > 
> > All but the last three patches are cleanups that lead to the new type.
> > 
> > The series it mostly limited to the block layer and drivers, and touching
> > file systems a little bit.  The only major exception is btrfs, which
> > does funny things with bios and thus sees a larger amount of propagation
> > of the new blk_status_t.
> > 
> > A git tree is also available at:
> > 
> >     git://git.infradead.org/users/hch/block.git block-errors
> > 
> > gitweb:
> > 
> >     http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/block-errors
> > 
> > Note the the two biggest patches didn't make it to linux-block and
> > linux-btrfs last time.  If you didn't get them they are available in
> > the git tree above.  Unfortunately there is no easy way to split them
> > up.
> 
> Mike, can you take a look at the dm bits in this series? I'd like to get
> this queued up, but I'd also greatly prefer if the dm patches had sign
> off from your end.

Hey Jens,

All looks to be done properly to me.

Though there are various weird partial indents, e.g.:

@@ -2820,7 +2821,8 @@ static int cache_map(struct dm_target *ti, struct bio *bio)
        return r;
 }

-static int cache_end_io(struct dm_target *ti, struct bio *bio, int *error)
+static int cache_end_io(struct dm_target *ti, struct bio *bio,
+               blk_status_t *error)
 {
        struct cache *cache = ti->private;
        unsigned long flags;

But I can let these go (will clean them up if/when I make changes to the
various locations in the future)...

You can add my s-o-b tag to all commits in this series that touch DM:

Signed-off-by: Mike Snitzer <snitzer@redhat.com>

But I'd also like the DM minor version bumped to reflect all the error
code churn, please include this patch, thanks!

From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 9 Jun 2017 11:02:40 -0400
Subject: [PATCH] dm: bump DM_VERSION_MINOR in response to target method error code changes

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 include/uapi/linux/dm-ioctl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 4bf9f1e..2f6c77a 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -267,9 +267,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	35
+#define DM_VERSION_MINOR	36
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2016-06-23)"
+#define DM_VERSION_EXTRA	"-ioctl (2017-06-09)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
-- 
2.10.1

