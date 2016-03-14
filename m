Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:34512 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbcCNLta (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 07:49:30 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afR04-0001n0-6n
	for linux-btrfs@vger.kernel.org; Mon, 14 Mar 2016 12:49:28 +0100
Date: Mon, 14 Mar 2016 12:49:28 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Message-ID: <20160314114928.GC2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <pan$9abbc$75454df4$bbede296$bf2d7878@cox.net>
 <20160313210537.GW2334@torres.zugschlus.de>
 <pan$4099$d134b7c1$fa33147d$c2943157@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <pan$4099$d134b7c1$fa33147d$c2943157@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 01:05:39AM +0000, Duncan wrote:
> But according to the mkfs.btrfs manpage, the detection is based on 
> /sys/block/DEV/queue/rotational (with DEV substituted appropriately), and 
> various layers got support for correctly passing that thru at various 
> times, some before btrfs, some after.  So that's very likely why btrfs 
> didn't detect it originally, if it was on top of crypto and/or some other 
> layer that might not have been passing that thru.

That explains it, thanks.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
