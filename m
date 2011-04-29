From: John Wyzer <john.wyzer@gmx.de>
Subject: abysmal performance
Date: Fri, 29 Apr 2011 16:46:08 +0200
Message-ID: <1304088305-sup-3784@localhost>
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently on 
commit 7cf96da3ec7ca225acf4f284b0e904a1f5f98821
Author: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date:   Mon Apr 25 19:43:53 2011 -0400
    Btrfs: cleanup error handling in inode.c

merged into 2.6.38.4

I'm on a btrfs filesystem that has been used for some time. Let's say nine 
months. Very recently I noticed performance getting worse and worse.
Most of the time it feels as if the system is just busy with iowait.
Write and read performance during random access is mostly around 2MB/s,
sometimes 1MB/s or slower. It's better for big files which can be read with about
6-9MB/s. The disk is a reasonably recent SATA disk (WDC_WD3200BEVT) so 30MB/s
or 40MB/s linear reading should not be a problem.

rootfs                291G  242G   35G  88% /

I tried  btrfs filesystem defragment -v / but did not notice any improvement 
after that.

Is this a known phenomenon? :-)

