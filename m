Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50242 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbbCIMpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 08:45:05 -0400
Message-ID: <1425905102.1178.27.camel@gmx.de>
Subject: Re: Lock-ups, assertion failure  in btrfsck, scrub reporting super=4
From: Tobias Getzner <tobias.getzner@gmx.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 09 Mar 2015 13:45:02 +0100
In-Reply-To: <pan$387dc$a5a9554$54f0b365$e45c3f38@cox.net>
References: <1425556080.32673.11.camel@gmx.de>
	 <pan$387dc$a5a9554$54f0b365$e45c3f38@cox.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fr, 2015-03-06 at 00:10 +0000, Duncan wrote:
> Tobias Getzner posted on Thu, 05 Mar 2015 12:48:00 +0100 as excerpted:
> 
> > I booted back into the graphical system, and when not running Firefox, I
> > did not get any immediate lock-ups anymore.
> > 
> > I’d welcome any advice on how to proceed, i.e., in how to resolve the
> > lock-ups, and, if possible, in fixing potential problems with the
> > file-system.
> 
> I'll let a dev answer that side of things but a couple comments, for what 
> they are worth...
> 
> 1) The firefox issue is likely related to the sqlite database files it 
> uses.  Database random-rewrite-pattern files are always a challenge for 
> cow-based filesystems such as btrfs, tho with small ones like those 
> firefox typically uses, the btrfs autodefrag mount option can help.

Thanks, I usually mount with autodefrag as well. Also, I had the
Firefox sqlite databases set to NOCOW, which might or might not be
involved in triggering this bug.

> Meanwhile, the problem file is likely in your firefox profile.  You could 
> try starting with a clean firefox profile and see if the problem 
> disappears, and if so, bisect the profile to see what file it is and 
> delete it or restore it from backup.

I guessed the same, so I moved my old profile aside and made a fresh
copy (no reflinking) of the old one. Indeed this was fruitful, because
the machine would no longer predictably lock up after starting Firefox.

However, after a while I figured I would «rm -r» the old (somehow
corrupted) profile folder, and this command then immediately froze the
machine. To my dismay, when I rebooted, the lock-up would now not only
trigger when starting Firefox with the old profile, but instead a
soft-lockup would predictably trigger when lauching zsh, most likely
when it sourced some rc file (the zsh binary itself is on another,
uncorrupted partition).

Again, here’s today’s kernel logs with some back-traces from btrfs.
While the logs I posted in the previous message were when running
kernel 3.19 and 3.18.6, these logs are with 3.19.1.

    http://a.pomf.se/xmmpgw.xz

Since I need the machine for work, I decided to create a new btrfs FS
on a spare partition and copy over all the data (since the scrub had
indicated no problems with the data, except super=4). I noticed that
even just mounting the old partition would cause a «kernel bug at
ctree.h:2498». This is not in the logs because I had booted into a
rescue system to copy the files (3.16.3 kernel). The back-trace however
seems to be the same which follows «kernel BUG at
fs/btrfs/ctree.h:2501» in my logs.

Luckily, I could mount the old partition read-only and all the files
could be rsynced to the new FS just fine.

For now I still have the corrupted file-system lying around, so if some
additional information from there could be helpful in fixing this
issue, let me know. I won’t be able to keep it around for too long
though, since the spare partition I’m using now is a bit restricted in
space.

Apart from the corruption issue as such, it might be helpful if the
assertion failure in btrfsck I posted could give some informative
output as to what’s happening.

Best regards,
Tobias


