Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33418 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751538AbaEFUNT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 16:13:19 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: copies= option
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140504111238.197768d6@ws>
Date: Tue, 6 May 2014 14:13:12 -0600
Cc: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org,
        Hugo Mills <hugo@carfax.org.uk>, Russell Coker <russell@coker.com.au>
Message-Id: <89C69688-FB8A-4D74-ADE9-C38FFD778257@colorremedies.com>
References: <201405041216.54348.russell@coker.com.au> <pan$9bead$d5bbe620$2c7141f7$fab07860@cox.net> <xjTK1n01B308YdQ01jTMAf> <20140504111238.197768d6@ws>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> N-copies, M-device-stripe, P-parity-devices (NcMsPp)

At expense of being the terminology nut, who doesn't even like SNIA's chosen terminology because it's confusing, I suggest a concerted effort to either use SNIA's terms anyway, or push back and ask them to make changes before propagating deviant terminology.

Strip is a consecutive blocks on a single extent (on a single device)
Strip size is the number of blocks in a single extent (on a single device)

Stripe is a set of strips on each member extent (on multiple devices)
Stripe size is strip size times non-parity extents.

e.g. Btrfs default strip size is 64KiB, therefore a 5 disk raid5 volume stripe size is 256KiB. I use and specify size units in bytes rather than SNIAs blocks (sectors) because it's less ambiguous.

In other words, for M- what we care about is the strip size, which is what md/mdadm calls a chunk. We can't know the stripe size without knowing how many non-parity member devices there are.


Chris Murphy

