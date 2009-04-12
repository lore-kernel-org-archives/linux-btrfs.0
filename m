From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: btrfs and /proc/self/mountinfo
Date: Sun, 12 Apr 2009 12:01:41 -0700
Message-ID: <ac3eb2510904121201p66ee37a2gcd75aeea683ff254@mail.gmail.com>
References: <7b13a0f80904120735r41736455hb7e226ab8ad30bd7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: David Zeuthen <zeuthen@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7b13a0f80904120735r41736455hb7e226ab8ad30bd7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 12, 2009 at 07:35, David Zeuthen <zeuthen@gmail.com> wrote:

> But we'd still need some kind of way of having the kernel tell user
> space what devices are currently claimed by the btrfs filesystem
> instance (and we'd need notifications on changes too). Otherwise we
> don't have enough information for the desktop shell and partitioning
> programs to let the user know that /dev/sdb2 or /dev/sdc1 or whatever
> is currently claimed by the 0:19 btrfs mount at /media/fedora-usb.
>
> One idea is to have a pollable file, /proc/fs/btrfs/devs, that maps
> from the dev_t of the btrfs filesystem instance (as used in
> /proc/self/mountinfo) to the set of dev_t for block devices currently
> claimed? E.g. for the example above we'd have
>
> =C2=A0/proc/fs/btrfs/devs:
> =C2=A00:19 =C2=A0 =C2=A08:18

Btrfs used to export some information in /sys/fs/btrfs/, this is
disabled for now. Maybe we can possibly make it export something like:
  $ tree /sys/fs/btrfs/
  /sys/fs/btrfs/
  |-- 969d1386-a002-4c28-94f2-47be23f344e4
  |   |-- ba1532f3-849b-400b-9c76-2c9aee126c52
  |   |   |-- device -> ../../../devices/.../block/sda/sda3
  |   |   |-- attribute1
  |   |   |-- ...
  |   `-- 45645656-849b-400b-9c76-2c9aee126c52
  |       |-- device -> ../../../devices/.../block/sdb/sdb3
  |       |-- attribute1
  |       ....
  `-- 645645686-a002-4c28-94f2-47be23f344e4
      |-- ...


So you could look for a "device" link at the subvolume devices? Or if
that does not fit for some reason, we could also add a "btrfs" class,
to export details about the subvolumes.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
