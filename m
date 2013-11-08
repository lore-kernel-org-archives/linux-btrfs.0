Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:30180 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444Ab3KHT4K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 14:56:10 -0500
Date: Fri, 08 Nov 2013 20:56:08 +0100
From: yzb3@wp.pl
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Odp: Re: Odp: Re: Odp: Btrfs might be gradually slowing the
 boot process
Message-ID: <527d41d89eebc3.25884342@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I will try doing that and report back if the boot time deteriorates again. I thought that was the default mount option - it definitely is on Arch, because this was the original mount option in fstab. My boot lags have begun when I was still mounting (probably remounting) root using fstab, though - but at that time i had no footflags in the kernel parameters.


