Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:39675 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab3KTVi3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 16:38:29 -0500
MIME-Version: 1.0
In-Reply-To: <20131119181237.GA3666@lazy.lzy>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<20131119181237.GA3666@lazy.lzy>
Date: Wed, 20 Nov 2013 22:38:28 +0100
Message-ID: <CAGKKSfWZD0N53+NCsYjk-LCYMCTFvqL9sqNq0Og4AHiw9H2Mrw@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Piergiorgio,

> In RAID-6 (as per raid6check) there is an easy way
> to verify where an HDD has incorrect data.
> I suspect, for each 2 parity block it should be
> possible to find 1 error (and if this is true, then
> quad parity is more attractive than triple one).
Yes. The theory say that with quad parity is possible to find 2
errors. Or find 1 error when running in degraded mode with 2 missing
disks.

But yep, the problem is how to do in a fast way. I don't know enough
the field to answer this.

Ciao,
Andrea
