Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38098 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbdIGEoJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Sep 2017 00:44:09 -0400
Received: by mail-wm0-f50.google.com with SMTP id 187so2271528wmn.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Sep 2017 21:44:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH=dxU6xwikfvfY7zCfuPavnCMMdecnyPckOZ3nyYm+_PZtOrg@mail.gmail.com>
References: <CAH=dxU6uVGXbdYc_65P6XbSby76A6Y=qoM6=cXMHkWDV8JRHVg@mail.gmail.com>
 <CAH=dxU7RM7s+pxT=wxE9WcUNMWjSG_A0=1pUWD1dWGVQ6g+g8Q@mail.gmail.com> <CAH=dxU6xwikfvfY7zCfuPavnCMMdecnyPckOZ3nyYm+_PZtOrg@mail.gmail.com>
From: Dave <davestechshop@gmail.com>
Date: Thu, 7 Sep 2017 00:43:47 -0400
Message-ID: <CAH=dxU6kQdqp-x0nLbTk=T8VhgH3oX8UUA_BO4p6rLEmwBsHhQ@mail.gmail.com>
Subject: Re: send | receive: received snapshot is missing recent files
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is more info and a possible (shocking) explanation. This
aggregates my prior messages and it provides an almost complete set of
steps to reproduce this problem.

Linux srv 4.9.41-1-lts #1 SMP Mon Aug 7 17:32:35 CEST 2017 x86_64 GNU/Linux
btrfs-progs v4.12

My steps:

[root@srv]# sync
[root@srv]# mkdir /home/.snapshots/test1
[root@srv]# btrfs su sn -r /home/ /home/.snapshots/test1/
Create a readonly snapshot of '/home/' in '/home/.snapshots/test1//home'
[root@srv]# sync
[root@srv]# mkdir /mnt/x5a/home/test1
[root@srv]# btrfs send /home/.snapshots/test1/home/ | btrfs receive
/mnt/x5a/home/test1/
At subvol /home/.snapshots/test1/home/
At subvol home
[root@srv]# ls -la /mnt/x5a/home/test1/home/user1/
NOTE: all recent files are present
[root@srv]# ls -la /mnt/x5a/home/test1/home/user2/Documents/
NOTE: all recent files are present
[root@srv]# mkdir /home/.snapshots/test2
[root@srv]# mkdir /mnt/x5a/home/test2
[root@srv]# btrfs su sn -r /home/ /home/.snapshots/test2/
Create a readonly snapshot of '/home/' in '/home/.snapshots/test2//home'
[root@srv]# sync
[root@srv]# btrfs send -p /home/.snapshots/test1/home/
/home/.snapshots/test2/home/ | btrfs receive /mnt/x5a/home/test2/
At subvol /home/.snapshots/test2/home/
At snapshot home
[root@srv]# ls -la /mnt/x5a/home/test2/home/user1/
NOTE: all recent files are MISSING
[root@srv]# ls -la /mnt/x5a/home/test2/home/user2/Documents/
NOTE: all recent files are MISSING

Below I am including some rsync output to illustrate when a snapshot
is missing files (or not):

[root@srv]# rsync -aniv /home/.snapshots/test1/home/
/home/.snapshots/test2/home/
sending incremental file list

sent 1,143,286 bytes  received 1,123 bytes  762,939.33 bytes/sec
total size is 3,642,972,271  speedup is 3,183.28 (DRY RUN)

This indicates that these two subvolumes contain the same files, which
they should because test2 is a snapshot of test1 without any changes
to files, and it was not sent to another physical device.

The problem is when test2 is sent to another device as shown by the
rsync results below.

[root@srv]# rsync -aniv /home/.snapshots/test2/home/ /mnt/x5a/home/test2/home/
sending incremental file list
.d..t...... ./
.d..t...... user1/
>f.st...... user1/.bash_history
>f.st...... user1/.bashrc
>f+++++++++ user1/test2017-09-06.txt
...
and a long list of other missing files

The incrementally sent snapshot at /mnt/x5a/home/test2/home/ is
missing all recent files (any files from the month of August or
September), as my prior visual inspections had indicated. The same
files are missing every time. There is no randomness to the missing
data.

