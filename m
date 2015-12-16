Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34485 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932751AbbLPIK6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 03:10:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a97Al-0002iR-72
	for linux-btrfs@vger.kernel.org; Wed, 16 Dec 2015 09:10:55 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 09:10:55 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 09:10:55 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs: poor performance on deleting many large files
Date: Wed, 16 Dec 2015 08:10:42 +0000 (UTC)
Message-ID: <pan$4efca$3a4784ea$c11db74f$a631a8cf@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<pan$eea04$e9596e27$78b44461$c5754723@cox.net>
	<1448488198.4717.4.camel@gmail.com>
	<pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
	<1448562347.8809.16.camel@scientia.net>
	<pan$54542$5eb77bd3$8682bff8$82310de1@cox.net>
	<1448582805.11377.9.camel@scientia.net>
	<pan$34543$2ed1f043$2f803125$884b36c0@cox.net>
	<1448683025.6837.4.camel@scientia.net>
	<pan$46a28$81694e9d$c6d5f048$1c8bcdd8@cox.net>
	<1449958538.15961.3.camel@scientia.net> <566ED124.30803@gmail.com>
	<1450121957.6629.41.camel@scientia.net> <566F261F.4040705@gmail.com>
	<566F34F0.8050407@bouton.name> <1450135505.6629.66.camel@scientia.net>
	<pan$c3e1a$7bad3839$12bcfe1f$4c2ff85e@cox.net>
	<566F7D29.9000707@bouton.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lionel Bouton posted on Tue, 15 Dec 2015 03:38:33 +0100 as excerpted:

> I just checked: this has only be made crystal-clear in the latest
> man-pages version 4.03 released 10 days ago.
> 
> The mount(8) page of Gentoo's current stable man-pages (4.02 release in
> August) which is installed on my systems states for noatime:
> "Do not update inode access times on this filesystem (e.g., for faster
> access on the news spool to speed up news servers)."

Hmm... I hadn't synced and updated in about that time, and sure enough, 
while I've just synced I've not yet updated, and still have man-pages 
4.02 installed.

But, the mount.8(.bz2 in my case as that's the compression I'm configured 
for, I had to use man -d mount to debug-dump what file it was actually 
loading) manpage actually belongs to util-linux, according to equery 
belongs, while equery files man-pages | grep mount only returns hits for 
mount.2(.bz2 and umount).

So at least here, it's util-linux providing the mount (8) manpage, not 
man-pages.

Tho I'm on ~amd64 and IIRC just updated util-linux in the last update, so 
the cross-ref to nodiratime in the noatime entry (saying it isn't 
necessary as noatime covers it) probably came from there, or a similar 
recent util-linux update.

Let's see...

My current util-linux (with the xref in both noatime and nodiratime to 
the other, saying nodiratime isn't needed if noatime is used) is 2.27.1.

The oldest version I still have in my binpkg cache (tho I likely have 
older on the backup) is util-linux 2.24.2.  For noatime it has the 
wording you mention, don't update inode access times, but for nodiratime, 
it specifically mentions directory inode access times.  So from util-linux 
2.24.2 at least, the information was there, but you had to read between 
the lines a bit more, because nodiratime mentions dir inodes, and noatime 
says don't update atime on inodes, so it's there but you have to be a 
reasonably astute reader to see it.

In between those two I have other versions including 2.26.2 and 2.27.  
Looks like 2.27 added both the "implies nodiratime" wording to the noatime 
entry, and the nodiratime unneeded if noatime set notation to the 
nodiratime entry.

If there was a util-linux 2.26.x beyond x=2, I apparently never installed 
it, so the wording likely changed with 2.27, but may have changed with 
late 2.26 versions as well, if there were any beyond 2.26.2.

And on gentoo, 2.26.2 appears to be the latest stable-keyworded, so 
that's what stable users would have.

But as I said, the info is there at least as of 2.24.2, you just have to 
note in the nodiratime entry that it says dir inodes, while the noatime 
entry simply says inodes, without excluding dir inodes.  So it's there, 
you just have to be a somewhat astute reader to note it.

Anywhere else, say on-the-net recommendations for nodiratime, /should/ 
mention that they aren't necessary if noatime is used as well, but of 
course not all of them will.  (Tho I'd actually find it a bit strange to 
see discussion of nodiratime without discussion of noatime as well, as 
I'd guess any discussion of just one of the two would likely be on 
noatime, leaving nodiratime unmentioned if they're only covering one, as 
it shouldn't be necessary to mention, since it's already included in 
noatime.)

But there's probably a bunch of folks who originally read coverage of 
noatime, then saw nodiratime later, and thought "Oh, that's separate?  
Well I want that too!" and simply enabled them both, without actually 
checking the manpage or other documentation including on-the-net 
discussion.

I know here I originally saw noatime and decided I wanted it, then was 
confused when I saw nodiratime sometime later.  But I don't just enable 
stuff without having some idea what I'm enabling, so I did my research, 
and saw noatime implied nodiratime as well, so the only reason nodiratime 
might be needed would be if you wanted atime in general, but not on dirs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

