Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:55978 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753385AbeCVMB6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 08:01:58 -0400
Received: by mail-it0-f45.google.com with SMTP id e195-v6so11012812ita.5
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 05:01:58 -0700 (PDT)
Subject: Re: Status of RAID5/6
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d46c16e9-4967-51de-762b-ae01f2e10e0a@gmail.com>
Date: Thu, 22 Mar 2018 08:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <1521662556.4312.39.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-03-21 16:02, Christoph Anton Mitterer wrote:
On the note of maintenance specifically:
> - Maintenance tools
>    - How to get the status of the RAID? (Querying kernel logs is IMO
>      rather a bad way for this)
>      This includes:
>      - Is the raid degraded or not?
Check for the 'degraded' flag in the mount options.  Assuming you're 
doing things sensibly and not specifying it on mount, it gets added when 
the array goes degraded.

>      - Are scrubs/repairs/rebuilds/reshapes in progress and how far are
>        they? (Reshape would be: if the raid level is changed or the raid
>        grown/shrinked: has all data been replicated enough to be
>        "complete" for the desired raid lvl/number of devices/size?
A bit trickier, but still not hard, just check the the output of `btrfs 
scrub status`, `btrfs balance status`, and `btrfs replace status` for 
the volume.  It won't check automatic spot-repairs (that is, repairing 
individual blocks that fail checksums), but most people really don't care

>     - What should one regularly do? scrubs? balance? How often?
>       Do we get any automatic (but configurable) tools for this?
There aren't any such tools that I know of currently.  storaged might 
have some, but I've never really looked at it so i can't comment (I'm 
kind of adverse to having hundreds of background services running to do 
stuff that can just as easily be done in a polling manner from cron 
without compromising their utility).  Right now though, it's _trivial_ 
to automate things with cron, or systemd timers, or even third-party 
tools like monit (which has the bonus that if the maintenance fails, you 
get an e-mail about it).

>     - There should be support in commonly used tools, e.g. Icinga/Nagios
>       check_raid
Agreed.  I think there might already be a Nagios plugin for the basic 
checks, not sure about anything else though.

Netdata has had basic monitoring support for a while now, but it only 
looks at allocations, not error counters, so while it will help catch 
impending ENOSPC issues, it can't really help much with data corruption 
issues.

>     - Ideally there should also be some desktop notification tool, which
>       tells about raid (and btrfs errors in general) as small
>       installations with raids typically run no Icinga/Nagios but rely
>       on e.g. email or gui notifications.
Desktop notifications would be nice, but are out of scope for the main 
btrfs-progs.  Not even LVM, MDADM, or ZFS ship desktop notification 
support from upstream.  You don't need Icinga or Nagios for monitoring 
either.  Netdata works pretty well for covering the allocation checks 
(and I'm planning to have something soon, and it's trivial to set up 
e-mail notifications with cron or systemd timers or even tools like monit.

On the note of generic monitoring though, I've been working on a Python 
3 script (with no dependencies beyond the Python standard library) to do 
the same checks that Netdata does regarding allocations, as well as 
checking device error counters and mount options that should be 
reasonable as a simple warning tool run from cron or a systemd timer. 
I'm hoping to get it included in the upstream btrfs-progs, but I don't 
have it in a state yet that it's ready to be posted (the checks are 
working, but I'm still having issues reliably mapping between mount 
points and filesystem UUID's).

> I think especially for such tools it's important that these are
> maintained by upstream (and yes I know you guys are rather fs
> developers not)... but since these tools are so vital, having them done
> 3rd party can easily lead to the situation where something changes in
> btrfs, the tools don't notice and errors remain undetected.
It depends on what they look at.  All the stuff under /sys/fs/btrfs 
should never change (new things might get added, but none of the old 
stuff is likely to ever change because /sys is classified as part of the 
userspace ABI, and any changes would get shot down by Linus), so 
anything that just uses those will likely have no issues (Netdata falls 
into this category for example).  Same goes for anything using ioctls 
directly, as those are also userspace ABI.
