Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:46458 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab2KAK4U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 06:56:20 -0400
Date: Thu, 1 Nov 2012 11:56:18 +0100
From: Sander <sander@humilis.net>
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Need help mounting laptop corrupted root btrfs. Kernel BUG at
 fs/btrfs/volumes.c:3707 - FIXED
Message-ID: <20121101105618.GA19415@panda>
Reply-To: sander@humilis.net
References: <E1TTCzR-0001nz-1p@gandalfthegreat.merlins.org>
 <20121030144914.GA18659@merlins.org>
 <20121029154713.GF8019@merlins.org>
 <B19885DE-6AED-4B8B-B1CA-891878B43C8C@colorremedies.com>
 <20121029174802.GB7796@merlins.org>
 <20121030154608.GA19231@merlins.org>
 <20121031092440.GA31209@panda>
 <20121031154056.GE3290@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121031154056.GE3290@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN wrote (ao):
> That said, it's working fine again for now after I went back to kernel 3.5.3 
> (down from 3.6.3). It hasn't been long enough to say for sure, but there is
> a remote possibility that changes in 3.6 actually caused my drive to freeze
> after several hours of use.
> When that happened (3 times), 2 of those times, btrfs did not manage to
> write all its data before access was cutoff, and I got the bug I reported
> here, which in turn crashes any kernel you try to mount the FS with.
> Cleaning the log manually fixed it both times so far.
> 
> For now, I'll stick with 3.5.3 for a while to make sure my drive is actually
> ok (it seems to be afterall), and once I'm happy that it's the case, I'll go
> back to 3.6.3 with serial console remote logging and try to capture the full
> sata failure I got with 3.6.3.

Thanks for the info. You could put some load on the ssd to see if you
can trigger an issue under 3.6.3(+) with btrfs filesystem scrub or
badblocks (in the default non-destructive mode).

Can you collect SMART data (with smartctl) from the ssd?

	Sander
