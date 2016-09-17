Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:36288 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753066AbcIQCs6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 22:48:58 -0400
Received: by mail-vk0-f66.google.com with SMTP id 16so2126023vko.3
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Sep 2016 19:48:58 -0700 (PDT)
MIME-Version: 1.0
From: GWB <gwb@2realms.com>
Date: Fri, 16 Sep 2016 21:48:17 -0500
Message-ID: <CAP8EXU25MR8iy41bOr1rPBZehXqb=3-FUnZqCZNA+J=ZMSAfTw@mail.gmail.com>
Subject: Re: df -i shows 0 inodes 0 used 0 free on 4.4.0-36-generic Ubuntu 14
 - Bug or not?
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good to know, and thank you for the quick reply.  That helps.  I'm
running btrfs on root and one of the vm partitions, and zfs on the
user folders and other vm partitions, largely because Ubuntu (and
gentoo, redhat, etc.) has btrfs in the kernel, it's very well
integrated with the kernel, and it's uses less memory than zfs.  /vm0
is pretty much full; after scrub and balance I get this:

$ sudo btrfs fi df /vm0
...
Data, single: total=354.64GiB, used=349.50GiB
System, single: total=32.00MiB, used=80.00KiB
Metadata, single: total=1.00GiB, used=413.69MiB
unknown, single: total=144.00MiB, used=0.00

Scrub and balance seems to do the trick for / as well, after deleting
snapshots.  When we get to the newer userland tools, I'll try the
version with later userspace tools you suggested.  btrfs works great
on Ubuntu 14 on root running on an mSata drive with apt-btrfs-snapshot
installed.  Nothing wrong with ext4, but coming from Solaris and
FreeBSD I wanted a fs that I could snapshot and roll back in case an
upgrade did not work.

The Stallman quote is great.  Oracle taught me that lesson the hard
way when it "branched" zfs after version 28 into new revisions that
were incompatible with the OpenSolaris (and zfs linux) revisions going
forward.  "zpool upgrade" on Solaris 11 makes the pool incompatible
with OpenSolaris and zfs-on-linux distros.

Gordon

On Thu, Sep 15, 2016 at 10:26 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> GWB posted on Thu, 15 Sep 2016 18:58:24 -0500 as excerpted:
>
>> I don't expect accurate data on a btrfs file system when using df, but
>> after upgrading to kernel 4.4.0 I get the following:
>>
>> $ df -i ...
>> /dev/sdc3               0       0          0     - /home
>> /dev/sdc4               0       0          0     - /vm0 ...
>>
>> Where /dev/sdc3 and /dev/sdc4 are btrfs filesystems.
>>
>> So is this a bug or not?
>
> Not a bug.
>
> Btrfs uses inodes, but unlike ext*, it creates them dynamically as-
> needed, so showing inodes used vs. free simply makes no sense in btrfs
> context.
>
> Now btrfs /does/ track data and metadata separately, creating chunks of
> each type, and it /is/ possible to have all otherwise free space already
> allocated to chunks of one type or the other and then run out of space in
> the one type of chunk while there's plenty of space in the other type of
> chunk, but that's quite a different concept, and btrfs fi usage (tho your
> v3.14 btrfs-progs will be too old for usage) or btrfs fi df coupled with
> btrfs fi show (the old way to get the same info), gives the information
> for that.
>
> And in fact, the btrfs fi show for vm0 says 374.66 GiB size and used, so
> indeed, all space on that one is allocated.  Unfortunately you don't post
> the btrfs fi df for that one, so we can't tell where all that allocated
> space is going and whether it's actually used, but it's all allocated.
> You probably want to run a balance to get back some unallocated space.
>
> Meanwhile, your kernel is 4.4.x LTS series so not bad there, but your
> userspace is extremely old, 3.12, making support a bit hard as some of
> the commands have changed (btrfs fi usage, for one, and I think the
> checker was still btrfsck in 3.12, while in current btrfs-progs, it's
> btrfs check).  I'd suggest updating that to at least something around the
> 4.4 level to match the kernel, tho you can upgrade to the latest 4.7.2
> (don't try 4.6 or 4.7 previous to 4.7.2, or don't btrfs check --repair if
> you do, as there's a bug with it in those versions that's fixed in 4.7.2)
> if you like, as newer userspace is designed to work with older kernels as
> well.
>
> Besides which, while old btrfs userspace isn't a big deal (other than
> translating back and forth between old style and new style commands) when
> your filesystems are running pretty much correctly, as in that case all
> userspace is doing in most cases is calling the kernel to do the real
> work anyway, it becomes a much bigger deal when something goes wrong,
> because it's userspace code that's executing with btrfs check or btrfs
> restore, and newer userspace knows about and can fix a LOT more problems
> than the really ancient 3.12.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
