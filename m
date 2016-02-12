Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18223 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbcBLRl7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 12:41:59 -0500
Date: Fri, 12 Feb 2016 09:41:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: [PATCH 33/32] aiocp: fix the gcc warnings
Message-ID: <20160212174154.GF6346@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Eliminate a debug printf that was causing warnings and fix the other two
debug printfs to avoid tripping on return value warnings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 src/aio-dio-regress/aiocp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/aio-dio-regress/aiocp.c b/src/aio-dio-regress/aiocp.c
index 1abff9c..ccab2ac 100644
--- a/src/aio-dio-regress/aiocp.c
+++ b/src/aio-dio-regress/aiocp.c
@@ -190,7 +190,7 @@ static void wr_done(io_context_t ctx, struct iocb *iocb, long res, long res2)
 	--busy;
 	free_iocb(iocb);
 	if (debug)
-		write(2, "w", 1);
+		fprintf(stderr, "w");
 }
 
 /*
@@ -225,7 +225,7 @@ static void rd_done(io_context_t ctx, struct iocb *iocb, long res, long res2)
 			io_error("io_submit write", res);
 	}
 	if (debug)
-		write(2, "r", 1);
+		fprintf(stderr, "r");
 	if (debug > 1)
 		printf("%d", iosize);
 }
@@ -404,7 +404,6 @@ int main(int argc, char *const *argv)
 	memset(&myctx, 0, sizeof(myctx));
 	io_queue_init(aio_maxio, &myctx);
 	tocopy = howmany(length, aio_blksize);
-printf("tocopy=%d len=%d blk=%d\n", tocopy, length, aio_blksize);
 	if (init_iocb(aio_maxio, aio_blksize) < 0) {
 		fprintf(stderr, "Error allocating the i/o buffers\n");
 		exit(1);
