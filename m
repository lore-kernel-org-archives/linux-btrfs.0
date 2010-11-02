From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: [RFC][PATCH] direct-io: btrfs: avoid splitting dio requests for non-btrfs
 filesystems
Date: Tue, 02 Nov 2010 13:18:42 +0100
Message-ID: <4CD001A2.4000408@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Jeff Moyer" <jmoyer@redhat.com>,
	"Josef Bacik" <jbacik@redhat.com>,
	"Chris Mason" <chris.mason@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-btrf
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
this is about an issue newer kernels show, bysplitting direct I/O reque=
sts
into 4k pieces to directly merge them in the Block Device Layer afterwa=
rds.

If anyone is interested in own tests just use a simple command like
dd if=3D/mnt/test/test-dd1 of=3D/dev/null iflag=3Ddirect bs=3D64k count=
=3D1
in combination with blktrace.

The following patch is more a proposal for discussion than a solution, =
well
thats what RFC's are about right.
I'm unsure about names, but also if the approach in general is the righ=
t way.
It should apply to every 2.6.36 and 2.6.37 kernel.

I put everyone on CC who was involved in the patches leading to the cur=
rent
behavior.

Gr=FCsse / regards,
Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance=20

--- cut here ---

Subject: [RFC][PATCH] direct-io: btrfs: avoid splitting dio requests fo=
r non-btrfs filesystems

=46rom: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

Commit c2c6ca41 by Josef Bacik <josef@redhat.com> caused all direct I/O=
's to
be split into 4k requests before arriving in the block device layer.
This was later on partially fixed by Jeff Moyer <jmoyer@redhat.com> in
7a801ac6.

Jeffs fix improved the situation a lot, but eventually it still splits =
I/Os
for non-btrfs file systems as well were it wouldn't have to.

Eventually in my example on a ext2 filesystem it splits it every 4Mb wh=
ere
dio->boundary is evaluated to true.

In blktrace this looks like:
              dd-910   [002]    38.762523:  94,8    A   R 131264 + 8 <-=
 (94,9) 131072
              dd-910   [002]    38.762531:  94,8    Q   R 131264 + 8 [d=
d]
              dd-910   [002]    38.762535:  94,8    G   R 131264 + 8 [d=
d]
              dd-910   [002]    38.762537:  94,8    P   N [dd]
              dd-910   [002]    38.762539:  94,8    I   R 131264 + 8 [d=
d]
              dd-910   [002]    38.762544:  94,8    A   R 131272 + 8 <-=
 (94,9) 131080
              dd-910   [002]    38.762544:  94,8    Q   R 131272 + 8 [d=
d]
              dd-910   [002]    38.762546:  94,8    M   R 131272 + 8 [d=
d]
              dd-910   [002]    38.762550:  94,8    A   R 131280 + 8 <-=
 (94,9) 131088
              dd-910   [002]    38.762551:  94,8    Q   R 131280 + 8 [d=
d]
              dd-910   [002]    38.762551:  94,8    M   R 131280 + 8 [d=
d]
              dd-910   [002]    38.762556:  94,8    A   R 131288 + 8 <-=
 (94,9) 131096
              dd-910   [002]    38.762557:  94,8    Q   R 131288 + 8 [d=
d]
              dd-910   [002]    38.762557:  94,8    M   R 131288 + 8 [d=
d]
              dd-910   [002]    38.762562:  94,8    A   R 131296 + 8 <-=
 (94,9) 131104
              dd-910   [002]    38.762563:  94,8    Q   R 131296 + 8 [d=
d]
              dd-910   [002]    38.762564:  94,8    M   R 131296 + 8 [d=
d]
              dd-910   [002]    38.762568:  94,8    A   R 131304 + 8 <-=
 (94,9) 131112
              dd-910   [002]    38.762569:  94,8    Q   R 131304 + 8 [d=
d]
              dd-910   [002]    38.762570:  94,8    M   R 131304 + 8 [d=
d]
              dd-910   [002]    38.762577:  94,8    A   R 131312 + 8 <-=
 (94,9) 131120
              dd-910   [002]    38.762578:  94,8    Q   R 131312 + 8 [d=
d]
              dd-910   [002]    38.762579:  94,8    M   R 131312 + 8 [d=
d]
              dd-910   [002]    38.762584:  94,8    A   R 131320 + 8 <-=
 (94,9) 131128
              dd-910   [002]    38.762584:  94,8    Q   R 131320 + 8 [d=
d]
              dd-910   [002]    38.762585:  94,8    M   R 131320 + 8 [d=
d]
              dd-910   [002]    38.762590:  94,8    A   R 131328 + 8 <-=
 (94,9) 131136
              dd-910   [002]    38.762590:  94,8    Q   R 131328 + 8 [d=
d]
              dd-910   [002]    38.762591:  94,8    M   R 131328 + 8 [d=
d]
              dd-910   [002]    38.762596:  94,8    A   R 131336 + 8 <-=
 (94,9) 131144
              dd-910   [002]    38.762597:  94,8    Q   R 131336 + 8 [d=
d]
              dd-910   [002]    38.762598:  94,8    M   R 131336 + 8 [d=
d]
              dd-910   [002]    38.762605:  94,8    A   R 131344 + 16 <=
