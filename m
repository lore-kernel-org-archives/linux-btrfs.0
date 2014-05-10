Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33208 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751318AbaEJQfP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 12:35:15 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140510135153.GE9276@merlins.org>
Date: Sat, 10 May 2014 10:34:38 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <00D71C65-1992-4E89-874E-AA7772497DAA@colorremedies.com>
References: <2678329.EOSaIZaHNO@quad> <0AE72D68-224C-4B12-9C9B-3B7628174ACB@colorremedies.com> <20140510004254.GB9276@merlins.org> <20140510010518.GP16185@carfax.org.uk> <2AB0814E-BFF4-47A9-832F-2DED825E5763@colorremedies.com> <20140510135153.GE9276@merlins.org>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 10, 2014, at 7:51 AM, Marc MERLIN <marc@merlins.org> wrote:

> Note that in my case, I wasn't trying to run linux inside vbox, just to
> start a win7 vm guest on my linux laptop.
> Is that a case that also is known to cause problems?

No, the host experiences no issues, although in my case the host is OS X so it's a completely different kernel. I don't think they're related. Mine was just an example of tainted kernel correlating to some other problem, while not known (yet) to be causation the source of the taintedness is suspect.

https://www.virtualbox.org/ticket/13022


Chris Murphy

