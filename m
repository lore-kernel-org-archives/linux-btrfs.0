Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35567 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbbEJDLl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 May 2015 23:11:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YrHeS-0006yc-LW
	for linux-btrfs@vger.kernel.org; Sun, 10 May 2015 05:11:36 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2015 05:11:36 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2015 05:11:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs receive error recovery
Date: Sun, 10 May 2015 03:11:24 +0000 (UTC)
Message-ID: <pan$9aa88$5ab24adb$91f7415$30f5f0f3@cox.net>
References: <554DF4E8.2010601@tty0.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Axel Burri posted on Sat, 09 May 2015 13:52:08 +0200 as excerpted:

> Hi btrfs team
> 
> I'm the developer of "btrbk" [1], which uses btrfs send/receive to
> create backups. In case of errors, "btrfs receive" leaves the partially
> received subvolume behind, causing some trouble for subsequent
> incremental backups. As I can see in the wiki, "Delete partially
> received subvolumes on error" is on the TODO list. Until then, what
> would be the best way to check if the received subvolume needs to be
> deleted?
> 
> As "btrfs receive" does always return an exit value of "1" on errors, I
> cannot rely on this (e.g. if a file with the received name already
> exists, I also get an exit code=1, but then I do NOT want to delete
> anything).
> 
> Also, "btrfs subvolume show <partially-received-subvol>" does not
> complain either.
> 
> Do you have any hints on how I can check for this? (and no, parsing
> stderr messages is not an option)

You might be interested in the discussion on a recent thread, sorry, I'd 
have to search it out the same as you, so I'll leave you to it (unless 
someone involved in that thread happens to read this one too and can 
point you right to it), where someone mentioned that their script (which 
is I think its own btrfs-based product similar to yours) did checksum and 
signature (md5 and gpg, IIRC) verification, and that as such and because 
it was actually btrfs checksumming independent, that part of it could be 
used to verify the same fileset from original pre-send run, as it was 
send/received, and even onto non-btrfs filesystems synced with rsync, etc.

I /think/ the whole thread should have been within the last week, but if 
not, certainly that reply was, so you should be able to find it by 
searching all the multi-post threads within the last week.  I'd start by 
excluding the ones with patch in the title first, as I don't think it was 
a patch thread, tho I'm not sure...

You may also be able to use btrfs subvolume find-new, tho from the 
discussion, it doesn't provide everything you need, and I think the above 
script actually started with it to get a list of the files to verify, 
then did the verification on them.

> 
> [1] https://www.digint.ch/btrbk/
>     https://github.com/digint/btrbk





-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

