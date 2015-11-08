Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46768 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbbKHVeN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 8 Nov 2015 16:34:13 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZvXbH-0005Sp-9O
	for linux-btrfs@vger.kernel.org; Sun, 08 Nov 2015 22:34:11 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Nov 2015 22:34:11 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Nov 2015 22:34:11 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: cannot mount btrfs volume read/write (+task blocked backtrace)
Date: Sun, 8 Nov 2015 21:34:06 +0000 (UTC)
Message-ID: <pan$3ffdf$6a78c0ef$7e29cbf3$bd815572@cox.net>
References: <1088210322.2591.1446934834083.JavaMail.zimbra@grelot.net>
	<1330727605.2639.1446965139494.JavaMail.zimbra@grelot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Frédéric Grelot posted on Sun, 08 Nov 2015 07:45:39 +0100 as excerpted:

> After 8 hours, "btrfs check --readonly" is still "checking quota
> groups". It does not have any IO activity, but uses 100% CPU.
> #top
>  1143 root      20   0 2266596 2.148g   1124 R 100.0 56.0 183:37.14
>  btrfs check --readonly /dev/sda1
> 
> I am not sure what to do : if you have no idea, since I have less than
> 3Tb of data I will just manually degrade the volume by removing one of
> the disk, build a new btrfs on it, copy the data since I can still open
> the old one RO, then manually take devices from the old volume to new
> new one (converting to raid1 first, then raid6).

Ahh... quotas.  Devs are working very hard on them, but to this point 
quotas have never really worked /correctly/, and the estimate as to when 
they might... seems to always remain a couple kernel cycles out.

So my recommendation continues to be, either you really need quotas and 
thus should use a filesystem where they are known to be mature and 
stable, or you don't, and btrfs is an option, but don't enable quotas and 
avoid the problems they cause.  Unless of course you're specifically 
working with the devs to debug and fix current functionality and don't 
mind loosing a filesystem or two in the process as a result, in which 
case, THANK YOU for helping to stabilize the feature for everyone, 
however long it might take. 

As for when it might be safe to enable them, at this point, with the 
quota history we have, I'd suggest waiting at least two kernel cycles 
after all known quota issues have been fixed.  But whether that's 4.6 or 
5.6 (with roughly 5 releases per year and a assuming another major 
version bump at what would be .20, in keeping with the precedent set with 
the 3.x series, it's roughly two years per major version kernel cycle, so 
5.6 would be around 1Q2018) or 6.6... who can tell, until it happens?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

