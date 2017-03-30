Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36674 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752742AbdC3DrG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 23:47:06 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ctR2f-0004uQ-Mw
        for linux-btrfs@vger.kernel.org; Thu, 30 Mar 2017 05:46:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fwd: Confusion about snapshots containers
Date: Thu, 30 Mar 2017 03:46:24 +0000 (UTC)
Message-ID: <pan$9f56c$63e254c1$b0a3dfea$f7b524f9@cox.net>
References: <CAAKzf7ngoK27K=7gtUJR83QoPOwLAxQNK9NcOunNDX0-ijQ5_w@mail.gmail.com>
        <20170329215554.GT11714@carfax.org.uk>
        <CAAKzf7n=e9Onnc5D-U_zBtXXpFk11QiN7RhisqAB5Ej0DQOcfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tim Cuthbertson posted on Wed, 29 Mar 2017 18:20:52 -0500 as excerpted:

> So, another question...
> 
> Do I then leave the top level mounted all the time for snapshots, or
> should I create them, send them to external storage, and umount until
> next time?

Keep in mind that because snapshots contain older versions of whatever 
they're snapshotting, they're a potential security issue, at least if 
some of those older versions are libs or binaries.  Consider the fact 
that you may have had security-updates since the snapshot, thus leaving 
your working copies unaffected by whatever security vulns the updates 
fixed.  If the old versions remain around where normal users have access 
to them, particularly if they're setuid or similar, they have access to 
those old and now known vulns in setuid executables!  (Of course users 
can grab vulnerable versions elsewhere or build them themselves, but they 
can't set them setuid root unless they /are/ root, so finding an existing 
setuid-root executable with known vulns is finding the keys to the 
kingdom.)

So keeping snapshots unmounted and out of the normally accessible 
filesystem tree by default is recommended, at least if you're at all 
concerned about someone untrusted getting access to a normal user account 
and being able to use snapshots with known vulns of setuid executables as 
root-escalation methods.

Another possibility is setting the snapshot subdir 700 perms, so non-
super-users can't normally access anything in it anyway.  Of course 
that's a problem if you want them to have access to snapshots of their 
own stuff for recovery purposes, but it's useful if you can do it.

Good admins will do both of these at once if possible as they know and 
observe the defense-in-depth mantra, knowing all too well how easy a 
single layer of defense yields to fat-fingering or previously unknown 
vulns.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

