Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37593 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdAPI3r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jan 2017 03:29:47 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cT2fS-0004K0-P6
        for linux-btrfs@vger.kernel.org; Mon, 16 Jan 2017 09:29:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [ISSUE] uncorrectable errors on Raid1
Date: Mon, 16 Jan 2017 08:28:57 +0000 (UTC)
Message-ID: <pan$e40ff$b4ae6eee$a2e29a1a$fc4e4760@cox.net>
References: <13125824.3612316.1484511403145.JavaMail.zimbra@laposte.net>
        <997304564.3648227.1484512081332.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

randomtechguy@laposte.net posted on Sun, 15 Jan 2017 21:28:01 +0100 as
excerpted:

> Hello /all,
> 
> I have some concerns about the raid 1 of BTRFS. I have encountered 114
> uncorrectable errors on the directory hosting my 'seafile-data'. Seafile
> is a software to backup the data. My 2 hard drives seems to be fined.
> SMARTCTL reports do not identify any badlocks (Reallocated_Event_Count
> or Current_Pending_Sector).
> How can I have uncorrectable errors since BTRFS is assuring data
> integrity ? How did my data got corrupted ? What can I do to ensure that
> it does not happen again ?

It's worth noting that btrfs data integrity is based on checksums over 
data and metadata blocks, and that btrfs raid1 makes exactly two copies 
of each chunk and block within a chunk.  If both copies of a block fail 
to match checksum, btrfs (either in normal operation or via scrub) can't 
fall back to the second copy as it's also bad.

Unfortunately, that seems to have happened to you.  How, I can't say.

And here comes the disclaimer.  I'm a normal if somewhat advanced btrfs 
user (I run gentoo and routinely build from sources, applying patches as 
necessary, doing git bisects, etc.) and list regular, not a dev.  So 
there's a limit to what I can cover, but I can address some of the easier 
stuff where it has been covered on the list previously, and by doing so, 
free the more advanced list regulars and devs for the more complex 
answers and for further development, etc.

There's a roadmapped proposal to offer N-way-mirroring, instead of just 
the two-way currently available, which would of course allow N fallbacks 
in case the first two are bad, and I've been intensely interested in 3-
way for my own use, but that has been scheduled for attention right after 
parity-raid (raid5/6 mode) for well over a full major kernel cycle now, 
since at least 3.6 (when I first started seriously looking into btrfs), 
when raid56 was supposed to be introduced in a (minor) kernel cycle or 
two.  Unfortunately, it was 3.19 before raid56 code was nominally 
complete, and just in the last couple kernel cycles (4.8/4.9) it became 
clear that the existing raid56 code is still majorly flawed, to the point 
a full or near full rewrite may be necessary, so now we're looking at 
another year or two likely for it to stabilize properly, meaning it could 
easily be 5.x (assuming 4.19 is the last 4.x, as was 3.19 for 3.x) before 
raid56 stabilization, and then easily 5.10 before N-way-mirroring is 
first available and maybe 6.x before stabilization, even if N-way-
mirroring doesn't end up with any of the long development time and then 
long term stability problems that hit raid56 mode.  So very possibly five 
years out... and in kernel terms five years is a very long time, the 
practical horizon for any sort of predicting at all, so who knows, 
really, but what we do know is it's unlikely in anything like the near 
future.

> You can find below all the useful information I can think of. If you
> need more, let me know.

> If I attempt to read the corresponding file, I have an " Input/output
> error ".

That's normal when both mirrors fail checksum verification.  You can try 
btrfs restore on the unmounted filesystem, telling it (using the regex 
option) to restore only that file or files and where to put them, but 
they may well be corrupt even if you can retrieve them that way.  With 
more work, you could depend on btrfs' copy-on-write nature and the fact 
that previous root generations are likely available, to find and feed to 
btrfs restore older roots and hope that it can find and restore an 
uncorrupted copy that way, but honestly, you better have some pretty 
advanced technical chops to even think about that -- I'm not sure I could 
do it here, tho I'd certainly try if I didn't have a backup to resort to.

Which of course brings up backups.  As any sysadmin worth the name will 
tell you, what you /really/ think about the value of your data is defined 
by the number of backups you have of it, and the faithfulness with which 
you update those backups.  No backups means you value the time and 
resources saved by /not/ doing those backups more than the data that you 
are risking losing as a result of not having those backups.  A single 
backup of course means much lower risk, but the same thing applies there 
-- only one backup means you value the time and resources saved by not 
making a second more than the risk of actually needing that second backup 
because both the working copy and the first backup failed at the same 
time, for whatever reason.

