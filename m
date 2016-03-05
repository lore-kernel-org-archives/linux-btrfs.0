Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:40048 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbcCERZz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 12:25:55 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1acFxh-0003E8-Mi
	for linux-btrfs@vger.kernel.org; Sat, 05 Mar 2016 18:25:53 +0100
Date: Sat, 5 Mar 2016 18:25:53 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: balance hangs and starts again on reboot
Message-ID: <20160305172553.GF1902@torres.zugschlus.de>
References: <20160304173125.GA1902@torres.zugschlus.de>
 <56D9CF63.3060603@googlemail.com>
 <20160305141707.GC1902@torres.zugschlus.de>
 <56DAFD91.2090805@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56DAFD91.2090805@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 05, 2016 at 04:38:57PM +0100, Holger Hoffstätte wrote:
> On 03/05/16 15:17, Marc Haber wrote:
> >> Then try to balance in small increments.
> > 
> > -dusage=5 and incrementing? Or what do you mean with "in small
> > increments"?
> 
> Exactly, yes. Sorry for not being more clear.

So you would recommend something along

for nr in $(seq 5 5 100); do
  btrfs balance start -dusage=$nr $FS
done

right?

Won't this take ages longer than a straight unfiltered balance?

> FWIW I've been balancing a lot recently (both for stress testing and
> cleaning up a few filesystems) and have never run into this particular
> stall, but only ever do filtered balances. Also I wouldn't be surprised
> at all if this is yet another problem where md does something in a way
> that btrfs doesn' expect, and things go wrong.

md as in the Linux Software RAID? That's not in the game here, it's a
single SATA hard disk.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
