Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:50978
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750Ab2J3Ele convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 00:41:34 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20121029090416.GD16937@yeono.kjorling.se>
Date: Mon, 29 Oct 2012 22:41:29 -0600
Message-Id: <1C720907-DF69-437E-A0B9-72A6E9948C1A@colorremedies.com>
References: <50899151.1070503@inwind.it> <201210281133.10571.Martin@lichtvoll.de> <508D0FC5.1020404@inwind.it> <201210281216.43983.Martin@lichtvoll.de> <017607D1-1C4E-47A9-9308-FFEB5737B440@colorremedies.com> <20121028190601.GJ2381@yeono.kjorling.se> <4B78F4E8-C65F-4436-A0BD-147CD776B7A7@colorremedies.com> <20121028200958.GK2381@yeono.kjorling.se> <76FFCBB0-A853-44CE-92A6-CEC6E8B83278@colorremedies.com> <20121029090416.GD16937@yeono.kjorling.se>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 29, 2012, at 3:04 AM, Michael Kjörling <michael@kjorling.se> wrote:
> There are two fairly big issues however that I can see having thought
> a little about this that will need careful consideration before
> deciding to go with a "time to full" scheme.
> 
> First, what if disk usage is actually decreasing over time? It should
> be trivial to translate that to, say, something like "> 3 years", but
> it's a case that needs to be taken into consideration.

Yes it should.

> 
> Second, there should still be a way to answer the question "will this
> amount of payload data fit here?".

I agree. Time to full is just one possible way of being more forward thinking with large file systems.


> At work, it isn't uncommon for my disk usage to vary up _and down_ by
> several GB (on the order of 10% or so of the total used is far from
> uncommon) inside the scope of a day. I'd like to see the statistical
> algorithm that can take such wild fluctuations and produce any
> meaningful metric of the amount of remaining space expressed as "time
> to full".

I think you'd something like CPU load balancing stats. An estimate based on today's usage, vs the past 2 weeks, or something. You wouldn't get just one estimate. It'd supply a context and thus give you a range of times to full depending on context, which hopefully the user knows something about.

> 
> *Perhaps*, to accomodate per-object replication settings, there could
> be a command like "display free space for this directory" which can
> take the specific directory's replication settings into account once
> that has been implemented. It could display two figures: the amount of
> payload data that could be stored in that directory without touching
> any replication settings ("if I do 'cat /dev/random > ./here', how big
> will the file become before I run out of space?"), as well as the
> number of data bytes available (think "how big will it become if I
> force SINGLE?").
> 
> Might that be a workable approach?

Seems reasonable.


Chris Murphy