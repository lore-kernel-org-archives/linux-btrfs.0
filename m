From: Chris Ball <cjb@laptop.org>
Subject: Building a RAID post-mkfs?
Date: Fri, 16 Oct 2009 13:54:10 -0400
Message-ID: <m3skdjusvx.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I installed btrfs to one disk using the Fedora 12 installer; it
doesn't allow any configuration of the mkfs command by the user,
so it wasn't possible to mkfs with more than one disk.

I'd like to add a second disk, with either RAID0 or RAID1 between
the two -- the equivalent of "mkfs.btrfs -m raid0/1 -d raid0/1
/dev/sda /dev/sdb".  Is it possible to create this non-destructively
now?  If not, should it be?  What would the implementation look like?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
