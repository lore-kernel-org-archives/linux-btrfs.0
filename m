Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36164 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab3KTVVk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 16:21:40 -0500
MIME-Version: 1.0
In-Reply-To: <528D0694.3060703@zytor.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<528B3A6F.2010304@hesbynett.no>
	<CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>
	<528C8F8E.9030908@hesbynett.no>
	<CAGKKSfV+TyONu0EgSy9r5k7SiP5ZM3n7pGajY62DBSBw6YvR+w@mail.gmail.com>
	<1fe6f763-a5a4-4cc7-b23d-7928b0925f09@email.android.com>
	<CAGKKSfV-jie=6X+DuJJB6L7AdW4f83bQofYHBHwuuZvV+6mUxg@mail.gmail.com>
	<528D0694.3060703@zytor.com>
Date: Wed, 20 Nov 2013 22:21:38 +0100
Message-ID: <CAGKKSfUXf0N8YtYv1g=VRqjuKt4p9F7o1XVRAFydOrO=aDZiZg@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Brown <david.brown@hesbynett.no>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Peter,

> Now, that doesn't sound like something that can get neatly meshed into
> the Cauchy matrix scheme, I assume.
You are correct. Multiplication by 2^-1 cannot be used for the Cauchy method.

I used it to implement an alternate triple parity not requiring PSHUFB
that I used as reference for performance evaluation of the Cauchy way,
assuming that this implementation using powers of 1,2,2^-1 is the
fastest possible one.

Hopefully the difference is minimal, and the Cauchy method is
competitive even at triple parity.

Ciao,
Andrea
