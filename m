From: Christian Brunner <chb@muc.de>
Subject: Btrfs slowdown
Date: Mon, 25 Jul 2011 09:54:47 +0200
Message-ID: <CAO47_-9BLKWUGDEuzaLqHSq9tZkAUaO8FMQEy1pPk9A2Hb+5AQ@mail.gmail.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we are running a ceph cluster with btrfs as it's base filesystem
(kernel 3.0). At the beginning everything worked very well, but after
a few days (2-3) things are getting very slow.

When I look at the object store servers I see heavy disk-i/o on the
btrfs filesystems (disk utilization is between 60% and 100%). I also
did some tracing on the Cepp-Object-Store-Daemon, but I'm quite
certain, that the majority of the disk I/O is not caused by ceph or
any other userland process.

When reboot the system(s) the problems go away for another 2-3 days,
but after that, it starts again. I'm not sure if the problem is
related to the kernel warning I've reported last week. At least there
is no temporal relationship between the warning and the slowdown.

Any hints on how to trace this would be welcome.

Thanks,
Christian
