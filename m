Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46058 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751407Ab3LOB7Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 20:59:24 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Blocket for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
Date: Sat, 14 Dec 2013 18:59:22 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <840381F8-BDCA-43BF-A170-6E10C2908B8A@colorremedies.com>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com> <46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com> <CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com> <337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com> <CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
To: Hans-Kristian Bakke <hkbakke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 14, 2013, at 5:28 PM, Hans-Kristian Bakke <hkbakke@gmail.com> wrote:

> When I look at the entire FS with df-like tools it is reported as
> 89.4% used (26638.65 of 29808.2 GB). But this is shared amongst both
> data and metadata I guess?

Yes.

> 
> I do know that ~90%+ seems full, but it is still around 3TB in my
> case! Are the "percentage rules" of old times still valid with modern
> disk sizes?

Probably not. But you also reported rather significant fragmentation. And it's also still an experimental file system when not ~ 90% full. I think it's fair to say that this level of fullness is a less tested use case.



> It seems extremely inconvenient that a filesystem like
> btrfs is starting to misbehave at "only" 3TB available space for
> RAID10 mirroring and metadata, which is probably a little bit over 1TB
> actual filestorage counting everything in.

I'm not suggesting the behavior is either desired or expected, but certainly blocking is better than an oops or a broken file system, and in the not too distant past such things have happened on full volumes. Given the level of fragmentation this behavior might be expected at the current state of development, for all I know.

But if you care about this data, I'd take the blocking as a warning to back off on this usage pattern, unless of course you're intentionally trying to see at what point it breaks and why.

> 
> I would normally expect that there is no difference in 1TB free space
> on a FS that is 2TB in total, and 1TB free space on a filesystem that
> is 30TB in total, other than my sense of urge and that you would
> probably expect data growth to be more rapid on the 30TB FS as there
> is obviously a need to store a lot of stuff.

Seems reasonable.


> Is "free space needed" really a different concept dependning on the
> size of your FS?

Maybe it depends more on the size and fragmentation of the files being access, and of remaining free space.

Can you do an lsattr on these 25GB files that you say have ~ 100,000 extents? And what are these files?



Chris Murphy