From: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
Subject: "Appending" data to the middle of a file using btrfs-specific features
Date: Mon, 6 Dec 2010 18:11:16 +0530
Message-ID: <AANLkTinXfbKmXYy52JF-QuJr0WTzgvbMXHAw-tYK4i5X@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'd like to know if there has been any discussion about adding a new
feature to write (add) data at an offset, but without overwriting
existing data, or re-writing the existing data. Essentially, in-place
addition/removal of data to a file at a place other than the end of
the file.

Some possible use-cases of such a feature would be:

(a) Databases (currently hack around this by allocating sparse files)
(b) Delta-patching (rsync, patch, xdelta, etc)
(c) Video editors (especially if combined with reflink copies)

Besides I/O savings, it would also have significant space savings if
the current subvolume being written to has been snapshotted (a common
use-case for incremental backups).

I've been told that the problem is somewhat difficult to solve
properly under block-based representation of data, but I was hoping
that btrfs' reflink mechanism and its space-efficient packing of small
files might make it doable.

A hack I can think of is to do a BTRFS_IOC_CLONE_RANGE into a new file
(upto the offset), writing whatever data is required, and then doing
another BTRFS_IOC_CLONE_RANGE with an offset for the rest of the
original file. This can be followed by a rename() over the original
file. Similarly for removing data from the middle of a file. Would
this work? Would it be cleaner to implement something equivalent
internally?

Thanks!

-- 
~Nirbheek Chauhan

Gentoo GNOME+Mozilla Team