The problem does not happen for me if the receive command target is
located on the same physical device as shown next. (However, I suspect
there's more to it than that, as explained further below.)

[root@srv]# mkdir /home/.snapshots/test2rec
[root@srv]# btrfs send -p /home/.snapshots/test1/home/
/home/.snapshots/test2/home/ | btrfs receive
/home/.snapshots/test2rec/
At subvol /home/.snapshots/test2/home/

# rsync -aniv /home/.snapshots/test2/home/ /home/.snapshots/test2rec/home/
sending incremental file list

sent 1,143,286 bytes  received 1,123 bytes  2,288,818.00 bytes/sec
total size is 3,642,972,271  speedup is 3,183.28 (DRY RUN)

The above (as well as visual inspection of files) indicates that these
two subvolumes contain the same files, which was not the case when the
same command had a target located on another physical device. Of
course, a snapshot which resides on the same physical device is not a
very good backup. So I do need to send it to another device, but that
results in missing files when the -p or -c options are used with btrfs
send. (Non-incremental sending to another physical device does work.)

I can think of a couple possible explanations.

One is that there is a problem when using the -p or -c options with
btrfs send when the target is another physical device. I suspect this
is the actual explanation, however.

A second possibility is that the presence of prior existing snapshots
at the target location (even if old and not referenced in any current
btrfs command), can determine the outcome and final contents of an
incremental send operation. I believe the info below suggests this to
be the case.

[root@srv]# btrfs su show /home/.snapshots/test2/home/
test2/home
        Name:                   home
        UUID:                   292e8bbf-a95f-2a4e-8280-129202d389dc
        Parent UUID:            62418df6-a1f8-d74a-a152-11f519593053
        Received UUID:          e00d5318-6efd-824e-ac91-f25efa5c2a74
        Creation time:          2017-09-06 15:38:16 -0400
        Subvolume ID:           2000
        Generation:             5020
        Gen at creation:        5020
        Parent ID:              257
        Top level ID:           257
        Flags:                  readonly
        Snapshot(s):

[root@srv]# btrfs su show /mnt/x5a/home/test1/home
home/test1/home
        Name:                   home
        UUID:                   dc00b13d-f841-cf48-a169-aa61429a5679
        Parent UUID:            -
        Received UUID:          e00d5318-6efd-824e-ac91-f25efa5c2a74
        Creation time:          2017-09-06 15:33:45 -0400
        Subvolume ID:           656
        Generation:             777
        Gen at creation:        773
        Parent ID:              257
        Top level ID:           257
        Flags:                  readonly
        Snapshot(s):

[root@srv]# btrfs su show /mnt/x5a/home/test2/home/
home/test2/home
        Name:                   home
        UUID:                   b01ab63f-17a1-f442-b9d4-ed12a0d057ea
        Parent UUID:            8bf40f97-10e0-9f47-a281-1a0b21bbbad0
        Received UUID:          e00d5318-6efd-824e-ac91-f25efa5c2a74
        Creation time:          2017-09-06 15:39:51 -0400
        Subvolume ID:           660
        Generation:             779
        Gen at creation:        779
        Parent ID:              257
        Top level ID:           257
        Flags:                  readonly
        Snapshot(s):

[root@srv]# btrfs su show /home/.snapshots/test2rec/home/
test2rec/home
        Name:                   home
        UUID:                   bde1891d-1474-414f-b6ab-2a34c5af224e
        Parent UUID:            62418df6-a1f8-d74a-a152-11f519593053
        Received UUID:          e00d5318-6efd-824e-ac91-f25efa5c2a74
        Creation time:          2017-09-06 17:36:19 -0400
        Subvolume ID:           2003
        Generation:             5027
        Gen at creation:        5027
        Parent ID:              257
        Top level ID:           257
        Flags:                  readonly
        Snapshot(s):

Below, we have old almost forgotten snapshot (date 2017-07-21) on
device /mnt/x5a/home with a Received UUID that matches the Received
UUID of test snapshots that were newly created today. How? Why?

[root@thehulk home]# btrfs su show /mnt/x5a/home/107/snapshot
home/107/snapshot
        Name:                   snapshot
        UUID:                   94d0bc47-dbf2-374e-b1c8-de06d729cde2
        Parent UUID:            8bf40f97-10e0-9f47-a281-1a0b21bbbad0
        Received UUID:          e00d5318-6efd-824e-ac91-f25efa5c2a74
        Creation time:          2017-07-21 00:00:25 -0400
        Subvolume ID:           433
        Generation:             222
        Gen at creation:        221
        Parent ID:              257
        Top level ID:           257
        Flags:                  readonly
        Snapshot(s):

If my guess is correct, btrfs has found this old snapshot and
referenced it without me telling it to do so. The result is that the
newly executed btrfs commands shown above have a totally unexpected
result.

Today's new snapshot will not contain any files newer than 2017-07-21.
Is this a known issue?

Refer back to the commands at the top of this message. I created a new
snapshot and did a full (non-incremental) send to the target location
(/mnt/x5a/home). Then I created a snapshot and did a send which only
referenced the prior snapshot created today. Nowhere did I reference
the ancient /mnt/x5a/home/107/snapshot. (Many prior snapshots exist at
this backup location -- it was intended to hold a lot of them.) Yet,
the very presence of /mnt/x5a/home/107/snapshot on the target device
resulted in today's backup (and all recent backups) being worthless
due to them missing all files since  2017-07-21.

These results are totally repeatable, given my set of existing
backups. But it's bizarre to me. As I understand it, a staff person
could transfer a btrfs snapshot to a target volume and it's mere
presence there could make all subsequent backups (incremental sends)
to that target volume invalid and useless. If that is true... wow.

Another interesting observation is that the device that contains the
source snapshot, /home/.snapshots, also contains many, many prior
snapshots, going back to when this system was first set up. Why do
none of them cause a problem? Is it because I had never used
/home/.snapshots as the target of a receive operation (until I did so
today in testing the steps above)?

As far as repeating these steps, all this was totally repeatable for
me as long as /mnt/x5a/home/107/snapshot existed on the target of the
receive command (/mnt/x5a/home/). I do not know how to create such a
"rogue" snapshot on purpose, but doing so may be key to reproducing my
results.

Maybe somebody can explain to me what's really happening. How is it
possible that an old snapshot created  2017-07-21 could have the same
Received UUID as snapshots created today? And how could that fact lead
to the result I'm seeing, which seems very serious. (Unexpected
missing files from a backup which was completed without errors is
pretty serious in my book.)

