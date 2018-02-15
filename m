Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43220 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755500AbeBOTek (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:34:40 -0500
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
        (Authenticated sender: alex@alex-wood.org.uk)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 124E71720A3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 20:34:38 +0100 (CET)
Received: by mail-wm0-f45.google.com with SMTP id b21so2892793wme.4
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:34:38 -0800 (PST)
MIME-Version: 1.0
From: Alex Wood <alex@alex-wood.org.uk>
Date: Thu, 15 Feb 2018 19:34:17 +0000
Message-ID: <CAOROK1YXuMgqJHSBdE9X-s6_fQfThpyQBhupSt0qPKGj7HeNYQ@mail.gmail.com>
Subject: Unable to Scrub or Repair a volume after bad Scrub (mountable)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi
A few weeks ago I was a bit under the weather for a week, and so was
unable to give my home server any attention.  Unfortunately during
this time it started a scheduled scrub and decided there was billions
of errors.  When I noticed this, maybe not thinking entirely straight
(i.e. not trying to find out what was causing the errors), I instantly
stopped the scrub and rebooted the server.  The volume didn't mount,
but still feeling unwell I just went back to bed.
When I was feeling better a few days later I tried to mount it, and
noticed I'd got a lot of transid error messages.  I'd had a similar
problem before over a year ago, but couldn't quite remember how I'd
fixed it.  A quick bit of googling later I found a post that suggested
using the check --init-extent-tree which sounded familiar and gave
that a go.  I realise this was  a bit silly, and should have looked a
bit further, but never mind.  Anyway, it literally ran for over a week
(a 38TB volume) and it eventually stopped saying it had ran out of
space.
Feeling fully functional by this stage, I did a bit more digging, and
noticed a few of my drives kept on going intermittently off-line and
tracked the culprit to a bad SAS fan-out cable.  Replaced the cable
and did a check (no repair), and saw that there were still loads of
errors, but the drives were now staying on-line.  I then tried a check
with --repair, which after listing a few transid errors, bombed out
saying it was unable to repair root items, as the operation was not
permitted  (did google this error, with not much coming up on it).
At this point I tried mounting it again (-o usebackuproot,ro) and it
actually worked (although dmesg reported transid errors still), and I
was able to read the last few files I'd written to it before I'd
become ill.  I also tried a scrub to see if  that would fix
anything,but that just bombed out.  So I then tried mounting with just
usebackuproot, which also worked (again with transid errors), tried a
scrub again in case it has bombed out previously due to the ro option,
but alas it didn't work.  Final, just I tried mounting it without any
options and again it worked (again with transid errors), but again I
couldn't get it to scrub.  As I am using Ubuntu 17.10 (so btrfs-progs
4.12), I compiled a static build of the git version of btrfs-progs
4.15 to see if using the check and scrub features in a newer build
maybe able to fix thing, but alas I just get the same errors.
During all of this, I've not written anything to the drives, apart
from what the scrubs check may do (i.e. I've not written anymore files
to the drives) as there is still something very wrong, even through I
seem to be able to read the files okay (obviously not tried them all,
just most recent and a couple of very old ones).  I've cut and past
the current output of dmesg and/or journalctl when
mounting/scrubbing/checking the drives.  As you can see there are 4
drives with large amount of listed read/write/corrupt errors which I
assume to the old errors caused by the bad cable (they don;t seem to
be increasing).  Also some of the transid generation numbers are
close-ish and some miles off, I assume this is due to corrupted
generation numbers being written, as I'd expect them to be a similar
amount out, not such a wide range as I have.
Basically, as the data seems readable I'd love to run a command that
will just tell it to change the generation numbers to what they should
be and clear the error counts, but I'm at a loss to find such a
command (is this what zero-log does, I'm a bit hesitant to use this
until I hear from someone in the know).  Also as check finished early
due to the permissions error with root items and scrub not seeming to
be able to handle the transid errors without finishing early I need a
way to get around these too.
Anyway, I hope this all makes sense, and sorry for it being so long,
but thought it best to give as much detail as possible.  Thank you for
your help.
Alex

