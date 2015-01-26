Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58301 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbbAZNiX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Jan 2015 08:38:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YFjrs-0000ss-PI
	for linux-btrfs@vger.kernel.org; Mon, 26 Jan 2015 14:38:16 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2015 14:38:16 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2015 14:38:16 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Bug Report Data Rescue: btrfs send ... btrfs set prop on linux
 3.18-2 on Arch Linux
Date: Mon, 26 Jan 2015 13:38:09 +0000 (UTC)
Message-ID: <pan$d4a72$2fba9dd8$b6d20a1e$30871850@cox.net>
References: <54C63021.8000502@automatix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Juergen Sauer posted on Mon, 26 Jan 2015 13:16:33 +0100 as excerpted:

> I think this is an Bug in btrfs send, not to check if an btrfs
> filesystem is mounted ro for refusing working.
> 
> It may be much more easier to recover damaged systems, if such annoying
> thngs would not occour.

That has been noted before, and is indeed considered a bug.

The problem is that in normal circumstances, a read-only mount wasn't 
considered secure enough, because the user could make it writable while 
the send was underway, causing the send to fail.

But at minimum, there needs to be a way to do a send from a forced-read-
only filesystem, you are correct, thus the bug.

I don't know whether they plan to relax the requirement and live with the 
chance of a user making it writable (admin responsibility, admin breaks 
the send, admin gets to keep the pieces), or if they plan to add an 
attribute to force-read-only so it can be distinguished from user-mounted-
read-only, in which case forced-read-only could be considered sufficient 
for a send.

But indeed, the current situation is acknowledged to be "less than ideal" 
by the devs, which will probably do something about it at some point, 
based on comments.  I don't know how soon that "some point" might be, 
however...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

