Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51826 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752837Ab3HDSuQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Aug 2013 14:50:16 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: building btrfs corrupt block
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130804184657.GB22967@carfax.org.uk>
Date: Sun, 4 Aug 2013 12:50:16 -0600
Cc: Hugo Mills <hugo@carfax.org.uk>
Message-Id: <1ACEF628-24F3-4124-AA1E-5A390D9BE28F@colorremedies.com>
References: <45469DAE-A90B-4E66-A03B-F35EBF92FDB8@colorremedies.com> <20130804184657.GB22967@carfax.org.uk>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 4, 2013, at 12:46 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Sun, Aug 04, 2013 at 12:39:28PM -0600, Chris Murphy wrote:
>> I must be doing something wrong, but I can't figure out what. I have btrfs-progs source installed from here:
>> http://koji.fedoraproject.org/koji/buildinfo?buildID=441375
>> 
>> make produces no errors. Yet btrfs-corrupt-block.c isn't built. Suggestions?
> 
> $ make btrfs-corrupt-block

*snicker* Lovely. Thanks. That worked.


Chris Murphy