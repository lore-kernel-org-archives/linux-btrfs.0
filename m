Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:39385 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab3KTSn0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 13:43:26 -0500
In-Reply-To: <CAGKKSfV+TyONu0EgSy9r5k7SiP5ZM3n7pGajY62DBSBw6YvR+w@mail.gmail.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <528A90B7.5010905@zytor.com> <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com> <528AA1EB.3010909@zytor.com> <528B3A6F.2010304@hesbynett.no> <CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com> <528C8F8E.9030908@hesbynett.no> <CAGKKSfV+TyONu0EgSy9r5k7SiP5ZM3n7pGajY62DBSBw6YvR+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Triple parity and beyond
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 20 Nov 2013 10:43:09 -0800
To: Andrea Mazzoleni <amadvance@gmail.com>,
        David Brown <david.brown@hesbynett.no>
CC: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Smith <creamyfish@gmail.com>
Message-ID: <1fe6f763-a5a4-4cc7-b23d-7928b0925f09@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is also possible to quickly multiply by 2^-1 which makes for an interesting R parity.

Andrea Mazzoleni <amadvance@gmail.com> wrote:
>Hi David,
>
>>> The choice of ZFS to use powers of 4 was likely not optimal,
>>> because to multiply by 4, it has to do two multiplications by 2.
>> I can agree with that.  I didn't copy ZFS's choice here
>David, it was not my intention to suggest that you copied from ZFS.
>Sorry to have expressed myself badly. I just mentioned ZFS because it's
>an implementation that I know uses powers of 4 to generate triple
>parity, and I saw in the code that it's implemented with two
>multiplication
>by 2.
>
>Ciao,
>Andrea

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
