Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:33946 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935698Ab3DRBuu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 21:50:50 -0400
Received: by mail-ob0-f179.google.com with SMTP id x4so152808obh.38
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2013 18:50:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG42Uxcjk-T9e-9uO6L+dLzqo3N7c+RMvUyaS2WE_aFWK9niJA@mail.gmail.com>
References: <CAG42UxdVpz7a0FPEc7Ajm+jHHrqG7zT2=JaPZcFzMQT18eqzww@mail.gmail.com>
 <20130417065506.GA21083@panda> <CAG42Uxcjk-T9e-9uO6L+dLzqo3N7c+RMvUyaS2WE_aFWK9niJA@mail.gmail.com>
From: Matt Pursley <mpursley@gmail.com>
Date: Wed, 17 Apr 2013 18:50:09 -0700
Message-ID: <CAG42Uxccx7NzJN2oyyAqU9mWN8q-6==V2zg1OQ2mOfvBZtbs1w@mail.gmail.com>
Subject: Re: One random read streaming is fast (~1200MB/s), but two or more
 are slower (~750MB/s)?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey All,

Here are the results of making and reading back a 13GB file on
"mdraid6 + ext4",  "mdraid6 + btrfs", and "btrfsraid6 + btrfs".

Seems to show that:
1) "mdraid6 + ext4" can do ~1100 MB/s for these sequential reads with
either one or two files at once.
2) "btrfsraid6 + btrfs" can do ~1100 MB/s for sequential reads with
one file at a time, but only ~750 MB/s with two (or more).
3) "mdraid6 + btrfs" can only do ~750 MB/s for these sequential reads
with either one or two files at once.


So, seems like the speed drop is related more to the btrfs files
system, then the experimental raid.
Although it is interesting that btrfs can only do the full ~1100 MB/s
with a single file on the btrfsraid6, but not mdraid6.


Anyway, just some more info and reproducible results.

I have also opened a ticket in bugzilla.kernel.org for this issue here...
https://bugzilla.kernel.org/show_bug.cgi?id=56771




Thanks,
Matt






___ mdraid6 + ext4 ___

kura1 / # mount | grep -i /var/data
/dev/md0 on /var/data type ext4 (rw)

kura1 / # cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
[linear] [multipath]
md0 : active raid6 sdm[11] sdl[10] sdk[9] sdj[8] sdi[7] sdh[6] sdg[5]
sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
      29302650880 blocks super 1.2 level 6, 512k chunk, algorithm 2
[12/12] [UUUUUUUUUUUU]
      [>....................]  resync =  0.0% (2731520/2930265088)
finish=47268.1min speed=1031K/sec

unused devices: <none>



## Create two 13GB testfiles...

kura1 / #  sysctl vm.drop_caches=1 ; dd if=/dev/zero
of=/var/data/persist/testfile1 bs=640k count=20000 conv=fdatasync
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 47.27 s, 277 MB/s
kura1 / #  sysctl vm.drop_caches=1 ; dd if=/dev/zero
of=/var/data/persist/testfile2 bs=640k count=20000 conv=fdatasync
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 47.0237 s, 279 MB/s


## Read back one testfile... ~1300 MB/s

kura1 / # sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 10.3469 s, 1.3 GB/s
kura1 / # sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 10.0073 s, 1.3 GB/s
kura1 / # sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 10.69 s, 1.2 GB/s



## Read back the two testfiles at the same time.. ~1100MB/s

kura1 / # (sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k) & (sysctl vm.drop_caches=1 ;
dd of=//dev/null if=/var/data/persist/testfile2 bs=640k) & wait
vm.drop_caches = 1
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 24.4988 s, 535 MB/s
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 24.591 s, 533 MB/s

kura1 / # (sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k) & (sysctl vm.drop_caches=1 ;
dd of=//dev/null if=/var/data/persist/testfile2 bs=640k) & wait
vm.drop_caches = 1
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 24.7013 s, 531 MB/s
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 24.7016 s, 531 MB/s

kura1 / # (sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k) & (sysctl vm.drop_caches=1 ;
dd of=//dev/null if=/var/data/persist/testfile2 bs=640k) & wait
vm.drop_caches = 1
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 24.5512 s, 534 MB/s
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 24.8276 s, 528 MB/s

