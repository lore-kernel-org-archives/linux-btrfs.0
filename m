Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33643 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbeHRAWd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 20:22:33 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Roman Mamedov <rm@romanrm.net>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Experiences on BTRFS Dual SSD RAID 1 with outage of one SSD
Date: Fri, 17 Aug 2018 23:17:33 +0200
Message-ID: <12085882.kBGyflhNqb@merkaba>
In-Reply-To: <20180817175022.70cd084e@natsu>
References: <2331408.nK7QgfhVWv@merkaba> <1598008.Z1BGxZKWFL@merkaba> <20180817175022.70cd084e@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Roman.

Now with proper CC.

Roman Mamedov - 17.08.18, 14:50:
> On Fri, 17 Aug 2018 14:28:25 +0200
> 
> Martin Steigerwald <martin@lichtvoll.de> wrote:
> > > First off, keep in mind that the SSD firmware doing compression
> > > only
> > > really helps with wear-leveling.  Doing it in the filesystem will
> > > help not only with that, but will also give you more space to
> > > work with.> 
> > While also reducing the ability of the SSD to wear-level. The more
> > data I fit on the SSD, the less it can wear-level. And the better I
> > compress that data, the less it can wear-level.
> 
> Do not consider SSD "compression" as a factor in any of your
> calculations or planning. Modern controllers do not do it anymore,
> the last ones that did are SandForce, and that's 2010 era stuff. You
> can check for yourself by comparing write speeds of compressible vs
> incompressible data, it should be the same. At most, the modern ones
> know to recognize a stream of binary zeroes and have a special case
> for that.

Interesting. Do you have any backup for your claim?

> As for general comment on this thread, always try to save the exact
> messages you get when troubleshooting or getting failures from your
> system. Saying just "was not able to add" or "btrfs replace not
> working" without any exact details isn't really helpful as a bug
> report or even as a general "experiences" story, as we don't know
> what was the exact cause of those, could that have been avoided or
> worked around, not to mention what was your FS state at the time (as
> in "btrfs fi show" and "fi df").

I had a screen.log, but I put it on the filesystem after the 
backup was made, so it was lost.

Anyway, the reason for not being able to add the device was the read 
only state of the BTRFS, as I wrote. Same goes for replace. I was able 
to read the error message just fine. AFAIR the exact wording was "read 
only filesystem".

In any case: It was a experience report, no request for help, so I don´t 
see why exact error messages are absolutely needed. If I had a support 
inquiry that would be different, I agree.

Thanks,
-- 
Martin
