Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32832 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757343AbaGYCcb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 22:32:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XAVJ8-00068U-EQ
	for linux-btrfs@vger.kernel.org; Fri, 25 Jul 2014 04:32:30 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 04:32:30 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 04:32:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
Date: Fri, 25 Jul 2014 02:32:17 +0000 (UTC)
Message-ID: <pan$aa09d$75e2870b$4abbbcef$7f21a37d@cox.net>
References: <1502954.OtX3SzjMKZ@merkaba> <1809953.ithLVmijbn@merkaba>
	<53D11F2B.1070008@fb.com> <1557956.045aK4K0qS@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Thu, 24 Jul 2014 20:49:37 +0200 as excerpted:

> It may take some time tough cause during compiling the kernel BTRFS hung
> again, which caused loss of KDE Baloo desktop search file index and
> parts of a mail I wrote in KMail.

Heh.  While I do run a kde(-lite) desktop, at least I don't have those 
problems to deal with.  As a gentooer I have the option to build kde 
without the semantic-desktop junk and I've taken that option, so no baloo 
or the like here.  And after the akonadified kmail lost one too many 
mails and I was going to need to reset the data store to retrieve them 
once again, I asked myself why I was putting up with it, after all, email 
is a decades old technology that should NOT be rocket-science any longer, 
and soon enough I was NOT putting up with it any longer, as I'd switched 
to claws-mail.  Actually, killing with fire kdepim and anything akonadi 
related was what allowed me to kill semantic-desktop as well instead of 
just run-time disabling it, since akonadi is part of the steaming pile.

And claws-mail has this nice option I didn't even know could be done on 
pop3 mail servers, too.  It downloads the mail for local reading, but 
keeps it on the server for a week (configurable) before final pop3 server-
side deletion, just in case you do crash after download and lose the 
local copy.  I've not actually had to take advantage of that feature yet, 
but it's sure nice to have, just in case. =:^)

Interesting this came up here just now, too, as there's a current xmodulo 
post about baloo and milou in kde4 and the carryover to kde-frameworks5 
and plasma5, too, with an ongoing discussion.

http://xmodulo.com/2014/07/kde-semantic-desktop-nepomuk-baloo.html

So fortunately, while I am a development version tester for of both kde 
and btrfs, the akonadi and semantic-desktop steaming-pile-of-.... is not 
something I have to worry about the stability of (or more precisely the 
lack thereof), while also testing a not yet fully stable btrfs at the 
same time.  Hopefully that'll continue to be the case in the claimed more 
modular kde-frameworks-5 era, because there's more than one way to ensure 
that I don't have to deal with that pile, and just as I suddenly found 
some other option for mail after using kmail since the kde2 era when it 
semantic-desktop-integrated without option, so my kde/plasma desktop, 
also since the kde2 era, can find itself going the same route locally, 
should it insist on going the same route globally.

Tho just as I did the akonadified kmail, I'll likely keep an open enough 
mind to try it.  <shrug>  Maybe it'll actually work this time, without 
eating up gigs of indexing space that has to be reset frequently due to 
something going wrong, to do it.  Time will tell...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

