Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from manchmal.in-ulm.de ([217.10.9.201]:44528 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbcAITFU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jan 2016 14:05:20 -0500
Date: Sat, 9 Jan 2016 20:05:16 +0100
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: send/receive for encrypted backup purposes
Message-ID: <1452365502@msgid.manchmal.in-ulm.de>
References: <1827847.pVfOzZHEoP@merkaba>
 <568FCF45.1060007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <568FCF45.1060007@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn wrote...

> (...) If you only ever
> need to access the device locally on the network served by the router
> however, I'd actually suggest ATAoE over iSCSI or NBD, it's a lot more
> efficient and technically more secure because it's non-routable (it runs
> directly over the link layer, which means you avoid the overhead of IP and
> TCP, and has the added advantage that you technically don't need anything
> but the kernel driver on the client side).

Although pretty offtopic ... AoE is not routable but don't sell this
as a security feature. If you cannot configure ACLs, you're doomed
anyway. The only security model AoE provides is the client's MAC
address but spoofing is really not a problem.

So in short:

* AoE is really simple to set up but if there's even a remote chance
  some evil guy is in your network (i.e. ethernet broadcast domain),
  just forget it. Also AoE completely relies on the ethernet checksums
  to detect data curruption, and I had some funny experiences because
  of that.

* NBD has (or had the last time I checked some 15 months ago) some
  serious issues on client side if the server becomes unavailable,
  including data loss. Yes, I should debug this one day.

* iSCSI probably provides everything you want. At the price of having
  to understand how to set it up. I failed several times and
  eventually gave up, your mileage may vary.

    Christoph
