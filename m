From: "Charlie Brune" <btrfs@BruneWorld.com>
Subject: Confused about resizing
Date: Tue, 25 May 2010 21:46:08 -0500 (CDT)
Message-ID: <41855.192.168.1.2.1274841968.squirrel@bruneworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I think I'm not understanding something fundamental about btrfs: what am I
able to resize?  Resizing would be nice, given that it's so hard to do
with ext3 (or even LVM).

I created a btrfs filesystem on my 32G thumbdrive (/dev/sdb):

     mkfs.btrfs /dev/sdb1

To mount it, I do:

     mkdir /mnt/btrfs
     mount -t btrfs /dev/sdb1 /mnt/btrfs

BUT, what's the point of resizing the filesystem with something like:

     btrfsctl -r 15g /mnt/btrfs

???

After I do it, I'm assuming that there's roughly 17G in /dev/sdb1 that I'm
not using, but I don't know how to get to it.  Can I make *another*
filesystem on /dev/sdb1 and then mount it to somewhere like /mnt/btrfs2.

Thanks,
Charlie


