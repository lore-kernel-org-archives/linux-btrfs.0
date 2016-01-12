Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46383 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510AbcALAfz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 19:35:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aImwB-00074a-Eo
	for linux-btrfs@vger.kernel.org; Tue, 12 Jan 2016 01:35:51 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 01:35:51 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 01:35:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
Date: Tue, 12 Jan 2016 00:35:45 +0000 (UTC)
Message-ID: <pan$bf442$578d348a$9e041d68$3f7003df@cox.net>
References: <CA+9GZUitvMjJSgdpmMb8Fsz-CHK4WXV9XVhGCk9mRCWUU_D-VQ@mail.gmail.com>
	<CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
	<CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
	<CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
	<CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
	<CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
	<CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
	<20160109202659.GC6060@carfax.org.uk>
	<CAPmG0jYaga9c0+x+TzdR_FuV57qfr2M-topeRstazV9n1=f9sQ@mail.gmail.com>
	<CA+9GZUg752dgd2mpEiBvHrFr3W_zccwk4yN=e04DN0OPTBrGDg@mail.gmail.com>
	<CAJCQCtSuCj2tWfgKaGOYRP57LURaQv4jXdkJW6cjqjdVEvHTxw@mail.gmail.com>
	<CA+9GZUi5vYqx7+QaU8uuCB7bBhx+mfM_RJP0S6eDN8ZCJf0wYg@mail.gmail.com>
	<CA+9GZUgKoyanUUBzLqgghnK-vJD_8jFRnW13iEAHqzDS2NXNyA@mail.gmail.com>
	<CA+9GZUgzToyc7YqoPSbJQ2f=YSCkYf81+N2oTzYWM6m95uzCKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cheater00 . posted on Mon, 11 Jan 2016 08:54:55 +0100 as excerpted:

> After the fsck, the Data segment is being resized correctly. It would
> seem to me that the fact Data was 2TB when this bug transpired was just
> a coincidence.
> 
> Perhaps this line:
> "BTRFS info (device sdc1): The free space cache file (2159324168192)
> is invalid. skip it"
> 
> should not be "info" but an error, and should instruct the user to fsck
> the file system.

[Please reply in context, under the context you're quoting, like this, 
not above it, which makes following the context very difficult and 
replying to multi-level context even more so, especially when others are 
trying to reply in context so some of the conversation is at the end, 
some at the beginning.]

It really /is/ info, as the filesystem simply regenerates that section of 
the free-space cache.  That the line disappeared in the remount after the 
fsck would appear to be coincidence as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

