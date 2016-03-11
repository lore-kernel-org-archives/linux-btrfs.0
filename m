Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56938 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083AbcCKCvE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 21:51:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aeDAJ-0002PU-Q9
	for linux-btrfs@vger.kernel.org; Fri, 11 Mar 2016 03:50:59 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 03:50:59 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 03:50:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs and containers
Date: Fri, 11 Mar 2016 02:50:53 +0000 (UTC)
Message-ID: <pan$5ccec$498efbab$a72ad404$705bc0c4@cox.net>
References: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
	<CAJCQCtSPEY1c-=GTJwH3-qRNxGCEsd0bVu9A_srdFt03bX7BcQ@mail.gmail.com>
	<20160308195857.GB26981@localhost.localdomain>
	<CAJCQCtSp5B=nnpCs3zaCsMK+8qLNLzYQAqka5P1X+a+R4RzGOQ@mail.gmail.com>
	<56E013E8.9080401@gmail.com>
	<pan$389e0$596a4ce9$6594c4ff$3be23a55@cox.net>
	<56E1A901.6050207@gmail.com>
	<CAJCQCtQVUiVhjop5oE9G_XzReXw=GFtQDgHtjn2=X_qwwsPt8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 10 Mar 2016 12:35:31 -0700 as excerpted:

> It's a tricky problem. If you're the owner of a filesystem tree, but
> something definitely not owned at all by you is buried in that tree
> somewhere, to do a subvolume delete don't you have to now traverse the
> entire thing to find out? Or does the owning user have sufficient
> implied permission by owning the subvolume, that no matter what's in it,
> is simply gone unless it's another subvolume?

Well, to the extent that subvolumes aren't special, they're supposed to 
behave like subdirs.  So it seems simple enough to me, just use subdir 
permissions semantics and don't worry about it.

Which means you can delete files you don't own located directly in a 
directory (so subvol) you have write permissions to, even if you couldn't 
write to the files themselves, but if those files are in turn nested in a 
subdir you can't write to, then you can't delete the files (even if you 
actually own the files and can write to them, meaning you could change 
them, but not delete them), and thus can't delete the dir, which means 
you can't delete its parent dir... or subvol.

At least, that's the way it /should/ work.

Unless of course subvolumes are documented to be special in that regard, 
since subvolumes are allowed to differ in behavior from subdirs if that's 
a specific feature of being a subvolume, in which case the documentation 
can simply document the way it works, which can be arbitrarily defined as 
convenient for the implementation if desired, and be done with it.

Of course, if subvolumes were /not/ declared to be special in that 
regard, and thus were supposed to fit the subdir model, actually 
implementing that would involve crawling the subdir tree checking the 
ownership and permissions of all nested subdirs and subvols, as many 
layers deep as it goes, and that would need done in the foreground, 
before the deletion could return, which would tend to slow down the 
subvolume delete implementation toward that of subdir delete.  So of 
speedy subvolume delete is to be retained, then it seems subvols need to 
be defined to have special subvol behavior in this regard, that does NOT 
follow subdir behavior, with that special behavior being defined as, if 
you own the subvolume, you can delete it (and its children), regardless 
of whether you'd have permissions to delete files in the subdirs beneath 
it and thus couldn't delete it were it a regular subdir.


But that brings up the opposite question, or otherwise put, the same 
question in the other direction, as well.  Currently, users can create 
subvols but not (ordinarily) delete them.  Can they create those subvols 
in directories they don't have write permissions in, and thus couldn't 
create subdirs or files in?  If so, that seems to be another security 
issue waiting to be exploited.  If not, then even if they have ownership 
of the subvol itself, they shouldn't be able to delete it, if it's in a 
subdir they don't have write permissions in and thus couldn't create it 
in.


Every time this sort of subvolumes permissions issue comes up, I get a 
(metaphorical) headache trying to sort out the permissions and thus 
security implications, and end up glad I'm simply not dealing with them 
here.  Tho I can't do anything about the security implications if normal 
users can create them, even if my policy is not to do so.  Which does 
have me somewhat worried, because that sort of problem is notorious for 
its unforeseen security implications, and right now, because any user 
(presumably with write permissions on any subdir on a btrfs) can create 
subvolumes, that means anyone running btrfs is exposed to those 
convoluted and likely unforeseen security issues.

Which is definitely another reason not to consider btrfs fully 
stabilized, until that sort of thing gets sorted.  Personally, I'd say 
just require superuser privs (and/or appropriate filecaps and/or SEL 
security labels) to create them as well, and avoid the whole problem.  
Yes, it'll be limiting, but it's a limit that will avoid the entire 
Pandora's box of permissions and security implications.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

