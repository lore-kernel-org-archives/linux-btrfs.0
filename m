Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:53364 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbeHRKTK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Aug 2018 06:19:10 -0400
Date: Sat, 18 Aug 2018 12:12:30 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Experiences on BTRFS Dual SSD RAID 1 with outage of one SSD
Message-ID: <20180818121230.7339a49f@natsu>
In-Reply-To: <12085882.kBGyflhNqb@merkaba>
References: <2331408.nK7QgfhVWv@merkaba>
 <1598008.Z1BGxZKWFL@merkaba>
 <20180817175022.70cd084e@natsu>
 <12085882.kBGyflhNqb@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 17 Aug 2018 23:17:33 +0200
Martin Steigerwald <martin@lichtvoll.de> wrote:

> > Do not consider SSD "compression" as a factor in any of your
> > calculations or planning. Modern controllers do not do it anymore,
> > the last ones that did are SandForce, and that's 2010 era stuff. You
> > can check for yourself by comparing write speeds of compressible vs
> > incompressible data, it should be the same. At most, the modern ones
> > know to recognize a stream of binary zeroes and have a special case
> > for that.
> 
> Interesting. Do you have any backup for your claim?

Just "something I read". I follow quote a bit of SSD-related articles and
reviews which often also include a section to talk about the controller
utilized, its background and technological improvements/changes -- and the
compression going out of fashion after SandForce seems to be considered a
well-known fact.

Incidentally, your old Intel 320 SSDs actually seem to be based on that old
SandForce controller (or at least license some of that IP to extend on it),
and hence those indeed might perform compression.

> As the data still needs to be transferred to the SSD at least when the 
> SATA connection is maxed out I bet you won´t see any difference in write 
> speed whether the SSD compresses in real time or not.

Most controllers expose two readings in SMART:

  - Lifetime writes from host (SMART attribute 241)
  - Lifetime writes to flash (attribute 233, or 177, or 173...)

It might be difficult to get the second one, as often it needs to be decoded
from others such as "Average block erase count" or "Wear leveling count".
(And seems to be impossible on Samsung NVMe ones, for example)

But if you have numbers for both, you know the write amplification of the
drive (and its past workload).

If there is compression at work, you'd see the 2nd number being somewhat, or
significantly lower -- and barely increase at all, if you write highly
compressible data. This is not typically observed on modern SSDs, except maybe
when writing zeroes. Writes to flash will be the same as writes from host, or
most often somewhat higher, as the hardware can typically erase flash only in
chunks of 2MB or so, hence there's quite a bit of under the hood reorganizing
going on. Also as a result depending on workloads the "to flash" number can be
much higher than "from host".

Point is, even when the SATA link is maxed out in both cases, you can still
check if there's compression at work via using those SMART attributes.

> In any case: It was a experience report, no request for help, so I don´t 
> see why exact error messages are absolutely needed. If I had a support 
> inquiry that would be different, I agree.

Well, when reading such stories (involving software that I also use) I imagine
what if I had been in that situation myself, what would I do, would I have
anything else to try, do I know about any workaround for this. And without any
technical details to go from, those are all questions left unanswered.

-- 
With respect,
Roman
