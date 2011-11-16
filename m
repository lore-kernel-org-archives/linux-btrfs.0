From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: fallocate vs O_(D)SYNC
Date: Wed, 16 Nov 2011 19:28:16 +0800
Message-ID: <20111116112816.GA23218@gmail.com>
References: <20111116084256.GA22963@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org, cluster-devel@redhat.com,
	jack@suse.cz, swhiteho@redhat.com, tytso@mit.edu
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20111116084256.GA22963@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 16, 2011 at 03:42:56AM -0500, Christoph Hellwig wrote:
> It seems all filesystems but XFS ignore O_SYNC for fallocate, and never
> make sure the size update transaction made it to disk.
> 
> Given that a fallocate without FALLOC_FL_KEEP_SIZE very much is a data
> operation (it adds new blocks that return zeroes) that seems like a
> fairly nasty surprise for O_SYNC users.

Hi all,

This patch should be fix this problem in ext4.

From: Zheng Liu <wenqing.lz@taobao.com>

Make sure the transaction to be commited if O_(D)SYNC flag is set in
ext4_fallocate().

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61fa9e1..f47e3ad 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4356,6 +4356,8 @@ retry:
                        ret = PTR_ERR(handle);
                        break;
                }
+               if (file->f_flags & O_SYNC)
+                       ext4_handle_sync(handle);
                ret = ext4_map_blocks(handle, inode, &map, flags);
                if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
-- 
1.7.4.1


> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
