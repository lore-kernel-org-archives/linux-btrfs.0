Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:39672 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbcCEORJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 09:17:09 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1acD11-00066w-GZ
	for linux-btrfs@vger.kernel.org; Sat, 05 Mar 2016 15:17:07 +0100
Date: Sat, 5 Mar 2016 15:17:07 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: balance hangs and starts again on reboot
Message-ID: <20160305141707.GC1902@torres.zugschlus.de>
References: <20160304173125.GA1902@torres.zugschlus.de>
 <56D9CF63.3060603@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56D9CF63.3060603@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 04, 2016 at 07:09:39PM +0100, Holger Hoffstätte wrote:
> On 03/04/16 18:31, Marc Haber wrote:
> > I have another btrfs on the same host that has no the no space left on
> > device balance issue, but on another disk. On this btrfs, it seems
> > like a balance process is stuck, with a lot of hanging kernel
> > threads. After a reboot, when I mount the filesystem, the balance
> > immediately starts again. btrfs balance cancel just hangs around with
> > no visible reaction for hours.
> > 
> > Log appended. Is there rescue?
> 
> Can't offer much help other than to recommend to *always* mount with
> -o skip_balance, which IMHO should have been the default behaviour
> from the beginning.

That's an important hint. The btrfs balance cancel has worked over
night though.

> Then try to balance in small increments.

-dusage=5 and incrementing? Or what do you mean with "in small
increments"?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
