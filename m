Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41059 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933567AbbGVLAj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 07:00:39 -0400
From: Russell Coker <russell@coker.com.au>
To: Chris Murphy <lists@colorremedies.com>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID1: system stability
Date: Wed, 22 Jul 2015 21:00:22 +1000
References: <556457b8.e72b980a.ee08.ffffce60@mx.google.com> <CAGqmi774WEukmUt9NAFZQ8R9kCCyOFm3M_TP2ULgvtgpDnMM1w@mail.gmail.com> <CAJCQCtTXiWWie+OtkdNhjmUEjPoyx565LZ15KC3Kfr7DC9ucpQ@mail.gmail.com>
In-Reply-To: <CAJCQCtTXiWWie+OtkdNhjmUEjPoyx565LZ15KC3Kfr7DC9ucpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201507222100.22471.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 23 Jun 2015 02:52:43 AM Chris Murphy wrote:
> OK I actually don't know what the intended block layer behavior is
> when unplugging a device, if it is supposed to vanish, or change state
> somehow so that thing that depend on it can know it's "missing" or
> what. So the question here is, is this working as intended? If the
> layer Btrfs depends on isn't working as intended, then Btrfs is
> probably going to do wild and crazy things. And I don't know that the
> part of the block layer Btrfs depends on for this is the same (or
> different) as what the md driver depends on.

I disagree with that statement.  BTRFS should be expected to not do wild and 
crazy things regardless of what happens with block devices.

A BTRFS RAID-1/5/6 array should cope with a single disk failing or returning 
any manner of corrupted data and should not lose data or panic the kernel.

A BTRFS RAID-0 or single disk setup should cope with a disk giving errors by 
mounting read-only or failing all operations on the filesystem.  It should not 
affect any other filesystem or have any significant impact on the system unless 
it's the root filesystem.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
