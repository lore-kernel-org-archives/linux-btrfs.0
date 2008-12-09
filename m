From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: btrfs and hotplug, auto-assembly, auto-setup, ...
Date: Tue, 9 Dec 2008 19:02:30 +0100
Message-ID: <ac3eb2510812091002g7d7c163am55f44b188dea0ef6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Greg <greg@kroah.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey,
I thought it would be a good time good to play around a bit with btrfs
in the usual hotplug setup, so we can - if needed - adapt things
before it is going to be finalized.

At a first look, it looks very promising, and I really like the idea
that the state of the (possibly incomplete) device tree is kept in the
kernel, and not somewhere in a file in userspace, like we usually see
for all sorts of multi-volume/multi-device setups. It should make
things much easier as usual.

Like with every other subsystem, people will expect btrfs to just work
with hotpluggable devices, without much configuration and explicit
setup after device connect. To assemble a mountable volume, we will
need to find the (possibly several independent) devices containing the
btrfs data.
This is currently done by scanning all block devices in /dev, and
investigating the content. It works fine for simple and usual setups,
where all block devices behave normally. This strategy is also
required in some situations, like in recovery and rescue situations.
But it will just not work in several "advanced" setups. We may open
devices which do not return the requested data to us, but hang in the
kernel in a timeout, waiting to return with an error to us. There are
boxes out there with tens of thousands of devices, and some, or many
of them, may not work as expected.
In such setups, we can not access all the devices with a single
thread, and open them all sequentially. It just asks for real trouble.
We already ran into such problems on big boxes with
mount-by-label/uuid.

To emulate such behavior, one just needs to do:
  $ modprobe scsi_debug max_luns=8 num_parts=2
  $ echo 1 > /sys/module/scsi_debug/parameters/every_nth
  $ echo 4 > /sys/module/scsi_debug/parameters/opts

  $ ls -l /sys/class/block/ | wc -l
  45

Any call to single-threaded /dev device-node scanner logic will take
~2 hours now, to return to the caller.

To work around these problems, udev probes all devices in a separate
process and puts the probing results asynchronously in the udev
database, and possibly into symlinks somewhere in /dev. The probing
happens fully parallelized. We currently support huge boxes with many
disks, that need to probe ~4000 block devices in parallel, to get a
reasonable bootup/setup time.

That way, all found volume-metadata is immediately available, and
hanging probing-processes will not block the probing of other devices.
They will time out, or return the data at a later point, when it
becomes avialable.

For a first naive try to integrate with udev's async probing, I did:
  $ cat /etc/udev/rules.d/80-btrfs.rules
  SUBSYSTEM=="block", ENV{ID_FS_TYPE}=="btrfs", \
    SYMLINK+="btrfs/$env{ID_FS_UUID_ENC}/$env{ID_FS_UUID_SUB_ENC}"

Connecting devices with btrfs volumes will now create:
  $ tree /dev/btrfs/
  /dev/btrfs/
  |-- 0cdedd75-2d03-41e6-a1eb-156c0920a021
  |   |-- 897fac06-569c-4f45-a0b9-a1f91a9564d4 -> ../../sda10
  |   `-- aac20975-b642-4650-b65b-b92ce22616f2 -> ../../sda9
  `-- a1ec970a-2463-414e-864c-2eb8ac4e1cf2
      |-- 4d1f1fff-4c6b-4b87-8486-36f58abc0610 -> ../../sdb2
      `-- e7fe3065-c39f-4295-a099-a89e839ae350 -> ../../sdb1

Tools could lookup that way all currently active volumes, and it would
also be easy to make the volume known to the kernel at the same time
we recognize it.

To update these links after mkfs.btrfs, the formatting tool would need
to send a change event to the kernel, like:
  echo change > /sys/dev/block/<maj>:<min>/uevent

We should make sure, that at least such problems are known, and we
have thought about the needed infrastructure, to be able to solve
these problems anytime later. If it requires changes to make
supporting such setups easier, even when it's not implemented now, it
would be nice to try to make them before it is finalized.

Let me know, what you think.

Thanks,
Kay
