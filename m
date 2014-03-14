Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40110 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbaCNT6D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 15:58:03 -0400
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Samuel <chris@csamuel.org>, Duncan <1i5t5.duncan@cox.net>,
        Christopher Corsi <cjmovie@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: discard synchronous on most SSDs?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1756989.4ep0Vdupld@tethys> <20140309113350.GH6318@carfax.org.uk>
	<20140314021159.GQ18959@merlins.org>
	<C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com>
	<20140314051750.GY6143@merlins.org>
	<pan$667da$c4955705$c59674a0$a844850c@cox.net>
	<531C1CC4.701@gmail.com>
	<C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com>
	<20140314051750.GY6143@merlins.org> <5289248.oqpgSKG6td@quad>
	<20140314192605.GD6143@merlins.org>
Date: Fri, 14 Mar 2014 15:57:41 -0400
In-Reply-To: <20140314192605.GD6143@merlins.org> (Marc MERLIN's message of
	"Fri, 14 Mar 2014 12:26:05 -0700")
Message-ID: <yq1bnx8y2mi.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Marc" == Marc MERLIN <marc@merlins.org> writes:

Marc,

Marc> So I have Sata 3.1, that's great news, it means I can keep using
Marc> discard without worrying about performance and hangs

The fact that the drive reports compliance with a certain version of
SATA does not in any way imply that it implements all commands defined
in that specification.

The location where queued TRIM support is reported is somewhat unusual.
And last I looked hdparm -I had no infrastructure in place to report
stuff contained in log pages.

The kernel does look the right place to determine whether to issue the
queued or unqueued variant or not. But the information isn't exported to
userland.

So right now I'm afraid we don't have a good way for a user to determine
whether a device supports queued trims or not.

I guess we could consider either adding an ATA-specific "I don't suck"
flag in sysfs, add the missing code to hdparm, or both...

-- 
Martin K. Petersen	Oracle Linux Engineering
