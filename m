Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45884 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbbLVJMs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 04:12:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBIzt-0005Zg-1q
	for linux-btrfs@vger.kernel.org; Tue, 22 Dec 2015 10:12:45 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 10:12:45 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 10:12:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: dear developers, can we have notdatacow + checksumming, plz?
Date: Tue, 22 Dec 2015 09:12:26 +0000 (UTC)
Message-ID: <pan$b5e12$31be6ea6$fd54b60e$5d72fa7a@cox.net>
References: <1450069158.2388.72.camel@scientia.net>
	<566ECF41.10709@gmail.com> <1450149311.701.126.camel@scientia.net>
	<56703928.7070003@gmail.com> <1450318197.6242.170.camel@scientia.net>
	<56780042.5060307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Mon, 21 Dec 2015 08:36:02 -0500 as
excerpted:

> On 2015-12-16 21:09, Christoph Anton Mitterer wrote:

>> On Tue, 2015-12-15 at 11:00 -0500, Austin S. Hemmelgarn wrote:

>>> nodatacow only [avoids fragmentation] if the file is
>>> pre-allocated, if it isn't, then it still ends up fragmented.

>> Hmm is that "it may end up fragmented" or a "it will definitely? Cause
>> I'd have hoped, that if nothing else had been written in the meantime,
>> btrfs would perhaps try to write next to the already allocated blocks.

> If there are multiple files being written, then there is a relatively
> high probability that they will end up fragmented if they are more than
> about 64k and aren't pre-allocated.

Does the 30-second-by-default commit window (and similarly 30-second-
default dirty-flush-time at the VFS level) modify this at all?  It has 
been my assumption that same-file writes accumulated during this time 
should merge, increasing efficiency and decreasing fragmentation (both 
with and without nocow), tho of course further writes outside this 30-
second window will likely trigger it, if other files have been written in 
parallel or in the mean time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

