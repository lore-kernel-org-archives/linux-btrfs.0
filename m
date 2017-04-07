Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34329 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933437AbdDGLl0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 07:41:26 -0400
Received: by mail-it0-f65.google.com with SMTP id 193so3756485itm.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Apr 2017 04:41:26 -0700 (PDT)
Subject: Re: Volume appears full but TB's of space available
To: John Petrini <jpetrini@coredial.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
 <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
 <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com>
Date: Fri, 7 Apr 2017 07:41:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-06 23:25, John Petrini wrote:
> Interesting. That's the first time I'm hearing this. If that's the
> case I feel like it's a stretch to call it RAID10 at all. It sounds a
> lot more like basic replication similar to Ceph only Ceph understands
> failure domains and therefore can be configured to handle device
> failure (albeit at a higher level)
Yeah, the stacking is a bit odd, and there are some rather annoying 
caveats that make most of the names other than raid5/raid6 misleading. 
In fact, raid1 mode in BTRFS is more like what most people think of as 
RAID10 when run on more than 2 disks than BTRFS raid10 mode is, although 
it stripes at a much higher level.
>
> I do of course keep backups but I chose RAID10 for the mix of
> performance and reliability. It doesn't seems worth it losing 50% of
> my usable space for the performance gain alone.
>
> Thank you for letting me know about this. Knowing that I think I may
> have to reconsider my choice here. I've really been enjoying the
> flexibility of BTRS which is why I switched to it in the first place
> but with experimental RAID5/6 and what you've just told me I'm
> beginning to doubt that it's the right choice.
There are some other options in how you configure it.  Most of the more 
useful operational modes actually require stacking BTRFS on top of LVM 
or MD.  I'm rather fond of running BTRFS raid1 on top of LVM RAID0 
volumes, which while it provides no better data safety than BTRFS raid10 
mode, gets noticeably better performance.  You can also reverse that to 
get something more like traditional RAID10, but you lose the 
self-correcting aspect of BTRFS.
>
> What's more concerning is that I haven't found a good way to monitor
> BTRFS. I might be able to accept that the array can only handle a
> single drive failure if I was confident that I could detect it but so
> far I haven't found a good solution for this.
This I can actually give some advice on.  There are a couple of options, 
but the easiest is to find a piece of generic monitoring software that 
can check the return code of external programs, and then write some 
simple scripts to perform the checks on BTRFS.  The things you want to 
keep an eye on are:

1. Output of 'btrfs dev stats'.  If you've got a new enough copy of 
btrfs-progs, you can pass '--check' and the return code will be non-zero 
if any of the error counters isn't zero.  If you've got to use an older 
version, you'll instead have to write a script to parse the output (I 
will comment that this is much easier in a language like Perl or Python 
than it is in bash).  You want to watch for steady increases in error 
counts or sudden large jumps.  Single intermittent errors are worth 
tracking, but they tend to happen more frequently the larger the array is.

2. Results from 'btrfs scrub'.  This is somewhat tricky because scrub is 
either asynchronous or blocks for a _long_ time.  The simplest option 
I've found is to fire off an asynchronous scrub to run during down-time, 
and then schedule recurring checks with 'btrfs scrub status'.  On the 
plus side, 'btrfs scrub status' already returns non-zero if the scrub 
found errors.

3. Watch the filesystem flags.  Some monitoring software can easily do 
this for you (Monit for example can watch for changes in the flags). 
The general idea here is that BTRFS will go read-only if it hits certain 
serious errors, so you can watch for that transition and send a 
notification when it happens.  This is also worth watching since the 
filesystem flags should not change during normal operation of any 
filesystem.

4. Watch SMART status on the drives and run regular self-tests.  Most of 
the time, issues will show up here before they show up in the FS, so by 
watching this, you may have an opportunity to replace devices before the 
filesystem ends up completely broken.

5. If you're feeling really ambitious, watch the kernel logs for errors 
from BTRFS and whatever storage drivers you use.  This is the least 
reliable thing out of this list to automate,  so I'd not suggest just 
doing this by itself.

The first two items are BTRFS specific.  The rest however, are standard 
things you should be monitoring regardless of what type of storage stack 
you have.  Of these, item 3 will immediately trigger in the event of a 
catastrophic device failure, while 1, 2, and 5 will provide better 
coverage of slow failures, and 4 will cover both aspects.

As far as what to use to actually track these, that really depends on 
your use case.  For tracking on an individual system basis, I'd suggest 
Monit, it's efficient, easy to configure, provides some degree of error 
resilience, and can actually cover a lot of monitoring tasks beyond 
stuff like this.  If you want some kind of centralized monitoring, I'd 
probably go with Nagios, but that's more because that's the standard for 
that type of thing, not because I've used it myself (I much prefer 
per-system decentralized monitoring, with only the checks that systems 
are online centralized).
