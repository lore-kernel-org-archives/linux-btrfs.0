Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:48893 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdLSV6v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 16:58:51 -0500
Date: Tue, 19 Dec 2017 22:58:49 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
Message-ID: <20171219215849.GD14726@polanet.pl>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl>
 <4b132c07-62c7-e313-d454-b7414c737602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <4b132c07-62c7-e313-d454-b7414c737602@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 15:11:22 -0500, Austin S. Hemmelgarn wrote:

> Except the systems running on those ancient kernel versions are not 
> necessarily using a recent version of btrfs-progs.

Still much easier to update a userspace tools than kernel (consider
binary drivers for various hardware).

> So in other words, spend the time to write up code for btrfs-progs that 
> will then be run by a significant minority of users because people using 
> old kernels usually use old userspace, and people using new kernels 
> won't have to care, instead of working on other bugs that are still 
> affecting people?

I am aware of the dillema and the answer is: that depends.
Depends on expected usefulness of such infrastructure regarding _future_
changes and possible bugs.
In case of stable/mature/frozen projects this doesn't make much sense,
as the possible incompatibilities would be very rare.
Wheter this makes sense for btrfs? I don't know - it's not mature, but if the quirk rate
would be too high to track appropriate kernel versions it might be
really better to officially state "DO USE 4.14+ kernel, REALLY".

This might be accomplished very easy - when releasing new btrfs-progs
check currently available LTS kernel and use it as a base reference for
warning.

After all, "giving users a hurt me button is not ethical programming."

>> Now, if the current kernels won't toggle degraded RAID1 as ro, can I
>> safely add "degraded" to the mount options? My primary concern is the
>> machine UPTIME. I care less about the data, as they are backed up to
>> some remote location and loosing day or week of changes is acceptable,
>> brain-split as well, while every hour of downtime costs me a real money.
> In which case you shouldn't be relying on _ANY_ kind of RAID by itself, 
> let alone BTRFS.  If you care that much about uptime, you should be 
> investing in a HA setup and going from there.  If downtime costs you 

I got this handled and don't use btrfs there - the question remains:
in a situation as described above, is it safe now to add "degraded"?

To rephrase the question: can degraded RAID1 run permanently as rw
without some *internal* damage?

>> Anyway, users shouldn't look through syslog, device status should be
>> reported by some monitoring tool.
> This is a common complaint, and based on developer response, I think the 
> consensus is that it's out of scope for the time being.  There have been 
> some people starting work on such things, but nobody really got anywhere 
> because most of the users who care enough about monitoring to be 
> interested are already using some external monitoring tool that it's 
> easy to hook into.

I agree, the btrfs code should only emit events, so
SomeUserspaceGUIWhatever could display blinking exclamation mark.

>> Well, the question is: either it is not raid YET, or maybe it's time to consider renaming?
> Again, the naming is too ingrained.  At a minimum, you will have to keep 
> the old naming, and at that point you're just wasting time and making 
> things _more_ confusing because some documentation will use the old 

True, but realizing that documentation is already flawed it gets easier.
But I still don't know if it is going to be RAID some day? Or won't be
"by design"?

>> Ha! I got this disabled on every bus (although for different reasons)
>> after boot completes. Lucky me:)
> Security I'm guessing (my laptop behaves like that for USB devices for 
> that exact reason)?  It's a viable option on systems that are tightly 

Yes, machines are locked and only authorized devices are allowed during
boot.

> IOW, if I lose a disk in a two device BTRFS volume set up for 
> replication, I'll mount it degraded, and convert it from the raid1 
> profile to the single profile and then remove the missing disk from the 
> volume.

I was about to do the same with my r/o-stuck btrfs system, unfortunatelly
unplugged the wrong cable...

>> Writing accurate documentation requires deep undestanding of internals.
[...]
> Writing up something like that is near useless, it would only be valid 
> for upstream kernels (And if you're using upstream kernels and following 
> the advice of keeping up to date, what does it matter anyway?  The 
[...]
> kernel that fixes the issues it reports.), because distros do whatever 
> the hell they want with version numbers (RHEL for example is notorious 
> for using _ancient_ version numbers bug having bunches of stuff 
> back-ported, and most other big distros that aren't Arch, Gentoo, or 
> Slackware derived do so too to a lesser degree), and it would require 
> constant curation to keep up to date.  Only for long-term known issues 

OK, you've convinced me that kernel-vs-feature list is overhead.

So maybe other approach: just like systemd sets the system time (when no
time source available) to it's own release date, maybe btrfs-progs
should take the version of the kernel on which it was build?

-- 
Tomasz Pala <gotar@pld-linux.org>
