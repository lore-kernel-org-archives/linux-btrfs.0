Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:36529 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755193AbdDMStt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2017 14:49:49 -0400
Received: by mail-wr0-f172.google.com with SMTP id c55so40789681wrc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Apr 2017 11:49:48 -0700 (PDT)
MIME-Version: 1.0
From: Ank Ular <ankular.anime@gmail.com>
Date: Thu, 13 Apr 2017 14:49:41 -0400
Message-ID: <CAFKQ2Bs9-=serb7F-PHDVNQ-X2AXcWPG5jBs9xKXTKkTQ59O7Q@mail.gmail.com>
Subject: Encountered kernel bug#72811. Advice on recovery?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've encountered kernel bug#72811 "If a raid5 array gets into degraded
mode, gets modified, and the missing drive re-added, the filesystem
loses state".

In my case, I had rebooted my system and one of the drives on my main
array did not come up. I was able to mount in degraded mode. I needed
to re-boot the following day. This time, all the drives in the array
came up. Several hours later, the array went into read only mode.
That's when I discovered the odd device out had been re-added without
any kind of error message or notice.

SMART does not report any errors on the device itself. I did have a
failed fan inside the server case and I suspect a thermally sensitive
issue with the responsible drive controller. Since replacing the
failed fan plus another fan, all drives devices report a running
temperature in the range of 34~35 Celsius. This is normal. None of the
drives report recording any errors.

The array normally consists of 22 devices with data and meta in raid6.
Physically, the devices are split 16 devices in a NORCO DS-24 cage and
the remaining devices are in the server itself. All the devices are
SATA III.

I've added "noauto" to the options in my fstab file for this array.
I've also disabled the odd drive out so it's no longer seen as part of
the array.

Current fstab line:
LABEL="PublicB"                                 /PublicB        btrfs
 autodefrag,compress=lzo,space_cache,noatime,noauto      0 0

I manually mount the array:
mount -o recovery,ro,degraded

Current device list for the array:
Label: 'PublicB'  uuid: 76d87b95-5651-4707-b5bf-168210af7c3f
       Total devices 22 FS bytes used 83.63TiB
       devid    1 size 5.46TiB used 5.12TiB path /dev/sdt
       devid    2 size 5.46TiB used 5.12TiB path /dev/sdv
       devid    3 size 5.46TiB used 5.12TiB path /dev/sdaa
       devid    4 size 5.46TiB used 5.12TiB path /dev/sdx
       devid    5 size 5.46TiB used 5.12TiB path /dev/sdo
       devid    6 size 5.46TiB used 5.12TiB path /dev/sdq
       devid    7 size 5.46TiB used 5.12TiB path /dev/sds
       devid    8 size 5.46TiB used 5.12TiB path /dev/sdu
       devid    9 size 5.46TiB used 4.25TiB path /dev/sdr
       devid   10 size 5.46TiB used 4.25TiB path /dev/sdy
       devid   11 size 5.46TiB used 4.25TiB path /dev/sdab
       devid   12 size 3.64TiB used 3.64TiB path /dev/sdb
       devid   13 size 3.64TiB used 3.64TiB path /dev/sdc
       devid   14 size 4.55TiB used 4.25TiB path /dev/sdd
       devid   17 size 4.55TiB used 4.25TiB path /dev/sdg
       devid   18 size 4.55TiB used 4.25TiB path /dev/sdh
       devid   19 size 5.46TiB used 4.25TiB path /dev/sdm
       devid   20 size 5.46TiB used 2.33TiB path /dev/sdp
       devid   21 size 5.46TiB used 2.33TiB path /dev/sdn
       devid   22 size 5.46TiB used 2.33TiB path /dev/sdw
       devid   23 size 5.46TiB used 2.33TiB path /dev/sdz
       *** Some devices missing

The missing device is a {nominal} 5.0TB drive and would usually show
up in this list as:
       devid   15 size 4.55TiB used 4.25TiB path /dev/sde

