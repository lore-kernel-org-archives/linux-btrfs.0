Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37351 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbcDWGXF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Apr 2016 02:23:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1atqy6-0006h8-6w
	for linux-btrfs@vger.kernel.org; Sat, 23 Apr 2016 08:23:02 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Apr 2016 08:23:02 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Apr 2016 08:23:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: primary location of btrfs-progs changelog: The wiki?
Date: Sat, 23 Apr 2016 06:22:54 +0000 (UTC)
Message-ID: <pan$c1942$3d3d9cd7$dd1909a2$ac816689@cox.net>
References: <CAD=QJKh50oFh+eEDte4BncgwRuiuJmC1wyiPG3HBVqOkLD2Wng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicholas D Steeves posted on Fri, 22 Apr 2016 20:41:36 -0400 as excerpted:

> I'm just wondering where the primary location of the btrfs-progs
> changelog is located, because I'd like to include upstream changes in
> the Debian package.  Is it really the wiki?  If so, it would seem my
> options are copying+pasting with every release, or writing a script to
> download the page, convert it to text, and then do something like cut
> everything before By version (btrfs-progs) and everything after By
> version (linux kernel).

As with most modern projects, particularly those that are kernel related, 
I believe the _primary_ and authoritative changelog is git log. =:^)  
Particularly with the kernel, Linus's merge-commits for the various 
subsystems (btrfs in this case) tend to give a rather good if somewhat 
technical overview of what's going on with the whole merge, so you don't 
need to drill down to individual commits unless it's something you're 
/that/ interested in.

Beyond git log and other than the wiki, for userspace see the "Btrfs progs 
release" (that should be a reasonable subject search on any of the list 
archives, or use pre-release if you want them) messages authored by David 
Sterba here on this list.  They normally contain a reasonable "user-
level" summary, similar to what eventually gets put on the wiki (indeed, 
I'd guess the wiki copies from the release announcements).

For example:

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/54781

For the kernel, search on "[GIT PULL] Btrfs" messages from Chris Mason.  
For example:

http://permalink.gmane.org/gmane.linux.kernel/219422

As with many subsystems Linus often uses these pretty directly in his 
merge commit comments, so it's pretty close to the same thing you'd get 
by reading the git log merge commits.

But beyond that, I think it's the wiki, which I believe can also have 
slightly more mainstreamed/sysadmin-level-change descriptions, 
particularly for the kernel, as I believe they're edited a bit 
differently than the git pull notices, where Linus and git log readers 
are the primary audience.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

