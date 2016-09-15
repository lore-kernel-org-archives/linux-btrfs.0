Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35717 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752143AbcIOVKZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 17:10:25 -0400
Received: by mail-wm0-f43.google.com with SMTP id l132so5592308wmf.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 14:10:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1fedb20d-9137-53f2-8d40-fcbf466b658d@chefmail.de>
References: <CAA3ktqmQ+kGddhuw6gC9Hoct+eayxjZFrDjigffCgmDa09=PBA@mail.gmail.com>
 <1fedb20d-9137-53f2-8d40-fcbf466b658d@chefmail.de>
From: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>
Date: Thu, 15 Sep 2016 23:10:22 +0200
Message-ID: <CAA3ktqnVa-s1RzJtDpA+hNOrdG1Vu-Edd8Be5kjEU6KbQ+LJoQ@mail.gmail.com>
Subject: Re: Size of scrubbed Data
To: g6094199@freenet.de
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi sash

How do I move the single system data to raid1? Dmesg doesnt show any
scrubbing errors, according to Smart all the disks are okay. I am not
using any any compression. How would I change freespacecache to v2 and
what benefits would it entail?

I think I need to add the following to my original question: How is
"total bytes scrubbed" calculated? On a Raid1, shouldnt it be exactly
two times the actual data size on the disk?

Yours
Stefan

