Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:38659 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab3BLPa5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 10:30:57 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 164A49A0373
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 08:30:57 -0700 (MST)
Date: Tue, 12 Feb 2013 10:30:54 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Kaspar Schleiser <kaspar@schleiser.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clmason@fusionio.com>
Subject: Re: experimental raid5/6 code in git
Message-ID: <20130212153054.GA16687@shiny.masoncoding.com>
References: <20130202160212.GB4694@shiny>
 <511A5CE1.60309@schleiser.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <511A5CE1.60309@schleiser.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 12, 2013 at 08:16:49AM -0700, Kaspar Schleiser wrote:
> Hey Chris,
> 
> On 02/02/2013 05:02 PM, Chris Mason wrote:
> > Btrfs -- 604MB/s
> > MD    -- 162MB/s
> > 
> > 
> > MD -- 800MB/s very little system time
> > Btrfs -- 3.8GB/s one CPU mostly pegged
> 
> > Btrfs -- 380MB/s seen by fio
> > MD    -- 174MB/s seen by fio
> 
> > Creating 12 million files on Btrfs raid5 took 226 seconds, vs 485
> > seconds on MD.
> 
> Do I read these numbers incorrectly, or does even this first iteration
> of btrfs' raid5/6 code run circles around MD?

Yes and no.  Most of the differences were on flash, and really it just
looks like MD needs tuning for IO latency and concurrency.  There are
some MD patches for this recently to add more threads for parity
calculations, and these solve some throughput problems.

But one thing that we've proven with btrfs is that helper threads mean
more IO latencies.  So the MD code probably needs some short cuts to do
the parity inline as well.

-chris
