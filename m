Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59026 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbbDSD4s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Apr 2015 23:56:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YjgLd-000880-Q7
	for linux-btrfs@vger.kernel.org; Sun, 19 Apr 2015 05:56:45 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2015 05:56:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2015 05:56:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how to clone a btrfs filesystem
Date: Sun, 19 Apr 2015 03:56:40 +0000 (UTC)
Message-ID: <pan$b5546$9e29a1d1$1032ca34$a50adf64@cox.net>
References: <1429312124.8371.62.camel@scientia.net>
	<201504180424.40385.russell@coker.com.au>
	<1429334269.8371.75.camel@scientia.net>
	<201504190102.42660.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sun, 19 Apr 2015 01:02:42 +1000 as excerpted:

>> Some additional questions:
>> a) Can btrfs send change anything(!) on the source fs?
>> b) Can one abort (Ctrl-C) a send and/or receive... and make it continue
>> at the same place were it was stopped?
> 
> A yes, B I don't know.

More directly on A, btrfs send creates a read-only snapshot and sends it, 
so the filesystem isn't changing out from under it as it sends.  So 
that's what it changes on the source filesystem.  AFAIK, nothing else.

For B, my use-case doesn't include send/receive, so I don't know, 
directly, either.  But due to the way it works, assuming an aborted send/
receive doesn't get automatically cleaned up (I simply don't know that, 
and I'm not bothering to look it up, but it should be documented if it 
does), it should at minimum be possible to include the aborted version as 
a parent or reference on each end, such that if any data was sent in the 
aborted send/receive, it shouldn't have to be sent again, only a metadata 
reference to it will need to be sent.

> Also I'm not personally inclined to trust send/recv at this time.  I
> don't think it's had a lot of testing.

Based on posts from people using it here, as well as watching the 
patches, etc, going by, I'd say that given a send/receive that has 
completed without error, it should be reliably golden.  There continue to 
be various corner-case bugs where it doesn't always work, but in that 
case it should reliably error on one side or the other.

A very simple example of the type of corner-case that still causes 
problems, tho this one should work, it's the much more complex ones that 
sometimes don't, is where the original filesystem had /dir/suba/subb/, 
but that nesting was reversed to /dir/subb/suba/.  That's the general 
sort of thing that can still cause problems, altho simple example 
shouldn't, but obviously, it can only be a problem on later incrementals 
that reference a parent with a tree that has "gone inside out", so to 
speak, since the parent send.

But again, if the process works without error on both sides, then the 
result should be golden, barring of course a serious regression bug.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

