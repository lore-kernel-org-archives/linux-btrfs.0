From: Andrew Lutomirski <luto@mit.edu>
Subject: How to remove a device on a RAID-1 before replacing it?
Date: Tue, 29 Mar 2011 16:09:36 -0400
Message-ID: <AANLkTinpGXaF_=nZW+uB8zEBG8XPZbwrn+HW48JG_02P@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a disk with a SMART failure.  It still works but I assume it'll
fail sooner or later.

I want to remove it from my btrfs volume, replace it, and add the new
one.  But the obvious command doesn't work:

# btrfs device delete /dev/dm-5 /mnt/foo
ERROR: error removing the device '/dev/dm-5'

dmesg says:
btrfs: unable to go below two devices on raid1

With mdadm, I would fail the device, remove it, run degraded until I
get a new device, and hot-add that device.

With btrfs, I'd like some confirmation from the fs that data is
balanced appropriately so I won't get data loss if I just yank the
drive.  And I don't even know how to tell btrfs to release the drive
so I can safely remove it.

(Mounting with -o degraded doesn't help.  I could umount, remove the
disk, then remount, but that feels like a hack.)

This is 2.6.38.1 running Fedora 14's version of btrfs-progs, but
btrfs-progs-unstable git does the same thing, as does btrfs-vol -r.

--Andy
