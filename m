Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52513 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757801AbcASJjN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 04:39:13 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aLSkp-0006g7-V1
	for linux-btrfs@vger.kernel.org; Tue, 19 Jan 2016 10:39:12 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 10:39:11 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 10:39:11 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS: bdev /dev/mapper/dshelf1 errs: wr 2970, rd 848, flush 0,
 corrupt 189, gen 0
Date: Tue, 19 Jan 2016 09:39:06 +0000 (UTC)
Message-ID: <pan$e0095$a14e90a4$23be3f21$9c2ce6e8@cox.net>
References: <20160118124533.GU422@carfax.org.uk>
	<20160118233943.GF17679@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Mon, 18 Jan 2016 15:39:43 -0800 as excerpted:

> On Mon, Jan 18, 2016 at 03:21:53AM +0000, Duncan wrote:
>> No.  Those are monotonically increasing counts that are never
>> automatically reset over the life of the filesystem.  Use ...
>> 
>> btrfs dev stats
>> 
>> ... to display them on the commandline (vs. the kernel log at
>> filesystem mount), with the -z option to reset them after display, if
>> desired.
> 
> It's a bit counter intuitive that check --repair doesn't reset error
> counts if it fixed underlying errors, but maybe there is a good reason
> :)

The idea is, I believe, that a new admin/tech or someone who hasn't been 
paying attention can get a quick idea of where the problems have been and 
may well still be, by looking at the error counts built up over the 
lifetime of the filesystem.  An admin who is paying attention, meanwhile, 
can always deliberately zero out the error counts once they've fixed 
whatever was causing the problem triggering the errors in the first place.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

