Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:40166 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730736AbeGQMS3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 08:18:29 -0400
Received: by mail-io0-f171.google.com with SMTP id l14-v6so686815iob.7
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jul 2018 04:46:14 -0700 (PDT)
Subject: Re: Healthy amount of free space?
To: Wolf <wolf@wolfsden.cz>, linux-btrfs@vger.kernel.org
References: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d847ef6e-aebe-6d5c-092c-b5e62d807db9@gmail.com>
Date: Tue, 17 Jul 2018 07:46:10 -0400
MIME-Version: 1.0
In-Reply-To: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-16 16:58, Wolf wrote:
> Greetings,
> I would like to ask what what is healthy amount of free space to keep on
> each device for btrfs to be happy?
> 
> This is how my disk array currently looks like
> 
>      [root@dennas ~]# btrfs fi usage /raid
>      Overall:
>          Device size:                  29.11TiB
>          Device allocated:             21.26TiB
>          Device unallocated:            7.85TiB
>          Device missing:                  0.00B
>          Used:                         21.18TiB
>          Free (estimated):              3.96TiB      (min: 3.96TiB)
>          Data ratio:                       2.00
>          Metadata ratio:                   2.00
>          Global reserve:              512.00MiB      (used: 0.00B)
> 
>      Data,RAID1: Size:10.61TiB, Used:10.58TiB
>         /dev/mapper/data1       1.75TiB
>         /dev/mapper/data2       1.75TiB
>         /dev/mapper/data3     856.00GiB
>         /dev/mapper/data4     856.00GiB
>         /dev/mapper/data5       1.75TiB
>         /dev/mapper/data6       1.75TiB
>         /dev/mapper/data7       6.29TiB
>         /dev/mapper/data8       6.29TiB
> 
>      Metadata,RAID1: Size:15.00GiB, Used:13.00GiB
>         /dev/mapper/data1       2.00GiB
>         /dev/mapper/data2       3.00GiB
>         /dev/mapper/data3       1.00GiB
>         /dev/mapper/data4       1.00GiB
>         /dev/mapper/data5       3.00GiB
>         /dev/mapper/data6       1.00GiB
>         /dev/mapper/data7       9.00GiB
>         /dev/mapper/data8      10.00GiB
Slightly OT, but the distribution of metadata chunks across devices 
looks a bit sub-optimal here.  If you can tolerate the volume being 
somewhat slower for a while, I'd suggest balancing these (it should get 
you better performance long-term).
> 
>      System,RAID1: Size:64.00MiB, Used:1.50MiB
>         /dev/mapper/data2      32.00MiB
>         /dev/mapper/data6      32.00MiB
>         /dev/mapper/data7      32.00MiB
>         /dev/mapper/data8      32.00MiB
> 
>      Unallocated:
>         /dev/mapper/data1    1004.52GiB
>         /dev/mapper/data2    1004.49GiB
>         /dev/mapper/data3    1006.01GiB
>         /dev/mapper/data4    1006.01GiB
>         /dev/mapper/data5    1004.52GiB
>         /dev/mapper/data6    1004.49GiB
>         /dev/mapper/data7    1005.00GiB
>         /dev/mapper/data8    1005.00GiB
> 
> Btrfs does quite good job of evenly using space on all devices. No, how
> low can I let that go? In other words, with how much space
> free/unallocated remaining space should I consider adding new disk?
Disclaimer: What I'm about to say is based on personal experience.  YMMV.

It depends on how you use the filesystem.

Realistically, there are a couple of things I consider when trying to 
decide on this myself:

* How quickly does the total usage increase on average, and how much can 
it be expected to increase in one day in the worst case scenario?  This 
isn't really BTRFS specific, but it's worth mentioning.  I usually don't 
let an array get close enough to full that it wouldn't be able to safely 
handle at least one day of the worst case increase and another 2 of 
average increases.  In BTRFS terms, the 'safely handle' part means you 
should be adding about 5GB for a multi-TB array like you have, or about 
1GB for a sub-TB array.

* What are the typical write patterns?  Do files get rewritten in-place, 
or are they only ever rewritten with a replace-by-rename? Are writes 
mostly random, or mostly sequential?  Are writes mostly small or mostly 
large?  The more towards the first possibility listed in each of those 
question (in-place rewrites, random access, and small writes), the more 
free space you should keep on the volume.

* Does this volume see heavy usage of fallocate() either to preallocate 
space (note that this _DOES NOT WORK SANELY_ on BTRFS), or to punch 
holes or remove ranges from files.  If whatever software you're using 
does this a lot on this volume, you want even more free space.

* Do old files tend to get removed in large batches?  That is, possibly 
hundreds or thousands of files at a time.  If so, and you're running a 
reasonably recent (4.x series) kernel or regularly balance the volume to 
clean up empty chunks, you don't need quite as much free space.

* How quickly can you get a new device added, and is it critical that 
this volume always be writable?  Sounds stupid, but a lot of people 
don't consider this.  If you can trivially get a new device added 
immediately, you can generally let things go a bit further than you 
would normally, same for if the volume being read-only can be tolerated 
for a while without significant issues.

It's worth noting that I explicitly do not care about snapshot usage. 
It rarely has much impact on this other than changing how the total 
usage increases in a day.

Evaluating all of this is of course something I can't really do for you. 
  If I had to guess, with no other information that the allocations 
shown, I'd say that you're probably generically fine until you get down 
to about 5GB more than twice the average amount by which the total usage 
increases in a day.  That's a rather conservative guess without any 
spare overhead for more than a day, and assumes you aren't using 
fallocate much but have an otherwise evenly mixed write/delete workload.