Other than "mount -o recovery,ro" when all 22 were present {and before
I understood I had encountered #72811}, I have NOT run any of the more
advanced recovery/repair commands/techniques.

As best as I can tell using independent {non btrfs related} all data
{approximately 80TB} prior to the initial event is intact. Directories
and files written/updated after the automatic {and silent} device
re-add are suspect and occasionally exhibit either missing files or
missing chunks of files.

Regardless of the fact the data is intact, I get runs of csum and
other errors - sample:
[114427.223006] BTRFS error (device sdw): parent transid verify failed
on 59281854676992 wanted 328408 found 328388
[114427.223011] BTRFS error (device sdw): parent transid verify failed
on 59281854676992 wanted 328408 found 328388
[114427.223012] BTRFS error (device sdw): parent transid verify failed
on 59281854676992 wanted 328408 found 328388
[114427.223015] BTRFS info (device sdw): no csum found for inode
913818 start 1219862528
[114427.223019] BTRFS error (device sdw): parent transid verify failed
on 59281854676992 wanted 328408 found 328388
[114427.223021] BTRFS error (device sdw): parent transid verify failed
on 59281854676992 wanted 328408 found 328388
[114427.223022] BTRFS error (device sdw): parent transid verify failed
on 59281854676992 wanted 328408 found 328388
[114427.223024] BTRFS info (device sdw): no csum found for inode
913818 start 1219866624
[114427.223027] BTRFS error (device sdw): parent transid verify failed
on 59281854676992 wanted 328408 found 328388
[114427.223029] BTRFS error (device sdw): parent transid verify failed
on 59281854676992 wanted 328408 found 328388
[114427.223030] BTRFS error (device sdw): parent transid verify failed
on 59281854676992 wanted 328408 found 328388
[114427.223032] BTRFS info (device sdw): no csum found for inode
913818 start 1219870720
[114427.223035] BTRFS error (device sdw): parent transid verify failed
on 59281854676992 wanted 328408 found 328388
[114427.223037] BTRFS info (device sdw): no csum found for inode
913818 start 1219874816
[114427.223042] BTRFS info (device sdw): no csum found for inode
913818 start 1219878912
[114427.223047] BTRFS info (device sdw): no csum found for inode
913818 start 1219883008
[114427.223051] BTRFS info (device sdw): no csum found for inode
913818 start 1219887104
[114427.223071] BTRFS info (device sdw): no csum found for inode
913818 start 1219891200
[114427.223076] BTRFS info (device sdw): no csum found for inode
913818 start 1219895296
[114427.223080] BTRFS info (device sdw): no csum found for inode
913818 start 1219899392
[114427.230847] BTRFS warning (device sdw): csum failed ino 913818 off
1220612096 csum 3114921698 expected csum 0
[114427.230856] BTRFS warning (device sdw): csum failed ino 913818 off
1220616192 csum 1310722868 expected csum 0
[114427.230861] BTRFS warning (device sdw): csum failed ino 913818 off
1220620288 csum 2799646595 expected csum 0
[114427.230866] BTRFS warning (device sdw): csum failed ino 913818 off
1220624384 csum 4020833134 expected csum 0
[114427.230870] BTRFS warning (device sdw): csum failed ino 913818 off
1220628480 csum 2942842633 expected csum 0
[114427.230875] BTRFS warning (device sdw): csum failed ino 913818 off
1220632576 csum 2112871613 expected csum 0
[114427.230879] BTRFS warning (device sdw): csum failed ino 913818 off
1220636672 csum 3037436145 expected csum 0
[114427.230884] BTRFS warning (device sdw): csum failed ino 913818 off
1220640768 csum 2799458999 expected csum 0
[114427.230888] BTRFS warning (device sdw): csum failed ino 913818 off
1220644864 csum 1132935941 expected csum 0
[114427.230893] BTRFS warning (device sdw): csum failed ino 913818 off
1220648960 csum 2622911668 expected csum 0

At the time of the event, I was running gentoo-sources-4.9.11. I've
upped my kernel to gentoo-sources-4.10.8. I've upped the associated
btrfs tools equivalently.

The practical problem with bug#72811 is that all the csum and transid
information is treated as being just as valid on the automatically
re-added drive as the same information on all the other drives. The
second practical problem appears to be that since this is a raid56
configuration, none of the usual tools such as for fixing csums or
going to backup roots etc appear to work properly. i.e., this appears
to be one of the areas in btrfs where raid56 isn't ready.

In hind sight, I've run into bug#72811 before, but didn't recognize it
at the time. This was due to both inexperience and to having other
problems as well {combination of physical mis-configuration and
failing hard drives}.

I don't have issues with the above tools not being ready for for
raid56. Despite the mass quantities, none of the data involved it
irretrievable, irreplaceable or of earth shattering importance on any
level. This is a purely personal setup.

I'd also like to point out that I have tested the process of
physically pulling a drive and then going through both reducing the
number of drives {given sufficient remaining space} and adding a new
drive to replace the allegedly failed one. These functions seem to
work fine so long as none of the devices are too full.

As such, I'm not bothered by the 'not ready for prime time status' of
raid56. This bug however, is really really nasty bad. Once a drive is
out of sync, if should never be automatically re-added back. Such
drives should always be re-initialized as new drives. At some future
date, if someone codes a solution for properly re-syncing such a
raid56 configured device, then perhaps auto re-adding might make
sense. For now, it doesn't.

I mention all this because I KNOW someone is going to go off on how I
should have back ups of everything and how I should not run raid56 and
how I should run mirrored instead etc. Been there. Done that. I have
the same canned lecture for people running data centers for
businesses.

I am not a business. This is my personal hobby. The risk does not
bother me. I don't mind running this setup because I think real life
runtimes can contribute to the general betterment of btrfs for
everyone. I'm not in any particular hurry. My income is completely
independent from this.

I've run 8 months with this array without a single problem. Drive
controller problems are always nasty and generally much more difficult
to protect against which is why I've been migrating to an external
chassis.

Now that I've gotten that out of my system, what I would really like
is some input/help into putting together a recovery strategy. As it
happens, I had already scheduled and budgeted for the purchase of 8
additional 6TB hard drives. This was in line with approaching 80%
storage utilization. I've accelerated the purchase of these drives and
now have them in hand. I do not currently have the resources to
purchase a second drive chassis nor anymore additional drives. This
means I cannot simply copy the entire array either directly nor via
'btrfs restore'.

On a superficial level, what I'd like to do is set up the new drives
as a second array. Copy/move approximately 20TBs of pre-event data
from the degraded array. Delete/remove/free up those 20TBs from the
degraded array. Reduce the number of devices in the degraded array.
Initialized and add those devices to the new array. Wash. Rinse.
Repeat. Eventually, I'd like all the drives in the external drive
chassis to be the new, recovered array. I'd re-purpose the internal
drives in the server for other uses.

The potential problem is controlling what happens once I mount the
degraded array in read/write mode to delete copied data and perform
device reduction. I have no clue how to or even if this can be done
safely.

The alternative is to continue to run this array in read only degraded
mode until I can accumulate sufficient funds for a second chassis and
approximately 20 more drives.This probably won't be until Jan 2018.

Is such a recovery strategy even possible? While I would expect a
strategy involving 'btrfs restore' to be possible for raid0, raid1,
raid10 configure arrays, I don't know that such a strategy will work
for raid56.

As I see it, the key here to to be able to safely delete copied files
and to safely reduce the number of devices in the array.
