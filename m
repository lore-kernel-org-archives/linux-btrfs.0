Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50447 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758752AbcALCS6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 21:18:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aIoXs-0004uD-OP
	for linux-btrfs@vger.kernel.org; Tue, 12 Jan 2016 03:18:52 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 03:18:52 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 03:18:52 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
Date: Tue, 12 Jan 2016 02:18:42 +0000 (UTC)
Message-ID: <pan$f2df8$647854de$65599d89$3a8d489b@cox.net>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
	<CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
	<CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
	<CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
	<CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
	<CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
	<20160109202659.GC6060@carfax.org.uk>
	<CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
	<20160109210429.GD6060@carfax.org.uk>
	<CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
	<5693A8B3.2090508@gmail.com>
	<CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com>
	<CA+9GZUg-6WrQTgCw_AmVb2qqr4aL4xeWH6mSq1zQ14qbxextzA@mail.gmail.com>
	<CA+9GZUgb=h9_t5fXH-qP_-MwKkoN4xLhhYNnCthccA114+KaeQ@mail.gmail.com>
	<CA+9GZUg4GxhnmQfUKN0c-5FWDmaGWDO78t83QdpMQcEhcUQARQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cheater00 . posted on Mon, 11 Jan 2016 15:04:42 +0100 as excerpted:

> I noticed that every time Data gets bumped, it only gets bumped by a
> couple GB. I rarely ever store files on that disk that are larger than 2
> GB, But the last time it crashed, I was moving a file that was 4.3 GB,
> so maybe that's conductive to the crash happening? Maybe the file being
> larger than what btrfs would allocate has something to do with this. I
> will keep track of the amount of data since last crash, and the file
> size when the crash occured.

See my just completed post to a different subthread of this now rather 
large thread, where I describe my experience with this bug.  The bug 
seems to be related to chunk creation, and those chunks are 1-10 GiB in 
size, depending on factors such as the size of the filesystem, chunk mode 
(raidx vs single or dup), etc.

Assuming your filesystem is creating 2 GiB data chunks and that existing 
chunks are close to full, a 4.3 GiB file would likely force creation of 
two such chunks, which, other factors being equal, would give it twice 
the chance of failure as attempting to copy a smaller file that only 
forces creation of one such chunk.  Similarly, attempting to copy 
(perhaps using --reflink=never or copying in from a different filesystem 
to insure that it's actually copying the data, not just reflinking it) a 
really large file of 10+ GiB would be several times more likely to fail, 
while attempting to copy files of under say half a GiB in size would most 
of the time succeed, since they'd be rather unlikely to force creation of 
a new data chunk.

[And again, as requested elsewhere, please reply inline in quote-context, 
under the part of the quote providing the context for what you're 
replying to, instead of above, out of context.  It makes both reading in 
context, and further replies in context, /so/ much easier.]

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

