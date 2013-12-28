Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54902 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751037Ab3L1XLj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Dec 2013 18:11:39 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:63250 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Vx32g-003rJl-7x
	for linux-btrfs@vger.kernel.org; Sat, 28 Dec 2013 16:11:38 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CABR0jERWpte3DAk+JCaybeGYRBtmUKEOoUzfAe=uC+k7KfdeQg@mail.gmail.com>
Date: Sat, 28 Dec 2013 16:11:37 -0700
Message-Id: <EF26DC97-2362-4C53-8B5F-4763A33375EC@colorremedies.com>
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk> <CAELSAVa=oVzrLnSSk+vnKQF46F7U5n6o8Nw9VGXkPQNCR2SVsA@mail.gmail.com> <CABR0jES_40xmVxi21+VUMzT_2ZuFWs9kUPfZAPZODq0rWrB0ug@mail.gmail.com> <CAELSAVY+J1GYuRDHwUZ882OVchqXk9ES9EJp89HQofC8m00uaQ@mail.gmail.com> <CABR0jERWpte3DAk+JCaybeGYRBtmUKEOoUzfAe=uC+k7KfdeQg@mail.gmail.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 28, 2013, at 1:34 PM, Richard Michael <rmichael@edgeofthenet.org> wrote:
> 
> Is the journal on the received side useless?

In my case, I'm unable to reproduce the problem. I get the same sha256sum of an existing 16M journal file (in the read only snapshot) as I do in the send/received snapshot. The difference is the original is compromised of 1976 extents, while the received is in a single extent.

This is kernel 3.12.5-301.fc20 and btrfs-progs 3.12.

I am slightly bugged about a 16MB file having nearly 2000 extents, basically it's being turned into a bunch of 8KB fragments. I know nothing of the pros and cons of how systemd is writing journals, but they don't seem very big so I don't understand why they're preallocated, which on btrfs appears instantly defeated by COW upon the journal being modified. It seems to me either the journal doesn't need to be preallocated (at least on btrfs) or maybe systemd should set xattr +C on /var/log/journal? That does disable checksumming though, along with data cow.


Chris Murphy

