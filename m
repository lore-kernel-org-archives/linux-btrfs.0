Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53921 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbcC2Bq5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 21:46:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1akikB-0006HB-85
	for linux-btrfs@vger.kernel.org; Tue, 29 Mar 2016 03:46:55 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 03:46:55 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 03:46:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Raid 0 setup doubt.
Date: Tue, 29 Mar 2016 01:46:25 +0000 (UTC)
Message-ID: <pan$5eff2$9df187d8$1f5c7833$dba90a9e@cox.net>
References: <56F7B77F.9050306@gmail.com>
	<pan$8fc2c$862a26c8$c5af9279$b4bfa8ec@cox.net> <56F9252F.90704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Mon, 28 Mar 2016 08:35:59 -0400 as
excerpted:

> The other caveat that nobody seems to mention outside of specific cases
> is that using suspend to disks exposes you to direct attack by anyone
> with the ability to either physically access the system, or boot an
> alternative OS on it.  This is however not a Linux specific issue
> (although Windows and OS X do a much better job of validating the
> hibernation image than Linux does before resuming from it, so it's not
> as easy to trick them into loading arbitrary data).

I believe that within the kernel community, it's generally accepted that 
physical access is to be considered effectively full root access,  
because there's simply too many routes to get root if you have physical 
access to practically control them all.  I've certainly read that.

Which is what encryption is all about, including encrypted / (via initr*) 
if you're paranoid enough, as that's considered the only effective way to 
thwart physical-access == root-access.

And even that has some pretty big assumptions if physical access is 
available, including that no hardware keyloggers or the like are planted, 
as that would let an attacker simply log the password or other access key 
used.  One would have to for instance use a wired keyboard that they kept 
on their person (or inspect the keyboard, including taking it apart to 
check for loggers), and at minimum visually inspect its connection to the 
computer, including having a look inside the case, to be sure, before 
entering their password.  Or store the access key on a thumbdrive kept on 
the person, etc, and still inspect the computer left behind for listening/
logging devices...

In practice it's generally simpler to just control physical access 
entirely, to whatever degree (onsite video security systems with tamper-
evident timestamping... kept in a vault, missile silo, etc) matches the 
extant paranoia level.

Tho hosting the swap, and therefore hibernation data, on an encrypted 
device that's setup by the initr* is certainly possible, if it's 
considered worth the trouble.  Obviously that's going to require jumping 
thru many of the same hoops that (as mentioned upthread) splitting the 
hibernate image between devices will require, as it generally uses the 
same underlying initr*-based mechanisms.  I'd certainly imagine the 
Snowden's of the world will be doing that sort of thing, among the 
multitude of security options they must take.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

