Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51474 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbbHCT0r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Aug 2015 15:26:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZMLNl-0000Xs-SM
	for linux-btrfs@vger.kernel.org; Mon, 03 Aug 2015 21:26:46 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 21:26:45 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 21:26:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
Date: Mon, 3 Aug 2015 19:26:35 +0000 (UTC)
Message-ID: <pan$e7ee0$9d28e5c7$47347d3e$4171406f@cox.net>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
	<pan$73c92$81fb65b9$3c60e540$cb422e6a@cox.net>
	<CAP5+4qfi4UdfMmNdC2XizTG0au-btnKBqSmg1rUaW=EJApZkmA@mail.gmail.com>
	<CAP5+4qdmjkniaoY6+FCL4OTAYQjpU=DOWBRv-3FkEvFN=TAeRw@mail.gmail.com>
	<20150803152835.GF14352@carfax.org.uk>
	<CAP5+4qfmXdMvBaVK1KqUfBRfM447ASJ4U0OqRxhsOw2r4WE1fQ@mail.gmail.com>
	<CAP5+4qd2-kKEG5y2gEphQ=5A4+B+=2teMxiZJc-vDHZ1_-t8OQ@mail.gmail.com>
	<CAP5+4qceVW2JbAteuRQUK+5mdwWcp8fF0QUk6Q87nqCw5P5wRw@mail.gmail.com>
	<CAP5+4qfLEqvGQhCkzQWPLy-dtAS7GjSfDy5Oo=6OXL1zohrc=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sonic posted on Mon, 03 Aug 2015 12:32:21 -0400 as excerpted:

> Are either one of these called for?
> 
> btrfs check --repair or btrfs check --repair --init-csum-tree
> 
> Seems like they might be a last ditch attempt. Is one preferred over the
> other?

The read-only check (without --repair) couldn't read the chunk tree, so 
check --repair probably should run into the same issue and not be able to 
do anything as well.

check --init-csum-tree reinitializes the checksums, but to do that you 
have to have something to reinitialize on, so that's unlikely to do 
anything, either.  (I did have that in mind as a possibility after the 
superblock recovery and chunk-recover operations, tho, if necessary.  
That's why I mentioned check at the end.  But the message was long enough 
already and that would have been getting ahead of things, so...)

> Is:
> btrfs rescue chunk-recover a much less dangerous attempt (IOW it wont
> hurt to try it first)?

I'd not call it less dangerous, but given that the chunk tree can't be 
read, you're already dealing with dangerous.  That's what I'd try here 
(tho Hugo's suggesting it won't help has me doubting, but that's where 
things do point from what I see).

Which is why I mentioned doing a raw device backup, before attempting 
it.  Chunk-recover is pretty invasive, and if it doesn't work, it could 
make the filesystem unrecoverable.  It's basically a one-shot deal.  A 
raw device backup can be used to avoid it being one-shot, but of course 
that does require that you have enough devices of sufficient size to 
backup to, which certainly in the terabyte range, is a potential problem 
unless you're a big-budget corporate user with a stack of spare devices 
on hand.

I believe Hugo's right on zero-log, tho.  That's a fix for a very 
specific situation, seen most often due to a specific bug that was short 
lived and has been fixed for quite some time, now, tho in certain very 
narrow post-crash situations the same fix has been known to work too.  
There's no evidence you're anywhere near that very specific situation, so 
zero-log's just not the tool for this job.  And it could make things 
slightly worse, too, tho in theory at least, all you're doing is cutting 
off the last 30 seconds or so of activity, so the chances of it doing 
major harm are small, unless you were actively rebalancing or something 
when the filesystem was last unmounted (gracefully or not).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

