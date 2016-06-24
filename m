Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34206 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbcFXA0Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 20:26:24 -0400
Received: by mail-oi0-f46.google.com with SMTP id s66so94669649oif.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 17:26:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
References: <20160620034427.GK15597@hungrycats.org> <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org> <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org> <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org> <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org> <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 23 Jun 2016 18:26:22 -0600
Message-ID: <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: kreijack@inwind.it
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>, Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 1:32 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:

>
> The raid5 write hole is avoided in BTRFS (and in ZFS) thanks to the checksum.

Yeah I'm kinda confused on this point.

https://btrfs.wiki.kernel.org/index.php/RAID56

It says there is a write hole for Btrfs. But defines it in terms of
parity possibly being stale after a crash. I think the term comes not
from merely parity being wrong but parity being wrong *and* then being
used to wrongly reconstruct data because it's blindly trusted.

I don't read code well enough, but I'd be surprised if Btrfs
reconstructs from parity and doesn't then check the resulting
reconstructed data to its EXTENT_CSUM.



-- 
Chris Murphy
