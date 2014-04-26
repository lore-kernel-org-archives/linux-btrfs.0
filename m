Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44776 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaDZBLu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 21:11:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wdr9g-00033f-7D
	for linux-btrfs@vger.kernel.org; Sat, 26 Apr 2014 03:11:48 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 03:11:48 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 03:11:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: safe/necessary to balance system chunks?
Date: Sat, 26 Apr 2014 01:11:36 +0000 (UTC)
Message-ID: <pan$58e5d$81cb95bd$fd0b992c$fbbc660c@cox.net>
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung>
	<75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com>
	<535AA581.1080301@gmail.com> <535AACC0.2000600@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steve Leung posted on Fri, 25 Apr 2014 12:43:12 -0600 as excerpted:

> On 04/25/2014 12:12 PM, Austin S Hemmelgarn wrote:
> 
>> Personally, I would recommend making a full backup of all the data (tar
>> works wonderfully for this), and recreate the entire filesystem from
>> scratch, but passing all three devices to mkfs.btrfs.  This should
>> result in all the chunks being RAID1, and will also allow you to
>> benefit from newer features.
> 
> I do have backups of the really important stuff from this filesystem,
> but they're offsite.  As this is just for a home system, I don't have
> enough temporary space for a full backup handy (which is related to how
> I ended up in this situation in the first place).
> 
> Once everything gets rebalanced though, I don't think I'd be missing out
> on any features, would I?

As ASH says, nothing critical.

But there are some relatively minor newer features available, and I 
actually re-mkfs.btrfs most of my (several) btrfs every few kernel cycles 
to take advantage of them, since btrfs is still under development and 
these minor features do accumulate over time.  The on-device format is 
now guaranteed to be readable by newer kernels, but that doesn't mean a 
newer kernel couldn't take advantage of minor features available to it in 
a newer filesystem, if the filesystem was new enough to make them 
available.

Of course the other reason is that doing a mkfs guarantees (especially 
with ssds, where it by default does a trim/discard on the entire space 
it's mkfsing, guaranteeing a zero-out that you'd otherwise have to do 
manually for that level of zero-out guarantee) that I've eliminated any 
cruft from now-fixed bugs that otherwise might come back to haunt me at 
some point.  

The other consideration is the range of kernels you plan on mounting/
accessing the filesystem with.  If you're planning on accessing the 
filesystem with an old kernel, mkfs.btrfs does have an option to toggle 
these newer features (with one, extref, allowing more per-directory hard-
links, defaulting on, others generally defaulting off), and keeping them 
off to work with older kernels is possible, but then of course eliminates 
the newer features as a reason for doing the mkfs in the first place.

My local policy being upto four kernel stability levels, current/testing 
development-kernel, last tested working kernel as first level fallback, 
latest stable series as second level fallback, and some reasonably recent 
but occasionally 2-3 stable series stable kernel before that (depending 
on when I last updated my backup /boot) as backup-boot stable fallback, 
even the latter is reasonably new, and given that I tend to wait a couple 
kernel cycles to work out the bugs before activating a new minor-feature 
here anyway, I don't generally worry much about old kernels when 
activating such features.

