From: David Zeuthen <zeuthen@gmail.com>
Subject: Re: btrfs and /proc/self/mountinfo
Date: Sun, 12 Apr 2009 17:08:31 -0400
Message-ID: <7b13a0f80904121408i1872ec7ej73ea2bf2dc72f4ed@mail.gmail.com>
References: <7b13a0f80904120735r41736455hb7e226ab8ad30bd7@mail.gmail.com>
	 <ac3eb2510904121201p66ee37a2gcd75aeea683ff254@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510904121201p66ee37a2gcd75aeea683ff254@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 12, 2009 at 3:01 PM, Kay Sievers <kay.sievers@vrfy.org> wro=
te:
> Btrfs used to export some information in /sys/fs/btrfs/, this is
> disabled for now. Maybe we can possibly make it export something like=
:
> =A0$ tree /sys/fs/btrfs/
> =A0/sys/fs/btrfs/
> =A0|-- 969d1386-a002-4c28-94f2-47be23f344e4
> =A0| =A0 |-- ba1532f3-849b-400b-9c76-2c9aee126c52
> =A0| =A0 | =A0 |-- device -> ../../../devices/.../block/sda/sda3
> =A0| =A0 | =A0 |-- attribute1
> =A0| =A0 | =A0 |-- ...
> =A0| =A0 `-- 45645656-849b-400b-9c76-2c9aee126c52
> =A0| =A0 =A0 =A0 |-- device -> ../../../devices/.../block/sdb/sdb3
> =A0| =A0 =A0 =A0 |-- attribute1
> =A0| =A0 =A0 =A0 ....
> =A0`-- 645645686-a002-4c28-94f2-47be23f344e4
> =A0 =A0 =A0|-- ...
>
>
> So you could look for a "device" link at the subvolume devices? Or if
> that does not fit for some reason, we could also add a "btrfs" class,
> to export details about the subvolumes.

I guess that either approach would work. The important thing for me is
to figure out what block devices are part of a mounted btrfs volume
including getting change notifications. This also includes the mount
point and the mount options so I think some kind information "linking"
entries in /proc/self/mountinfo to /sys/fs/btrfs would be helpful.

=46or example if /sys/fs/btrfs looked like this

  $ tree /sys/fs/btrfs/
  /sys/fs/btrfs/
  |-- 0:19
  |   |   969d1386-a002-4c28-94f2-47be23f344e4
  |   |   |-- ba1532f3-849b-400b-9c76-2c9aee126c52
  |   |   |   |-- device -> ../../../../devices/.../block/sda/sda3
  |   |   |   |-- attribute1
  |   |   |   |-- ...
  |   |   `-- 45645656-849b-400b-9c76-2c9aee126c52
  |   |       |-- device -> ../../../../devices/.../block/sdb/sdb3
  |   |       |-- attribute1
  |   |       ....
  |-- 0:20
  |   `-- 645645686-a002-4c28-94f2-47be23f344e4
  |       |-- ...

then it's really easy to figure out that sda3 and sdb3 are both active
subvolumes of the btrfs volume 969d1386-a002-4c28-94f2-47be23f344e4
that is mounted with dev_t 0:19.

E.g. the app would go through /proc/self/mountinfo, see that 0:19 is
mounted at /foo with options bar,baz, see that the fstype is 'btrfs'
and then look up /sys/fs/btrfs/0:19 to get the subvolumes.

Ideally we'd also get events (POLLPRI or POLLERR) on
/proc/self/mountinfo when btrfs subvolumes are attached and detached.

(apologies if 'active', 'attached' and 'detached' isn't proper btrfs li=
ngo)

I mean, this approach probably require the least amount of changes to
apps if they want to properly support btrfs. I think at least *some*
changes are to be expected due to the multi-disk nature of btrfs.

There might be an easier way to solve this, I don't know. Perhaps if
every btrfs subvolume had an entry in /proc/self/mountinfo at least
some legacy apps wouldn't need modifications... yet others would
probably fail... I don't know.

     David
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
