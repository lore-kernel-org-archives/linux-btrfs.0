From: Stephane Chazelas <stephane.chazelas@gmail.com>
Subject: cloning single-device btrfs file system onto multi-device one
Date: Mon, 21 Mar 2011 16:24:50 +0000
Message-ID: <chaz20110321162450.GB918@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hiya,

I'm trying to move a btrfs FS that's on a hardware raid 5 (6TB
large, 4 of which are in use) to another machine with 3 3TB HDs
and preserve all the subvolumes/snapshots.

Is there a way to do that without using a software/hardware raid
on the new machine (that is just use btrfs multi-device).

If fewer than 3TB were occupied, I suppose I could just resize
it so that it fits on one 3TB hd, then copy device to device
onto a 3TB disk, add the 2 other ones and do a "balance", but
here, I can't do that.

I suspect that if compression was enabled, the FS could fit on
3 TB, but AFAICT, compression is enabled at mount time and would
only apply to newly created files. Is there a way to compress
files already in a btrfs filesystem?

Any help would be appreciated.
Stephane

