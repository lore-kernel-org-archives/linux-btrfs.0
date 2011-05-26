From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: strange btrfs sub list output
Date: Thu, 26 May 2011 22:22:03 +0100
Message-ID: <20110526212203.GA4611@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hiya,

I get a btrfs sub list output that I don't understand:

# btrfs sub list /backup/
ID 257 top level 5 path u1/linux/lvm+btrfs/storage/data/data
ID 260 top level 5 path u2/linux/lvm/linux/var/data
ID 262 top level 5 path u1/linux/lvm+btrfs/storage/data/snapshots/2010-10-11
ID 263 top level 5 path u2/linux/lvm/linux/home/snapshots/2011-04-07
ID 264 top level 5 path u2/linux/lvm/linux/root/snapshots/2011-04-07
ID 265 top level 5 path u2/linux/lvm/linux/var/snapshots/2011-04-07
ID 266 top level 5 path u1/linux/lvm+btrfs/storage/data/snapshots/2010-10-26
ID 267 top level 5 path u1/linux/lvm+btrfs/storage/data/snapshots/2010-11-08
ID 268 top level 5 path u1/linux/lvm+btrfs/storage/data/snapshots/2010-11-22
ID 269 top level 5 path u1/linux/lvm+btrfs/storage/data/snapshots/2010-12-15
ID 270 top level 5 path u2/linux/lvm/linux/home/snapshots/2011-04-14
ID 271 top level 5 path u2/linux/lvm/linux/root/snapshots/2011-04-14
ID 272 top level 5 path u2/linux/lvm/linux/var/snapshots/2011-04-14
ID 273 top level 5 path u1/linux/lvm+btrfs/storage/data/snapshots/2010-12-29
ID 274 top level 5 path u1/linux/lvm+btrfs/storage/data/snapshots/2011-01-26
ID 275 top level 5 path u1/linux/lvm+btrfs/storage/data/snapshots/2011-03-07
ID 276 top level 5 path u1/linux/lvm+btrfs/storage/data/snapshots/2011-04-01
ID 277 top level 5 path u2/linux/lvm/linux/home/data
ID 278 top level 5 path u2/linux/lvm/linux/home/snapshots/2011-04-27
ID 279 top level 5 path u2/linux/lvm/linux/root/snapshots/2011-04-27
ID 280 top level 5 path u2/linux/lvm/linux/var/snapshots/2011-04-27
ID 281 top level 5 path u3:10022/vm+xfs@u9/xvda1/g1/v4/data
ID 282 top level 5 path u3:10022/vm+xfs@u9/xvda1/g1/v4/snapshots/2011-05-19
ID 283 top level 5 path u5/vm+xfs@u9/xvda1/g1/v5/data
ID 284 top level 5 path u6:10022/vm+xfs@u8/xvda1/g8/v3/data
ID 286 top level 5 path u5/vm+xfs@u9/xvda1/g1/v5/snapshots/2011-05-24
ID 287 top level 285 path data
ID 288 top level 5 path u4/vm+xfs@u9/xvda1/g1/v1/data
ID 289 top level 5 path u4/vm+xfs@u9/xvda1/g1/v1/snapshots/2011-03-11
ID 290 top level 5 path u4/vm+xfs@u9/xvda1/g1/v2/data
ID 291 top level 5 path u4/vm+xfs@u9/xvda1/g1/v2/snapshots/2011-05-11
ID 292 top level 5 path u4/vm+xfs@u9/xvda1/g1/v1/snapshots/2011-05-11

See ID 287 above.

There is no "/backup/data" directory. There is however a
/backup/u6:10022/vm+xfs@u8/xvda1/g8/v3/snapshots/2011-03-30 that
contains the same thing as what I get if I mount the fs with
subvolid=287. And I did do a btrfs sub snap data
snapshots/2011-03/30 there.

What could be the cause of that? How to fix it?

In case that matters, there used to be more components in the
path of u6:10022/vm+xfs@u8/xvda1/g8/v3/data.

Thanks,
Stephane
