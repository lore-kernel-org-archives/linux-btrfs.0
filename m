From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: bonnie triggers and endless numbers of stack traces
Date: Fri, 19 Aug 2011 19:28:37 +0200
Message-ID: <j2m6g5$7f3$1@dough.gmane.org>
References: <j2m3ud$u8e$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <j2m3ud$u8e$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

I think we either should remove it or replace by WARN_ON_ONCE()


Remove WARN_ON(1) in a common code path

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

Something like bonnie++ -d /mnt/btrfs -s0 -n 1:256:256:1 -r 0
will trigger lots of those WARN_ON(1), so lets remove it.


Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 fs/btrfs/extent-tree.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 80d6148..1d1a8d0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5708,7 +5708,6 @@ use_block_rsv(struct btrfs_trans_handle *trans,
        if (!ret)
                return block_rsv;
        if (ret) {
-               WARN_ON(1);
                ret = reserve_metadata_bytes(trans, root, block_rsv, blocksize,
                                             0);
                if (!ret) {




