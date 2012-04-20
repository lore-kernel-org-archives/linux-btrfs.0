From: Alexander Block <ablock84@googlemail.com>
Subject: send/receive and clone/clone_range ioctls
Date: Fri, 20 Apr 2012 16:24:47 +0200
Message-ID: <CAB9VWqCjBuSKWRMMVx3xyGVCHe7jAC_q+2R5sb9B0H=6nzaFqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm currently implementing parts of a send/receive tool that walks
through all inodes and records changes into a tar/pax archive. Changes
are determined by the transid of inodes and the generation number of
file extent items. An inode/extent is considered to be changed if the
transid/generation is higher then a specified generation.

While testing the code I found a problem with files where parts where
cloned with the BTRFS_IOC_CLONE_RANGE ioctl. When the extents get
cloned, their generation is cloned too. Which means, that even if the
file was actually changed, my checks may say that it is unchanged
because the extents generation numbers are lower then the specified
generation number.
The same problem may occur when BTRFS_IOC_CLONE was used. I could also
imagine that deduplication would result in the same issue when a
recent change to the file (which increased the generation) would allow
deduplication on the changed parts of the file. In that case, we may
get extents injected into the file that have an old generation number.

Any ideas how these issues could be handled/fixed? Would it for
example be possible to increase generation numbers when extents get
cloned?

BTW: Why is it sometimes called transid (e.g. in inodes) and sometimes
generation (e.g. in extents). In btrfs_inode_item I also see a field
named "generation" but the comment above this field says "nfs style
generation number" so I don't know if this represents the same value
as the transid. Can someone explain this?

Alex.
