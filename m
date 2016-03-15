Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51782 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbcCOAtO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 20:49:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1afdAe-0002KT-8c
	for linux-btrfs@vger.kernel.org; Tue, 15 Mar 2016 01:49:12 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 01:49:12 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 01:49:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: dedup and receive -p
Date: Tue, 15 Mar 2016 00:49:06 +0000 (UTC)
Message-ID: <pan$107ae$106a86dc$2e999292$282894b@cox.net>
References: <CAFENT7Ky+DXPSvKmMHcSW4+Nu2Fb0sAu_yZ4DPgNhHQ3bHO0jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sylvain Joyeux posted on Mon, 14 Mar 2016 09:39:51 -0300 as excerpted:

> I was trying to find a definitive information about this, but could not
> ...
> 
> AFAIK,  defrag breaks CoW and send/receive -p. I was wondering whether
> deduplication would break it too, i.e. if doing a send/receive to
> transfer a subvolume, running dedup, and then using said subvolum as a
> parent with send -p would work or not.

I believe it would... if done as you posted.  But this seems blindingly 
obvious to me so I think either the scenario you posted didn't actually 
match what you intended in your head, or there's a misunderstanding on 
either your part or mine.

The better method would be to do the dedup, take a read-only snapshot of 
the subvolume, send/receive it (of course send/receive already works with 
snapshots, but this is making it explicit), and keep that snapshot around 
to do the later send -p from.

You could then continue using the subvolume itself without worrying about 
changing it in ways incompatible with send -p, because you'd be changing 
the subvolume, not the read-only snapshot you took of it for the send, 
which would remain unchanged and thus could be used as the basis of a 
later send -p without a problem.

But like I said using the read-only snapshot for both the original send 
and as the parent in the later send -p seems blindingly obvious to me, so 
I think somewhere along the line some signals got crossed and I'm not 
sure if you didn't write what you actually intended, or if either you or 
I misunderstood something somewhere along the line.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