Output:
uname -a:
Linux TheMatrix 4.13.0-32-generic #35-Ubuntu SMP Thu Jan 25 09:13:46
UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

btrfs --version:
btrfs-progs v4.12
btrfs.static --version:
btrfs-progs v4.15

btrfs filesystem show /mnt/btrfs/broken:
Label: 'Videos'  uuid: db40f1f9-6239-4db0-87d9-bbce4affdb43
        Total devices 11 FS bytes used 38.18TiB
        devid    1 size 3.64TiB used 3.45TiB path /dev/sds
        devid    2 size 3.64TiB used 3.45TiB path /dev/sdq
        devid    3 size 3.64TiB used 3.45TiB path /dev/sdi
        devid    4 size 3.64TiB used 3.45TiB path /dev/sdj
        devid    5 size 3.64TiB used 3.45TiB path /dev/sdd
        devid    6 size 3.64TiB used 3.56TiB path /dev/sde
        devid    7 size 3.64TiB used 3.56TiB path /dev/sdh
        devid    8 size 3.64TiB used 3.56TiB path /dev/sdr
        devid    9 size 3.64TiB used 3.56TiB path /dev/sdk
        devid   10 size 3.64TiB used 3.56TiB path /dev/sdf
        devid   11 size 3.64TiB used 3.56TiB path /dev/sdp

btrfs filesystem df /mnt/btrfs/broken:
Data, RAID0: total=38.54TiB, used=38.14TiB
System, RAID1: total=64.00MiB, used=3.30MiB
Metadata, RAID1: total=45.61GiB, used=42.01GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

During mount /dev/sdd /mnt/btrfs/broken:
Nothing via stdout
dmesg:
[1216197.622816] BTRFS info (device sdf): disk space caching is enabled
[1216197.622817] BTRFS info (device sdf): has skinny extents
[1216197.845195] BTRFS info (device sdf): bdev /dev/sdf errs: wr 487,
rd 430, flush 0, corrupt 0, gen 8
[1216197.845198] BTRFS info (device sdf): bdev /dev/sdd errs: wr
5292890, rd 693156626, flush 0, corrupt $
, gen 10
[1216197.845201] BTRFS info (device sdf): bdev /dev/sdp errs: wr 2316,
rd 678, flush 0, corrupt 3072, gen
0
[1216197.845202] BTRFS info (device sdf): bdev /dev/sdi errs: wr 335,
rd 615, flush 0, corrupt 0, gen 0
[1216197.845205] BTRFS info (device sdf): bdev /dev/sds errs: wr
98077, rd 114295, flush 0, corrupt 0, ge$
 144
[1216197.845207] BTRFS info (device sdf): bdev /dev/sdr errs: wr 456,
rd 400, flush 0, corrupt 0, gen 0
[1216210.463895] BTRFS info (device sdf): checking UUID tree
[1216211.577078] verify_parent_transid: 2 callbacks suppressed
[1216211.577080] BTRFS error (device sdf): parent transid verify
failed on 50124166119424 wanted 347306 found 15892315202] BTRFS info
(device sdf): bdev /dev/sdi errs: wr 335, rd 615, flush 0, corrupt
[1216211.594138] BTRFS error (device sdf): parent transid verify
failed on 50124166119424 wanted 347306 found 1589231
[1216211.595063] BTRFS warning (device sdf): btrfs_uuid_scan_kthread failed -5
[1216242.108296] BTRFS warning (device sdf): block group
50124114100224 has wrong amount of free space
[1216242.108298] BTRFS warning (device sdf): failed to load free space
cache for block group 50124114100224, rebuilding it now
[1216246.641588] BTRFS info (device sdf): The free space cache file
(49531408613376) is invalid. skip it
[1216247.324292] BTRFS info (device sdf): The free space cache file
(49821318905856) is invalid. skip it
[1216247.621971] BTRFS info (device sdf): The free space cache file
(49866416062464) is invalid. skip it
[1216247.850904] BTRFS info (device sdf): The free space cache file
(49924398120960) is invalid. skip it
[1216248.907827] BTRFS info (device sdf): The free space cache file
(50279806664704) is invalid. skip it
[1216254.083562] BTRFS info (device sdf): The free space cache file
(52395078057984) is invalid. skip it
[1216260.278069] BTRFS info (device sdf): The free space cache file
(54948436115456) is invalid. skip it
[1216266.747547] BTRFS info (device sdf): The free space cache file
(57407304892416) is invalid. skip it
[1216267.730967] BTRFS info (device sdf): The free space cache file
(57711173828608) is invalid. skip it

