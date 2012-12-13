Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:60081 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097Ab2LMWHa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Dec 2012 17:07:30 -0500
Date: Thu, 13 Dec 2012 17:07:27 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: David Sterba <dave@jikos.cz>
CC: Chris Mason <clmason@fusionio.com>, Pascal Junod <pascal@junod.info>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [btrfs] is vulnerable to a hash-DoS attack
Message-ID: <20121213220727.GC27308@shiny>
References: <50C9D085.3020305@junod.info>
 <20121213205208.GA27308@shiny>
 <20121213213430.GB22426@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121213213430.GB22426@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 13, 2012 at 02:34:30PM -0700, David Sterba wrote:
> On Thu, Dec 13, 2012 at 03:52:08PM -0500, Chris Mason wrote:
> > Thanks for taking the time to write this up.  As far as I can tell, the
> > looping was actually fixed in an older kernel and I just misread our
> > version string in your original email.
> 
> Yeah, the blogpost says 3.3.7. I did a quick test with 3.7 and was not
> able to reproduce it.

I tried with 3.3 and every step between 3.3 and 3.7.  I'm not able to
reproduce the problem, and I did run with Hack=True in the script
(thanks for the flag btw, I really like that).

So, that leaves us with a few possibilities:

1) mount -o seclabel
2) The small size of the device
3) loopback

I ran with a 1GB FS here on 3.3 and wasn't able to trigger things.  But
Pascal, could you please help narrow the problem down?

-chris

