Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34745 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbbJNO3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 10:29:07 -0400
Received: by lfaz124 with SMTP id z124so12786438lfa.1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 07:29:05 -0700 (PDT)
MIME-Version: 1.0
From: Dmitry Katsubo <dmitry.katsubo@gmail.com>
Date: Wed, 14 Oct 2015 16:28:46 +0200
Message-ID: <CAOGcOQE3_ROtk=2kQkjTUkGE1tz=HEzbeZnrWUOPziW=kNNXBQ@mail.gmail.com>
Subject: Recover btrfs volume which can only be mounded in read-only mode
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear btrfs community,

I am facing several problems regarding to btrfs, and I will be very
thankful if someone can help me with. Also while playing with btrfs I
have few suggestions – would be nice if one can comment on those.

While starting the system, /var (which is btrfs volume) failed to be
mounted. That btrfs volume was created with the following options:

# mkfs.btrfs -d raid1 -m raid1 /dev/sdc2 /dev/sda /dev/sdd1

Here comes what is recorded in systemd journal during the startup:

[    2.931097] BTRFS: device fsid 57b828ee-5984-4f50-89ff-4c9be0fd3084
devid 2 transid 394288 /dev/sda
[    9.810439] BTRFS: device fsid 57b828ee-5984-4f50-89ff-4c9be0fd3084
devid 1 transid 394288 /dev/sdc2
Oct 11 13:00:22 systemd[1]: Job
dev-disk-by\x2duuid-57b828ee\x2d5984\x2d4f50\x2d89ff\x2d4c9be0fd3084.device/start
timed out.
Oct 11 13:00:22 systemd[1]: Timed out waiting for device
dev-disk-by\x2duuid-57b828ee\x2d5984\x2d4f50\x2d89ff\x2d4c9be0fd3084.device.

After the system started on runlevel 1, I attempted to mount the filesystem:

# mount /var
Oct 11 13:53:55 kernel: BTRFS info (device sdc2): disk space caching is enabled
Oct 11 13:53:55 kernel: BTRFS: failed to read chunk tree on sdc2
Oct 11 13:53:55 kernel: BTRFS: open_ctree failed

When I google for "failed to read chunk tree" the feedback was that
something really bad is happening, and it's time to restore the data /
give up with btrfs. In fact, this message is misleading because it
refers /dev/sdc2 which is a mount device in fstab but this is SSD
drive, so it is very unlikely to cause "read" error. Literally I read
the message as "BTRFS: tried to read something from sdc2 and failed".
Maybe it is better to re-phrase the message to "failed to construct
chunk tree on /var (sdc2,sda,sdd1)"?

Next I did a check:

# btrfs check /dev/sdc2
warning devid 3 not found already
checking extents
checking free space cache
Error reading 36818145280, -1
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/sdc2
UUID: 57b828ee-5984-4f50-89ff-4c9be0fd3084
failed to load free space cache for block group 36536582144
found 29602081783 bytes used err is 0
total csum bytes: 57681304
total tree bytes: 1047363584
total fs tree bytes: 843694080
total extent tree bytes: 121159680
btree space waste bytes: 207443742
file data blocks allocated: 77774524416
 referenced 60893913088

The message "devid 3 not found already" does not tell much to me. If I
understand correctly, btrfs does not store the list of devices in the
metadata, but maybe it would be a good idea to save the last seen
information about devices so that I would not need to guess what
"devid 3" means?

Next I tried to list all devices in my btrfs volume. I found this is
not possible (unless volume is mounted). Would be nice if "btrfs
device scan" outputs the detected volumes / devices to stdout (e.g.
with "-v" option) or there is any other way to do that.

Then I have mounted the volume in degraded mode and only after that I
could understand what the error message means:

