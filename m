From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: BTRFS and old kernels.
Date: Sat, 5 Apr 2008 20:13:47 +0100
Message-ID: <f058a9c30804051213j4276cc88j92a8222dd4115e39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
Return-path: <btrfs-devel-bounces@oss.oracle.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/btrfs-devel>
List-Post: <mailto:btrfs-devel@oss.oracle.com>
List-Help: <mailto:btrfs-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=subscribe>
Errors-To: btrfs-devel-bounces@oss.oracle.com
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I've been testing btrfs on a linux/ppc with a 2.6.20 kernel.
For that I needed to apply a minor patch for <v0.13 (related to the
definition of ,write_cache_pages()).
For v0.13 it required the patch for the endianess bug in crc32 due to
the change in the crc32c() implementation on linux-2.6.23, that I've
posted here before.

I've just pulled the unstable tree, and tried to build, but it doesn't
even compile, I've found yet one more changed function declaration :
linux-2.6.20: include/linux/bio.h:extern void bio_endio(struct bio *,
unsigned int, int);
linux-2.6.24: include/linux/bio.h:extern void bio_endio(struct bio *, int);

and also some missing functions: (bdi_ini()t, bdi_destroy()). (not
found in 2.6.23 and older)
linux-2.6.24: include/linux/backing-dev.h:int bdi_init(struct
backing_dev_info *bdi);
linux-2.6.24: include/linux/backing-dev.h:void bdi_destroy(struct
backing_dev_info *bdi);
Should I include the code from 2.6.24 for bdi_init and bdi_destroy in
btrfs, and wrap it around ifdefs ?

My question is, is there sill interestest in having btrfs compatible
with older kernels (like, 2.6.20 or 2.6.18)?
I'll post (or repost) patches that I need for btrfs-unstable to
build/work on this ppc system of mine.

Kind regards,
-- 
Miguel Sousa Filipe
