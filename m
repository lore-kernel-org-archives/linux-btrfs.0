Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:48718 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbcB1Ik5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 03:40:57 -0500
Date: Sun, 28 Feb 2016 09:40:54 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160228084054.GU26042@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <1595760.q3He7oiP70@merkaba>
 <20160228000829.GT26042@torres.zugschlus.de>
 <20160228002245.GH14504@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160228002245.GH14504@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 28, 2016 at 12:22:45AM +0000, Hugo Mills wrote:
> On Sun, Feb 28, 2016 at 01:08:29AM +0100, Marc Haber wrote:
> > Why wouldn't btrfs allocate more data chunks from the ample free space?
> 
>    It's a bug. It's been around for years (literally), but nobody's
> tracked it down and fixed it yet.

Is there a fix/workaround?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
