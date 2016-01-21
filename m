Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34079 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbcAUU7l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 15:59:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aMMKR-0002tn-Ur
	for linux-btrfs@vger.kernel.org; Thu, 21 Jan 2016 21:59:39 +0100
Received: from ip5f5ae057.dynamic.kabel-deutschland.de ([95.90.224.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:59:39 +0100
Received: from hurikhan77 by ip5f5ae057.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:59:39 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Interjection: autodefrag mount option aye, nae?
Date: Thu, 21 Jan 2016 21:59:32 +0100
Message-ID: <20160121215932.3e6654af@jupiter.sol.kaishome.de>
References: <CAGkb5vfzcOmj1Js=pBR6=-Uad7jY2bJy5ht3F-m-1TEOBjwCYA@mail.gmail.com>
	<5697D0E9.3080007@gmail.com>
	<20160114192647.GB24567@localhost.localdomain>
	<5697F9E7.1020004@gmail.com>
	<loom.20160120T163054-326@post.gmane.org>
	<569FAA4E.1040204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 20 Jan 2016 10:39:58 -0500
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> On 2016-01-20 10:33, Al wrote:
> > [very quietly] I've had autodefrag out of my mount options for a
> > long while now. Is that still the recommended position?
> I think it really depends on what you're doing.  In my case, I
> usually have it on, and the only issue I've ever seen is that Chrome
> sometimes loads pages from local cache slower than it should be.  I
> also don't use ridiculous numbers of snapshots either (I use them
> only to get a stable view of the filesystem when generating a
> backup), so I don't have much experience with how they interact with
> autodefrag.

I'd recommend to set chrome caching to simple http cache in
chrome://flags as this is more suitable for btrfs (as for most Unix
file systems which deal with many small files better than with random
updates in a big fat files).

I experienced much improved performance and responsiveness with it. May
be worth a try for you. I'd be interested in your results.

chrome://flags/#enable-simple-cache-backend

-- 
Regards,
Kai

Replies to list-only preferred.

