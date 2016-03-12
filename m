Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:58222 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbcCLVgI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Mar 2016 16:36:08 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1aerCg-0007bY-Cw
	for linux-btrfs@vger.kernel.org; Sat, 12 Mar 2016 22:36:06 +0100
Date: Sat, 12 Mar 2016 22:36:06 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160312213606.GM2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160305200909.GJ1902@torres.zugschlus.de>
 <pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
 <CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
 <20160307084235.GB6939@torres.zugschlus.de>
 <CAJCQCtTbfexN9UKRrHTs6yDkSxP3G7qsX-TMR8qZi=x1ef6vSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtTbfexN9UKRrHTs6yDkSxP3G7qsX-TMR8qZi=x1ef6vSg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 07, 2016 at 11:39:11AM -0700, Chris Murphy wrote:
> Since there's no hardware issue suspect, you could filter for just btrfs.
> 
> journalctl -o short-iso | grep -i btrfs

Which is exactly what I did. Why did you suspect that my logs were
"trimmed"? That's what got me kind of furious. I took great care to
not trim relevant information.

> When there's hardware stuff suspect it's better to include all the
> SCSI and  libata (and USB if it's a USB drive) messages also.

None there.

> If you have any logs that include the filesystem mounted with
> enospc_debug, that might be useful for a developer?

The later logs I posted were actually taken with enospc_debug, the
4.4.3 ones even with Duncan's patch. I think I didn't apply it before
building 4.4.4.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
