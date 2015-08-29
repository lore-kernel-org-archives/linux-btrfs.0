Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbbH2LSA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Aug 2015 07:18:00 -0400
Date: Sat, 29 Aug 2015 13:17:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Vincent Olivier <vincent@up4.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Response to Bcachefs Claims
Message-ID: <20150829111721.GN11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1440516154.040713246@apps.rackspace.com>
 <pan$ac59$d5b01668$cfc6f266$3accc55c@cox.net>
 <1440617086.383124909@apps.rackspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440617086.383124909@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

thanks for stepping up.

On Wed, Aug 26, 2015 at 03:24:46PM -0400, Vincent Olivier wrote:
> As for the work on "Gotchas/Known Issues" on the Btrfs wiki, I also
> think that the best way is to start with the Gotchas page and put a
> more prominent link for it on the home page.

Agreed.

> I would restructure the Gotchas page in the following ways :
> 
> * Add the mention "Known Issues" close to the title;
> 
> * Only keep current issues/gotchas (current stable kernel, current
> userspace utilities release), archive every other on a separate page;

IMO makes sense to keep the current and the previous, ie reflecting
versions that are likely still in wide use.

> * Group by smallest feature encompassing the issue : multi-device,
> quotas, subvolumes, compression, conversion from extX, interactions
> with other things like LVM, MD, encryption, etc.;
> 
> * Something that is "new" and not as thoroughly tested as other
> features should be listed there as well (I think) until there is a
> consensus (to be defined) on it being reliable enough to be taken out
> of the list. Or maybe that should go on another page ?

I'd keep it on the same page, at least for now. 

> * Provide links to HOWTOs or best practices for the features discussed
> (multi-device GOTCHAS should link to multi-device HOWTO).
> 
> I will be thinking about it more before doing anything and still
> welcoming ideas.

Otherwise all points seem ok to me, feel free to start. Some gotchas may
be covered on another pages (FAQ), but we can figure out the best page
later.
