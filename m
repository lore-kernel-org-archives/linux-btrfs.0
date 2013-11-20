Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45750 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KTSey (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 13:34:54 -0500
MIME-Version: 1.0
In-Reply-To: <528C8F8E.9030908@hesbynett.no>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<528B3A6F.2010304@hesbynett.no>
	<CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>
	<528C8F8E.9030908@hesbynett.no>
Date: Wed, 20 Nov 2013 19:34:53 +0100
Message-ID: <CAGKKSfV+TyONu0EgSy9r5k7SiP5ZM3n7pGajY62DBSBw6YvR+w@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: David Brown <david.brown@hesbynett.no>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

>> The choice of ZFS to use powers of 4 was likely not optimal,
>> because to multiply by 4, it has to do two multiplications by 2.
> I can agree with that.  I didn't copy ZFS's choice here
David, it was not my intention to suggest that you copied from ZFS.
Sorry to have expressed myself badly. I just mentioned ZFS because it's
an implementation that I know uses powers of 4 to generate triple
parity, and I saw in the code that it's implemented with two multiplication
by 2.

Ciao,
Andrea