Of course that's for normal, fully stable, hardware and filesystems.  
Btrfs, while no longer (since 3.12, IIRC) labeled "eat your data" 
experimental, remains under heavy development and not yet entirely stable 
and mature.  As such, the additional risk to any data stored on the not 
yet fully stable and mature btrfs must be taken into account when 
assigning relative value to backups or the lack thereof, tilting the 
balance toward more backups than one would consider worth the trouble on 
a more stable and mature filesystem.

Thus it can be safely and confidently stated that you either have 
backups, or by your (in)actions in not having them, placed a lower value 
on the data than on your time and resources that would be used in backing 
it up.  So a problem with btrfs that results in loss of some or all of 
the data on it isn't a big problem, because you can either resort to your 
backups if you have to, or the data was of only trivial value as defined 
by the lack of backups in any case, as even if you lose it, you saved 
what you considered of more value, the time and trouble that would have 
otherwise gone into making those backups.

Since it's just a few files here, not the entire filesystem, it's even 
less of a problem.  Just restore from backups if you have them.  Or try 
btrfs restore on them, and if they're corrupted from that or it doesn't 
work at all, no big deal since the files were obviously not worth a lot 
anyway as they weren't backed up, and you can just delete the problem 
files and move on, or worse comes to worse, blow away the filesystem with 
a fresh mkfs, and move on.

Meanwhile...

> Here is my Raid1 configuration: [snippage]

> sudo btrfs fi df /mnt
> Data, RAID1: total=299.00GiB, used=298.15GiB
> Data, single: total=8.00MiB, used=0.00B
> System, RAID1: total=8.00MiB, used=64.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=2.00GiB, used=887.55MiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=304.00MiB, used=0.00B

It's worth noting that those data, system and metadata single-mode chunks 
are an artifact from an older mkfs.btrfs, and can be eliminated using for 
example btrfs balance start -dusage=0 -musage=0 or btrfs balance start 
-profiles=single.  (GlobalReserve is different and always single, despite 
it actually coming from metadata, the reason metadata as reported never 
gets entirely full.)


> btrfs --version btrfs-progs v3.19.1
> 
> 
> sudo smartctl -a /dev/sde
> smartctl 6.2 2013-07-26 r3841
> [x86_64-linux-3.10.0-327.28.3.el7.x86_64] (local build)

If that's your current kernel, an upgrade to at minimum the LTS kernel 
4.1 series is *VERY* strongly recommended.  As mentioned above, btrfs 
prior to kernel 3.12 still had the "experimental" label, and is well out 
of the practical support range for this list.  All sorts of btrfs bugs 
have been found and fixed since 3.10, and it could in fact be one of 
them, likely in combination with something else like a system crash or 
hard shutdown without proper unmounting, or simply some strange corner-
case that wasn't dealt with properly back then, that triggered your 
uncorrectable errors.

Here on this list, which does focus on the mainstream kernel and forward 
development, the recommended kernels are the last two kernels in one of 
two tracks, current stable release or the mainstream LTS kernel series.  
For current stable, 4.10 is in development so 4.9 and 4.8 are supported, 
tho 4.8 is now EOL on kernel.org, so people should be moving to 4.9 by 
now unless they have specific reason not to.  For LTS, the 4.4 series is 
the latest, with 4.1 previous to that, so 4.4 and 4.1 are supported.  
Previous to 4.1, while we do try, enough development has happened since 
then that practical support quality is likely to be quite reduced, with a 
very early suggestion being an upgrade to something newer.

Of course we realize that various distros have chosen to support btrfs on 
their older kernels, backporting various patches as they consider 
appropriate.  However, we don't track what they've backported and what 
they haven't, and thus aren't in a particularly good position to offer 
support.  The distros choosing to do that backporting and support should 
be far better resources in that case, as they actually know what they've 
backported and what they haven't.

Tho if I'm not mistaken and based on what I've read, RHEL offered 
experimental support for btrfs back then, but never full support, and 
even that experimental support is long ended, so you may be on your own 
there in any case.  But that's second hand.  Maybe they still offer it?

But if you're choosing to use that ancient a long-term-supported 
enterprise distro and kernel, presumably you value stability very highly, 
which would seem at its root to be incompatible with btrfs' status as 
still in development and stabilizing, not yet fully stable and mature.  
So a reevaluation is likely in order, as depending on your needs and 
priorities, your use of either RHEL 7 and its old kernel for stability 
reasons, or your use of the still under heavy development and not yet 
fully stable btrfs, would appear to be inappropriate for your 
circumstances and priorities and may well need changed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

