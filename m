Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44341 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaLADJH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 22:09:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvHMH-0001kK-9X
	for linux-btrfs@vger.kernel.org; Mon, 01 Dec 2014 04:09:05 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 04:09:05 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 04:09:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
Date: Mon, 1 Dec 2014 03:08:54 +0000 (UTC)
Message-ID: <pan$d4d18$d4463d$8df93dd7$d770703b@cox.net>
References: <547BCB43.5020505@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Mon, 01 Dec 2014 09:58:27 +0800 as excerpted:

> [CRAZY IDEA]
> So why not using SQL to implement the btrfsck inode-record things?

> 2. Heavy dependency
>     If use it, btrfs-progs will include RDBMS as the make and runtime
>     dependency.  Such low level progs depend on high level programs
>     like sqlite3 may be very strange.

I expect this will turn many of the "traditionalists" off, at least.  I 
could see a lot of traditional sysadmins lumping btrfs in with systemd if 
it started requiring a db, much as one of the big objections to systemd 
is the dbus requirement... even for headless servers that have never 
required it before.  Of course they could be ignored, but do we really 
want to go there?

(Personally, my gut reaction is "eew", and of course getting database 
file handling correct after an ungraceful shutdown/reboot is one of the 
big challenges for a filesystem as it is, so I'm not entirely sure 
storing information in a database file in ordered to use it to help fix 
the filesystem is a good idea since it could well be that you end up 
needing an fsck to restore the file... to do the fsck, but I could be 
convinced.  I'm worried about the ones that can't be.)

> 4. Copyright
>     Will it cause any copyright problem if using non-GPL RDBMS like
>     sqlite3 in GPLv2 btrfs-progs?

I just checked and at least on gentoo, sqlite's license is registered as 
"public domain", which is legally mergeable with code under any other 
license free or proprietary, so there should be no problem with it.  If 
something else is used of course it would depend on its license.

I believe the general kernel-rules practice for such compatible license 
merging is to keep code under compatible licenses in separate files and 
keep the individual files under their individual licenses.  While if it's 
compatible I don't believe that's generally an actual legal requirement, 
the BSD folks in particular tend to be /very/ sensitive about code 
formerly under the BSD license, for instance, merged directly into GPL 
headlined files, because in that case they can't reverse the process.  
Personally I don't see the big deal, since they seem to have /no/ problem 
with their code being taken proprietary where they can't even /look/ at 
it, but a /huge/ problem with it being taken GPL, where they may not be 
able to directly copy back to BSD, but they obviously have the code 
available to look at anyway and still mergeable provided they dual 
license, and that makes absolutely no sense to me. <shrug>


So while I don't think it'll go over well, there should be no license 
issues at least with sqlite.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

