Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36668 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbcCLAEs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 19:04:48 -0500
Received: by mail-wm0-f42.google.com with SMTP id n186so38678855wmn.1
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 16:04:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$9dde$acf9ba51$bb837cb8$8c954a04@cox.net>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
	<CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
	<20160310023627.2e915667@natsu>
	<pan$9dde$acf9ba51$bb837cb8$8c954a04@cox.net>
Date: Fri, 11 Mar 2016 19:04:46 -0500
Message-ID: <CAD=QJKjkzh4U5Gmp=PJMiR8w3by12BVCDZ+MN2S+Ekk_EksjAg@mail.gmail.com>
Subject: Re: dstat shows unexpected result for two disk RAID1
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9 March 2016 at 23:06, Duncan <1i5t5.duncan@cox.net> wrote:
>
> Meanwhile, while parity-raid (aka raid56) isn't as bad as it was when
> first nominally completed in 3.19, as of 4.4 (and I think 4.5 as I've not
> seen a full trace yet, let alone a fix), there's still at least one known
> bug remaining to be traced down and exterminated, that's causing at least
> some raid56 reshapes to different numbers of devices or recovery from a
> lost device to take at least 10 times as long as they logically should,
> we're talking times of weeks to months, during which time the array can
> be used, but if it's a bad device replacement and more devices go down in
> that time...
>
> Tho hopefully all the really tough problems they would have hit with N-
> way-mirroring were hit and resolved with raid56, and N-way-mirroring will
> thus be relatively simple, so hopefully it's less than the four years
> it's taking raid56.  But I don't expect to see it for another year or
> two, and don't expect to be actually use it as intended (as a more
> failure resistant raid1) for some time after that as the bugs get worked
> out, so realistically, 2-3 years.

Could the raid5 code could be patched to copy/read instead of
build/check parity?  In effect I'm wondering if this could be used as
an alternative to the current raid1 profile.  The bonus being that it
seems like it might accelerate shaking out the bugs in raid5.
Likewise, would doing the same with the raid6 code in effect implement
a 3-way mirror distributed over n-devices?

Kind regards,
Nicholas
