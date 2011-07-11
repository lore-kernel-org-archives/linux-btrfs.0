From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: feature request: btrfs-image without zeroing data
Date: Mon, 11 Jul 2011 02:00:51 +0200
Message-ID: <CAJ1PRSn6TBnzXaSQSEffb15oH4+jncKE5ydCipcT6HHt1U=GLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Documentation says that btrfs-image zeros data. Feature request is for
disabling this. btrfs-image could be used to copy filesystem to
another drive (for example with snapshots, when copying it file by
file would take much longer time or acctualy was not possible
(snapshots)). btrfs-image in turn could be used to actualy shrink loop
devices/sparse file containing btrfs - by copying filesystem to new
loop device/sparse file.

Also it would be nice if copying filesystem could occour without
intermediate dump to a file...
