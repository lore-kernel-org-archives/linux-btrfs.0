Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44454 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbdGRHYx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 03:24:53 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dXMs1-00078V-MK
        for linux-btrfs@vger.kernel.org; Tue, 18 Jul 2017 09:24:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: bind mounts on btrfs cause mountinfo confusion
Date: Tue, 18 Jul 2017 07:24:29 +0000 (UTC)
Message-ID: <pan$78a03$5a3730b6$f093b5e5$da803183@cox.net>
References: <CAJCQCtT=-YoFJgEo=BFqfiPdtMoJCYR3dJPSekf+HQ22GYGztw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 17 Jul 2017 15:47:20 -0600 as excerpted:

> Example during boot:
> 
> Executing: /usr/bin/mount
> /sysroot/ostree/deploy/fedora-workstation/var /var -o bind
> 
> cat /proc/self/mounts
> 
> /dev/sda6 /var btrfs
> rw,relatime,ssd,space_cache,subvolid=5,subvol=/ostree/deploy/fedora-
> workstation/var 0 0
> 
> findmnt shows basically the same [options only listed]
> 
> rw,relatime,ssd,space_cache,subvolid=5,subvol=/ostree/deploy/fedora-
> workstation
> 
> 
> There is no such subvolume /ostree/deploy/fedora-workstation/var,
> basically it seems like whatever is producing this mount information
> (kernel code?) is just assuming a bind mount on Btrfs is a subvolume
> without checking if that subvolume really exists, and if it's just an
> ordinary directory being bind mounted, which is what's going on here.
> 
> I'd say it's confusing. But I don't know if it's a problem otherwise.

Yes, it's kernel code.  The reason is that btrfs internally handles 
subvolume mounts as bind-mounts, so it thinks all bind-mounts are 
subvolume mounts, even when they're not.

It can be slightly confusing, true, but I actually appreciate having the 
path information available here for my bind-mounts (which aren't 
subvolumes as I don't use subvolumes here).  It makes it easier to figure 
out which are the bind-mounts vs the original mount.  From my mount 
output:

/dev/sda5 on / type btrfs (..,subvolid=5,subvol=/)
/dev/sda5 on /m/cbind/etc/bind type btrfs (..,subvolid=5,subvol=/etc/bind)

/dev/sda6 on /h type btrfs (..,subvolid=5,subvol=/)
/dev/sda6 on /m/cbind/var/bind type btrfs (..,subvolid=5,subvol=/var/bind)

Note the subvolid=5.  For real subvolume mounts that should be something 
else, so it makes it clear it's the root subvolume and thus a regular 
bind-mount not a subvolume mount, regardless of what subvol= says.

Meanwhile, the subvol= gives me the information that the duplicate 
/dev/sdx is missing, the path on the device that's actually being 
mounted.  For the original mount it's /.  For bind-mounts, it's the path 
that's being bind-mounted elsewhere, /etc/bind being bind-mounted to 
/m/cbind/etc/bind, for the first (sda5) listing above.

Before the kernel started printing that subvol= stuff, this information 
was missing, as it still is for non-btrfs.

So while slightly confusing, I definitely /like/ having that new 
information available. =:^)

Arguably it could be printed as something other than "subvol=", however, 
but what?  If I had a reasonable suggestion for something that retains 
the additional information but looks less confusing regardless of whether 
it's an actual subvolume mount or just a bind-mount, I'd have made it 
already. =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

