Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:36556 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbdCaMl6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 08:41:58 -0400
Received: by mail-qt0-f180.google.com with SMTP id r45so63880772qte.3
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 05:41:57 -0700 (PDT)
Subject: Re: Shrinking a device - performance?
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk>
 <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327194847.5c0c5545@natsu>
 <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
 <22746.30348.324000.636753@tree.ty.sabi.co.uk>
 <43e29da2-1d1b-1680-f262-1c95575645d8@gmail.com>
 <22749.10893.729399.275210@tree.ty.sabi.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d2f4af84-739e-d43c-0978-8bbe74e8a277@gmail.com>
Date: Fri, 31 Mar 2017 08:41:49 -0400
MIME-Version: 1.0
In-Reply-To: <22749.10893.729399.275210@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-30 11:55, Peter Grandi wrote:
>>> My guess is that very complex risky slow operations like that are
>>> provided by "clever" filesystem developers for "marketing" purposes,
>>> to win box-ticking competitions. That applies to those system
>>> developers who do know better; I suspect that even some filesystem
>>> developers are "optimistic" as to what they can actually achieve.
>
>> There are cases where there really is no other sane option. Not
>> everyone has the kind of budget needed for proper HA setups,
>
> Thnaks for letting me know, that must have never occurred to me, just as
> it must have never occurred to me that some people expect extremely
> advanced features that imply big-budget high-IOPS high-reliability
> storage to be fast and reliable on small-budget storage too :-)
You're missing my point (or intentionally ignoring it).  Those types of 
operations are implemented because there are use cases that actually 
need them, not because some developer thought it would be cool.  The one 
possible counter-example of this is XFS, which doesn't support shrinking 
the filesystem at all, but that was a conscious decision because their 
target use case (very large scale data storage) does not need that 
feature and not implementing it allows them to make certain other parts 
of the filesystem faster.
>
>> and if you need maximal uptime and as a result have to reprovision the
>> system online, then you pretty much need a filesystem that supports
>> online shrinking.
>
> That's a bigger topic than we can address here. The topic used to be
> known in one related domain as "Very Large Databases", which were
> defined as databases so large and critical that they the time needed for
> maintenance and backup were too slow for taking them them offline etc.;
> that is a topics that has largely vanished for discussion, I guess
> because most management just don't want to hear it :-).
No, it's mostly vanished because of changes in best current practice. 
That was a topic in an era where the only platform that could handle 
high-availability was VMS, and software wasn't routinely written to 
handle things like load balancing.  As a result, people ran a single 
system which hosted the database, and if that went down, everything went 
down.  By contrast, it's rare these days outside of small companies to 
see singly hosted databases that aren't specific to the local system, 
and once you start parallelizing on the system level, backup and 
maintenance times generally go down.
>
>> Also, it's not really all that slow on most filesystem, BTRFS is just
>> hurt by it's comparatively poor performance, and the COW metadata
>> updates that are needed.
>
> Btrfs in realistic situations has pretty good speed *and* performance,
> and COW actually helps, as it often results in less head repositioning
> than update-in-place. What makes it a bit slower with metadata is having
> 'dup' by default to recover from especially damaging bitflips in
> metadata, but then that does not impact performance, only speed.
I and numerous other people have done benchmarks running single metadata 
and single data profiles on BTRFS, and it consistently performs worse 
than XFS and ext4 even under those circumstances.  It's not horrible 
performance (it's better for example than trying the same workload on 
NTFS on Windows), but it's still not what most people would call 'high' 
performance or speed.
>
>>> That feature set is arguably not appropriate for VM images, but
>>> lots of people know better :-).
>
>> That depends on a lot of factors.  I have no issues personally running
>> small VM images on BTRFS, but I'm also running on decent SSD's
>> (>500MB/s read and write speeds), using sparse files, and keeping on
>> top of managing them. [ ... ]
>
> Having (relatively) big-budget high-IOPS storage for high-IOPS workloads
> helps, that must have never occurred to me either :-).
It's not big budget, the SSD's in question are at best mid-range 
consumer SSD's that cost only marginally more than a decent hard drive, 
and they really don't get all that great performance in terms of IOPS 
because they're all on the same cheap SATA controller.  The point I was 
trying to make (which I should have been clearer about) is that they 
have good bulk throughput, which means that the OS can do much more 
aggressive writeback caching, which in turn means that COW and 
fragmentation have less impact.
>
>>> XFS and 'ext4' are essentially equivalent, except for the fixed-size
>>> inode table limitation of 'ext4' (and XFS reportedly has finer
>>> grained locking). Btrfs is nearly as good as either on most workloads
>>> is single-device mode [ ... ]
>
>> No, if you look at actual data, [ ... ]
>
> Well, I have looked at actual data in many published but often poorly
> made "benchmarks", and to me they seem they seem quite equivalent
> indeed, within somewhat differently shaped performance envelopes, so the
> results depend on the testing point within that envelope. I have been
> done my own simplistic actual data gathering, most recently here:
>
>   http://www.sabi.co.uk/blog/17-one.html?170302#170302
>   http://www.sabi.co.uk/blog/17-one.html?170228#170228
>
> and however simplistic they are fairly informative (and for writes they
> point a finger at a layer below the filesystem type).
In terms of performance, yes they are roughly equivalent.  Performance 
isn't all that matters though, and once you get that point, ext4 and XFS 
are significantly different in what they offer.
>
> [ ... ]
>
>>> "Flexibility" in filesystems, especially on rotating disk
>>> storage with extremely anisotropic performance envelopes, is
>>> very expensive, but of course lots of people know better :-).
>
>> Time is not free,
>
> Your time seems especially and uniquely precious as you "waste"
> as little as possible editing your replies into readability.
>
>> and humans generally prefer to minimize the amount of time they have
>> to work on things. This is why ZFS is so popular, it handles most
>> errors correctly by itself and usually requires very little human
>> intervention for maintenance.
>
> That seems to me a pretty illusion, as it does not contain any magical
> AI, just pretty ordinary and limited error correction for trivial cases.
On average, trivial cases account for most errors in any computer.  So, 
by definition, to handle most errors correctly, you can get by with just 
handling all 'trivial' cases correctly.  By handling all trivial cases 
correctly, ZFS is doing far better than any other current filesystem or 
storage stack can even begin to claim.  It's been doing this since 
before most modern Linux distributions made their first release too, so 
compared to just about anything else people are using these days, it's 
got a pretty solid track record.  Anyone trying to claim it's the best 
option in any case is obviously either a zealot or being paid, but for 
many cases, it really is one of the top options.
>
>> 'Flexibility' in a filesystem costs some time on a regular basis, but
>> can save a huge amount of time in the long run.
>
> Like everything else. The difficulty is having flexibility at scale with
> challenging workloads. "An engineer can do  for a nickel what  any damn
> fool can do for a dollar" :-).
>
>> To look at it another way, I have a home server system running BTRFS
>> on top of LVM. [ ... ]
>
> But usually home servers have "unchallenging" workloads, and it is
> relatively easy to overbudget their storage, because the total absolute
> cost is "affordable".
OK, so running
    * Almost a dozen statically allocated VM's with a variety of 
differing workloads including web-servers, a local mail server, DHCP and 
DNS for the network, a VPN server, and 3 different file sharing 
protocols (which see rather regular use) among other things
   * On average between 4 and 10 transient VM's running regression 
testing on kernel patches (including automation of almost everything but 
selecting patches)
   * A BOINC client
   * GlusterFS (both client and storage node)
   * Network security monitoring (Nagios plus a handful of custom scripts)
   * Cloud storage software
All on the same system is an 'unchallenging' workload.  Given the fact 
that it's only got 32G of RAM and a cheap quad-core Xeon, that's a 
pretty damn challenging workload by most people standards.  I call it a 
home server because I run it out of my house, not because it's some 
trivial dinky little file server that could run just fine on something 
like a Raspberry Pi.
