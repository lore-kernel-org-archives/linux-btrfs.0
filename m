Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:33792 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbcHJStR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 14:49:17 -0400
Received: by mail-io0-f172.google.com with SMTP id q83so50129371iod.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Aug 2016 11:48:23 -0700 (PDT)
Subject: Re: system locked up with btrfs-transaction consuming 100% CPU
To: Dave T <davestechshop@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAGdWbB5aRffesaje-VSEOOH=O-rCWTqupLEu=BLdXurRU7dmtw@mail.gmail.com>
 <pan$40039$460e87d$113bf211$8f82b7dd@cox.net>
 <CAGdWbB5CQoCPUR05=e48UdkXCB40EYKOfq+7tHw+XoEnSsA-FQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e4d6d0c1-985b-e342-d55a-4de297b5835e@gmail.com>
Date: Wed, 10 Aug 2016 07:39:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAGdWbB5CQoCPUR05=e48UdkXCB40EYKOfq+7tHw+XoEnSsA-FQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-09 18:20, Dave T wrote:
> Thank you for the info, Duncan.
>
> I will use Alt-sysrq-s alt-sysrq-u alt-sysrq-b. This is the best
> description / recommendation I've read on the subject. I had read
> about these special key sequences before but I could never remember
> them and I didn't fully understand what they did. Now you have given
> me the understanding as well as an easy-to-remember method. I'll use
> it.
The other two which you may find potentially useful are alt-sysrq-o, 
which shuts down the system (it's like 'b' too though, so you should 
still sync and remount before using it), and alt-sysrq-c,  which will 
immediately trigger a kernel panic (and thus force a crash dump if you 
have them set up).

As for the other three:
'r' will force the keyboard back to raw mode, this is only generally 
needed if you've been using a old version of X or something like svgalib 
or directfb and it crashed and you can't get the keyboard to work on the 
terminal again.  I normally don't use this simply because it isn't 
needed if your running in text mode or have a new enough version of X.
'e' and 'i' respectively send SIGTERM and SIGKILL to all userspace 
processes except init.  These are generally recommended because most 
things will clean up properly if you send them SIGTERM, and the few 
stragglers that don't catch that (or get stuck during their cleanup) 
will get killed by SIGKILL regardless, and if there are still processes 
writing to a filesystem, syncing may not flush everything out to disk.

