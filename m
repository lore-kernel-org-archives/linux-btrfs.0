Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53585 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbbL3S0s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 13:26:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aELSP-00058u-QE
	for linux-btrfs@vger.kernel.org; Wed, 30 Dec 2015 19:26:45 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Dec 2015 19:26:45 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Dec 2015 19:26:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Confining scrub to a subvolume
Date: Wed, 30 Dec 2015 18:26:39 +0000 (UTC)
Message-ID: <pan$88aff$ee7e2e75$cb54e003$bedb8f3a@cox.net>
References: <56831EA2.3090807@totakura.in>
	<20151230173949.GH4227@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Wed, 30 Dec 2015 18:39:49 +0100 as excerpted:

> On Wed, Dec 30, 2015 at 01:00:34AM +0100, Sree Harsha Totakura wrote:
>> Is it possible to confine scrubbing to a subvolume instead of the whole
>> file system?
> 
> No. Srub reads the blocks from devices (without knowing which files own
> them) and compares them to the stored checksums.

Of course if like me you prefer not to have all your data eggs in one 
filesystem basket and have used partitions (or LVM) and multiple 
independent btrfs, in which case you scrub the filesystem you want, and 
don't worry about the others. =:^)

It definitely helps with maintenance time -- on SSDs with all under 50 
GiB partitions, scrub times per btrfs are typically under a minute, and 
btrfs check and balance times are similarly short.  Plus, arranging to 
have additional partitions exactly the same size to use as backups works 
pretty nicely as well.  =:^)  OTOH, people routinely report days for 
multi-terabyte btrfs maintenance commands on spinning rust. =:^(

Tho I do still have my media partition, along with backups, on reiserfs 
on spinning rust.  I should think about switching that over one of these 
days...

>> [...]  Therefore, I would like to scrub the photos and documents
>> subvolumes more often than the backups subvolume.  Would this be
>> possible with the current tools?
> 
> The closest would be to read the files and look for any reported errors.

That should work.  Cat the files to /dev/null and check dmesg.  For 
single mode it should check the only copy.  For raid1/10 or dup, running 
two checks, ensuring one is even-PID while the other is odd-PID, should 
work to check both copies, since the read-scheduler assigns copy based on 
even/odd PID.  Errors will show up in dmesg, as well as cat's STDERR.

Pretty clever thinking there. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

