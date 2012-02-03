From: lutz.euler@freenet.de (Lutz Euler)
Subject: Can't write much data on a degraded mirror
Date: Fri, 3 Feb 2012 20:17:49 +0100
Message-ID: <20268.13021.256682.485482@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Btrfs seems not to want to allocate new chunks on a degraded mirror,
severely restricting the amount of new data that can be written to such
a filesystem. I hope this is not intentional? It makes mirroring much
less useful than it could be, at least for me.

My use case: I want to use btrfs with two mirrored disks on a desktop
machine. Lets say the filesystem is far from full. Assume one disk
fails, I send it in for RMA and have to wait 6 weeks for a replacement.
I could live without the mirror redundancy during this time but not
without the ability to store more data on the filesystem.

I would prefer if btrfs remembered the size of the missing device and
allowed to allocate space on the degraded mirror until the capacity is
reached that the nondegraded mirror had.

Here is how to reproduce the effect:

Create and mount a mirror of two 20 GB devices:

# dd if=3D/dev/zero of=3D/tmp/img0 bs=3D1 count=3D0 seek=3D20G
# dd if=3D/dev/zero of=3D/tmp/img1 bs=3D1 count=3D0 seek=3D20G
# losetup -f /tmp/img0
# losetup -f /tmp/img1
# losetup -a
/dev/loop0: [0802]:1441845 (/tmp/img0)
/dev/loop1: [0802]:1441856 (/tmp/img1)
# mkfs.btrfs -d raid1 -m raid1 /dev/loop0 /dev/loop1
# mount /dev/loop0 /mnt
# df -h /mnt
Dateisystem            Size  Used Avail Use% Eingeh=E4ngt auf
/dev/loop0             40G   56K   38G   1% /mnt

Umount, make one device unavailable and mount degraded:

# umount /mnt
# losetup -d /dev/loop1
# mount -o degraded /dev/loop0 /mnt
# df -h /mnt
Dateisystem            Size  Used Avail Use% Eingeh=E4ngt auf
/dev/loop0             40G  312K  2,0G   1% /mnt

Notice that the "Avail" value has shrunk drastically; it seems
to show only the space available in already allocated chunks.
Now, "df" might simply lie, so let's try to put data on the filesystem:

# dd if=3D/dev/zero of=3D/mnt/data bs=3D4K count=3D512K

-> ENOSPC after writing 1.1 GB

The software used is:

Kernel: v3.3-rc1-383-g0a96265
uname -a: Linux test 3.3.0-rc1 #1 SMP PREEMPT Sun Jan 29 16:06:29 CET
  2012 x86_64 x86_64 x86_64 GNU/Linux
btrfs-progs: cloned on 2012-01-25 from
  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git,
  latest commit is fdb6c0402337d9607c7a39155088eaf033742752.
OS: Ubuntu 11.04.

Kind regards,

Lutz
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
