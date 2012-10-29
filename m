Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:32775 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756546Ab2J2JEn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 05:04:43 -0400
Date: Mon, 29 Oct 2012 09:04:16 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Message-ID: <20121029090416.GD16937@yeono.kjorling.se>
References: <50899151.1070503@inwind.it>
 <201210281133.10571.Martin@lichtvoll.de>
 <508D0FC5.1020404@inwind.it>
 <201210281216.43983.Martin@lichtvoll.de>
 <017607D1-1C4E-47A9-9308-FFEB5737B440@colorremedies.com>
 <20121028190601.GJ2381@yeono.kjorling.se>
 <4B78F4E8-C65F-4436-A0BD-147CD776B7A7@colorremedies.com>
 <20121028200958.GK2381@yeono.kjorling.se>
 <76FFCBB0-A853-44CE-92A6-CEC6E8B83278@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <76FFCBB0-A853-44CE-92A6-CEC6E8B83278@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28 Oct 2012 14:19 -0600, from lists@colorremedies.com (Chris Murphy):
> Somehow for large storage I like the idea of time to "full." GB and
> TB of storage is not really what we care about, it just seems that
> way because it's what we're used to. (Not to imply that we don't
> care about GB and TB at all, but I do think most people convert this
> into a "how many more movies, how much more database growth" and how
> much time remaining is just a generic variation on those things.
> GB/TB remaining doesn't do that, *and* just by nature of the term it
> connotes an absolute value with inflexible meaning. But free space
> on btrfs is flexible/relative, not absolute.

There are two fairly big issues however that I can see having thought
a little about this that will need careful consideration before
deciding to go with a "time to full" scheme.

First, what if disk usage is actually decreasing over time? It should
be trivial to translate that to, say, something like "> 3 years", but
it's a case that needs to be taken into consideration.

Second, there should still be a way to answer the question "will this
amount of payload data fit here?". There are numerous valid reasons
for wanting to know whether you can store a given number of bytes in a
specific place. Of course, depending on various factors (compression
etc.) the amount of available space may decrease by less than the size
of the payload data, but that is only a nice bonus in that case.

At work, it isn't uncommon for my disk usage to vary up _and down_ by
several GB (on the order of 10% or so of the total used is far from
uncommon) inside the scope of a day. I'd like to see the statistical
algorithm that can take such wild fluctuations and produce any
meaningful metric of the amount of remaining space expressed as "time
to full".

*Perhaps*, to accomodate per-object replication settings, there could
be a command like "display free space for this directory" which can
take the specific directory's replication settings into account once
that has been implemented. It could display two figures: the amount of
payload data that could be stored in that directory without touching
any replication settings ("if I do 'cat /dev/random > ./here', how big
will the file become before I run out of space?"), as well as the
number of data bytes available (think "how big will it become if I
force SINGLE?").

Might that be a workable approach?

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
