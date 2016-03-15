Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:38154 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbcCOHQN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 03:16:13 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afjD9-0000S5-OV
	for linux-btrfs@vger.kernel.org; Tue, 15 Mar 2016 08:16:11 +0100
Date: Tue, 15 Mar 2016 08:16:11 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Message-ID: <20160315071611.GL2334@torres.zugschlus.de>
References: <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <20160314120703.GD2334@torres.zugschlus.de>
 <CAPmG0jbwDjf6L1-9VPCwwzqj44Th9ZHaGVcY-PhoQF=eHo5hnA@mail.gmail.com>
 <20160314200546.GG2334@torres.zugschlus.de>
 <CAPmG0jYfEnvLEHskv8uy+FjnRtv4yY8HA7bqMqZ8ScqVuAHatA@mail.gmail.com>
 <CAJCQCtQHZsvQyAfWO4HGY7Jr+PGdW5L=LUTqM+5E=ys0+Ypzqw@mail.gmail.com>
 <CAPmG0jaf7TaU2Nt3ULRm3651ByiwW-2PdYart318ceLDN7JqbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPmG0jaf7TaU2Nt3ULRm3651ByiwW-2PdYart318ceLDN7JqbQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2016 at 12:22:00AM +0100, Henk Slager wrote:
> The other question is: What is mounted on /media/tempdisk/  ?

The "old" btrfs filesystem "ofanbtr", formerly 417 GB in size, now
resized to 300 GB. Does it need to be umounted to be checked?

> At least I think a check of the current 200GiB fs is needed. As it is
> a rootfs and encrypted, some work is needed to make that happen.

You suggested a btrfs check after looking at the image of "ofanbtr".
Do you want me to check the new "fanbtr" also?

Too bad that we went back to looking at "ofanbtr" after I changed the
subject to avoid mixing up both instances.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
