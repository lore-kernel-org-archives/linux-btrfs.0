From: "Michael Niederle" <mniederle@gmx.at>
Subject: crash when mounting subvolume in a subdirectory
Date: Mon, 6 Dec 2010 23:27:24 +0100
Message-ID: <20101206232724.4bf1ebfc@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I'm not sure whether this *should* be possible, but I think it *shouldn't*
crash:

I created a snapshot of the root directory within a subdirectory:

# mount /dev/sde2 /mnt
# cd /mnt
# mkdir save
# btrfs subvolume snapshot . save/snap1
# umount /mnt

Then I tried to mount the snapshot:

# mount -o subvol=save/snap1 /dev/sde2 /mnt

This inevitably leads to a segfault in the btrfs-driver crashing the whole
system. I tried this with kernel versions 2.6.32 and 2.6.37.rc4.

If I create the subvolume within the root directory of the btrfs volume
everything works fine.

I'm using btrfs for nearly a year by now (since the release of 2.6.32) and am
using subvolumes within subdirectories since then but never tried to directly
mount one until today, when my main btrfs volume crashed (by a hardware failure
or due to a bug in 2.6.36 - I don't know).

If you cannot reproduce this behaviour I can try to send you the kernel log
(not so easy, because the system crashes and I will have to write it down by
hand).

Greetings, Michael