So what are these minor features?  Using mkfs.btrfs -O list-all (as 
suggested in the mkfs.btrfs manpage, for btrfs-progs v3.14 (slightly 
reformatted to avoid wrap when posting):

$ mkfs.btrfs -O list-all
Filesystem features available at mkfs time:
mixed-bg        - mixed data and metadata block groups (0x4)
extref          - increased hardlink limit per file to 65536 (0x40, def)
raid56          - raid56 extended format (0x80)
skinny-metadata - reduced-size metadata extent refs (0x100)
no-holes        - no explicit hole extents for files (0x200)

Mixed-bg: This one's reasonably old and is available with the -M option 
as well.  It has been the default for filesystems under 1 GiB for some 
time.  Some people recommend it for filesystems upto perhaps 32-64 GiB as 
well, and it does lessen the hassle with data/metadata getting out of 
balance since they're then combined, but there is a performance cost to 
enabling it.  Basically, I'd say don't bother with activating it via -O, 
use -M instead if you want it, but do consider well if you really want it 
above say 64 or 128 MiB, because there IS a performance cost, and as 
filesystem sizes get bigger, the benefit of -M/mixed-bg on smaller 
filesystems doesn't matter as much.

Tho mixed-bg DOES make possible dup data (and indeed, requires if if you 
want dup metadata, since they're mixed together in this mode) on a single-
device btrfs, something that's not otherwise possible.

Extref: As mentioned, extref is now the default.  The reason being it was 
introduced a number of kernels ago and is reasonably important as some 
people were running into hardlinking issues with the previous layout, so 
activating it by default is the right choice.

Raid56: Unless you plan on doing raid56 in the near term (and that's not 
recommended ATM as btrfs raid56 mode isn't yet complete in terms of 
device loss recovery, etc, anyway), that one probably doesn't matter.  
Recommend not using raid56 at this time and thus keeping the option off.

Skinny-metadata: This one's /relatively/ new, being introduced in kernel 
3.10 according to the wiki.  In the 3.10 and possibly 3.11 cycles I did 
see a number of bugfixes going by for it, and wasn't using or 
recommending it at that time.  But I used it on one less critical btrfs 
in the 3.12 timeframe and had no issues, and with my last mkfs.btrfs 
round shortly after v3.14's release, I enabled it on everything I redid.

The benefit of skinny-metadata is simply less metadata to deal with.  
It's not critical as a new kernel can write the "fat" metadata just fine, 
and is not yet the default, but if you're recreating filesystems anyway 
and don't plan on accessing them with anything older than 3.11, I suggest 
enabling it.

No-holes:  This one is still new, enabled in kernel (and btrfs-progs) 
v3.14, and thus could have a few bugs to work out still.  In theory, like 
skinny-metadata it simply makes for more efficient metadata.  However, 
unlike skinny metadata I've yet to see any bugs at all related to it, and 
in fact, tracking explicit-hole mapping has I believe caused a few bugs 
of its own, so despite its newness, I enabled it for all new btrfs
in my last round of mkfs.btrfs filesystem redos shortly after v3.14 
release.

So a cautious no-holes recommend once you are fairly sure you won't be 
mounting with anything pre-3.14 series, tho be aware that since 3.14 
itself is so new and because this isn't yet the default, it won't yet 
have the testing that the other minor-features have, and thus could in 
theory still have a few bugs.  But as I said, I believe there were 
actually bugs in the hole-extent processing before, so I think the risk 
profile on this one is actually pretty favorable, and I'd consider the 
accessing kernel age factor the major caveat, at this point.

So here I'm doing -O extref,skinny-metadata,no-holes .

(Minor usage note:  In btrfs-progs v3.14 itself, --features, the long 
form of the -O option, was buggy and didn't work.  That was actually a 
bug I reported here after finding it when I was doing those redoes as I 
use a script that was coded to use the long form, only to have it bug 
out.  -O worked tho, and after rewriting that bit of the script to use 
that, it worked fine.  I haven't actually updated btrfs-progs in 10 days 
or so, but I've seen mention of a v3.14.1, which presumably fixes this 
bug.)

Meanwhile, as I've observed before, I tend to be more comfortable on 
newsgroups and mailing lists than editing the wiki, and I still haven't 
gotten a wiki account setup.  If someone with such an account wants to 
put all that on the wiki somewhere I'm sure many will find it useful. =;^)


So back to the immediate situation at hand.  Since you don't have all the 
data at hand (it's partially remote) to do a mkfs and restore at this 
time, you may or may not wish to do a full mkfs.btrfs and restore, and 
indeed, the features and performance you'd gain in doing so are 
relatively minor.  But in general, you probably want to consider doing 
such a mkfs.btrfs and restore at some point, even if it's only once, 
perhaps a year or so from now as btrfs continues toward full 
stabilization and the frequency of these individually relatively minor on-
device-format changes drops toward zero, the ultimate idea being to 
rebuild your filesystem with a stable btrfs, doing away with all the 
cruft that might have built up after years of running a not-entirely 
stable development filesystem, as well as taking advantage of all the 
individually incremental feature tweaks that were made available one at a 
time as the filesystem stabilized.

Personally I've been routinely testing pre-stable releases of various 
things for a couple decades now, including what I now consider MS 
proprietary servantware (in the context of my sig) before the turn of the 
century (I was active back on the IE/OE beta newsgroups back in the day 
and at one point was considering becoming an MSMVP, before I discovered 
freedomware), and a policy of cleaning out the beta cruft and making a 
clean start once there's a proper stable release out, has never done me 
wrong.  I don't always do so, and in fact am using the same basic user-
level KDE config I used back with KDE 2 shortly after the turn of the 
century, tho I've of course gone thru and manually cleaned out old config 
files from time to time, but particularly for something as critical to 
the safety of my data as a filesystem, I'd consider, and could certainly 
recommend, nothing else.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

