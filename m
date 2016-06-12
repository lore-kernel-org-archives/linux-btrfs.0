Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38146 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbcFLCSm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jun 2016 22:18:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bBuz2-00071C-73
	for linux-btrfs@vger.kernel.org; Sun, 12 Jun 2016 04:18:40 +0200
Received: from ip-64-134-228-1.public.wayport.net ([64.134.228.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jun 2016 04:18:40 +0200
Received: from 1i5t5.duncan by ip-64-134-228-1.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jun 2016 04:18:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Files seen by some apps and not others
Date: Sun, 12 Jun 2016 02:18:33 +0000 (UTC)
Message-ID: <pan$dc991$bc4b5712$73c16333$5c108126@cox.net>
References: <CAMPo9spCUSEwMBhGWcr1iX0ny28e52GYMO4D=eug-MZaWB0iEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bearcat Şándor posted on Sat, 11 Jun 2016 13:54:44 -0600 as excerpted:

> I'm about to try a btrfs restore to see what it can do for me. Any
> pointers or help here? I don't want to fsck things up further.

FWIW, btrfs restore doesn't write anything at all to the filesystem it's 
restoring from -- it's read-only in that regard -- so you really don't 
have to worry about it screwing up a filesystem further.

But by the same token, btrfs restore may not do what you think it does.  
It doesn't try to fix the filesystem.  Rather, it's a way to try to 
salvage anything you can off a filesystem that won't mount, or, as it 
would be used here, that will mount but where files aren't showing up 
properly so you can't just copy them elsewhere using normal means.  It 
writes the files it can salvage to some other filesystem, which of course 
means that whatever filesystem you're writing the files to must have 
enough room for the files to be written.

Also note the various restore options.  In particular, the restore 
metadata option must be used if you want to restore the same ownership, 
permissions and timestamp information.  Otherwise, restore simply writes 
the files as the user you're running it as (root), using the current 
umask.  Similarly, if you want to restore symlinks and extended 
attributes, there's options for that, otherwise they aren't restored.

And you won't necessarily be wanting to restore snapshots, as you should 
have backups if needed for the history, and are likely most worried about 
the current version of the files, so snapshots aren't restored unless you 
use the appropriate option.

Given that the filesystem is still mounted and most files are apparently 
still readable normally, you may want to copy off what you can that way, 
and only restore specific files using btrfs restore.  Or you may not have 
room on the destination filesystem to restore everything, and will need 
to pick only the most important stuff to restore.  That's where the 
pattern-match option comes in.

What I did here when I used restore (I had backups of course but they 
weren't current) was use the metadata and symlinks restore options, and 
simply restored everything.

Note that if a particular directory has a lot of files, restore will 
begin to think that it's looping to much and that it's stuck.  It'll 
prompt you to continue, and may prompt a *LOT*.  Here I have multiple 
independent small filesystems, so it wasn't a big deal, but you may need 
to experiment with automating the "yes" if your filesystem is huge 
(piping the output of the yes command to stdin, for instance, or similar 
sysadmin prompt automation tricks).  A number of folks have mentioned 
that and requested a way to say "yes, really all, don't ask again", an 
option that btrfs restore unfortunately doesn't have yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