- (94,9) 131152
              dd-910   [002]    38.762607:  94,8    Q   R 131344 + 16 [=
dd]
              dd-910   [002]    38.762608:  94,8    M   R 131344 + 16 [=
dd]
              dd-910   [002]    38.762611:  94,8    A   R 131368 + 32 <=
- (94,9) 131176
              dd-910   [002]    38.762612:  94,8    Q   R 131368 + 32 [=
dd]
              dd-910   [002]    38.762616:  94,8    G   R 131368 + 32 [=
dd]
              dd-910   [002]    38.762617:  94,8    I   R 131368 + 32 [=
dd]
              dd-910   [002]    38.762619:  94,8    U   N [dd] 2
              dd-910   [002]    38.762621:  94,8    D   R 131264 + 96 [=
dd]
              dd-910   [002]    38.762625:  94,8    D   R 131368 + 32 [=
dd]
          <idle>-0     [012]    38.763363:  94,8    C   R 131264 + 96 [=
0]=20
          <idle>-0     [015]    38.763797:  94,8    C   R 131368 + 32 [=
0]

The usual behavior before both commits was:
              dd-919   [002]    37.513685:  94,8    A   R 7824 + 96 <- =
(94,9) 7632
              dd-919   [002]    37.513693:  94,8    Q   R 7824 + 96 [dd=
]
              dd-919   [002]    37.513697:  94,8    G   R 7824 + 96 [dd=
]
              dd-919   [002]    37.513700:  94,8    P   N [dd]
              dd-919   [002]    37.513701:  94,8    I   R 7824 + 96 [dd=
]
              dd-919   [002]    37.513794:  94,8    A   R 7928 + 32 <- =
(94,9) 7736
              dd-919   [002]    37.513795:  94,8    Q   R 7928 + 32 [dd=
]
              dd-919   [002]    37.513800:  94,8    G   R 7928 + 32 [dd=
]
              dd-919   [002]    37.513802:  94,8    I   R 7928 + 32 [dd=
]
              dd-919   [002]    37.513804:  94,8    U   N [dd] 2
              dd-919   [002]    37.513806:  94,8    D   R 7824 + 96 [dd=
]
              dd-919   [002]    37.513810:  94,8    D   R 7928 + 32 [dd=
]
          <idle>-0     [011]    37.514362:  94,8    C   R 7824 + 96 [0]=
=20
          <idle>-0     [014]    37.514728:  94,8    C   R 7928 + 32 [0]

That remaining split is cause by the test for:
 "dio->final_block_in_bio !=3D dio->cur_page_block".
As this was in the code for a long time I just assume it is right.

So eventually for the 64k request in the example this patch improves th=
e
effective submissions that get to the block device layer from:
10x4k, 1x8k, 1x16k to 1x48k & 1x16k which is much better.

