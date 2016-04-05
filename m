Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47429 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbcDEHFd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Apr 2016 03:05:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anL3K-0002gE-Mw
	for linux-btrfs@vger.kernel.org; Tue, 05 Apr 2016 09:05:30 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 09:05:30 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 09:05:30 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
Date: Tue, 5 Apr 2016 09:05:20 +0200
Message-ID: <20160405090520.2f07a373@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
	<20160403060202.03e67651@jupiter.sol.kaishome.de>
	<pan$2593b$f74bb320$4b6df891$663eb0b@cox.net>
	<20160404001925.2abc2649@jupiter.sol.kaishome.de>
	<CAJCQCtTjoQ93wiMRgzHJ+3D_GPwygK1EzGPCFyKdoi1=Mjip_w@mail.gmail.com>
	<20160404213637.58ad33b1@jupiter.sol.kaishome.de>
	<CAJCQCtQdGG3o9mu2u=Vjc0rN+0eLWYVXikH5KtfOap2SijjSKA@mail.gmail.com>
	<20160404225018.150988d2@jupiter.sol.kaishome.de>
	<CAJCQCtSVHwx=xwzv29sYVEdQ5Y=vOjT-26iagiqbWU5mXyGkZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 4 Apr 2016 17:09:14 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

> > Why couldn't/shouldn't I remove snapshots before detaching the seed
> > device? I want to keep them on the seed but they are useless to me
> > on the sprout.  
> 
> You can remove snapshots before or after detaching the seed device, it
> doesn't matter, but such snapshot removal only affects the sprout. You
> wrote:
> 
> "remove all left-over snapshots from the seed"
> 
> The seed is read only, you can't modify the contents of the seed
> device.

Sorry, not a native speaker... What I actually meant was to remove the
snapshot that originated from the seed, and which I don't need in the
sprout.

-- 
Regards,
Kai

Replies to list-only preferred.

