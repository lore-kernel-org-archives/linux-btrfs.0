From: David Zeuthen <zeuthen@gmail.com>
Subject: btrfs and /proc/self/mountinfo
Date: Sun, 12 Apr 2009 10:35:04 -0400
Message-ID: <7b13a0f80904120735r41736455hb7e226ab8ad30bd7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a question about how btrfs is supposed to work with
/proc/self/mountinfo. It appears that the dev_t isn't matching what
one would expect when mounting a btrfs filesystem - here's /dev/sdb2
mounted at /media/usb-fedora

 # cat /proc/self/mountinfo |grep btrfs
 17 19 0:19 / /media/usb-fedora rw,nosuid,nodev,relatime - btrfs /dev/sdb2 rw

I would expect to see 8:18 corresponding to /dev/sdb2.

This makes it a bit hard for user space to figure out whether a given
device (such as /dev/sdb2) is mounted. We need this kind of
information in the desktop shell (e.g. Nautilus) and partitioning
programs to tell the user that a device or partition is currently part
of a mounted file system (and if so, what filesystem).

We also want to do this using dev_t (e.g. not rely on device node
names) using /proc/self/mountinfo since /proc/mounts and /etc/mtab
have well-known flaws and it's never a good idea to use device node
names anyway.

So. My guess is that the reason I'm seeing an unnamed block device
(0:19) has to do with the fact that a btrfs filesystem can use
multiple devices. In fact, I guess it's entirely possible that a user
could add a new disk, mirror the mounted filesystem onto, say,
/dev/sdc1 and then detach /dev/sdb2. Then you'd end up with only
having bits on /dev/sdc1. So if this is one goal (and I hope it is, it
sounds really useful), then referencing dev_t of the physical devices
in /proc/self/mountinfo of course won't work.

But we'd still need some kind of way of having the kernel tell user
space what devices are currently claimed by the btrfs filesystem
instance (and we'd need notifications on changes too). Otherwise we
don't have enough information for the desktop shell and partitioning
programs to let the user know that /dev/sdb2 or /dev/sdc1 or whatever
is currently claimed by the 0:19 btrfs mount at /media/fedora-usb.

One idea is to have a pollable file, /proc/fs/btrfs/devs, that maps
from the dev_t of the btrfs filesystem instance (as used in
/proc/self/mountinfo) to the set of dev_t for block devices currently
claimed? E.g. for the example above we'd have

  /proc/fs/btrfs/devs:
  0:19    8:18

That way, user space can look up that file when encountering 0:19 in
/proc/self/mountinfo and also listen for changes when the block
devices are added/removed to the btrfs filesystem instance. I'm just
thinking out loud here.

Apologies if this has been discussed previously or if there already is
a way to get this information.

     David