It's also worth pointing out that many RPM based distributions (at least 
RHEL, CentOS, and Fedora, and I think SLES and openSUSE as well) disable 
some or all of the SYsRq combinations (they technically are a security 
issue, but if someone has console access to your system, you probably 
have much bigger issues than sysrq to deal with).
>
> I launch KDE the same way you do (no DM). I also run a tiple monitor
> setup, but I am using an nvidia GTX 1070 (and proprietary drivers),
> for the time being.
This is potentially going to sound like an odd suggestion, but have you 
tried running with the proprietary drivers blacklisted?  NVIDIA's 
drivers are generally good citizens, but with any proprietary driver 
involved, there's considerably less certainty that everything else in 
the kernel is working like it should.  I don't personally have much 
experience with the NVIDIA proprietary drivers (I have a system with a 
Quadro K620, but it actually gets better overall performance when I use 
the in-kernel open source drivers or even when I just use it as a 
framebuffer and push the rendering to the CPU than it does with the 
official NVIDIA drivers, so I just don't use them), but I have had 
issues similar to what you are seeing with other kernel subsystems when 
using the proprietary AMD drivers on other systems.
>
> My system does not have any issues when the monitors go to sleep. That
> happens many times a day as I have a short timeout set.
>
> I am very concerned about this primary problem (or problems) and I
> hope I can find some understanding of what is going on. BTRFS has
> worked well for me since 2012. While that's fantastic, it also means I
> haven't had to troubleshoot it in the past. Now (because of 4 years of
> problem-free operation) I'm using it on a critical production system.
> I have backups, but I cannot allow these problems to go unresolved.
>
> On Tue, Aug 9, 2016 at 5:32 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Dave T posted on Tue, 09 Aug 2016 14:07:46 -0400 as excerpted:
>>
>>> I hard reset my system, expecting the worst, but it rebooted normally.
>>> journalctl -xb -p3 showed no entries.
>>
>> I don't have any suggestions for your primary problem, tho I do have a
>> comment down below, but I do have a suggestion regarding your "hard
>> reset".
>>
>> Consider doing some reading on "magic sysrequest", aka sysrq aka srq.
>>
>> $KERNDIR/Documentation/sysrq.txt , and there's lots of googlable articles
>> about it as well.
>>
>> Basically, when you'd otherwise do a hard reset, try a series of triple-
>> key chords, alt-sysrq-<otherkey> first.  (Sysrq is printscreen, if alt
>> isn't pressed with it, so alt-sysrq-thirdkey.)
>>
>> The longer form of the emergency sequence is reisub -- you can read what
>> the r-e-i keys due in the documentation -- but from my own experience, I
>> find when the system's in bad enough shape I need to do an emergency
>> reboot, these keys don't do much for me, while the last three, sub, often
>> (but not always) do, and they're much easier to remember, so...
>>
>> Alt-sysrq-s alt-sysrq-u alt-sysrq-b
>>
>> s=Sync.  If the kernel is still alive and believes it's still stable
>> enough to write to permanent storage without risking writing somewhere it
>> shouldn't, this will force all write-cached "dirty" data to be written
>> out.
>>
>> You can safely do an alt-srq-s at any time, and continue working, as it
>> forces cached writes to be written out, but doesn't otherwise interfere
>> with the running system.  As such, alt-srq-s is a useful sequence to use
>> right before you do anything you suspect /might/ crash the system, like
>> starting X with a new graphics driver.
>>
>> u=remoUnt-read-only.  Again, if the kernel is alive and stable, this will
>> remount all filesystems read-only, allowing them to safely clean up in
>> the process.  The action carries down to sub-filesystem layers like
>> dmcrypt as well.
>>
>> Note that this is an emergency remount-read-only, so it's a bit more
>> forceful regarding open files that would block an ordinary remount-
>> readonly.  As such, consider the system unusable after doing an alt-srq-
>> u, and shutdown or reboot immediately.
>>
>> b=reBoot.  This forces the kernel to do an immediate reboot, without
>> syncing or remounting, etc.  Thus the s-u- first, to sync and remount.
>>
>>
>> Besides being a bit safer than a hard reset, since when it works it
>> allows the system to sync and cleanup the filesystems before the reboot,
>> this also serves as a crude but effective method of finding out just how
>> severely the system was locked up.  If the sync and remount steps light
>> up your storage I/O activity LED, you know the kernel considered itself
>> in pretty good shape, even if userspace was lost and there was no display
>> at all.  If there's no response to them but the reboot step works, you
>> know the kernel was still alive enough to respond, but either there
>> wasn't anything dirty to write out, or more likely, the kernel believed
>> itself to be corrupted, and thus didn't trust its ability to write to
>> permanent storage without risking scribbling on other parts of the device
>> (other files, perhaps even other partitions).  And of course if none of
>> them work and you /do/ have to do a hard reboot, then you know the kernel
>> itself was dead, at least to the point it could no longer respond at all
>> to magic srq.
>>
>>
>> As to the comment... I'm running plasma/kde5 on gentoo, here, but I'm
>> running upstream-kde's live-git version, available via the gentoo/kde
>> overlay.  Some weeks ago, for a period, something wasn't working, and
>> every time I left the system alone long enough to lock the screen and
>> power-down the monitors, when I came back the system would be crashed.
>> With a bit of experimentation, I discovered that it would stay running as
>> long as I didn't let the monitors power off automatically (I could power
>> them down manually, tho), so for awhile, I was running xset -dpmi after
>> every X/plasma restart (I start X/plasma using startx from a text login
>> and don't use a *DM), to keep plasma from powering down the graphics
>> adapter, tho it could and did still run the screenlocker.
>>
>> Since then, they fixed whatever it was and I can let the power-downs
>> happen normally.  I don't believe the bug made it to a release, tho
>> because I'm following live-git I'm not tracking the releases closely and
>> could be mistaken.
>>
>> You mentioned arch, which IIRC is pretty close to upstream's release
>> cycle, so it's just possible that if this /did/ hit a release, and you're
>> running a new enough kde/plasma, the problem you're seeing may be related
>> to what I was experiencing.  Tho I doubt it since as I said it was only a
>> short period, and I don't think the defective code made it into a release.
>>
>> FWIW, tho, I'm running Radeon Turks graphics (hd6670, IIRC) with triple
>> monitor and the native freedomware kernel/mesa/xorg driver, not frglx or
>> whatever the proprietary thing is called.  If you're running Radeon, with
>> the freedomware driver, especially if also running multi-monitor and the
>> absolute latest plasma, you might try either downgrading a version to see
>> if the problem goes away, or doing the xset -dpmi thing I was doing,
>> temporarily.  It's just possible it'll help since your problem seems
>> similarly to be triggering when you're away from the machine, but your
>> problem does seem a bit different than mine (mine was a consistent
>> crash), and I don't believe mine made release code anyway, so it's likely
>> the similarity is just coincidence.

