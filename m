Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43839 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751936AbcILWV1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 18:21:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bjZbP-0004lQ-DC
        for linux-btrfs@vger.kernel.org; Tue, 13 Sep 2016 00:21:23 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Mixing partitioned and non-partitioned discs in a RAID?
Date: Tue, 13 Sep 2016 00:21:10 +0200
Message-ID: <20160913002110.0c621dc2@jupiter.sol.kaishome.de>
References: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
        <CAJCQCtTQAG+0M9AsNj5LNWXTAKd8V-6DL=5kS80dPt59S1uiAA@mail.gmail.com>
        <BLU437-SMTP168169D258F02597287B2E92170@phx.gbl>
        <CAJCQCtS1LPmYN2JY0cayWpCPVzaPq+KQSZZU4g9ifVGT9HCZCg@mail.gmail.com>
        <pan$37954$2a2891c6$a583cdc5$350ef358@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 21 Aug 2016 02:19:33 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Chris Murphy posted on Sat, 20 Aug 2016 18:36:21 -0600 as excerpted:
> 
> > FAT leaves a lot to be desired but it's pretty universally
> > supported and almost trivial to repair *if* the volume is
> > repairable in the first place. The much bigger issue with ESP on
> > Linux is this neurotic tendency of distros to persistently mount
> > shit that does not need to be mounted. Like the ESP, and even the
> > dedicated boot volume. They only need to be mounted when being
> > updated and then should be umounted. And worse the convention is to
> > do nested mount with /boot and then /boot/efi for the ESP so it's
> > twice as bad a practice. By virtue of mounting the ESP the dirty
> > bit is set, so any crash means it must be fsck'd and if that
> > doesn't work, it's game over for that volume. Fragile setup.  
> 
> Depends on the distro.  On gentoo, you set it up the way you want of 
> course, but the recommendation has always been /boot, and now the
> ESP, not mounted by default.
> 
> But that would be /expected/ on gentoo, since being able to configure
> it the way you want is the whole /point/ of running gentoo in the
> first place.  Sort of like arch, only much more so.

systemd systems (I'm booting Gentoo with systemd) should auto-mount ESP
to /boot on access, and auto-unmount after a short timeout. So the
solution to this problem is already wired into systemd if you use (a)
proper GPT setup (with correct GUIDs) and (b) do not mention /boot in
fstab.

-- 
Regards,
Kai

Replies to list-only preferred.