2016-09-15 22:11 GMT+02:00  <g6094199@freenet.de>:
> Hi Stefan,
>
> 1st you should run an balance on system data to move the single data to
> raid1. imho.
> then do the scrub again.
> btw are there any scrubbing errors in dmesg? disks are ok?! any
> compression involved? changed freespacecache to v2?
>
>
> sash
>
>
>
> Am 15.09.2016 um 17:48 schrieb Stefan Malte Schumacher:
>> Hello
>>
>>
>> I have encountered a very strange phenomenon while using btrfs-scrub.
>> I believe it may be a result of replacing my old installation of
>> Debian Jessie with Debian Stretch, resulting in a Kernel Switch from
>> 3.16+63 to 4.6.0-1. I scrub my filesystem once a month and let anacron
>> send me the results. My filesystem, consisting of four four-gigabyte
>> drives with both data and metadata as RAID1 was reported as containing
>> nearly 12TiB of data in scrubs done in May, June, July and August. But
>> then it changed and suddenly shows only 9TiB in size, despite the fact
>> that I did not delete any large files. If I remember correctly my
>> switch from Debian Jessie to Stretch was around that time period.
>> Could someone explain this behavior to me? Was a new way of
>> calculating the size of scrubed data introduced? How can I check if I
>> have lost data? I have a backup, but only one generation and rsync
>> will by now have deleted files on the NAS, which might have lost on
>> the fileserver. According to the long and short self-tests, which I
>> run with smartmontools my drives are alright. How do I proceed?
>>
>>
>>
>> Yours
>>
>> Stefan
>>
>> uname -a
>> Linux mars 4.6.0-1-amd64 #1 SMP Debian 4.6.4-1 (2016-07-18) x86_64 GNU/Linux
>>
>> btrfs --version
>> btrfs-progs v4.7.1
>>
>>  btrfs fi show
>> Label: none  uuid: 8c668854-db5d-45a7-875d-43c4e82a829e
>>         Total devices 4 FS bytes used 6.06TiB
>>         devid    1 size 3.64TiB used 3.09TiB path /dev/sde
>>         devid    2 size 3.64TiB used 3.09TiB path /dev/sdc
>>         devid    3 size 3.64TiB used 3.09TiB path /dev/sdd
>>         devid    4 size 3.64TiB used 3.09TiB path /dev/sda
>>
>>
>>  btrfs fi df /mnt/btrfs-raid/
>> Data, RAID1: total=6.17TiB, used=6.05TiB
>> System, RAID1: total=32.00MiB, used=916.00KiB
>> System, single: total=4.00MiB, used=0.00B
>> Metadata, RAID1: total=10.00GiB, used=8.14GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>> Maybe this is also of use in identifying the problem:
>> grep btrfs *
>> grep: apt: Ist ein Verzeichnis
>> grep: cups: Ist ein Verzeichnis
>> dpkg.log:2016-09-03 15:20:16 upgrade btrfs-progs:amd64 4.7-1 4.7.1-1
>> dpkg.log:2016-09-03 15:20:16 status triggers-awaited btrfs-progs:amd64 4.7-1
>> dpkg.log:2016-09-03 15:20:16 status half-configured btrfs-progs:amd64 4.7-1
>> dpkg.log:2016-09-03 15:20:16 status unpacked btrfs-progs:amd64 4.7-1
>> dpkg.log:2016-09-03 15:20:16 status half-installed btrfs-progs:amd64 4.7-1
>> dpkg.log:2016-09-03 15:20:16 status half-installed btrfs-progs:amd64 4.7-1
>> dpkg.log:2016-09-03 15:20:17 status unpacked btrfs-progs:amd64 4.7.1-1
>> dpkg.log:2016-09-03 15:20:17 status unpacked btrfs-progs:amd64 4.7.1-1
>> dpkg.log:2016-09-03 15:20:45 configure btrfs-progs:amd64 4.7.1-1 <keine>
>> dpkg.log:2016-09-03 15:20:45 status unpacked btrfs-progs:amd64 4.7.1-1
>> dpkg.log:2016-09-03 15:20:45 status unpacked btrfs-progs:amd64 4.7.1-1
>> dpkg.log:2016-09-03 15:20:45 status half-configured btrfs-progs:amd64 4.7.1-1
>> dpkg.log:2016-09-03 15:20:46 status triggers-awaited btrfs-progs:amd64 4.7.1-1
>> dpkg.log:2016-09-03 15:20:51 status installed btrfs-progs:amd64 4.7.1-1
>> dpkg.log.1:2016-08-10 16:58:23 upgrade btrfs-progs:amd64 4.5.2-1 4.6.1-1
>> dpkg.log.1:2016-08-10 16:58:23 status triggers-awaited btrfs-progs:amd64 4.5.2-1
>> dpkg.log.1:2016-08-10 16:58:23 status half-configured btrfs-progs:amd64 4.5.2-1
>> dpkg.log.1:2016-08-10 16:58:23 status unpacked btrfs-progs:amd64 4.5.2-1
>> dpkg.log.1:2016-08-10 16:58:23 status half-installed btrfs-progs:amd64 4.5.2-1
>> dpkg.log.1:2016-08-10 16:58:24 status half-installed btrfs-progs:amd64 4.5.2-1
>> dpkg.log.1:2016-08-10 16:58:24 status unpacked btrfs-progs:amd64 4.6.1-1
>> dpkg.log.1:2016-08-10 16:58:24 status unpacked btrfs-progs:amd64 4.6.1-1
>> dpkg.log.1:2016-08-10 17:01:25 configure btrfs-progs:amd64 4.6.1-1 <keine>
>> dpkg.log.1:2016-08-10 17:01:25 status unpacked btrfs-progs:amd64 4.6.1-1
>> dpkg.log.1:2016-08-10 17:01:26 status unpacked btrfs-progs:amd64 4.6.1-1
>> dpkg.log.1:2016-08-10 17:01:26 status half-configured btrfs-progs:amd64 4.6.1-1
>> dpkg.log.1:2016-08-10 17:01:26 status triggers-awaited btrfs-progs:amd64 4.6.1-1
>> dpkg.log.1:2016-08-10 17:02:34 status installed btrfs-progs:amd64 4.6.1-1
>> dpkg.log.1:2016-08-19 00:45:05 upgrade btrfs-progs:amd64 4.6.1-1 4.7-1
>> dpkg.log.1:2016-08-19 00:45:05 status triggers-awaited btrfs-progs:amd64 4.6.1-1
>> dpkg.log.1:2016-08-19 00:45:05 status half-configured btrfs-progs:amd64 4.6.1-1
>> dpkg.log.1:2016-08-19 00:45:05 status unpacked btrfs-progs:amd64 4.6.1-1
>> dpkg.log.1:2016-08-19 00:45:05 status half-installed btrfs-progs:amd64 4.6.1-1
>> dpkg.log.1:2016-08-19 00:45:06 status half-installed btrfs-progs:amd64 4.6.1-1
>> dpkg.log.1:2016-08-19 00:45:06 status unpacked btrfs-progs:amd64 4.7-1
>> dpkg.log.1:2016-08-19 00:45:06 status unpacked btrfs-progs:amd64 4.7-1
>> dpkg.log.1:2016-08-19 00:47:06 configure btrfs-progs:amd64 4.7-1 <keine>
>> dpkg.log.1:2016-08-19 00:47:06 status unpacked btrfs-progs:amd64 4.7-1
>> dpkg.log.1:2016-08-19 00:47:06 status unpacked btrfs-progs:amd64 4.7-1
>> dpkg.log.1:2016-08-19 00:47:06 status half-configured btrfs-progs:amd64 4.7-1
>> dpkg.log.1:2016-08-19 00:47:06 status triggers-awaited btrfs-progs:amd64 4.7-1
>> dpkg.log.1:2016-08-19 00:49:22 status installed btrfs-progs:amd64 4.7-1
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
