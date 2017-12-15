Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:34619 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753544AbdLOIgj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 03:36:39 -0500
Received: by mail-ua0-f196.google.com with SMTP id d26so5719764uak.1
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 00:36:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171215103423.0fd678a6@natsu>
References: <CAA85sZvo8_39nhyoZP6SGiXTAEi4MCNPDLgqe75LNuUUwQSMqQ@mail.gmail.com>
 <20171215103423.0fd678a6@natsu>
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Fri, 15 Dec 2017 09:36:17 +0100
Message-ID: <CAA85sZsEf7T+9s_BKpzoFm4aNO6hHsXNTk86LQCOiFiuA3aJYw@mail.gmail.com>
Subject: Re: [4.14.3] btrfs out of space error
To: Roman Mamedov <rm@romanrm.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 15, 2017 at 6:34 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Fri, 15 Dec 2017 01:39:03 +0100
> Ian Kumlien <ian.kumlien@gmail.com> wrote:
>
>> Hi,
>>
>> Running a 4.14.3 kernel, this just happened, but there should have
>> been another 20 gigs or so available.
>>
>> The filesystem seems fine after a reboot though
>
> What are your mount options, and can you show the output of "btrfs fi
> df" and "btrfs fi us" for the filesystem? And what does
> "cat /sys/block/sdb/queue/rotational" return.

It's a btrfs raid1 mirror of two ssd:s

mount options was:
defaults,acl,noatime,space_cache,autodefrag,compress=lzo

btrfs fi df /
Data, RAID1: total=459.25GiB, used=372.42GiB
Data, single: total=8.00MiB, used=0.00B
System, RAID1: total=8.00MiB, used=80.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=6.00GiB, used=3.69GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

btrfs fi us /
Overall:
    Device size: 930.54GiB
    Device allocated: 930.53GiB
    Device unallocated:   20.05MiB
    Device missing:      0.00B
    Used: 752.22GiB
    Free (estimated):   86.84GiB (min: 86.84GiB)
    Data ratio:       2.00
    Metadata ratio:       2.00
    Global reserve: 512.00MiB (used: 0.00B)

Data,single: Size:8.00MiB, Used:0.00B
   /dev/sdb2    8.00MiB

Data,RAID1: Size:459.25GiB, Used:372.42GiB
   /dev/sdb2 459.25GiB
   /dev/sdc2 459.25GiB

Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/sdb2    8.00MiB

Metadata,RAID1: Size:6.00GiB, Used:3.69GiB
   /dev/sdb2    6.00GiB
   /dev/sdc2    6.00GiB

System,single: Size:4.00MiB, Used:0.00B
   /dev/sdb2    4.00MiB

System,RAID1: Size:8.00MiB, Used:80.00KiB
   /dev/sdb2    8.00MiB
   /dev/sdc2    8.00MiB

Unallocated:
   /dev/sdb2   24.00KiB
   /dev/sdc2   20.02MiB

And as expected:
cat /sys/block/sdb/queue/rotational
0

> I wonder if it's the same old "ssd allocation scheme" problem, and no
> balancing done in a long time or at all.

I had something similar happen on a laptop a while ago - took a while
before i could get it back in order
(in that case i think it was actually a oops --- it kept saying "no
space left" and switched to read only even
if you removed a lot of data, invalidated the space cache and so on)
