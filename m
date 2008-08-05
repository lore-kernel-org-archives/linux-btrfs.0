From: Chris Mason <chris.mason@oracle.com>
Subject: Btrfs v0.16 released
Date: Tue, 05 Aug 2008 15:01:16 -0400
Message-ID: <1217962876.15342.33.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Btrfs v0.16 is available for download, please see
http://btrfs.wiki.kernel.org/ for download links and project
information.

v0.16 has a shiny new disk format, and is not compatible with
filesystems created by older Btrfs releases.  But, it should be the
fastest Btrfs yet, with a wide variety of scalability fixes and new
features.  

There were quite a few contributors this time around, but big thanks to
Josef Bacik and Yan Zheng for their help on this release.  Toei Rei also
helped track down an important corruption problem.

Scalability and performance:

* Fine grained btree locking.  The large fs_mutex is finally gone.
There is still some work to do on the locking during extent allocation,
but the code is much more scalable than it was.

* Helper threads for checksumming and other background tasks.  Most CPU
intensive operations have been pushed off to helper threads to take
advantage of SMP machines.  Streaming read and write throughput now
scale to disk speed even with checksumming on.

* Improved data=ordered mode.  Metadata is now updated only after all
the blocks in a data extent are on disk.  This allows btrfs to provide
data=ordered semantics without waiting for all the dirty data in the FS
to flush at commit time.  fsync and O_SYNC writes do not force down all
the dirty data in the FS.

* Faster cleanup of old transactions (Yan Zheng).  A new cache now
dramatically reduces the amount of IO required to clean up and delete
old snapshots.

Major features (all from Josef Bacik):

* ACL support.  ACLs are enabled by default, no special mount options
required.

* Orphan inode prevention, no more lost files after a crash

* New directory index format, fixing some suboptimal corner cases in the
original.

There are still more disk format changes planned, but we're making every
effort to get them out of the way as quickly as we can.  You can see the
major features we have planned on the development timeline:

http://btrfs.wiki.kernel.org/index.php/Development_timeline

A few interesting statistics:

Between v0.14 and v0.15:

42 files changed, 6995 insertions(+), 3011 deletions(-)

The btrfs kernel module now weighs in at 30,000 LOC, which means we're
getting very close to the size of ext[34].

-chris



