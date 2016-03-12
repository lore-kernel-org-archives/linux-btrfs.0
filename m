Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:58200 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbcCLVae (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Mar 2016 16:30:34 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1aer7I-0007YY-O6
	for linux-btrfs@vger.kernel.org; Sat, 12 Mar 2016 22:30:32 +0100
Date: Sat, 12 Mar 2016 22:30:32 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160312213032.GL2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160305200909.GJ1902@torres.zugschlus.de>
 <pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
 <CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 06, 2016 at 01:27:10PM -0700, Chris Murphy wrote:
> So if it were me, I'd gather all possible data, including complete,
> not trimmed, logs. And as for the btrfs-image, it could be huge.

[5/504]mh@q:~/.www/public_html/stuff$ unxz --list 20160307-fanbtr-image.xz
Strms  Blocks   Compressed Uncompressed  Ratio  Check   Filename
    1      19    248.0 MiB   2385.2 MiB  0.104  CRC32   20160307-fanbtr-image.xz

>  It might not be
>  a bad idea to capture a complete btrfs-debug-tree also, and compress
>  that, add as attachment.

How do I do that?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
