Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:59489 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753452Ab2J1UTE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 16:19:04 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20121028200958.GK2381@yeono.kjorling.se>
Date: Sun, 28 Oct 2012 14:19:02 -0600
Message-Id: <76FFCBB0-A853-44CE-92A6-CEC6E8B83278@colorremedies.com>
References: <50899151.1070503@inwind.it> <201210281133.10571.Martin@lichtvoll.de> <508D0FC5.1020404@inwind.it> <201210281216.43983.Martin@lichtvoll.de> <017607D1-1C4E-47A9-9308-FFEB5737B440@colorremedies.com> <20121028190601.GJ2381@yeono.kjorling.se> <4B78F4E8-C65F-4436-A0BD-147CD776B7A7@colorremedies.com> <20121028200958.GK2381@yeono.kjorling.se>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 28, 2012, at 2:09 PM, Michael Kjörling <michael@kjorling.se> wrote:

> I did not mean to imply that "sysadmins and storage experts aren't
> also ordinary people" who can benefit from an "at a glance" view of
> their storage situation. Quite to the contrary, that's one point I
> have raised in this thread: the usefulness of an "at a glance" view of
> the storage situation. But I can also certainly see the side of the
> argument that they could reason their way around the concept of raw
> storage capacity and allocation multipliers. After all, by the time
> you get down to the "a few days of ordinary added data" range of free
> space remaining, which would be when the exact numbers _really_ begin
> to matter, you should be on top of adding more storage capacity
> anyway.

Agreed. Whether the free space is GB, %, or time - in any case if it jumps from a "comfortable" value to a "crisis" value inside of a few days, it's a problem (for the user and the algorithm).

Somehow for large storage I like the idea of time to "full." GB and TB of storage is not really what we care about, it just seems that way because it's what we're used to. (Not to imply that we don't care about GB and TB at all, but I do think most people convert this into a "how many more movies, how much more database growth" and how much time remaining is just a generic variation on those things. GB/TB remaining doesn't do that, *and* just by nature of the term it connotes an absolute value with inflexible meaning. But free space on btrfs is flexible/relative, not absolute.

Chris Murphy

