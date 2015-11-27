Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43194 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbbK0CCp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 21:02:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a28My-00074b-Jz
	for linux-btrfs@vger.kernel.org; Fri, 27 Nov 2015 03:02:40 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 03:02:40 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 03:02:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: subvols and parents - how?
Date: Fri, 27 Nov 2015 02:02:37 +0000 (UTC)
Message-ID: <pan$3a1c9$86b20059$6602684a$c91a5eb4@cox.net>
References: <1448340960.14125.51.camel@scientia.net>
	<pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
	<1448400350.21291.88.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Tue, 24 Nov 2015 22:25:50 +0100 as
excerpted:

>> Then there's the security angle to consider.  With the (basically,
>> possibly modified as I suggested) flat layout, mounting something
>> doesn't automatically give people in-tree access to nested subvolumes
>> (subject to normal file permissions, of course), like nested layout
>> does.  And with (possibly modified) flat layout, the whole subvolume
>> tree doesn't need to be mounted all the time either, only when you're
>> actually working with subvolumes.

> Uhm, I don't get the big security advantage here... whether nested or
> manually mounted to a subdir,... if the permissions are insecure I'll
> have a problem... if they're secure, than not.

Consider a setuid-root binary with a recently publicized but patched on 
your system vuln.  But if you have root snapshots from before the patch 
and those snapshots are nested below root, then they're always 
accessible.  If the path to the vulnerable setuid is as user accessible 
as it likely was in its original location, then anyone with login access 
to the system is likely to be able to run it from the snapshot... and 
will be able to get root due to the vuln.

On a flat layout, a snapshot with the vuln would have to be mounted 
before it could be accessed, as otherwise it'd be outside the mounted 
tree.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

