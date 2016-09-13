Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35586 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755255AbcIMTuI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 15:50:08 -0400
Received: by mail-it0-f49.google.com with SMTP id r192so12421794ita.0
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 12:50:08 -0700 (PDT)
Subject: Re: Filesystem forced to readonly after use
To: Cesar Strauss <cestrauss@gmail.com>, linux-btrfs@vger.kernel.org
References: <a74b20fd-9640-b543-c31c-d475a51dcc57@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <53969836-4a5a-f842-6156-3f88a78bfc4e@gmail.com>
Date: Tue, 13 Sep 2016 15:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <a74b20fd-9640-b543-c31c-d475a51dcc57@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-13 15:20, Cesar Strauss wrote:
> Hello,
>
> I have a BTRFS filesystem that is reverting to read-only after a few
> moments of use. There is a stack trace visible in the kernel log, which
> is attached.
>
> Here is my system information:
>
> # uname -a
>
> Linux rescue 4.7.2-1-ARCH #1 SMP PREEMPT Sat Aug 20 23:02:56 CEST 2016
> x86_64 GNU/Linux
>
> # btrfs --version
>
> btrfs-progs v4.7
It's always good to see people who are staying up-to-date on the kernel 
and userspace :)
>
> # btrfs fi show
>
> Label: 'linux'  uuid: 79862c20-d0b0-4ffa-a9af-e3a40868a243
>         Total devices 1 FS bytes used 284.60GiB
>         devid    1 size 300.03GiB used 300.03GiB path /dev/sdb5
Given this, you're running with the whole device fully allocated by the 
chunk allocator, this is not a good state to be in for any extended 
period of time on a filesystem which is being written to and modified.
>
> # btrfs fi df /mnt
>
> Data, single: total=278.00GiB, used=274.68GiB
> System, DUP: total=8.00MiB, used=64.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=11.00GiB, used=9.92GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
But you appear to have a reasonable amount of slack space within the 
chunks themselves.
>
> As soon as the problem started, I saw that the Metadata, DUP was
> completely used. It become a little better (like above) after a scrub.
> I can easily recover disk space by removing old snapshots, if needed.
>
> The dmesg output is attached.
>
> Before making further recovery attempts, or even restoring from backup,
> I would like to ask for the best option to proceed.
I'd be kind of curious to see the results from btrfs check run without 
repair, but I doubt that will help narrow things down any further.

As of right now, the absolute first thing I'd do is check your logs to 
see if you can find any indication of errors from the disk itself.  I 
don't think it's likely, but it's worth checking.

The couple of lines just before the crash in the attached kernel log 
would indicate to me that some of the metadata is corrupted.  There are 
two likely possibilities for how that happened:
1. Running with no extra space for new chunks to be allocated is not a 
common use case, so it's not well tested, and it wouldn't surprise me if 
some accounting falls apart in that situation.
2. You might have bad RAM or a bad PSU.  This is the second thing you 
should check after checking to see if the disk is OK, as either will 
likely cause any repair attempts to make things worse.  RAM is pretty 
easy to check, but for a PSU you need a proper testing device.  You can 
get such a device on Amazon or similar sites for about 25USD, and it's 
generally worth having around for troubleshooting.

Assuming your disk and RAM are good, the next thing to do would be try 
and get the filesystem into a more usable state.  The best option for 
this is to expand the filesystem if possible.  Given that you're running 
right near capacity, I'd suggest at least 16G of extra space if 
possible.  If that isn't a viable solution for you, the other option is 
to delete some of the oldest snapshots (Ideally enough that you have at 
least a few GB of extra space in the data chunks and a few hundred MB in 
the metadata chunks), then add a 4-8GB device to the FS temporarily (a 
ramdisk or flash drive works well for this), and run a full balance.  If 
you're lucky, this will fix any metadata that's messed up, and the 
system should be usable.  If not, it shouldn't make things any worse, 
and you probably want to look at btrfs restore to copy out the data to a 
new filesystem (ideally a bigger one).