During btrfs check --repair --progress /dev/sdd:
stdout:
enabling repair mode
warning, bad space info total_bytes 2147483648 used 2169978880
Checking filesystem on /dev/sdd
UUID: db40f1f9-6239-4db0-87d9-bbce4affdb43
parent transid verify failed on 50124166119424 wanted 347306 found 1589231
parent transid verify failed on 50124166119424 wanted 347306 found 1589231
parent transid verify failed on 50124166119424 wanted 347306 found 1589231
parent transid verify failed on 50124166119424 wanted 347306 found 1589231
Ignoring transid failure
parent transid verify failed on 50124166119424 wanted 347306 found 1589231
Ignoring transid failure
leaf parent key incorrect 50124166119424
bad block 50124166119424

ERROR: errors found in extent allocation tree or chunk allocation
parent transid verify failed on 50124166119424 wanted 347306 found 1589231
Ignoring transid failure
leaf parent key incorrect 50124166119424
ERROR: failed to repair root items: Operation not permitted

No dmesg output

During btrfs scrub start -Bd /mnt/btrfs/broken:
stdout:
ERROR: scrubbing /mnt/btrfs1/broken failed for device id 1: ret=-1,
errno=5 (Input/output error)
ERROR: scrubbing /mnt/btrfs1/broken failed for device id 2: ret=-1,
errno=5 (Input/output error)
ERROR: scrubbing /mnt/btrfs1/broken failed for device id 3: ret=-1,
errno=5 (Input/output error)
ERROR: scrubbing /mnt/btrfs1/broken failed for device id 4: ret=-1,
errno=5 (Input/output error)
ERROR: scrubbing /mnt/btrfs1/broken failed for device id 5: ret=-1,
errno=5 (Input/output error)
ERROR: scrubbing /mnt/btrfs1/broken failed for device id 6: ret=-1,
errno=5 (Input/output error)
ERROR: scrubbing /mnt/btrfs1/broken failed for device id 7: ret=-1,
errno=5 (Input/output error)
ERROR: scrubbing /mnt/btrfs1/broken failed for device id 8: ret=-1,
errno=5 (Input/output error)
ERROR: scrubbing /mnt/btrfs1/broken failed for device id 9: ret=-1,
errno=5 (Input/output error)
ERROR: scrubbing /mnt/btrfs1/broken failed for device id 10: ret=-1,
errno=5 (Input/output error)
ERROR: scrubbing /mnt/btrfs1/broken failed for device id 11: ret=-1,
errno=5 (Input/output error)
scrub device /dev/sds (id 1) canceled
        scrub started at Thu Feb 15 19:10:31 2018 and was aborted after 00:01:12
        total bytes scrubbed: 7.44GiB with 0 errors
scrub device /dev/sdq (id 2) canceled
        scrub started at Thu Feb 15 19:10:31 2018 and was aborted after 00:01:12
        total bytes scrubbed: 7.58GiB with 0 errors
scrub device /dev/sdi (id 3) canceled
        scrub started at Thu Feb 15 19:10:31 2018 and was aborted after 00:01:29
        total bytes scrubbed: 9.51GiB with 0 errors
scrub device /dev/sdj (id 4) canceled
        scrub started at Thu Feb 15 19:10:31 2018 and was aborted after 00:02:05
        total bytes scrubbed: 12.23GiB with 0 errors
scrub device /dev/sdd (id 5) canceled
        scrub started at Thu Feb 15 19:10:31 2018 and was aborted after 00:06:08
        total bytes scrubbed: 47.41GiB with 0 errors
scrub device /dev/sde (id 6) canceled
        scrub started at Thu Feb 15 19:10:31 2018 and was aborted after 00:02:49
        total bytes scrubbed: 18.83GiB with 0 errors
