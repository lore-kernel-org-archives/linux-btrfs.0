Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:46732 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbeHQPxm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 11:53:42 -0400
Date: Fri, 17 Aug 2018 17:50:22 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Experiences on BTRFS Dual SSD RAID 1 with outage of one SSD
Message-ID: <20180817175022.70cd084e@natsu>
In-Reply-To: <1598008.Z1BGxZKWFL@merkaba>
References: <2331408.nK7QgfhVWv@merkaba>
        <5591e89c-eb89-dc48-1dc6-dc46775c7817@gmail.com>
        <1598008.Z1BGxZKWFL@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 17 Aug 2018 14:28:25 +0200
Martin Steigerwald <martin@lichtvoll.de> wrote:

> > First off, keep in mind that the SSD firmware doing compression only
> > really helps with wear-leveling.  Doing it in the filesystem will help
> > not only with that, but will also give you more space to work with.
> 
> While also reducing the ability of the SSD to wear-level. The more data 
> I fit on the SSD, the less it can wear-level. And the better I compress 
> that data, the less it can wear-level.

Do not consider SSD "compression" as a factor in any of your calculations or
planning. Modern controllers do not do it anymore, the last ones that did are
SandForce, and that's 2010 era stuff. You can check for yourself by comparing
write speeds of compressible vs incompressible data, it should be the same. At
most, the modern ones know to recognize a stream of binary zeroes and have a
special case for that.

As for general comment on this thread, always try to save the exact messages
you get when troubleshooting or getting failures from your system. Saying just
"was not able to add" or "btrfs replace not working" without any exact details
isn't really helpful as a bug report or even as a general "experiences" story,
as we don't know what was the exact cause of those, could that have been
avoided or worked around, not to mention what was your FS state at the time
(as in "btrfs fi show" and "fi df").

-- 
With respect,
Roman
