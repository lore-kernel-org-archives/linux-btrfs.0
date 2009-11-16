From: Roland Dreier <rdreier@cisco.com>
Subject: UI issues around RAID1
Date: Mon, 16 Nov 2009 10:45:28 -0800
Message-ID: <adapr7ib96f.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've just started playing around with btrfs RAID1, and I've noticed a
couple of what seem to be UI issues.  Suppose I do something like
"mkfs.btrfs -d raid1 -m raid1 dev1 dev2".  I see the following minor
usability problems:

 - Unless I'm missing something, there doesn't seem to be any way later
   on to see that I set the data policy to raid1, except using
   btrfs-dump-tree and checking the flags bits for the appropriate
   group.  Which can make things confusing if I have a bunch of btrfs
   filesystems around.

 - The free space reporting doesn't seem to take into account the fact
   that everything is going to be mirrored; so "df" et al report the
   size of the filesystem and free space on the new filesystem as
   size(dev1) + size(dev2) -- if dev1 and dev2 are the same size then I
   would assume it should really be just size(dev1) for a fully-RAID1
   filesystem.  (Not sure in general what we should say for a
   metadata-only mirrored filesystem, since we don't really know in
   advance how much space we have exactly)

I'm happy to help fix these issues up; just want to make sure I'm not
missing something or doing it wrong.

Thanks,
  Roland
