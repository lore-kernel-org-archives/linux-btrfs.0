Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout91.mail01.mtsvc.net ([216.70.64.178]:36762 "EHLO
	n56.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750814AbbLIGaK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Dec 2015 01:30:10 -0500
Message-ID: <1449642609.20669.7.camel@love2code.net>
Subject: Re: Missing half of available space (resend)
From: David Hampton <mailinglists@love2code.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Wed, 09 Dec 2015 01:30:09 -0500
In-Reply-To: <CAJCQCtQrfRxrvmGT2ZA4WM6YLN5oy-+_k+NmDpv475SAtCoVNw@mail.gmail.com>
References: <1449637341.20669.0.camel@love2code.net>
	 <CAJCQCtQrfRxrvmGT2ZA4WM6YLN5oy-+_k+NmDpv475SAtCoVNw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2015-12-08 at 22:27 -0700, Chris Murphy wrote:
> On Tue, Dec 8, 2015 at 10:02 PM, David Hampton
> <mailinglists@love2code.net> wrote:
> > The
> > 'btrfs fi df' command consistently shows a total size of around
> > 3TB, and says that space is almost completely full.
> 
> and
> 
> 
> > root@selene:~# btrfs fi df /video
> > Data, RAID6: total=3.15TiB, used=3.11TiB
> 
> The "total=3.15TiB" means "there's a total of 3.15TiB allocated for
> data chunks using raid6 profile" and of that 3.11TiB is used.
> 
> btrfs fi df doesn't ever show how much is free or available.

I think I get it.  The numbers in the 'df' command don't show the total
number of chunks that exist, only the subset of those chunks that have
been allocated to something.

> You can get an estimate of that by using 'btrfs fi usage' instead.

Seems I need to upgrade my tools.  That command was added in 3.18 and I
only have the 3.12 tools.

> > root@selene:~# df -h /video
> > Filesystem      Size  Used Avail Use% Mounted on
> > /dev/vda         15T  3.2T  8.3T  28% /video
> 
> That's about right although it seems it's slightly overestimating the
> available free space.

Thanks.  Make me feel a lot better.

David



