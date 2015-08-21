Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58394 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbbHULXd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 07:23:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZSkPy-00055C-OE
	for linux-btrfs@vger.kernel.org; Fri, 21 Aug 2015 13:23:30 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 13:23:30 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 13:23:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS cannot remove empry directory pretending it is not empty
Date: Fri, 21 Aug 2015 11:23:19 +0000 (UTC)
Message-ID: <pan$3546e$3dbd1a66$4b200cff$9537e206@cox.net>
References: <2017000.AEG9PyVY17@zafu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Fri, 21 Aug 2015 10:19:54 +0200 as excerpted:

> BTRFS refuses to remove an empty dir and pretends it is not empty (and
> there is no BTRFS subvolume involved in there...)
> 
> # uname -r 4.1.5-1-ARCH

[The below description of the bug apparently involved is my not 
necessarily perfect understanding.  I don't claim to know the technical 
details behind inodes and thus it's possible my understanding isn't 
entirely correct.]

There was a recent inode refcounting bug that it sounds like you may well 
have hit, that failed to decrement (or double-incremented) the refcount 
in some cases, such that when a file was deleted, the filesystem still 
thought it had a reference to the inode and didn't delete it, resulting 
in inodes remaining but without a name attached to them.  These nameless 
inodes then prevent deletion of the directories the files were in, 
because the filesystem thinks there's still files there even tho there's 
no name associated with them so there's no file available to delete.

AFAIK, the bug is now fixed, but for those affected, the bad-refcounts 
remain.  I believe btrfs check should detect the problem and with
--repair should fix it, but of course caution is urged in using --repair 
as there's still a chance it'll do damage if there's other problems it 
doesn't understand and thus tries to fix in the wrong way.

So I'd suggest running btrfs check, without --repair, first, and see what 
it says.  If the only reported problems have to do with inode refcounts, 
then (assuming your backups are current, just in case, admin's rule of 
backups, if you don't have them, you don't care about losing the data) 
I'd then go ahead and run it with --repair.

Of course to do that you'll have to have the filesystem unmounted, and 
have access to a reasonably new btrfs command on the initr* or from your 
emergency boot, if it's the root filesystem.  Could be fun... but it 
should correct the issue.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

