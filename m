Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:41418 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab2J1Msi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 08:48:38 -0400
Date: Sun, 28 Oct 2012 12:48:13 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Message-ID: <20121028124813.GE2381@yeono.kjorling.se>
References: <50899151.1070503@inwind.it>
 <20121027223812.GB5042@carfax.org.uk>
 <508CF08D.8060203@gmail.com>
 <201210281138.02590.Martin@lichtvoll.de>
 <508D1015.6050100@gmail.com>
 <20121028111858.GC2381@yeono.kjorling.se>
 <508D2430.9020006@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <508D2430.9020006@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28 Oct 2012 13:25 +0100, from kreijack@inwind.it (Goffredo Baroncelli):
> On 2012-10-28 12:18, Michael Kjörling wrote:
>> I would personally really prefer a tabular view that perhaps does not
>> show _all_ details when no explicit parameters are given, and a
>> "--dump" or similar that will give a fuller data dump that might lend
>> itself better to parsing by other tools for a more thorough
>> presentation. The data is all right there; it's basically a matter of
>> deciding how much of it to show by default.
> 
> In your opinion, which details we could omit ?

For a _summary_, _I_ would want an overview that tells me:

1. how much data is actually currently stored on the file system
   (which might not be equal to the number of data bytes used on disk)

2. if I add a single file to the file system, how large can that file
   grow before I run out of disk space? ("how much free space is there
   on the file system?") In the case of btrfs, this should probably be
   calculated under a "worst case scenario" presumption but still
   assuming that all currently unused space is usable for data storage
   and no changed file system settings, and without rebalancing
   between data and metadata areas.

For multi-device file systems, it seems logical to offer a per-device
breakdown of the numbers as well as totals. In that case the totals
should definitely be at the bottom of the output so you don't need to
pipe through "head" just to get the totals if you have a file system
spread out over a large number of devices.

Since unless I've missed something big per-object replication settings
is a _planned_ feature and not currently implemented, I don't quite
see why the "btrfs fi df" output design _now_ has to accomodate that.

I still feel that the format I mentioned in my post 27 Oct 19:55 UTC
should work fairly well, given the _currently implemented_ btrfs
feature set. It answers the question that "home" users are most likely
to face ("how much more data can I store?") and can be supplemented by
a more in-depth view meant for technically inclined users who really
care about the technical breakdown of the data.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