scrub device /dev/sdh (id 7) canceled
        scrub started at Thu Feb 15 19:10:31 2018 and was aborted after 00:02:09
        total bytes scrubbed: 13.52GiB with 0 errors
scrub device /dev/sdr (id 8) canceled
        scrub started at Thu Feb 15 19:10:31 2018 and was aborted after 00:00:54
        total bytes scrubbed: 5.36GiB with 0 errors
scrub device /dev/sdk (id 9) canceled
        scrub started at Thu Feb 15 19:10:31 2018 and was aborted after 00:01:00
        total bytes scrubbed: 6.32GiB with 0 errors
scrub device /dev/sdf (id 10) canceled
        scrub started at Thu Feb 15 19:10:31 2018 and was aborted after 00:00:52
        total bytes scrubbed: 5.98GiB with 0 errors
scrub device /dev/sdp (id 11) canceled
        scrub started at Thu Feb 15 19:10:31 2018 and was aborted after 00:00:52
        total bytes scrubbed: 5.98GiB with 0 errors

dmesg:
[1216802.322219] BTRFS error (device sdf): parent transid verify
failed on 50124160401408 wanted 65598 found 1522534
[1216802.356205] BTRFS error (device sdf): parent transid verify
failed on 50124160401408 wanted 65598 found 1522534
[1216802.400389] BTRFS error (device sdf): parent transid verify
failed on 50124160401408 wanted 65598 found 1522534
[1216802.501807] BTRFS error (device sdf): parent transid verify
failed on 50124160401408 wanted 65598 found 1522534
[1216802.503638] BTRFS error (device sdf): parent transid verify
failed on 50124160401408 wanted 65598 found 1522534
[1216804.677302] BTRFS error (device sdf): parent transid verify
failed on 50124133826560 wanted 287542 found 1213960
[1216804.692425] BTRFS error (device sdf): parent transid verify
failed on 50124133826560 wanted 287542 found 1213960
[1216810.010117] BTRFS error (device sdf): parent transid verify
failed on 50124126388224 wanted 78735 found 1125448
[1216810.029168] BTRFS error (device sdf): parent transid verify
failed on 50124126388224 wanted 78735 found 1125448
[1216810.045383] BTRFS error (device sdf): parent transid verify
failed on 50124126388224 wanted 78735 found 1125448
[1216822.251380] BTRFS error (device sdf): parent transid verify
failed on 50124153438208 wanted 271274 found 2545637
[1216822.263511] BTRFS error (device sdf): parent transid verify
failed on 50124153438208 wanted 271274 found 2545637
[1216822.325286] BTRFS error (device sdf): parent transid verify
failed on 50124152291328 wanted 271274 found 2297672
[1216822.332262] BTRFS error (device sdf): parent transid verify
failed on 50124152291328 wanted 271274 found 2297672
[1216839.859689] BTRFS error (device sdf): parent transid verify
failed on 50124152291328 wanted 271274 found 2297672
[1216839.873995] BTRFS error (device sdf): parent transid verify
failed on 50124152291328 wanted 271274 found 2297672
[1216875.849979] BTRFS error (device sdf): parent transid verify
failed on 50124152291328 wanted 271274 found 2297672
[1216875.857510] BTRFS error (device sdf): parent transid verify
failed on 50124152291328 wanted 271274 found 2297672
[1216879.640796] BTRFS error (device sdf): parent transid verify
failed on 50124152799232 wanted 208777 found 2338800
[1216879.644477] BTRFS error (device sdf): parent transid verify
failed on 50124152799232 wanted 208777 found 2338800
[1216919.772617] BTRFS error (device sdf): parent transid verify
failed on 50124145115136 wanted 279114 found 1347923
[1216919.794803] BTRFS error (device sdf): parent transid verify
failed on 50124145115136 wanted 279114 found 1347923
[1217118.374837] BTRFS error (device sdf): parent transid verify
failed on 50124148342784 wanted 270180 found 1383517
[1217118.397785] BTRFS error (device sdf): parent transid verify
failed on 50124148342784 wanted 270180 found 1383517
