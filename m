Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47588 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbcASPkb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 10:40:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aLYOT-00013S-KN
	for linux-btrfs@vger.kernel.org; Tue, 19 Jan 2016 16:40:29 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 16:40:29 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 16:40:29 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)?
 Explain like I'm five pls.
Date: Tue, 19 Jan 2016 15:40:16 +0000 (UTC)
Message-ID: <pan$330cc$b22a90e4$71c973$72db5b5c@cox.net>
References: <loom.20160116T132316-196@post.gmane.org>
	<569C41B1.1090206@cn.fujitsu.com>
	<pan$9ea8b$cdf4a5be$a6b3ced0$e73fd4ce@cox.net>
	<569C58FB.70407@cn.fujitsu.com>
	<pan$9dd9b$58cdc4a$94401f0f$f97ce29e@cox.net> <569CDF0D.9030609@gmail.com>
	<pan$9821b$e84a8fc3$23a877ef$2b0858e0@cox.net>
	<pan$85c04$d9fd4f4d$1304efda$85c18be@cox.net> <569E2BFC.8080107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 19 Jan 2016 07:28:44 -0500 as
excerpted:

> There's a reason I don't use KDE...
> (Well, a couple actually, the indexing getting pulled in is only part of
> it, I also dislike the all-or-nothing packaging (everything seems to
> depend on everything else), and having to update the whole thing in
> lock-step; somewhat ironically, GNOME has the same issues these days, so
> I don't use that either).

Rather OT for the list, but... while I'm still using a kde desktop, it's 
pretty stripped down.  As I said, until I installed plasma5, I not only 
had nepomuk/baloo turned off, but I had them stripped out at build-time 
as well.  And I expect to get there again.  I'm already package.providing 
udisks as a plasma5 dep as it's runtime-only, and expect to strip out 
polkit similarly as I've seen indications it's runtime-only, as well as 
baloo again eventually, and networkmanager.

Late in the kde3 cycle I was actually contemplating getting rid of the 
last few gtk2 apps I had and switching to qt/kde only.  But over the 
course of kde4, mostly at the beginning when kde4 was still so broken but 
kde3 wasn't supported any more, but later (~4.6) for konqueror when it 
became apparent its devs considered it little more than a toy, and kmail 
when it jumped the akonadi shark, I switched off of kde for nearly 
everything except the desktop itself, superkaramba (which is being 
dropped tho plasma supposedly supports it, tho I could never get that to 
work properly with my theme back before I decided to give up and just use 
superkaramba, so I'm not sure whether I can get plasma to work there or 
not and I might have to switch to gkrellm or some such), a few games 
which I can give up or there's alternatives for, and dolphin and gwenview 
as file and image managers, with gimv (GImageViewer) already installed as 
an alternative for the latter and pretty much any graphic file manager 
workable as a dolphin replacement since I do much of my file management 
in the terminal using either CLI or the ncurses-based mc anyway.  So the 
situation has nearly reversed from that of the late kde3 cycle, and now 
I'd find it much easier to dump kde than gtk2, as it's primarily a 
relatively lite kde desktop that's my not immediately replaceable kde 
tools now.  And I'm sure I could find a workable alternative to it too, 
if I had too.  Enlightenment has always been on my list to try, and a 
(likely heavily customized by the time I'm done with it) qt-based lxde is 
on my short list as well.

So we'll see how plasma5 develops.  Meanwhile, there's the x11/wayland 
switch coming up, which could yet rock the Linux desktop environment 
landscape pretty wildly, changing it as we know it and putting entirely 
different environments at the forefront a few years from now.  But other 
than gnome, which isn't an option for me due to their "our way is the 
only correct way" attitude, and kde, I simply don't know enough about 
what other environments are doing with it to have the foggiest, at this 
point, particularly if I don't choose to stay with kde/plasma as my 
desktop thru that transition, which is a possibility.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