# mount /var -o degraded
# btrfs device stats /var
btrfs device stats /var
[/dev/sdc2].write_io_errs   0
[/dev/sdc2].read_io_errs    0
[/dev/sdc2].flush_io_errs   0
[/dev/sdc2].corruption_errs 0
[/dev/sdc2].generation_errs 0
[/dev/sda].write_io_errs   0
[/dev/sda].read_io_errs    0
[/dev/sda].flush_io_errs   0
[/dev/sda].corruption_errs 0
[/dev/sda].generation_errs 0
[].write_io_errs   3160958
[].read_io_errs    0
[].flush_io_errs   0
[].corruption_errs 0
[].generation_errs 0

Now I can see that the device with devid 3 is actually /dev/sdd1,
which btrfs found not ready. Is it possible to improve btrfs output
and to list "last seen device" in that output, e.g.

[/dev/sdd1*].write_io_errs   3160958
[/dev/sdd1*].read_io_errs    0
...

where "*" means that device is missing.

I have listed all partitions and /dev/sdd1 was among them. I have also run

# badblocks /dev/sdd

and it found no bad blocks. Why btrfs considers the device "not ready"
– that is a question.

Afterwards I have decided to run scrub:

# btrfs scrub start /var
# btrfs scrub status /var
scrub status for 57b828ee-5984-4f50-89ff-4c9be0fd3084
    scrub started at Sun Oct 11 14:55:45 2015 and was aborted after 1365 seconds
    total bytes scrubbed: 89.52GiB with 0 errors

I have noticed that btrfs always reports "was aborted after X
seconds", even if scrub is still running (I check that X and number of
bytes scrubbed is increasing). That is confusing. After scrub
finished, I have no idea whether it scrubbed everything, or was really
aborted. And if it was aborted, what is the reason? Also it would be
nice if status displays the number of data bytes (without replicas)
scrubbed because the number 89.52GiB includes all replicas (of raid1
in my case):

total bytes scrubbed: 89.52GiB (data 55.03GiB, system 16.00KiB,
metadata 998.83MiB) with 0 errors

Then I can compare this number with "filesystem df" output to answer
the question: was all data successfully scrubbed?

# btrfs filesystem df /var
Data, RAID1: total=70.00GiB, used=55.03GiB
Data, single: total=8.00MiB, used=0.00B
System, RAID1: total=32.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=2.00GiB, used=998.83MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=336.00MiB, used=0.00B

Unfortunately, btrfs version I have (3.17) does not support "device
delete missing" command (it printed help to console), so I just
re-added /dev/sdd1 and started the balancing:

# btrfs device add /dev/sdd1 /var
# btrfs balance start /var
Done, had to relocate 76 out of 76 chunks

I assumed that last command should return the control quickly, but it
tool quite some time it to perform the necessary relocations.
Wishlist: "balance start" is truly asynchronous (initiates balancing
on the background and exits). Also it would be nice if "balance
status" remembers displays the status of last operation.

After that the picture was the following:

# btrfs fi show /var
Label: none  uuid: 57b828ee-5984-4f50-89ff-4c9be0fd3084
    Total devices 4 FS bytes used 55.99GiB
    devid    1 size 52.91GiB used 0.00B path /dev/sdc2
    devid    2 size 232.89GiB used 58.03GiB path /dev/sda
    devid    4 size 111.79GiB used 58.03GiB path /dev/sdd1
    *** Some devices missing

I was surprised to see that balance operation has moved everything
away from /dev/sdc2. That was not clever.

I thought that the problem is solved and rebooted. Unfortunately
/dev/sdd1 was again dropped off from the volume. This time I was not
able to mount in degraded mode, only in read-only mode:

# mount -o degraded /var
Oct 11 18:20:15 kernel: BTRFS: too many missing devices, writeable
mount is not allowed

# mount -o degraded,ro /var
# btrfs device add /dev/sdd1 /var
ERROR: error adding the device '/dev/sdd1' - Read-only file system

Now I am stuck: I cannot add device to the volume to satisfy raid pre-requisite.

Please, advise.

P.S. I know that sdd1 device is failing (the write error counter is
3160958) and needs replacing.

Extra information:
Debian jessie
Linux kernel v3.16.0-4-686-pae
btrfs v3.17-1.1

--
With best regards,
Dmitry
