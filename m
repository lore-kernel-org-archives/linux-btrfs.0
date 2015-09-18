Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51290 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbbIRCWX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 22:22:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZclJd-00009e-Ej
	for linux-btrfs@vger.kernel.org; Fri, 18 Sep 2015 04:22:21 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 04:22:21 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 04:22:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS as image store for KVM?
Date: Fri, 18 Sep 2015 02:22:09 +0000 (UTC)
Message-ID: <pan$8e5ba$d0b208e1$ccdbec8$531e48c2@cox.net>
References: <55F88ECC.1040604@menke.ac>
	<pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net> <55FAFEB8.6030404@menke.ac>
	<20150917194314.GA29926@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Thu, 17 Sep 2015 19:43:14 +0000 as excerpted:

>> Is nodatacowbutkeepdatachecksums a feature that might turn up
>> in the future?
> 
> No. If you try doing that particular combination of features, you
> end up with a filesystem that can be inconsistent: there's a race
> condition between updating the data in a file and updating the csum
> record for it, and the race can't be fixed.

...  Which is both why btrfs disables checksumming on nocow, and why
more traditional in-place-overwrite filesystems don't normally offer a 
checksumming feature -- it's only easily and reliably possible with copy-
on-write, as in-place-overwrite introduces race issues that are basically 
impossible to solve.

Logging can narrow the race, but consider, either they introduce some 
level of copy-on-write themselves, or one way or another, you're going to 
have to write two things, one a checksum of the other, and if they are in-
place-overwrites, while the race can be narrowed, there's always going to 
be a point at which either one or the other will have been written, while 
the other hasn't been, and if failure occurs at that point...

The only real way around that is /some/ form of copy-on-write, such that 
both the change and its checksum can be written to a different location 
than the old version, with a single, atomic write then updating a pointer 
to point to the new version of both the data and its checksum, instead of 
the old one.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