________________________________


___ mdraid6 + btrfs _______________


kura1 ~ # mount | grep -i /var/data
/dev/md0 on /var/data type btrfs (rw,noatime)

kura1 ~ # cat  /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
[linear] [multipath]
md0 : active raid6 sdm[11] sdl[10] sdk[9] sdj[8] sdi[7] sdh[6] sdg[5]
sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
      29302650880 blocks super 1.2 level 6, 512k chunk, algorithm 2
[12/12] [UUUUUUUUUUUU]
      [>....................]  resync =  0.0% (1917184/2930265088)
finish=44415.7min speed=1098K/sec

unused devices: <none>

kura1 ~ # btrfs filesystem show
failed to open /dev/sr0: No medium found
Label: none  uuid: 5eb756b5-03a1-4d06-8e91-0f683a763a88
Total devices 1 FS bytes used 448.00KB
devid    1 size 27.29TB used 2.04GB path /dev/md0

Label: none  uuid: 4546715c-8948-42b3-b529-a1c9cd175c2e
Total devices 12 FS bytes used 80.74GB
devid   12 size 2.73TB used 9.35GB path /dev/sdm
devid   11 size 2.73TB used 9.35GB path /dev/sdl
devid   10 size 2.73TB used 9.35GB path /dev/sdk
devid    9 size 2.73TB used 9.35GB path /dev/sdj
devid    8 size 2.73TB used 9.35GB path /dev/sdi
devid    7 size 2.73TB used 9.35GB path /dev/sdh
devid    6 size 2.73TB used 9.35GB path /dev/sdg
devid    5 size 2.73TB used 9.35GB path /dev/sdf
devid    4 size 2.73TB used 9.35GB path /dev/sde
devid    3 size 2.73TB used 9.35GB path /dev/sdd
devid    2 size 2.73TB used 9.35GB path /dev/sdc
devid    1 size 2.73TB used 9.37GB path /dev/sdb

Btrfs v0.20-rc1-253-g7854c8b


## Create two 13GB testfiles...

kura1 ~ # sysctl vm.drop_caches=1 ; dd if=/dev/zero
of=/var/data/persist/testfile1 bs=640k count=20000 conv=fdatasync
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 34.2789 s, 382 MB/s
kura1 ~ # sysctl vm.drop_caches=1 ; dd if=/dev/zero
of=/var/data/persist/testfile2 bs=640k count=20000 conv=fdatasync
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 43.2937 s, 303 MB/s



## Read back one testfile... ~750 MB/s

kura1 ~ # sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 16.7785 s, 781 MB/s
kura1 ~ # sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 18.1361 s, 723 MB/s
kura1 ~ # sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 19.1985 s, 683 MB/s


## Read back the two testfiles at the same time.. ~750MB/s

kura1 ~ # (sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k) & (sysctl vm.drop_caches=1 ;
dd of=//dev/null if=/var/data/persist/testfile2 bs=640k) & wait
vm.drop_caches = 1
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 30.8396 s, 425 MB/s
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 35.5478 s, 369 MB/s

kura1 ~ # (sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k) & (sysctl vm.drop_caches=1 ;
dd of=//dev/null if=/var/data/persist/testfile2 bs=640k) & wait
vm.drop_caches = 1
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 34.6504 s, 378 MB/s
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 35.7795 s, 366 MB/s

kura1 ~ # (sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k) & (sysctl vm.drop_caches=1 ;
dd of=//dev/null if=/var/data/persist/testfile2 bs=640k) & wait
vm.drop_caches = 1
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 36.9101 s, 355 MB/s
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 37.7395 s, 347 MB/s


________________________



___ btrfsraid6 + btrfs ___

kura1 ~ # mount | grep -i /var/data
/dev/sdl on /var/data type btrfs (rw,noatime)

