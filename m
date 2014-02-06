Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34976 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbaBFCjA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 21:39:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WBErh-0005sS-F8
	for linux-btrfs@vger.kernel.org; Thu, 06 Feb 2014 03:38:57 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 03:38:57 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 03:38:57 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Are nocow files snapshot-aware
Date: Thu, 6 Feb 2014 02:38:32 +0000 (UTC)
Message-ID: <pan$9252f$8363907a$3eaa17a6$f558018@cox.net>
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de> <52F1923D.8090306@fb.com>
	<20140205020239.GP1364@twin.jikos.cz> <6qbasa-fq1.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Wed, 05 Feb 2014 19:17:10 +0100 as excerpted:

> David Sterba <dsterba@suse.cz> schrieb:
> 
>> On Tue, Feb 04, 2014 at 08:22:05PM -0500, Josef Bacik wrote:
>>> On 02/04/2014 03:52 PM, Kai Krakow wrote:
>>> >Hi!
>>> >
>>> >I'm curious... The whole snapshot thing on btrfs is based on its COW
>>> >design. But you can make individual files and directory contents
>>> >nocow by applying the C attribute on it using chattr. This is usually
>>> >recommended for database files and VM images. So far, so good...
>>> >
>>> >But what happens to such files when they are part of a snapshot? Do
>>> >they become duplicated during the snapshot? Do they become unshared
>>> >(as a whole) when written to? Or when the the parent snapshot becomes
>>> >deleted?
>>> >Or maybe the nocow attribute is just ignored after a snapshot was
>>> >taken?
>>> >
>>> When snapshotted nocow files fallback to normal cow behaviour.
>> 
>> This may seem unclear to people not familiar with the actual
>> implementation, and I had to think for a second about that sentence.
>> The file will keep the NOCOW status, but any modified blocks will be
>> newly allocated on the first write (in a COW manner), then the block
>> location will not change anymore (unlike ordinary COW).
> 
> Ah okay, that makes it clear. So, actually, in the snapshot the file is
> still nocow - just for the exception that blocks being written to become
> unshared and relocated. This may introduce a lot of fragmentation but it
> won't become worse when rewriting the same blocks over and over again.

That also explains the report of a NOCOW VM-image still triggering the 
snapshot-aware-defrag-related pathology.  It was a _heavily_ auto-
snapshotted btrfs (thousands of snapshots, something like every 30 
seconds or more frequent, without thinning them down right away), and the 
continuing VM writes would nearly guarantee that many of those snapshots 
had unique blocks, so the effect was nearly as bad as if it wasn't NOCOW 
at all!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

