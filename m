Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.ctyme.com ([184.105.182.178]:45420 "EHLO smtp.ctyme.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbcC0EXj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 00:23:39 -0400
Received: from cagate.csd.rawbw.com ([198.144.201.83] helo=[192.168.123.14]) helo=[192.168.123.14]
	by darwin.junkemailfilter.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(Exim 4.86_2)
	id 1ak2Ek-0005Vc-Dh on interface=184.105.182.178
	for linux-btrfs@vger.kernel.org; Sat, 26 Mar 2016 21:23:38 -0700
Reply-To: bradtem@gmail.com
Subject: Re: RAID-1 refuses to balance large drive
References: <56F1E7BE.1000004@gmail.com> <56F21510.6050707@cn.fujitsu.com>
 <56F21FC5.50209@gmail.com>
 <CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
 <56F22F80.501@gmail.com>
 <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
 <56F2C991.9080500@gmail.com>
 <CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
 <56F2EA25.4070004@gmail.com>
 <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
 <CAA7pwKNjyRRoXGV0djzjgXX7HQ2MY8mhQFj8_7TsfYeKkge-2g@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Brad Templeton <bradtem@gmail.com>
Message-ID: <56F7604A.8090106@gmail.com>
Date: Sat, 26 Mar 2016 21:23:38 -0700
MIME-Version: 1.0
In-Reply-To: <CAA7pwKNjyRRoXGV0djzjgXX7HQ2MY8mhQFj8_7TsfYeKkge-2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




For those curious as the the result, the reduction to single and
restoration to RAID1 did indeed balance the array.   It was extremely
slow of course on a 12tb array.   I did not bother doing this with the
metadata.   I also stopped the conversion to single when it had freed up
enough space on the 2 smaller drives, because at that time it was moving
stuff into the big drive, which seemed sub-optimal considering what was
to come.

In general, obviously, I hope the long term goal is to not need this,
indeed not to need manual balance at all.   I would hope the goal is to
just be able to add and remove drives, tell the system what type of
redundancy you need and let it figure out the rest.  But I know this is
an FS in development.

I've actually come to feel that when it comes to personal drive arrays,
we actually need something much smarter than today's filesystems.  Truth
is, for example, that once my infrequently accessed files, such as old
photo and video archives, have a solid backup made, there is not
actually a need to keep them redundantly at all, except for speed, while
the much smaller volume of frequently accessed files needs that (or even
extra redundancy not for safety but extra speed, and of course cache on
an SSD is even better.)   This requires not just the fileystem and OS to
get smarter about this, but even the apps.  It may happen some day -- no
matter how cheap storage gets, we keep coming up with ways to fill it.

Thanks for the help.
