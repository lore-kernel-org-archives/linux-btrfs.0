From: Christoph Hellwig <hch@lst.de>
Subject: some -o discard performance numbers
Date: Mon, 16 Nov 2009 16:48:09 +0100
Message-ID: <20091116154809.GA6199@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I played around with the btrfs discard support now that I've finished
trying up the ATA TRIM support to the block layer.  These numbers are
with an OCZ-Vertex SSD with the 1.4 firmware, on a 2.6.32-rc7 kernel
and current git btrfs-progs with my patch do discard the whole device
at mkfs time.

I used this little script (with the discard option comment out for the
non-discard run):

---- snip ----
#!/bin/sh

OPTS=
OPTS="-o discard"

./mkfs.btrfs /dev/sdb
mount -t btrfs $OPTS /dev/sdb /mnt/
cp -a ../linux-2.6 /mnt/
echo 1 > /proc/sys/vm/drop_caches
time rm -rf /mnt/linux-2.6
time sync
umount /mnt/
---- snip ----

And here are the numbers:


---- snip ----
rm -rf				sync

With TRIM:

real	0m19.375s		real	0m8.603s
user	0m0.065s		user	0m0.000s
sys	0m11.122s		sys	0m0.070s

real	0m16.267s		real	0m8.277s
user	0m0.049s		user	0m0.001s
sys	0m11.175s		sys	0m0.117s

real	0m16.039s		real	0m9.883s
user	0m0.058s		user	0m0.000s
sys	0m10.993s		sys	0m0.157s

real	0m16.277s		real    0m8.419s
user	0m0.057s		user    0m0.000s
sys	0m11.196s		sys     0m0.161s

real	0m16.264s		real	0m9.017s
user	0m0.063s		user	0m0.000s
sys	0m11.066s		sys	0m0.152s


Without:

real	0m15.796s		real    0m0.181s
user	0m0.043s		user    0m0.000s
sys	0m10.950s		sys     0m0.133s

real	0m15.591s		real	0m0.190s
user	0m0.067s		user	0m0.000s
sys	0m11.157s		sys	0m0.114s

real	0m15.877s		real	0m0.230s
user	0m0.064s		user	0m0.000s
sys	0m11.162s		sys	0m0.115s

real	0m15.171s		real	0m0.187s
user	0m0.051s		user	0m0.000s
sys	0m11.156s		sys	0m0.120s

real	0m15.965s		real	0m0.194s
user	0m0.049s		user	0m0.000s
sys	0m11.327s		sys	0m0.134s