Througput impact is small, but in terms of cpu consumption this is visi=
ble
by a single digit percentage depending on the incoming request size.

The solution looking for comments or alternatives in this RFC patch add=
s a new
kiocb flag that let filesystems specify if they need these workaround t=
o
separate meta data reads - if not, like all pre-btrfs filesystems the d=
io code
doesn't have to cause this extra work.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 fs/btrfs/inode.c    |    4 ++++
 fs/direct-io.c      |    9 ++++++++-
 include/linux/aio.h |    5 +++++
 3 files changed, 17 insertions(+), 1 deletion(-)

[diff]
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c038644..1126185 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -37,6 +37,7 @@
 #include <linux/posix_acl.h>
 #include <linux/falloc.h>
 #include <linux/slab.h>
+#include <linux/aio.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -5822,6 +5823,9 @@ static ssize_t btrfs_direct_IO(int rw, struct kio=
cb *iocb,
 	free_extent_state(cached_state);
 	cached_state =3D NULL;
=20
+	/* btrfs cannot handle logically non-contiguous requests */
+	kiocb_set_separate_meta_reads(iocb);
+
 	ret =3D __blockdev_direct_IO(rw, iocb, inode,
 		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
 		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 48d74c7..6d2dcb2 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -35,6 +35,7 @@
 #include <linux/buffer_head.h>
 #include <linux/rwsem.h>
 #include <linux/uio.h>
+#include <linux/aio.h>
 #include <asm/atomic.h>
=20
 /*
@@ -79,6 +80,7 @@ struct dio {
 	sector_t final_block_in_request;/* doesn't change */
 	unsigned first_block_in_page;	/* doesn't change, Used only once */
 	int boundary;			/* prev block is at a boundary */
+	int separate_meta_reads;	/* separate in I/O submission */
 	int reap_counter;		/* rate limit reaping */
 	get_block_t *get_block;		/* block mapping function */
 	dio_iodone_t *end_io;		/* IO completion function */
@@ -659,7 +661,7 @@ static int dio_send_cur_page(struct dio *dio)
 		 * Submit now if the underlying fs is about to perform a
 		 * metadata read
 		 */
-		else if (dio->boundary)
+		else if (dio->separate_meta_reads &&  dio->boundary)
 			dio_bio_submit(dio);
 	}
=20
@@ -1245,6 +1247,11 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb,=
 struct inode *inode,
 	dio->is_async =3D !is_sync_kiocb(iocb) && !((rw & WRITE) &&
 		(end > i_size_read(inode)));
=20
+	/*
+	 * some filesystems e.g. btrfs need to separate metadata read
+	 */
+	dio->separate_meta_reads =3D kiocb_needs_separate_meta_reads(iocb);
+
 	retval =3D direct_io_worker(rw, iocb, inode, iov, offset,
 				nr_segs, blkbits, get_block, end_io,
 				submit_io, dio);
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 7a8db41..9ee9c6e 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -34,6 +34,8 @@ struct kioctx;
 /* #define KIF_LOCKED		0 */
 #define KIF_KICKED		1
 #define KIF_CANCELLED		2
+/* to separate meta reads */
+#define KIF_SEPARATE_META	3
=20
 #define kiocbTryLock(iocb)	test_and_set_bit(KIF_LOCKED, &(iocb)->ki_fl=
ags)
 #define kiocbTryKick(iocb)	test_and_set_bit(KIF_KICKED, &(iocb)->ki_fl=
ags)
@@ -50,6 +52,9 @@ struct kioctx;
 #define kiocbIsKicked(iocb)	test_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED, &(iocb)->ki_fla=
gs)
=20
+#define kiocb_set_separate_meta_reads(iocb)	set_bit(KIF_SEPARATE_META,=
 &(iocb)->ki_flags)
+#define kiocb_needs_separate_meta_reads(iocb)	(KIF_SEPARATE_META & (io=
cb)->ki_flags)
+
 /* is there a better place to document function pointer methods? */
 /**
  * ki_retry	-	iocb forward progress callback
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
