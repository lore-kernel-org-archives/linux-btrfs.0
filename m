Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:46556 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942720AbdDTHmm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Apr 2017 03:42:42 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
        (envelope-from <mh+linux-btrfs@zugschlus.de>)
        id 1d16jg-0006hk-Q6
        for linux-btrfs@vger.kernel.org; Thu, 20 Apr 2017 09:42:40 +0200
Date: Thu, 20 Apr 2017 09:42:40 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs won't mount any more
Message-ID: <20170420074240.GZ3699@torres.zugschlus.de>
References: <20170411071531.GK3699@torres.zugschlus.de>
 <20170411161502.ol4tjl3agqnlerab@angband.pl>
 <20170413084509.GH3699@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170413084509.GH3699@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 13, 2017 at 10:45:09AM +0200, Marc Haber wrote:
> On Tue, Apr 11, 2017 at 06:15:02PM +0200, Adam Borowski wrote:
> > Ouch, this is generally harmless unless your disk lies about barriers. 
> > Btrfs absolutely depends on them, and tends to suffer catastrophic
> > corruption if writes were reordered when they shouldn't.
> 
> So if the disk would actually lie, I would have had much trouble even
> earlier. It's an SSD from 2013 or 2014, I think from Kingston. The box
> is offline and remote at the moment, so I cannot give the exact type.

I have re-built the btrfs and restored from backup, so I can access the
disk again. It's a Crucial/Micron RealSSD m4/C400/P400 M4-CT256M4SSD1
with 256 GB Capacity.

I do have an image of the bad btrfs that makes the kernel oops on mount,
reproducibly. Does this help in debugging?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
