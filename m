Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55359 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756144AbcINSVs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 14:21:48 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bkEoS-0005y8-44
        for linux-btrfs@vger.kernel.org; Wed, 14 Sep 2016 20:21:36 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Mixing partitioned and non-partitioned discs in a RAID?
Date: Wed, 14 Sep 2016 20:21:30 +0200
Message-ID: <20160914202130.79e783ad@jupiter.sol.kaishome.de>
References: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
        <CAJCQCtTQAG+0M9AsNj5LNWXTAKd8V-6DL=5kS80dPt59S1uiAA@mail.gmail.com>
        <BLU437-SMTP168169D258F02597287B2E92170@phx.gbl>
        <CAJCQCtS1LPmYN2JY0cayWpCPVzaPq+KQSZZU4g9ifVGT9HCZCg@mail.gmail.com>
        <pan$37954$2a2891c6$a583cdc5$350ef358@cox.net>
        <20160913002110.0c621dc2@jupiter.sol.kaishome.de>
        <pan$717d6$66f35969$3e561cab$6b1e254f@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 13 Sep 2016 04:07:37 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Kai Krakow posted on Tue, 13 Sep 2016 00:21:10 +0200 as excerpted:
> 
> > Am Sun, 21 Aug 2016 02:19:33 +0000 (UTC)
> > schrieb Duncan <1i5t5.duncan@cox.net>:
> >   
> >> Chris Murphy posted on Sat, 20 Aug 2016 18:36:21 -0600 as
> >> excerpted: 
>  [...]  
> >> 
> >> Depends on the distro.  On gentoo, you set it up the way you want
> >> of course, but the recommendation has always been /boot, and now
> >> the ESP, not mounted by default.
> >> 
> >> But that would be /expected/ on gentoo, since being able to
> >> configure it the way you want is the whole /point/ of running
> >> gentoo in the first place.  Sort of like arch, only much more so.  
> > 
> > systemd systems (I'm booting Gentoo with systemd) should auto-mount
> > ESP to /boot on access, and auto-unmount after a short timeout. So
> > the solution to this problem is already wired into systemd if you
> > use (a) proper GPT setup (with correct GUIDs) and (b) do not
> > mention /boot in fstab.  
> 
> No "automagic" on-access mounting here.  The kernel options aren't
> turned on for it, neither do I want them on (the systemd ebuild
> checks for and recommends but does not force them, and systemd
> functions fine without them except it doesn't automount on access,
> which is pretty much the point).  What gets mounted on boot is what I
> have in fstab (plus a few things like cgroups that systemd handles
> entirely on its own).  After that, nothing else is mounted unless I
> mount it, or unmounted, unless I umount it or systemd does it as part
> of shutdown, etc.

https://www.freedesktop.org/software/systemd/man/systemd-gpt-auto-generator.html

FD> Mount and automount units for the EFI System Partition (ESP),
FD> mounting it to /boot, are generated on EFI systems where the boot
FD> loader communicates the used ESP to the operating system. Since
FD> this generator creates an automount unit, the mount will only be
FD> activated on-demand, when accessed. On systems where /boot is an
FD> explicitly configured mount (for example, listed in fstab(5)) or
FD> where the /boot mount point is non-empty, no mount units are
FD> generated.

So there are a few points when this does not happen. It does not
blindly auto-mount ESP.

> However, good point about systemd, since it should more or less
> standardize handling across mainline distros over the longer term,
> except of course where admins/distros specifically configure it
> otherwise, as I've done here.
 
I also explicitly put it in fstab - so the generator doesn't work for
me.


-- 
Regards,
Kai

Replies to list-only preferred.