Most important question: how can we rely on automated incremental
backups with btrfs send | receive given what I'm observing here
(assuming my observations are roughly correct)?

Here's more info just to confirm that my results are not due to
filesystem corruption.

running check on unmounted volume that contains /mnt/x5a/home/test2/home:
[root@srv]# btrfs check -p /dev/mapper/x5a_luks
Checking filesystem on /dev/mapper/x5a_luks
UUID: 724f7cc1-41d8-456f-9fab-7ace457bd62a
checking extents [o]
checking free space cache [.]
checking fs roots [o]
checking csums
checking root refs
found 258178555904 bytes used, no error found
total csum bytes: 250354776
total tree bytes: 1752088576
total fs tree bytes: 1308540928
total extent tree bytes: 175161344
btree space waste bytes: 215594634
file data blocks allocated: 258634637312
 referenced 292888985600

[root@srv]# btrfs fi show /mnt/x5a/
Label: 'x5a_top'  uuid: 724f7cc1-41d8-456f-9fab-7ace457bd62a
        Total devices 1 FS bytes used 240.45GiB
        devid    1 size 4.55TiB used 244.07GiB path /dev/mapper/x5a_luks

[root@srv]# btrfs fi df /mnt/x5a/
Data, single: total=239.01GiB, used=238.82GiB
System, DUP: total=32.00MiB, used=48.00KiB
Metadata, DUP: total=2.50GiB, used=1.63GiB
GlobalReserve, single: total=422.73MiB, used=0.00B

# btrfs scrub status -d /mnt/x5a/
scrub status for 724f7cc1-41d8-456f-9fab-7ace457bd62a
scrub device /dev/mapper/x5a_luks (id 1) history
        scrub started at Wed Sep  6 17:09:58 2017 and finished after 01:42:30
        total bytes scrubbed: 242.08GiB with 0 errors
