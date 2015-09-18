Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45950 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbbIRAfD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 20:35:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zcjdk-0007Ds-Av
	for linux-btrfs@vger.kernel.org; Fri, 18 Sep 2015 02:35:00 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 02:35:00 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 02:35:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: FYIO: A rant about btrfs
Date: Fri, 18 Sep 2015 00:34:54 +0000 (UTC)
Message-ID: <pan$8db10$2ae04448$ef503df5$d1537993@cox.net>
References: <20150916144355.GA1285@invalid> <55F988A6.8070109@gmail.com>
	<A4269DC6-6CD6-4E8C-B3C9-5F5DDBE86911@up4.com>
	<55F9B357.4070505@gmail.com>
	<54A9EC91-FDFD-44A8-97B9-7347A89FA415@up4.com>
	<20150916220856.GA23830@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Wed, 16 Sep 2015 18:08:56 -0400 as excerpted:

> On Wed, Sep 16, 2015 at 03:04:38PM -0400, Vincent Olivier wrote:
>> 
>> OK fine. Let it be clearer then (on the Btrfs wiki): nobarrier is an
>> absolute no go. Case closed.
> 
> Sometimes it is useful to make an ephemeral filesystem, i.e. a btrfs on
> a dm-crypt device with a random key that is not stored.  This
> configuration intentionally and completely destroys the entire
> filesystem, and all data on it, in the event of a power failure.  It's
> useful for things like temporary table storage, where ramfs is too
> small, swap-backed tmpfs is too slow, and/or there is a requirement that
> the data not be persisted across reboots.
> 
> In other words, nobarrier is for a little better performance when you
> already want to _intentionally_ destroy your filesystem on power
> failure.

Very good explanation of why it's useful to have such an otherwise 
destructive mount option even available in the first place.  Thanks! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

