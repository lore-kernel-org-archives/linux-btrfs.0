Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asav4.altibox.net ([81.167.36.153]:58569 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3KUIg6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 03:36:58 -0500
Message-ID: <528DC628.9090403@hesbynett.no>
Date: Thu, 21 Nov 2013 09:36:56 +0100
From: David Brown <david.brown@hesbynett.no>
MIME-Version: 1.0
To: Andrea Mazzoleni <amadvance@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<528B3A6F.2010304@hesbynett.no>	<CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>	<528C8F8E.9030908@hesbynett.no> <CAGKKSfV+TyONu0EgSy9r5k7SiP5ZM3n7pGajY62DBSBw6YvR+w@mail.gmail.com>
In-Reply-To: <CAGKKSfV+TyONu0EgSy9r5k7SiP5ZM3n7pGajY62DBSBw6YvR+w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/11/13 19:34, Andrea Mazzoleni wrote:
> Hi David,
> 
>>> The choice of ZFS to use powers of 4 was likely not optimal,
>>> because to multiply by 4, it has to do two multiplications by 2.
>> I can agree with that.  I didn't copy ZFS's choice here
> David, it was not my intention to suggest that you copied from ZFS.
> Sorry to have expressed myself badly. I just mentioned ZFS because it's
> an implementation that I know uses powers of 4 to generate triple
> parity, and I saw in the code that it's implemented with two multiplication
> by 2.
> 

Andrea, I didn't take your comment as an accusation of any kind - there
is no need for any kind of apology!  It was was merely a statement of
fact - I picked powers of 4 as an obvious extension of the powers of 2
in raid6, and found it worked well.

And of course, in the open source world, copying of code and ideas is a
good thing - there is no point in re-inventing the wheel unless we can
invent a better one.  Really, I /should/ have read the ZFS
implementation and copied it!

mvh.,

David


