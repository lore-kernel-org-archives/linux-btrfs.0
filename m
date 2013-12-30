Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47393 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752800Ab3L3Ai0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Dec 2013 19:38:26 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: systemd-journal, nodatacow, was: Is anyone using btrfs send/receive for backups instead of rsync?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$ac557$b59f1c0a$eeb339c8$e2df444@cox.net>
Date: Sun, 29 Dec 2013 17:38:23 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <9B8C24F7-2F6C-4879-9A21-6A6D940BE4C1@colorremedies.com>
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk> <CAELSAVa=oVzrLnSSk+vnKQF46F7U5n6o8Nw9VGXkPQNCR2SVsA@mail.gmail.com> <CABR0jES_40xmVxi21+VUMzT_2ZuFWs9kUPfZAPZODq0rWrB0ug@mail.gmail.com> <CAELSAVY+J1GYuRDHwUZ882OVchqXk9ES9EJp89HQofC8m00uaQ@mail.gmail.com> <CABR0jERWpte3DAk+JCaybeGYRBtmUKEOoUzfAe=uC+k7KfdeQg@mail.gmail.com> <EF26DC97-2362-4C53-8B5F-4763A33375EC@colorremedies.com> <pan$ac557$b59f1c0a$eeb339c8$e2df444@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 29, 2013, at 5:39 AM, Duncan <1i5t5.duncan@cox.net> wrote:

> Yes, it does turn off checksumming as well as COW, but given the write-
> into scenario, that's actually best anyway, because otherwise btrfs has 
> to keep updating the checksums

On second thought, I'm less concerned with bitrot and checksumming being lost with nodatacow, than I am with significantly increasing the chance the journal is irreparably lost due to corruption during an unclean shutdown.


> But in all these cases, it's also quite common for the application doing 
> the writing to have its own checksumming/error-detection and possible 
> correction -- it pretty much comes with the territory -- in which case 
> btrfs attempting to do the same is simply superfluous even if it weren't 
> a race-condition trigger.

I don't know what kind of checksumming systemd performs on the journal, but whenever Btrfs has found corruption with the journal file(s), systemd-journald has also found corruption and starts a new log. So it makes sense to rely on its own mechanisms, than Btrfs's.

> And I'm predicting that since btrfs is the assumed successor to the ext* 
> series as the Linux default filesystem, and systemd is targeting Linux 
> default initsystem status as well, it's only logical that at some point 
> systemd will detect what filesystem it's logging to, and will 
> automatically set NOCOW on the journal file when that filesystem is 
> btrfs. 

Is this something that should be brought up on the systemd-devel@ list? Or maybe file it as an RFE against systemd at freedesktop.org?

Chris Murphy