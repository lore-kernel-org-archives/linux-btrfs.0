From: Avi Kivity <avi.kivity@gmail.com>
Subject: Problems with nodatacow/nodatasum
Date: Fri, 20 Apr 2012 11:19:39 +0300
Message-ID: <CAEbWaipj_MzfM2wF6CpQg5dNCmLNLVomReDmnBVZHv9R3Be-cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs filesystem mounted in two locations as two subvolumes:


  /dev/mapper/luks-blah /                       btrfs
subvol=/rootvol        1 1
  /dev/mapper/luks-blah /var/lib/libvirt/images     btrfs
nodatasum,nodatacow,subvol=/images.libvirt        1 2

However, a file under the second  mount is getting seriously
fragmented.  It started out with a few dozen extents (reasonable for a
several gigabytes), now it's 11000 and counting, after an application
started pounding on it with a bit of threaded O_DIRECT random I/O.

3.3.1-5.fc16.x86_64

Any hints?