kura1 ~ # btrfs filesystem show
failed to open /dev/sr0: No medium found
Label: none  uuid: 4546715c-8948-42b3-b529-a1c9cd175c2e
Total devices 12 FS bytes used 80.74GB
devid   12 size 2.73TB used 9.35GB path /dev/sdm
devid   11 size 2.73TB used 9.35GB path /dev/sdl
devid   10 size 2.73TB used 9.35GB path /dev/sdk
devid    9 size 2.73TB used 9.35GB path /dev/sdj
devid    8 size 2.73TB used 9.35GB path /dev/sdi
devid    7 size 2.73TB used 9.35GB path /dev/sdh
devid    6 size 2.73TB used 9.35GB path /dev/sdg
devid    5 size 2.73TB used 9.35GB path /dev/sdf
devid    4 size 2.73TB used 9.35GB path /dev/sde
devid    3 size 2.73TB used 9.35GB path /dev/sdd
devid    2 size 2.73TB used 9.35GB path /dev/sdc
devid    1 size 2.73TB used 9.37GB path /dev/sdb

Btrfs v0.20-rc1-253-g7854c8b


## Create two 13GB testfiles...

kura1 data # sysctl vm.drop_caches=1 ; dd if=/dev/zero
of=/var/data/persist/testfile2 bs=640k count=20000 conv=fdatasync
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 21.5018 s, 610 MB/s
kura1 data # sysctl vm.drop_caches=1 ; dd if=/dev/zero
of=/var/data/persist/testfile1 bs=640k count=20000 conv=fdatasync
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 21.3389 s, 614 MB/s



## Read back one testfile... ~1100 MB/s

kura1 data # sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 11.8312 s, 1.1 GB/s
kura1 data # sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 11.7888 s, 1.1 GB/s
kura1 data # sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k
vm.drop_caches = 1
20000+0 records in
20000+0 records out

20000+0 records out
13107200000 bytes (13 GB) copied, 41.4113 s, 317 MB/s

kura1 data #  (sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k) & (sysctl vm.drop_caches=1 ;
dd of=/dev/null if=/var/data/persist/testfile2 bs=640k) & wait
[1] 19482
[2] 19483
vm.drop_caches = 1
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 36.0124 s, 364 MB/s
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 36.2298 s, 362 MB/s

kura1 data #  (sysctl vm.drop_caches=1 ; dd of=/dev/null
if=/var/data/persist/testfile1 bs=640k) & (sysctl vm.drop_caches=1 ;
dd of=/dev/null if=/var/data/persist/testfile2 bs=640k) & wait
[1] 19500
[2] 19501
vm.drop_caches = 1
vm.drop_caches = 1
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 35.4703 s, 370 MB/s
20000+0 records in
20000+0 records out
13107200000 bytes (13 GB) copied, 35.7789 s, 366 MB/s
[1]-  Done                    ( sysctl vm.drop_caches=1; dd
of=/dev/null if=/var/data/persist/testfile1 bs=640k )
[2]+  Done                    ( sysctl vm.drop_caches=1; dd
of=/dev/null if=/var/data/persist/testfile2 bs=640k )


_____



On Wed, Apr 17, 2013 at 10:30 AM, Matt Pursley <mpursley@gmail.com> wrote:
> On Tue, Apr 16, 2013 at 11:55 PM, Sander <sander@humilis.net> wrote:
>> Matt Pursley wrote (ao):
>>> I have an LSI HBA card (LSI SAS 9207-8i) with 12 7200rpm SAS drives
>>> attached.  When it's formated with mdraid6+ext4 I get about 1200MB/s
>>> for multiple streaming random reads with iozone.  With btrfs in
>>> 3.9.0-rc4 I can also get about 1200MB/s, but only with one stream at a
>>> time.
>>
>> Just curious, is that btrfs on top of mdraid6, or is this experimental
>> btrfs raid6 without md?
>
>
>
> This is the "experimental btrfs raid6 without md".
>
> But, I did do a "mdraid6 with btrfs" test last night... and with that
> setup I only get the ~750MB/s result.. even with just one
> thread/stream...
>
> I will flip the system back to "btrfsraid6+btrfs" today to verify that
> I still get the full 1200MB/s with one stream/thread and ~750MB/s with
> two or more streams/threads with that setup...
>
>
> Thanks,
> Matt
>
>
>
> ___
> mdraid6+btrfs_64GBRam_80files # sysctl vm.drop_caches=1 ; dd
> of=/dev/null if=/var/data/persist/testfile bs=640k
> vm.drop_caches = 1
> 20000+0 records in
> 20000+0 records out
> 13107200000 bytes (13 GB) copied, 18.2109 s, 720 MB/s
> ___
