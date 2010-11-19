From: Evert Vorster <evorster@gmail.com>
Subject: tiny btrfs bug.....
Date: Thu, 18 Nov 2010 21:34:12 -0700
Message-ID: <AANLkTim=XFBrra=gTu_+D_iQqVeJyyKdexf0qGAQPdsD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there.

I'm running my root on a raid1 btrfs partition stretching over two
partitions on two separate disks.

Each partition is 30GB, so I would expect the raid to be 30GB big,
being a mirror and all.

In stead, df reports the size of the partition to be about 60GB. For
each GB written to the partition, 2GB gets used.

Is this intentional?

I'm running kernel 2.6.36

-Evert-

-- 
http://magnatune.com - Music shared the way it should be.
