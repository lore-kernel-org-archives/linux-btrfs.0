From: Bob McElrath <bob@mcelrath.org>
Subject: heterogeneous raid1
Date: Fri, 23 Mar 2012 06:11:59 +0000
Message-ID: <20120323061159.GA11099@mcelrath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Greetings butter-heads,

I would like to implement a redundant (raid1) disk array on heterogeneous disks
using btrfs.  A more detailed description of what I want to do can be found here:

http://superuser.com/questions/387851/a-zfs-or-lvm-or-md-redundant-heterogeneous-storage-proposal/388536

In a nutshell: organize your heterogenous disks into two "halves", the sum of
which are of roughly equal size, and create a raid1 array across those two
halves.

For various reasons I decided to go with btrfs over zfs.  What I have done is to
create two lvm Logical Volumes, one using a single large disk, and another as a
linear concatenation of several smaller disks.  It works, so far, and I could
automate it with some scripts.

In the long term, I would like this to be something that btrfs could do by
itself, without LVM.  Having absolutely no knowledge of the btrfs code, this
seems easy, I'm sure you'll tell me otherwise.  ;)  But one needs:

1) The ability to "group" a heterogeneous set of disks into the "halves" of a
raid1.  I don't understand what btrfs is doing if you give it more than 2
devices and ask for raid1.

2) Intellegently rebalance when a new device is added or removed (e.g. rearrange
the halves, and rebalance as necessary)

While btrfs seems to support multi-disk devices, in trying this, I encountered
the following deadly error: creating a raid1 btrfs with more than 2 devices
cannot be mounted in degraded mode if one or more are missing.  (In the above
plan, a filesystem should be mountable as long as one "half" is intact)  With 1
of 4 devices missing in such a circumstance, I get:

    device fsid 2ea954c6-d9ee-47c4-9f90-79a1342c71df devid 1 transid 31 /dev/loop0
    btrfs: allowing degraded mounts
    btrfs: failed to read chunk root on loop0
    btrfs: open_ctree failed

btrfs fi show:
    Label: none  uuid: 2ea954c6-d9ee-47c4-9f90-79a1342c71df
        Total devices 4 FS bytes used 1.78GB
        devid    1 size 1.00GB used 1.00GB path /dev/loop0
        devid    2 size 1.00GB used 1023.00MB path /dev/loop1
        devid    3 size 1.00GB used 1023.00MB path /dev/loop2
        *** Some devices missing

Also I discovered that writing to a degraded 2-disk raid1 btrfs array quickly
fills up the disk.  It does not behave as a single disk.  

Both these errors were encountered with Ubuntu 11.10 (linux 3.0.9).  I tried
with 3.0.22 and I got "failed to read chunk tree" instead of the above "failed
to read chunk root" and furthermore after mounting it degraded, I could not
mount it non-degraded, even after a balance and a fsck.

So, any comments on the general difficulty of implementing this proposal?  Can
someone explain the above errors?  What is btrfs doing with >2 disks and raid1?
Any comments on what parts of this should be inside btrfs, and which parts are
better in external scripts?  I think this feature would be extremely popular: it
turns btrfs into a Drobo.

P.S. why doesn't df work with btrfs raid1?  Why is 'btrfs fi df' necessary?

--
Cheers, Bob McElrath

"The individual has always had to struggle to keep from being overwhelmed by
the tribe.  If you try it, you will be lonely often, and sometimes frightened.
But no price is too high to pay for the privilege of owning yourself." 
    -- Friedrich Nietzsche
